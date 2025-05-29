package developer;
import java.io.IOException;
import java.io.OutputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/ImageServlet")
public class ImageServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    	System.out.println("Got into the ImageServelt servelt");
        String id = request.getParameter("id");
        System.out.println("Got the id" + Integer.parseInt(id));
        
        boolean isCustomer = true, isDeveloper = false, isAdmin = false;
        if (Integer.parseInt(id)>49 && Integer.parseInt(id)<100) {
        	isAdmin = true;
        	isCustomer = false;
        } else if (Integer.parseInt(id)>=0 && Integer.parseInt(id)<50) {
        	isDeveloper = true;
        	isCustomer = false;
        }
        System.out.println("He/She is a " + (isCustomer? "customer": isDeveloper? "developer": "admin"));

        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        String url = "jdbc:mysql://localhost:3306/panmyodaw";
        String user = "root"; // Update with your DB username
        String dbPassword = System.getenv("DB_PASSWORD"); // Update with your DB password

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection(url, user, dbPassword);

            String query = isCustomer? "SELECT customer_profile_pic FROM customers WHERE customer_id=?": isDeveloper? "SELECT developer_profile_pic FROM developers WHERE developer_id=?": "SELECT admin_profile_pic FROM admins WHERE admin_id=?";
            stmt = conn.prepareStatement(query);
            stmt.setInt(1, Integer.parseInt(id));
            rs = stmt.executeQuery();

            if (rs.next()) {
                byte[] imgData = rs.getBytes(isCustomer?"customer_profile_pic":isDeveloper?"developer_profile_pic":"admin_profile_pic");
                response.setContentType("image/jpeg");
                OutputStream os = response.getOutputStream();
                os.write(imgData);
                os.flush();
                os.close();
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND); // 404 error
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR); // 500 error
        } finally {
            try {
                if (rs != null) rs.close();
                if (stmt != null) stmt.close();
                if (conn != null) conn.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }
}
