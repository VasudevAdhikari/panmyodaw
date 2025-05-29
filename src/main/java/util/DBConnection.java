package util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {
	private static Connection connection = null;

	public static Connection openConnection() {
		try {
			Class.forName("com.mysql.cj.jdbc.Driver");
			String password = System.getenv("DB_PASSWORD");
			connection = DriverManager.getConnection("jdbc:mysql://localhost:3306/panmyodaw", "root", password);
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return connection;
	}
}
