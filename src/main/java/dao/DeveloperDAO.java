package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import model.Developer;
import util.DBConnection;

public class DeveloperDAO {
	Connection connection = null;
	ResultSet resultSet = null;
	Statement statement = null;
	PreparedStatement preparedStatement = null;

	public List<Developer> get() {
		List<Developer> list = null;
		Developer developer = null;
		try {
			list = new ArrayList<Developer>();
			String sql = "SELECT * FROM developers";
			connection = DBConnection.openConnection();
			statement = connection.createStatement();
			resultSet = statement.executeQuery(sql);
			while (resultSet.next()) {
				developer = new Developer();
				developer.setId(resultSet.getInt("developer_id"));
				developer.setName(resultSet.getString("developer_name"));
				developer.setEmail(resultSet.getString("developer_email"));
				developer.setPassword(resultSet.getString("developer_password"));
				developer.setPhone(resultSet.getLong("developer_phone"));
				developer.setProfile_pic(resultSet.getString("developer_profile_pic"));
				list.add(developer);
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return list;
	}

	public Developer get(int id) {
		Developer developer = null;
		try {
			developer = new Developer();
			String sql = "SELECT * FROM developers where developer_id=" + id;
			connection = DBConnection.openConnection();
			statement = connection.createStatement();
			resultSet = statement.executeQuery(sql);
			if (resultSet.next()) {
				developer.setId(resultSet.getInt("developer_id"));
				developer.setName(resultSet.getString("developer_name"));
				developer.setEmail(resultSet.getString("developer_email"));
				developer.setPassword(resultSet.getString("developer_password"));
				developer.setPhone(resultSet.getLong("developer_phone"));
				developer.setProfile_pic(resultSet.getString("developer_profile_pic"));
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return developer;
	}

	public boolean save(Developer developer) {
		boolean flag = false;
		try {
			String sql = "INSERT INTO developers (developer_name, developer_email, developer_password, developer_phone, developer_profile_pic) VALUES (?,?,?,?,?)";
			connection = DBConnection.openConnection();
			preparedStatement = connection.prepareStatement(sql);
			preparedStatement.setString(1, developer.getName());
			preparedStatement.setString(2, developer.getEmail());
			preparedStatement.setString(3, developer.getPassword());
			preparedStatement.setLong(4, developer.getPhone());
			preparedStatement.setString(5, developer.getProfile_pic());
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
			String sql = "DELETE FROM developers where developer_id=" + id;
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

	public boolean update(Developer developer) {
		boolean flag = false;
		try {
			String sql = "UPDATE developers SET developer_name = ?, developer_email = ?, developer_password = ?, developer_phone = ?, developer_profile_pic = ? where developer_id = ?";
			connection = DBConnection.openConnection();
			preparedStatement = connection.prepareStatement(sql);
			preparedStatement.setString(1, developer.getName());
			preparedStatement.setString(2, developer.getEmail());
			preparedStatement.setString(3, developer.getPassword());
			preparedStatement.setLong(4, developer.getPhone());
			preparedStatement.setString(5, developer.getProfile_pic());
			int rowUpdated = preparedStatement.executeUpdate();
			if (rowUpdated > 0)
				flag = true;
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return flag;
	}
}
