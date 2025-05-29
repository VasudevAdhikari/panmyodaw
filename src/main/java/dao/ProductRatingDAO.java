package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import model.ProductRating;
import util.DBConnection;

public class ProductRatingDAO {
	Connection connection = null;
	ResultSet resultSet = null;
	Statement statement = null;
	PreparedStatement preparedStatement = null;

	public List<ProductRating> get() {
		List<ProductRating> list = null;
		ProductRating productRating = null;
		try {
			list = new ArrayList<ProductRating>();
			String sql = "SELECT * FROM product_rating where description is not null order by rating_id desc";
			connection = DBConnection.openConnection();
			statement = connection.createStatement();
			resultSet = statement.executeQuery(sql);
			while (resultSet.next()) {
				productRating = new ProductRating();
				productRating.setId(resultSet.getInt("rating_id"));
				productRating.setCustomer_id(resultSet.getInt("customer_id"));
				productRating.setProduct_id(resultSet.getInt("product_id"));
				productRating.setStars(resultSet.getInt("stars"));
				productRating.setDescription(resultSet.getString("description"));
				list.add(productRating);
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return list;
	}
	
	public int getOverallRating(int product_id) throws SQLException {
		String sql = "SELECT product_id, AVG(stars) AS overall_rating FROM product_rating WHERE product_id = " + product_id + " GROUP BY product_id";
		connection = DBConnection.openConnection();
		statement = connection.createStatement();
		resultSet = statement.executeQuery(sql);
		if (resultSet.next()) {
			return resultSet.getInt("overall_rating");
		}
		return 0;
	}

	public ProductRating get(int id) {
		ProductRating productRating = null;
		try {
			productRating = new ProductRating();
			String sql = "SELECT * FROM product_rating where rating_id=" + id;
			connection = DBConnection.openConnection();
			statement = connection.createStatement();
			resultSet = statement.executeQuery(sql);
			if (resultSet.next()) {
				productRating.setId(resultSet.getInt("rating_id"));
				productRating.setCustomer_id(resultSet.getInt("customer_id"));
				productRating.setProduct_id(resultSet.getInt("product_id"));
				productRating.setStars(resultSet.getInt("stars"));
				productRating.setDescription(resultSet.getString("description"));
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return productRating;
	}

	public boolean save(ProductRating productRating) {
		boolean flag = false;
		try {
			String sql = "INSERT INTO product_rating (customer_id, product_id, stars, description) VALUES (?,?,?,?)";
			connection = DBConnection.openConnection();
			preparedStatement = connection.prepareStatement(sql);
			preparedStatement.setInt(1, productRating.getCustomer_id());
			preparedStatement.setInt(2, productRating.getProduct_id());
			preparedStatement.setInt(3, productRating.getStars());
			preparedStatement.setString(4, productRating.getDescription());
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
			String sql = "DELETE FROM product_rating where rating_id=" + id;
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
