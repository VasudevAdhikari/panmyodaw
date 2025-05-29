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

@WebServlet("/DeleteCustomerServlet")
public class DeleteCustomerServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    	System.out.println("Got into the DeleteCustomerServlet.");
        String url = "jdbc:mysql://localhost:3306/panmyodaw";
        String user = "root"; // Update with your DB username
        String password = System.getenv("DB_PASSWORD"); // Update with your DB password

        int id = Integer.parseInt(request.getParameter("id"));
        System.out.println("Id to delete is " + id);
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection(url, user, password);
            Statement stmt = conn.createStatement();
            String deleteQuery = "DELETE FROM customers WHERE customer_id=" + id;
            System.out.println("Delete successful");
            stmt.executeUpdate(deleteQuery);
            stmt.close();
            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        response.sendRedirect("customers.jsp");
    }
}
