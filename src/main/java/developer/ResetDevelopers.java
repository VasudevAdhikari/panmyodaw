package developer;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.sql.Statement;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/ResetDevelopers")
public class ResetDevelopers extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String url = "jdbc:mysql://localhost:3306/panmyodaw";
        System.out.println("Got into the ResetDevelopers servlet.\n\n\n\n\n\n\n\n\n\n");
        String user = "root"; // Update with your DB username
        String password = System.getenv("DB_PASSWORD"); // Update with your DB password

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection(url, user, password);
            Statement stmt = conn.createStatement();
            String resetQuery = "DELETE FROM developers";
            stmt.executeUpdate(resetQuery);
            stmt.close();
            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        response.sendRedirect("developers.jsp");
    }
}
