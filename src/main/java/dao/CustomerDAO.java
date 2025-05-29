package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import model.Customer;
import util.DBConnection;

public class CustomerDAO {
	Connection connection = null;
	ResultSet resultSet = null;
	Statement statement = null;
	PreparedStatement preparedStatement = null;

	public List<Customer> get() {
		List<Customer> list = null;
		Customer customer = null;
		try {
			list = new ArrayList<Customer>();
			String sql = "SELECT * FROM customers";
			connection = DBConnection.openConnection();
			statement = connection.createStatement();
			resultSet = statement.executeQuery(sql);
			while (resultSet.next()) {
				customer = new Customer();
				customer.setId(resultSet.getInt("customer_id"));
				customer.setName(resultSet.getString("customer_name"));
				customer.setShop_name(resultSet.getString("shop_name"));
				customer.setEmail(resultSet.getString("customer_email"));
				customer.setPassword(resultSet.getString("customer_password"));
				customer.setPhone(resultSet.getLong("customer_phone"));
				customer.setProfile_pic(resultSet.getString("customer_profile_pic"));
				customer.setAddress(resultSet.getString("customer_city"));
				customer.setLatitude(resultSet.getDouble("latitude"));
				customer.setLongitude(resultSet.getDouble("longitude"));
				list.add(customer);
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return list;
	}

	public boolean update(String id, String name, String email, String phone, String shop, String city)
			throws SQLException {
		// TODO Auto-generated method stub
		String sql = "update customers set customer_name = ?, customer_email = ?, customer_phone = ?, shop_name = ?, customer_city = ? where customer_id = ?";
		connection = DBConnection.openConnection();
		preparedStatement = connection.prepareStatement(sql);
		preparedStatement.setInt(6, Integer.parseInt(id));
		preparedStatement.setString(1, name);
		preparedStatement.setString(2, email);
		preparedStatement.setLong(3, Long.parseLong(phone));
		preparedStatement.setString(4, shop);
		preparedStatement.setString(5, city);
		int rowUpdated = preparedStatement.executeUpdate();
		return rowUpdated > 0;
	}

	public Customer get(int id) {
		Customer customer = null;
		try {
			customer = new Customer();
			String sql = "SELECT * FROM customers where customer_id=" + id;
			connection = DBConnection.openConnection();
			statement = connection.createStatement();
			resultSet = statement.executeQuery(sql);
			if (resultSet.next()) {
				customer.setId(resultSet.getInt("customer_id"));
				customer.setName(resultSet.getString("customer_name"));
				customer.setShop_name(resultSet.getString("shop_name"));
				customer.setEmail(resultSet.getString("customer_email"));
				customer.setPassword(resultSet.getString("customer_password"));
				customer.setPhone(resultSet.getLong("customer_phone"));
				customer.setProfile_pic(resultSet.getString("customer_profile_pic"));
				customer.setAddress(resultSet.getString("customer_city"));
				customer.setLatitude(resultSet.getDouble("latitude"));
				customer.setLongitude(resultSet.getDouble("longitude"));

				System.out.println("Customer city in dao is " + customer.getAddress());
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return customer;
	}

	public String getName(String id) throws SQLException {
		String sql = "SELECT customer_name FROM customers where customer_id=" + id;
		connection = DBConnection.openConnection();
		statement = connection.createStatement();
		resultSet = statement.executeQuery(sql);
		if (resultSet.next()) {
			return resultSet.getString("customer_name");
		}
		return "";
	}
	
	public String getProfile(String id) throws SQLException {
		String sql = "SELECT customer_profile_pic FROM customers where customer_id=" + id;
		connection = DBConnection.openConnection();
		statement = connection.createStatement();
		resultSet = statement.executeQuery(sql);
		if (resultSet.next()) {
			return resultSet.getString("customer_profile_pic");
		}
		return "";
	}

	public boolean save(Customer customer) {
		boolean flag = false;
		try {
			String sql = "INSERT INTO customers (customer_name, customer_email, customer_password, customer_phone, customer_profile_pic , customer_address, shop_name, latitude, longitude) VALUES (?,?,?,?,?,?,?,?,?)";
			connection = DBConnection.openConnection();
			preparedStatement = connection.prepareStatement(sql);
			preparedStatement.setString(1, customer.getName());
			preparedStatement.setString(2, customer.getEmail());
			preparedStatement.setString(3, customer.getPassword());
			preparedStatement.setLong(4, customer.getPhone());
			preparedStatement.setString(5, customer.getProfile_pic());
			preparedStatement.setString(6, customer.getAddress());
			preparedStatement.setString(7, customer.getShop_name());
			preparedStatement.setDouble(8, customer.getLatitude());
			preparedStatement.setDouble(9, customer.getLongitude());
			int rowInserted = preparedStatement.executeUpdate();
			if (rowInserted > 0)
				flag = true;
		} catch (SQLException ex) {
			ex.printStackTrace();
		}
		return flag;
	}

	public boolean delete(int id) {
		boolean flag = false;
		try {
			String sql = "DELETE FROM customers where customer_id=" + id;
			connection = DBConnection.openConnection();
			preparedStatement = connection.prepareStatement(sql);
			int rowDeleted = preparedStatement.executeUpdate();
			if (rowDeleted > 0)
				flag = true;
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return flag;
	}

	public boolean update(Customer customer) {
		boolean flag = false;
		try {
			String sql = "UPDATE customers SET customer_name = ?, customer_email = ?, customer_password = ?, customer_phone = ?, customer_address = ?, customer_profile_pic = ?, shop_name = ? where customer_id = ?";
			connection = DBConnection.openConnection();
			preparedStatement = connection.prepareStatement(sql);
			preparedStatement.setString(1, customer.getName());
			preparedStatement.setString(2, customer.getEmail());
			preparedStatement.setString(3, customer.getPassword());
			preparedStatement.setLong(4, customer.getPhone());
			preparedStatement.setString(5, customer.getAddress());
			preparedStatement.setString(6, customer.getProfile_pic());
			preparedStatement.setString(7, customer.getShop_name());
			preparedStatement.setInt(8, customer.getId());
			int rowUpdated = preparedStatement.executeUpdate();
			if (rowUpdated > 0)
				flag = true;
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return flag;
	}
}
