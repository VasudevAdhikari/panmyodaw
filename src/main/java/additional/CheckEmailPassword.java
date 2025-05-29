package additional;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class CheckEmailPassword 
{
	private String role = null;
	public void setRole(String role) {
		this.role = role;
	}
	public String getRole() {
		return this.role;
	}
	public boolean isPasswordTrue(String email, String password) throws Exception
	{
		System.out.println("got into the isPasswordTrue method");
		PasswordEncryptor passwordEncryptor = new PasswordEncryptor();
		String PasswordFromDB = null;
		
		UserChecker userChecker = new UserChecker();
		String table_name = userChecker.isCustomer(email)? "customers": userChecker.isAdmin(email)? "admins": "developers";
		String user_email = userChecker.isCustomer(email)? "customer_email": userChecker.isAdmin(email)? "admin_email": "developer_email";
		String user_password = userChecker.isCustomer(email)? "customer_password": userChecker.isAdmin(email)? "admin_password": "developer_password";
		this.setRole(table_name);
		
		Class.forName("com.mysql.cj.jdbc.Driver");
		try (Connection connection = DriverManager.getConnection(userChecker.JDBC_URL, userChecker.DB_USER, userChecker.DB_PASSWORD)) {
			System.out.println("got into the try block connection");
		    String sql = String.format("SELECT %s FROM %s WHERE %s = ?", user_password, table_name, user_email);
		    System.out.println(sql);
		    try (PreparedStatement preparedStatement = connection.prepareStatement(sql)) {
		    	System.out.println("Got into the second try block");
		        preparedStatement.setString(1, email);

		        try (ResultSet resultSet = preparedStatement.executeQuery()) {
		        	System.out.println("Got into the third try block");
		            if (resultSet.next()) {
		                PasswordFromDB = resultSet.getString(user_password);
		                System.out.println(PasswordFromDB);
		            } else {
		            	System.out.println("empty output from db.");
		            }
		        }
		        System.out.println("got out of the third try block");
		    }
		    System.out.println("Got out of the second try block");
		} catch (Exception e) {
		    e.printStackTrace();
		    System.out.println("Got out of first try block and got into the catch block.");
		}
		System.out.println("Now we are gonna decrypt the password");
		System.out.println("the password as argument is " + password);
		String realDBpassword = passwordEncryptor.decrypt(PasswordFromDB);
		System.out.println("real db password is " + realDBpassword);
		return realDBpassword.equalsIgnoreCase(password);
	}
}
