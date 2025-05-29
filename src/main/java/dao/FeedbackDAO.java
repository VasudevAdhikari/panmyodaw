package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import model.Feedback;
import util.DBConnection;

public class FeedbackDAO {
	Connection connection = null;
	ResultSet resultSet = null;
	Statement statement = null;
	PreparedStatement preparedStatement = null;

	public List<Feedback> getNotResponded() {
		System.out.println("got into getNotResponded method");
		List<Feedback> list = null;
		Feedback feedback = null;
		try {
			list = new ArrayList<Feedback>();
			String sql = "SELECT * FROM feedback where reply is null";
			connection = DBConnection.openConnection();
			statement = connection.createStatement();
			resultSet = statement.executeQuery(sql);
			while (resultSet.next()) {
				feedback = new Feedback();
				feedback.setId(resultSet.getInt("feedback_id"));
				feedback.setCustomer_id(resultSet.getInt("customer_id"));
				feedback.setDescription(resultSet.getString("description"));
				feedback.setFeedback_date(resultSet.getString("feedback_date"));
				list.add(feedback);
				System.out.println(feedback.getCustomer_id() + feedback.getDescription());
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return list;
	}

	public Feedback get(int id) {
		Feedback feedback = null;
		try {
			feedback = new Feedback();
			String sql = "SELECT * FROM feedback where feedback_id=" + id;
			connection = DBConnection.openConnection();
			statement = connection.createStatement();
			resultSet = statement.executeQuery(sql);
			if (resultSet.next()) {
				feedback.setId(resultSet.getInt("feedback_id"));
				feedback.setCustomer_id(resultSet.getInt("customer_id"));
				feedback.setDescription(resultSet.getString("description"));
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return feedback;
	}
	
	public List<Feedback> getByCustomer(int id) {
	    List<Feedback> list = new ArrayList<>();
	    try {
	        String sql = "SELECT * FROM feedback WHERE customer_id=" + id;
	        connection = DBConnection.openConnection();
	        statement = connection.createStatement();
	        resultSet = statement.executeQuery(sql);
	        while (resultSet.next()) {
	            Feedback feedback = new Feedback(); // Create a new Feedback object for each record
	            feedback.setId(resultSet.getInt("feedback_id"));
	            feedback.setFeedback_date(resultSet.getString("feedback_date"));
	            feedback.setCustomer_id(resultSet.getInt("customer_id"));
	            feedback.setDescription(resultSet.getString("description"));
	            feedback.setReply(resultSet.getString("reply"));
	            
	            list.add(feedback); // Add the newly created object to the list
	        }
	    } catch (SQLException e) {
	        e.printStackTrace();
	    }
	    for (Feedback f : list) {
	        System.out.println(f.getDescription() + " " + f.getReply());
	    }
	    return list;
	}
	
	public String getReply(int id) throws SQLException {
		String sql = "SELECT reply FROM feedback where feedback_id=" + id;
		connection = DBConnection.openConnection();
		statement = connection.createStatement();
		resultSet = statement.executeQuery(sql);
		if (resultSet.next()) {
			return resultSet.getString("reply");
		}
		return "";
	}

	public boolean save(Feedback feedback) {
		boolean flag = false;
		try {
			String sql = "INSERT INTO feedback (customer_id, description) VALUES (?,?)";
			connection = DBConnection.openConnection();
			preparedStatement = connection.prepareStatement(sql);
			preparedStatement.setInt(1, feedback.getCustomer_id());
			preparedStatement.setString(2, feedback.getDescription());
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
			String sql = "DELETE FROM feedback where feedback_id=" + id;
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

	public boolean setReply(String id, String replyText) throws SQLException {
		// TODO Auto-generated method stub
		String sql = "update feedback set reply = '" + replyText + "' where feedback_id = " + id;
		connection = DBConnection.openConnection();
		statement = connection.createStatement();
		int rowUpdated = statement.executeUpdate(sql);
		
		return rowUpdated > 0;
	}
	
}
