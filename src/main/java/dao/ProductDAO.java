package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import model.Product;
import util.DBConnection;

public class ProductDAO {
	Connection connection = null;
	ResultSet resultSet = null;
	Statement statement = null;
	PreparedStatement preparedStatement = null;

	public List<Product> get() {
		List<Product> list = null;
		Product product = null;
		try {
			list = new ArrayList<Product>();
			String sql = "SELECT * FROM products";
			connection = DBConnection.openConnection();
			statement = connection.createStatement();
			resultSet = statement.executeQuery(sql);
			while (resultSet.next()) {
				product = new Product();
				product.setId(resultSet.getInt("product_id"));
				product.setName(resultSet.getString("product_name"));
				product.setProfile_pic(resultSet.getString("product_pic"));
				product.setPrice(resultSet.getDouble("product_price"));
				product.setInStock(resultSet.getBoolean("in_stock"));
				product.setDiscount(resultSet.getDouble("discount"));
				product.setProduct_description(resultSet.getString("product_description"));
				product.setProfit(resultSet.getDouble("profit"));
				product.setTheme_color(resultSet.getString("theme_color"));
				list.add(product);
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return list;
	}
	
	public List<Product> getInStock() {
		List<Product> list = null;
		Product product = null;
		try {
			list = new ArrayList<Product>();
			String sql = "SELECT * FROM products where in_stock=true";
			connection = DBConnection.openConnection();
			statement = connection.createStatement();
			resultSet = statement.executeQuery(sql);
			while (resultSet.next()) {
				product = new Product();
				product.setId(resultSet.getInt("product_id"));
				product.setName(resultSet.getString("product_name"));
				product.setProfile_pic(resultSet.getString("product_pic"));
				product.setPrice(resultSet.getDouble("product_price"));
				product.setInStock(resultSet.getBoolean("in_stock"));
				product.setDiscount(resultSet.getDouble("discount"));
				product.setProduct_description(resultSet.getString("product_description"));
				product.setProfit(resultSet.getDouble("profit"));
				product.setTheme_color(resultSet.getString("theme_color"));
				list.add(product);
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return list;
	}

	public Product get(int id) {
		Product product = null;
		try {
			product = new Product();
			String sql = "SELECT * FROM products where product_id=" + id;
			connection = DBConnection.openConnection();
			statement = connection.createStatement();
			resultSet = statement.executeQuery(sql);
			if (resultSet.next()) {
				product.setId(resultSet.getInt("product_id"));
				product.setName(resultSet.getString("product_name"));
				product.setProfile_pic(resultSet.getString("product_pic"));
				product.setPrice(resultSet.getDouble("product_price"));
				product.setInStock(resultSet.getBoolean("in_stock"));
				product.setDiscount(resultSet.getDouble("discount"));
				product.setProduct_description(resultSet.getString("product_description"));
				product.setProfit(resultSet.getDouble("profit"));
				product.setTheme_color(resultSet.getString("theme_color"));
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return product;
	}
	
	public int getProductId(String name) throws SQLException {
		String sql = "select product_id from products where product_name = '" + name + "'";
		connection = DBConnection.openConnection();
		statement = connection.createStatement();
		resultSet = statement.executeQuery(sql);
		if (resultSet.next()) {
			int id = resultSet.getInt("product_id");
			return id;
		}
		return -1;
	}
	
	public String getProductName(int id) throws SQLException {
		String sql = "select product_name from products where product_id = '" + id + "'";
		connection = DBConnection.openConnection();
		statement = connection.createStatement();
		resultSet = statement.executeQuery(sql);
		if (resultSet.next()) {
			String name = resultSet.getString("product_name");
			return name;
		}
		return "";
	}

	public boolean save(Product product) {
		boolean flag = false;
		try {
			String sql = "INSERT INTO products (product_name, product_pic, product_price, in_stock, discount, profit, product_description, theme_color) VALUES (?,?,?,?,?,?,?,?)";
			connection = DBConnection.openConnection();
			preparedStatement = connection.prepareStatement(sql);
			preparedStatement.setString(1, product.getName());
			preparedStatement.setString(2, product.getProfile_pic());
			preparedStatement.setDouble(3, product.getPrice());
			preparedStatement.setBoolean(4, true);
			preparedStatement.setDouble(5, product.getDiscount());
			preparedStatement.setDouble(6, product.getProfit());
			preparedStatement.setString(7, product.getProduct_description());
			preparedStatement.setString(8, product.getTheme_color());
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
			String sql = "DELETE FROM products where product_id=" + id;
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
	
	public boolean update(Product product) {
		boolean flag = false;
		try {
			String sql = "UPDATE products SET product_name = ?, product_pic = ?, product_price = ?, in_stock = ?, discount = ?, profit=?, product_description=?, theme_color=? where product_id = ?";
			connection = DBConnection.openConnection();
			preparedStatement = connection.prepareStatement(sql);
			preparedStatement.setString(1, product.getName());
			preparedStatement.setString(2, product.getProfile_pic());
			preparedStatement.setDouble(3, product.getPrice());
			preparedStatement.setBoolean(4, product.isInStock());
			preparedStatement.setDouble(5, product.getDiscount());
			preparedStatement.setDouble(6, product.getProfit());
			preparedStatement.setString(7, product.getProduct_description());
			preparedStatement.setString(8, product.getTheme_color());
			preparedStatement.setInt(9, product.getId());
			int rowUpdated = preparedStatement.executeUpdate();
			if (rowUpdated > 0)
				flag = true;
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return flag;
	}
}
