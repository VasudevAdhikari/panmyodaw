package backend.first;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.sql.SQLException;
import java.util.Base64;
import java.util.zip.GZIPOutputStream;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.google.gson.Gson;

import additional.CheckEmailPassword;
import additional.User;
import additional.UserChecker;
import model.Customer;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    public LoginServlet() {
        super();
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        this.doGet(request, response);
    }
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Other codes
        System.out.println("got into the login servlet");
        CheckEmailPassword check = new CheckEmailPassword();
        HttpSession session = request.getSession(false);
        String email = (String) session.getAttribute("email");
        String password = (String) session.getAttribute("password");
        boolean isPasswordTrue = false;
        try {
            System.out.println("try block");
            isPasswordTrue = check.isPasswordTrue(email, password);
        } catch (Exception e) {
            e.printStackTrace();
        }

        if (isPasswordTrue) {
            UserChecker userChecker = new UserChecker();
            Customer user = null;
            try {
                user = userChecker.getUserInfo(email);
            } catch (ClassNotFoundException | SQLException e) {
                e.printStackTrace();
            }
            
            Cookie user_id = new Cookie("user_id", Integer.toString(user.getId()));
            user_id.setMaxAge(60 * 60 * 24 * 60); // Cookie expires in 60 days
            response.addCookie(user_id);
            System.out.println("Successfully stored as cookie");
            response.sendRedirect(request.getContextPath() + "/customer_home_page.jsp");
        } else {
        	session.setAttribute("checkPassword", isPasswordTrue);
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }
    }
}
