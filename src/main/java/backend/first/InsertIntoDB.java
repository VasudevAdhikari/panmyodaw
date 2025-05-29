package backend.first;

import javax.servlet.ServletException;
import com.google.gson.Gson;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.*;
import additional.PasswordEncryptor;
import additional.User;
import additional.UserChecker;
import model.Customer;

@WebServlet("/InsertIntoDB")
public class InsertIntoDB extends HttpServlet {
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		PasswordEncryptor passwordEncryptor = new PasswordEncryptor();

		HttpSession session = request.getSession(false);
		String name = (String) session.getAttribute("name");
		String city = (String) session.getAttribute("city");
		String profilePic = (String) session.getAttribute("profilePic");
		String email = (String) session.getAttribute("email");
		Long phone = (Long) session.getAttribute("phone");
		String password = (String) session.getAttribute("password");
		System.out.println("got name, city, profile picture, email, phone and password from the session");

		String jdbcURL = "jdbc:mysql://localhost:3306/panmyodaw";
		String dbUser = "root";
		String dbPassword = System.getenv("DB_PASSWORD");

		try {
			Class.forName("com.mysql.cj.jdbc.Driver");
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
		}

		try (Connection connection = DriverManager.getConnection(jdbcURL, dbUser, dbPassword)) {
			String insertSql = "INSERT INTO customers (customer_name, customer_city, customer_profile_pic, customer_email, customer_phone, customer_password, shop_name, latitude, longitude) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
			try (PreparedStatement insertStatement = connection.prepareStatement(insertSql)) {
				insertStatement.setString(1, name);
				insertStatement.setString(2, city);
				insertStatement.setString(3, profilePic);
				insertStatement.setString(4, email);
				insertStatement.setLong(5, phone);
				insertStatement.setString(6, passwordEncryptor.encrypt(password));
				insertStatement.setString(7, (String) session.getAttribute("shop"));
				insertStatement.setDouble(8, (Double.parseDouble((String) session.getAttribute("latitude"))));
				insertStatement.setDouble(9, (Double.parseDouble((String) session.getAttribute("longitude"))));

				int successful = insertStatement.executeUpdate();
				System.out.println(successful > 0 ? "Insert successful. Congratulations" : "Insert not successful.");
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			UserChecker userChecker = new UserChecker();
			Customer customer = userChecker.getUserInfo(email);
			
			Cookie cookie = new Cookie("user_id", customer.getId()+"");
			cookie.setMaxAge(60 * 60 * 24 * 60);
			response.addCookie(cookie);

			response.sendRedirect(request.getContextPath() + "/customer_home_page.jsp");
		} catch (ClassNotFoundException | SQLException e) {
			e.printStackTrace();
		}
	}
}
