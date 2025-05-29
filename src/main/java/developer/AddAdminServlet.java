package developer;

import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;

@WebServlet("/AddAdminServlet")
@MultipartConfig(maxFileSize = 16177215) // Upload file's size up to 16MB
public class AddAdminServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Get the form data
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String password = request.getParameter("password");
        String city = request.getParameter("city");
        Part filePart = request.getPart("profilePicture");
        InputStream inputStream = null;

        if (filePart != null) {
            // Retrieves input stream of the upload file
            inputStream = filePart.getInputStream();
        }

        // Database connection settings
        String dbURL = "jdbc:mysql://localhost:3306/panmyodaw";
        String dbUser = "root"; // Update with your DB username
        String dbPass = System.getenv("DB_PASSWORD"); // Update with your DB password

        Connection conn = null;
        String message = null; // Message will be sent back to client

        try {
            // Connect to the database
            DriverManager.registerDriver(new com.mysql.cj.jdbc.Driver());
            conn = DriverManager.getConnection(dbURL, dbUser, dbPass);

            // SQL query to insert data into the customers table
            String sql = "INSERT INTO admins (admin_name, admin_email, admin_phone, admin_password, admin_city, admin_profile_pic) values (?, ?, ?, ?, ?, ?)";
            PreparedStatement statement = conn.prepareStatement(sql);
            statement.setString(1, name);
            statement.setString(2, email);
            statement.setString(3, phone);
            statement.setString(4, password);
            statement.setString(5, city);

            if (inputStream != null) {
                // Fetches input stream of the upload file for the blob column
                statement.setBlob(6, inputStream);
            }

            // Sends the statement to the database server
            int row = statement.executeUpdate();
            if (row > 0) {
                message = "Admin added successfully!";
            }
        } catch (SQLException ex) {
            message = "ERROR: " + ex.getMessage();
            ex.printStackTrace();
        } finally {
            if (conn != null) {
                // Closes the database connection
                try {
                    conn.close();
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
            // Sets the message in request scope
            request.setAttribute("Message", message);
            // Forwards to the message page
            response.sendRedirect("admins.jsp");
        }
    }
}
