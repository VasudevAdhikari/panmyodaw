package backend.first;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;
import additional.UserChecker;

@WebServlet("/CheckLoginServlet")
@MultipartConfig
public class CheckLoginServlet extends HttpServlet {
	
	private static final long serialVersionUID = 1L;

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String email = request.getParameter("email");
        System.out.println("Got the email from the login page.");
        
        HttpSession session = request.getSession(true);
        UserChecker userChecker = new UserChecker();

        try {
            System.out.println("Got into the try block.");
            
            boolean userExists = userChecker.doesUserExist(email);
            System.out.println("Does user exist or not in the db: " + userExists);

            if (userExists) {
                String password = request.getParameter("password");

                session.setAttribute("email", email);
                session.setAttribute("password", password);
                System.out.println("Successfully stored the inputted email and password into the session.");
                System.out.println("Now we are gonna proceed to LoginServlet");

                response.sendRedirect("LoginServlet");
                return;  // Ensure no further code is executed after redirection
            } else {
                session.setAttribute("userExist", false);
                response.sendRedirect("login.jsp");
            }
        } catch (ClassNotFoundException | SQLException e) {
            e.printStackTrace();
            response.sendRedirect("myerrorpage.jsp");
        }
    }
}
