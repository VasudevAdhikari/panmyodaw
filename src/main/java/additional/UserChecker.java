package additional;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import model.Customer;
import dao.CustomerDAO;

public class UserChecker 
{
	protected static final String JDBC_URL = "jdbc:mysql://localhost:3306/panmyodaw";
	protected static final String DB_USER = "root";
	protected static final String DB_PASSWORD = System.getenv("DB_PASSWORD");

	public boolean doesUserExist(String table, String attribute, String email) throws SQLException, ClassNotFoundException
	{
		Class.forName("com.mysql.cj.jdbc.Driver");
		try (Connection connection = DriverManager.getConnection(JDBC_URL, DB_USER, DB_PASSWORD))
		{
			String query = String.format("SELECT 1 FROM %s WHERE %s = ?", table, attribute);
			System.out.println(query);
			try (PreparedStatement statement = connection.prepareStatement(query)) 
			{
				statement.setString(1, email);
				try (ResultSet resultSet = statement.executeQuery()) 
				{
					return resultSet.next(); // returns true if a row is found
				}
			}
		}
	}
	
	public boolean doesUserExist(String email) throws ClassNotFoundException, SQLException {
		return this.doesUserExist("customers", "customer_email", email);
	}
	
	public boolean isCustomer(String email) throws ClassNotFoundException, SQLException {
		return this.doesUserExist("customers", "customer_email", email);
	}
	
	public boolean isDeveloper(String email) throws ClassNotFoundException, SQLException {
		return this.doesUserExist("developers", "developer_email", email);
	}
	
	public boolean isAdmin(String email) throws ClassNotFoundException, SQLException {
		return this.doesUserExist("admins", "admin_email", email);
	}
	
	public Customer getUserInfo(String email) throws ClassNotFoundException, SQLException {
		System.out.println("Got into the getUserInfo method");
		String id=null;
		String table_name = this.isCustomer(email)? "customer": this.isAdmin(email)? "admin": "developer";
		Class.forName("com.mysql.cj.jdbc.Driver");
		try (Connection connection = DriverManager.getConnection(JDBC_URL, DB_USER, DB_PASSWORD))
		{
			Statement statement = connection.createStatement();
			String query = String.format("SELECT * FROM %ss where %s_email = '%s'", table_name, table_name, email);
			System.out.println(query);
			ResultSet resultSet = statement.executeQuery(query);
			
			while (resultSet.next()) {
				id = resultSet.getString(String.format("%s_id", table_name));
			}
		}
		CustomerDAO customerDAO = new CustomerDAO();
		return customerDAO.get(Integer.parseInt(id));
	}
}