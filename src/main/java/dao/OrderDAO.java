package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;
import model.Order;
import util.DBConnection;

public class OrderDAO {
	Connection connection = null;
	ResultSet resultSet = null;
	Statement statement = null;
	PreparedStatement preparedStatement = null;

	public List<Order> get() {
		List<Order> list = null;
		Order order = null;
		try {
			list = new ArrayList<Order>();
			String sql = "SELECT * FROM orders";
			connection = DBConnection.openConnection();
			statement = connection.createStatement();
			resultSet = statement.executeQuery(sql);
			while (resultSet.next()) {
				order = new Order();
				order.setId(resultSet.getInt("order_id"));
				order.setCustomer_id(resultSet.getInt("customer_id"));
				order.setDeliverer_id(resultSet.getInt("deliverer_id"));
				order.setTimestamp(resultSet.getTimestamp("timestamp"));
				order.setDelivery_status(resultSet.getString("Delivery_status"));
				order.setIs_paid(resultSet.getBoolean("Is_paid"));
				
				list.add(order);
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return list;
	}

	public Order get(int id) {
		Order order = null;
		try {
			order = new Order();
			String sql = "SELECT * FROM orders where order_id=" + id;
			connection = DBConnection.openConnection();
			statement = connection.createStatement();
			resultSet = statement.executeQuery(sql);
			if (resultSet.next()) {
				order.setId(resultSet.getInt("order_id"));
				order.setCustomer_id(resultSet.getInt("order_id"));
				order.setDeliverer_id(resultSet.getInt("deliverer_id"));
				order.setTimestamp(resultSet.getTimestamp("timestamp"));
				order.setDelivery_status(resultSet.getString("delivery_status"));
				order.setIs_paid(resultSet.getBoolean("is_paid"));
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return order;
	}
	
	public List<Integer> getAllId() throws SQLException {
		String sql = "select order_id from orders";
		connection = DBConnection.openConnection();
		statement = connection.createStatement();
		resultSet = statement.executeQuery(sql);
		
		List<Integer> list = new ArrayList<Integer>();
		while (resultSet.next()) {
			list.add(resultSet.getInt("order_id"));
		}
		return list;
	}

	public boolean saveCustomerId(int id) throws SQLException {
		String sql = "insert into orders (customer_id) values (" + id + ")";
		connection = DBConnection.openConnection();
		statement = connection.createStatement();
		int rowInserted = statement.executeUpdate(sql);
		return rowInserted > 0;
	}
	
	public boolean save(Order order) {
		boolean flag = false;
	  
		try {
			String sql = "INSERT INTO orders (order_date,customer_id,delivery_status,deliverer_id,is_paid) VALUES (?,?,?,?,?)";
			connection = DBConnection.openConnection();
			preparedStatement = connection.prepareStatement(sql);
			preparedStatement.setTimestamp(1, order.getTimestamp());
			preparedStatement.setInt(2, order.getCustomer_id());
			preparedStatement.setString(3, order.getDelivery_status());
			preparedStatement.setInt(4, order.getDeliverer_id());
			preparedStatement.setBoolean(5, order.isIs_paid());
			
			int rowInserted = preparedStatement.executeUpdate();
			if (rowInserted > 0)
				flag = true;
		} catch (SQLException ex) {
			ex.printStackTrace();
		}
		return flag;
	}
	
	public int getLatestId() throws SQLException {
		String sql = "select max(order_id) as id from orders";
		connection = DBConnection.openConnection();
		statement = connection.createStatement();
		resultSet = statement.executeQuery(sql);
		if (resultSet.next()) {
			return resultSet.getInt("id");
		}
		return -1;
	}

	public boolean delete(int id) {
		boolean flag = false;
		try {
			String sql = "DELETE FROM orders where order_id=" + id;
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
	
}	

