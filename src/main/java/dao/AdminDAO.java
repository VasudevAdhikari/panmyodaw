package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.Cookie;

import model.Admin;
import util.DBConnection;

public class AdminDAO {
	Connection connection = null;
	ResultSet resultSet = null;
	Statement statement = null;
	PreparedStatement preparedStatement = null;

	public List<Admin> get() {
		List<Admin> list = null;
		Admin admin = null;
		try {
			list = new ArrayList<Admin>();
			String sql = "SELECT * FROM admins";
			connection = DBConnection.openConnection();
			statement = connection.createStatement();
			resultSet = statement.executeQuery(sql);
			while (resultSet.next()) {
				admin = new Admin();
				admin.setId(resultSet.getInt("admin_id"));
				admin.setName(resultSet.getString("admin_name"));
				admin.setEmail(resultSet.getString("admin_email"));
				admin.setPassword(resultSet.getString("admin_password"));
				admin.setPhone(resultSet.getLong("admin_phone"));
				admin.setProfile_pic(resultSet.getString("admin_profile_pic"));
				list.add(admin);
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return list;
	}
	
	public List<Admin> getUnverified() {
		List<Admin> list = null;
		Admin admin = null;
		try {
			list = new ArrayList<Admin>();
			String sql = "SELECT * FROM admins where is_verified = false";
			connection = DBConnection.openConnection();
			statement = connection.createStatement();
			resultSet = statement.executeQuery(sql);
			while (resultSet.next()) {
				admin = new Admin();
				admin.setId(resultSet.getInt("admin_id"));
				admin.setName(resultSet.getString("admin_name"));
				admin.setEmail(resultSet.getString("admin_email"));
				admin.setPassword(resultSet.getString("admin_password"));
				admin.setPhone(resultSet.getLong("admin_phone"));
				admin.setProfile_pic(resultSet.getString("admin_profile_pic"));
				admin.setVerified(resultSet.getBoolean("is_verified"));
				list.add(admin);
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return list;
	}

	public List<Admin> getVerified() {
		List<Admin> list = null;
		Admin admin = null;
		try {
			list = new ArrayList<Admin>();
			String sql = "SELECT * FROM admins where is_verified = true";
			connection = DBConnection.openConnection();
			statement = connection.createStatement();
			resultSet = statement.executeQuery(sql);
			while (resultSet.next()) {
				admin = new Admin();
				admin.setId(resultSet.getInt("admin_id"));
				admin.setName(resultSet.getString("admin_name"));
				admin.setEmail(resultSet.getString("admin_email"));
				admin.setPassword(resultSet.getString("admin_password"));
				admin.setPhone(resultSet.getLong("admin_phone"));
				admin.setProfile_pic(resultSet.getString("admin_profile_pic"));
				admin.setVerified(resultSet.getBoolean("is_verified"));
				list.add(admin);
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return list;
	}

	
	public Admin get(int id) {
		Admin admin = null;
		try {
			admin = new Admin();
			String sql = "SELECT * FROM admins where admin_id=" + id;
			connection = DBConnection.openConnection();
			statement = connection.createStatement();
			resultSet = statement.executeQuery(sql);
			if (resultSet.next()) {
				admin.setId(resultSet.getInt("admin_id"));
				admin.setName(resultSet.getString("admin_name"));
				admin.setEmail(resultSet.getString("admin_email"));
				admin.setPassword(resultSet.getString("admin_password"));
				admin.setPhone(resultSet.getLong("admin_phone"));
				admin.setProfile_pic(resultSet.getString("admin_profile_pic"));
				admin.setVerified(resultSet.getBoolean("is_verified"));
				System.out.println("admin verification status: " + admin.isVerified());
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return admin;
	}
	
	public int get(String email) {
		Admin admin = null;
		int id = -1;
		try {
			admin = new Admin();
			String sql = "SELECT admin_id from admins where admin_email = '" + email + "'";
			connection = DBConnection.openConnection();
			statement = connection.createStatement();
			resultSet = statement.executeQuery(sql);
			if (resultSet.next()) id = resultSet.getInt("admin_id");
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return id;
	}

	public boolean save(Admin admin) {
		boolean flag = false;
		try {
			String sql = "INSERT INTO admins (admin_name, admin_email, admin_password, admin_phone, admin_profile_pic, is_verified) VALUES (?,?,?,?,?,?)";
			connection = DBConnection.openConnection();
			preparedStatement = connection.prepareStatement(sql);
			preparedStatement.setString(1, admin.getName());
			preparedStatement.setString(2, admin.getEmail());
			preparedStatement.setString(3, admin.getPassword());
			preparedStatement.setLong(4, admin.getPhone());
			preparedStatement.setString(5, admin.getProfile_pic());
			preparedStatement.setBoolean(6, false);
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
			String sql = "DELETE FROM admins where admin_id=" + id;
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

	public boolean update(Admin emp) {
		boolean flag = false;
		try {
			String sql = "UPDATE admins SET admin_name = ?, admin_email = ?, admin_password = ?, admin_phone = ?, admin_profile_pic = ? where admin_id = ?";
			connection = DBConnection.openConnection();
			preparedStatement = connection.prepareStatement(sql);
			preparedStatement.setString(1, emp.getName());
			preparedStatement.setString(2, emp.getEmail());
			preparedStatement.setString(3, emp.getPassword());
			preparedStatement.setLong(4, emp.getPhone());
			preparedStatement.setString(5, emp.getProfile_pic());
			preparedStatement.setInt(6, emp.getId());
			int rowUpdated = preparedStatement.executeUpdate();
			if (rowUpdated > 0)
				flag = true;
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return flag;
	}
	
	public boolean approve(String id) throws SQLException {
		System.out.println("this is approve method");
		String sql = "UPDATE admins SET is_verified = true where admin_id = ?";
		connection = DBConnection.openConnection();
		preparedStatement = connection.prepareStatement(sql);
		System.out.println("the id to update is " + id);
		preparedStatement.setString(1, id);
		int rowUpdated = preparedStatement.executeUpdate();
		return rowUpdated > 0? true: false;
	}	
	
	public boolean doesExist(String email) throws SQLException {
		String sql = "select admin_id from admins where admin_email = '" + email + "'";
		connection = DBConnection.openConnection();
		statement = connection.createStatement();
		resultSet = statement.executeQuery(sql);
		if (resultSet.next()) {
			return true;
		}
		return false;
	}

	public boolean update(String id, String name, String email, String phone) throws SQLException {
		// TODO Auto-generated method stub
		String sql = "update admins set admin_name = ?, admin_email = ?, admin_phone = ? where admin_id = ?";
		connection = DBConnection.openConnection();
		preparedStatement = connection.prepareStatement(sql);
		preparedStatement.setInt(4, Integer.parseInt(id));
		preparedStatement.setString(1, name);
		preparedStatement.setString(2, email);
		preparedStatement.setLong(3, Long.parseLong(phone));
		int rowUpdated = preparedStatement.executeUpdate();
		return rowUpdated>0;
	}
}



































