package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import model.LoginFailure;
import util.DBConnection;

public class LoginFailureDAO {
	Connection connection = null;
	ResultSet resultSet = null;
	Statement statement = null;
	PreparedStatement preparedStatement = null;

	public List<LoginFailure> get() {
		List<LoginFailure> list = null;
		LoginFailure loginFailure = null;
		try {
			list = new ArrayList<LoginFailure>();
			String sql = "SELECT * FROM LoginFailures";
			connection = DBConnection.openConnection();
			statement = connection.createStatement();
			resultSet = statement.executeQuery(sql);
			while (resultSet.next()) {
				loginFailure = new LoginFailure();
				loginFailure.setId(resultSet.getInt("login_failure_id"));
				loginFailure.setUserId(resultSet.getInt("user_id"));
				loginFailure.setIpAddress(resultSet.getString("ip_address"));
				loginFailure.setUserType(resultSet.getString("user_type"));
				loginFailure.setReason(resultSet.getString("reason"));
				loginFailure.setFailureTime(resultSet.getTimestamp("failure_time"));
				loginFailure.setSuspensionEndTime(resultSet.getTimestamp("suspension_end_time"));
				list.add(loginFailure);
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return list;
	}

	public LoginFailure get(int id, String userType) {
		LoginFailure loginFailure = null;
		try {
			String sql = "SELECT * FROM login_failures where user_id=" + id + " userType=" + userType;
			connection = DBConnection.openConnection();
			statement = connection.createStatement();
			resultSet = statement.executeQuery(sql);
			if (resultSet.next()) {
				loginFailure = new LoginFailure();
				loginFailure.setId(resultSet.getInt("login_failure_id"));
				loginFailure.setUserId(resultSet.getInt("user_id"));
				loginFailure.setIpAddress(resultSet.getString("ip_address"));
				loginFailure.setUserType(resultSet.getString("user_type"));
				loginFailure.setReason(resultSet.getString("reason"));
				loginFailure.setFailureTime(resultSet.getTimestamp("failure_time"));
				loginFailure.setSuspensionEndTime(resultSet.getTimestamp("suspension_end_time"));

			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return loginFailure;
	}

	public boolean save(LoginFailure loginFailure) {
		boolean flag = false;
		try {
			String sql = "INSERT INTO login_failures (user_id, ip_address, user_type, reason) VALUES (?,?,?,?)";
			connection = DBConnection.openConnection();
			preparedStatement = connection.prepareStatement(sql);
			preparedStatement.setInt(1, loginFailure.getUserId());
			preparedStatement.setString(2, loginFailure.getIpAddress());
			preparedStatement.setString(3, loginFailure.getUserType());
			preparedStatement.setString(4, loginFailure.getReason());
			int rowInserted = preparedStatement.executeUpdate();
			if (rowInserted > 0)
				flag = true;
		} catch (SQLException ex) {
			ex.printStackTrace();
		}
		return flag;
	}

	public boolean delete(int id, String userType) {
		boolean flag = false;
		try {
			String sql = "DELETE FROM login_failures where user_id=" + id + " user_type=" + userType;
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
