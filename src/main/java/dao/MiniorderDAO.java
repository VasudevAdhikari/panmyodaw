package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;
import model.Miniorder;
import util.DBConnection;

public class MiniorderDAO {
	Connection connection = null;
	ResultSet resultSet = null;
	Statement statement = null;
	PreparedStatement preparedStatement = null;

	public List<Miniorder> get() {
		List<Miniorder> list = null;
		Miniorder miniorder = null;
		try {
			list = new ArrayList<Miniorder>();
			String sql = "SELECT * FROM miniorders";
			connection = DBConnection.openConnection();
			statement = connection.createStatement();
			resultSet = statement.executeQuery(sql);
			while (resultSet.next()) {
				miniorder = new Miniorder();
				miniorder.setId(resultSet.getInt("miniorder_id"));
				miniorder.setOrder_id(resultSet.getInt("order_id"));
				miniorder.setProduct_id(resultSet.getInt("product_id"));
				miniorder.setQuantity(resultSet.getInt("quantity"));
				
				list.add(miniorder);
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return list;
	}

	public Miniorder get(int id) {
		Miniorder miniorder = null;
		try {
			miniorder = new Miniorder();
			String sql = "SELECT * FROM miniorders where miniorder_id=" + id;
			connection = DBConnection.openConnection();
			statement = connection.createStatement();
			resultSet = statement.executeQuery(sql);
			if (resultSet.next()) {
				miniorder.setId(resultSet.getInt("miniorder_id"));
				miniorder.setOrder_id(resultSet.getInt("order_id"));
				miniorder.setProduct_id(resultSet.getInt("product_id"));
				miniorder.setQuantity(resultSet.getInt("quantity"));
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return miniorder;
	}


	public boolean save(Miniorder miniorder) {
		boolean flag = false;
	  
		try {
			String sql = "INSERT INTO miniorders (order_id,product_id,quantity) VALUES (?,?,?)";
			connection = DBConnection.openConnection();
			preparedStatement = connection.prepareStatement(sql);
			preparedStatement.setInt(1, miniorder.getOrder_id());
			preparedStatement.setInt(2, miniorder.getProduct_id());
			preparedStatement.setInt(3, miniorder.getQuantity());
			
			
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
			String sql = "DELETE FROM miniorders where miniorder_id=" + id;
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


