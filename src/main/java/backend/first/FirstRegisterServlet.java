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

@WebServlet("/FirstRegisterServlet")
@MultipartConfig
public class FirstRegisterServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String email = request.getParameter("email");
        HttpSession session = request.getSession(true);
        UserChecker userChecker = new UserChecker();

        try {
            if (userChecker.doesUserExist(email)) {
                session.setAttribute("userExist", true);
                response.sendRedirect("index.jsp");
                return;  // Ensure no further code is executed after redirection
            }
        } catch (ClassNotFoundException | SQLException e) {
            e.printStackTrace();
        }

        Long phone = Long.parseLong(request.getParameter("phone-no"));
        String password = request.getParameter("password");

        session.setAttribute("email", email);
        session.setAttribute("phone", phone);
        session.setAttribute("password", password);

        response.sendRedirect("register.jsp");
    }
}
