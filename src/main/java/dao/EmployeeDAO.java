package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import additional.PasswordEncryptor;
import model.Employee;
import util.DBConnection;

public class EmployeeDAO {
  Connection connection = null;
  ResultSet resultSet = null;
  Statement statement = null;
  PreparedStatement preparedStatement = null;

  public List<Employee> get() {
    List<Employee> list = null;
    Employee employee = null;
    try {
      list = new ArrayList<Employee>();
      String sql = "SELECT * FROM employees";
      connection = DBConnection.openConnection();
      statement = connection.createStatement();
      resultSet = statement.executeQuery(sql);
      while (resultSet.next()) {
        employee = new Employee();
        employee.setId(resultSet.getInt("employee_id"));
        employee.setName(resultSet.getString("employee_name"));
        employee.setEmail(resultSet.getString("employee_email"));
        employee.setPassword(resultSet.getString("employee_password"));
        employee.setPhone(resultSet.getLong("employee_phone"));
        employee.setProfile_pic(resultSet.getString("employee_profile_pic"));
        employee.setSalary(resultSet.getInt("employee_salary"));
        employee.setRole(resultSet.getString("employee_role"));
        
        list.add(employee);
      }
    } catch (SQLException e) {
      e.printStackTrace();
    }
    return list;
  }
  public List<Employee> getUnverified() {
    List<Employee> list = null;
    Employee employee = null;
    try {
      list = new ArrayList<Employee>();
      String sql = "SELECT * FROM employees where is_verified = false";
      connection = DBConnection.openConnection();
      statement = connection.createStatement();
      resultSet = statement.executeQuery(sql);
      while (resultSet.next()) {
        employee = new Employee();
        employee.setId(resultSet.getInt("employee_id"));
        employee.setName(resultSet.getString("employee_name"));
        employee.setEmail(resultSet.getString("employee_email"));
        employee.setPassword(resultSet.getString("employee_password"));
        employee.setPhone(resultSet.getLong("employee_phone"));
        employee.setProfile_pic(resultSet.getString("employee_profile_pic"));
        employee.setSalary(resultSet.getInt("employee_salary"));
        employee.setRole(resultSet.getString("employee_role"));
        employee.setVerified(resultSet.getBoolean("is_verified"));
        list.add(employee);
      }
    } catch (SQLException e) {
      e.printStackTrace();
    }
    return list;
  }

  public List<Employee> getVerified() {
    List<Employee> list = null;
    Employee employee = null;
    try {
      list = new ArrayList<Employee>();
      String sql = "SELECT * FROM employees where is_verified = true";
      connection = DBConnection.openConnection();
      statement = connection.createStatement();
      resultSet = statement.executeQuery(sql);
      while (resultSet.next()) {
        employee = new Employee();
        employee.setId(resultSet.getInt("employee_id"));
        employee.setName(resultSet.getString("employee_name"));
        employee.setEmail(resultSet.getString("employee_email"));
        employee.setPassword(resultSet.getString("employee_password"));
        employee.setPhone(resultSet.getLong("employee_phone"));
        employee.setProfile_pic(resultSet.getString("employee_profile_pic"));
        employee.setSalary(resultSet.getInt("employee_salary"));
        employee.setRole(resultSet.getString("employee_role"));
        employee.setVerified(resultSet.getBoolean("is_verified"));


list.add(employee);
      }
    } catch (SQLException e) {
      e.printStackTrace();
    }
    return list;
  }
  
  public boolean fire(int id) throws SQLException {
    String sql = "update employees set is_verified = false where employee_id = " + id;
    connection = DBConnection.openConnection();
    statement = connection.createStatement();
    int rowUpdated = statement.executeUpdate(sql);
    
    return rowUpdated>0;
  }
  
  public boolean checkOngoingExist(int id) throws SQLException {
	  String sql = "select * from orders where delivery_status = 'ongoing' and deliverer_id = " + id;
	    connection = DBConnection.openConnection();
	    statement = connection.createStatement();
	    resultSet = statement.executeQuery(sql);
	    
	    return resultSet.next();
  }
  
  public Employee get(int id) {
    Employee employee = null;
    try {
      employee = new Employee();
      String sql = "SELECT * FROM employees where employee_id=" + id;
      connection = DBConnection.openConnection();
      statement = connection.createStatement();
      resultSet = statement.executeQuery(sql);
      if (resultSet.next()) {
        employee.setId(resultSet.getInt("employee_id"));
        employee.setName(resultSet.getString("employee_name"));
        employee.setEmail(resultSet.getString("employee_email"));
        employee.setPassword(resultSet.getString("employee_password"));
        employee.setPhone(resultSet.getLong("employee_phone"));
        employee.setProfile_pic(resultSet.getString("employee_profile_pic"));
        employee.setSalary(resultSet.getInt("employee_salary"));
        employee.setRole(resultSet.getString("employee_role")==null? "delivery staff": resultSet.getString("employee_role"));
        employee.setVerified(resultSet.getBoolean("is_verified"));
        
        System.out.println("Employee role in employee dao is " + employee.getRole());
      }
    } catch (SQLException e) {
      e.printStackTrace();
    }
    return employee;
  }
  
  public boolean updateSalary(int id, double salary) throws SQLException {
    String sql = "update employees set employee_salary = " + salary + " where employee_id = " + id;
    connection = DBConnection.openConnection();
    statement = connection.createStatement();
    int rowUpdated = statement.executeUpdate(sql);
    
    return rowUpdated>0;
  }
  
  public boolean updateSalary(double salary) throws SQLException {
    String sql = "update employees set employee_salary = " + salary;
    connection = DBConnection.openConnection();
    statement = connection.createStatement();
    int rowUpdated = statement.executeUpdate(sql);
    
    return rowUpdated>0;
  }
  
  public boolean isPasswordTrue(String email, String password) throws Exception {
    String sql = "select employee_password from employees where employee_email = '"  + email + "'";
    connection = DBConnection.openConnection();
    statement = connection.createStatement();
    resultSet = statement.executeQuery(sql);
    String passwordFromDB = "";
    if (resultSet.next()) {
      passwordFromDB = resultSet.getString("employee_password");
    }
    
    PasswordEncryptor enc = new PasswordEncryptor();
    String realPassword = enc.decrypt(passwordFromDB);
    
    System.out.println("The real password is " + realPassword);
    
    return realPassword.equalsIgnoreCase(password);
  }
  
  public int get(String email) {
    Employee employee = null;
    int id = -1;
    try {
      employee = new Employee();
      String sql = "SELECT employee_id from employees where employee_email = '" + email + "'";
      connection = DBConnection.openConnection();
      statement = connection.createStatement();
      resultSet = statement.executeQuery(sql);
      if (resultSet.next()) id = resultSet.getInt("employee_id");
    } catch (SQLException e) {
      e.printStackTrace();
    }
    return id;
  }

public boolean save(Employee employee) {
    boolean flag = false;
    try {
      String sql = "INSERT INTO employees (employee_name, employee_email, employee_password, employee_phone,employee_role , employee_salary, employee_profile_pic, is_verified ) VALUES (?,?,?,?,?,?,?,?)";
      connection = DBConnection.openConnection();
      preparedStatement = connection.prepareStatement(sql);
      preparedStatement.setString(1, employee.getName());
      preparedStatement.setString(2, employee.getEmail());
      preparedStatement.setString(3, employee.getPassword());
      preparedStatement.setLong(4, employee.getPhone());
      preparedStatement.setString(5, "delivery staff");
      preparedStatement.setLong(6, 200000);
      preparedStatement.setString(7, employee.getProfile_pic());
      preparedStatement.setBoolean(8, false);
      
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
      String sql = "DELETE FROM employees where employee_id=" + id;
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

  public boolean update(Employee employee) {
    boolean flag = false;
    try {
      String sql = "UPDATE employees SET employee_name = ?, employee_email = ?, employee_password = ?, employee_phone = ?, employee_role = ?, employee_salary = ?, employee_profile_pic = ? where employee_id = ?";
      connection = DBConnection.openConnection();
      preparedStatement = connection.prepareStatement(sql);
      preparedStatement.setString(1, employee.getName());
      preparedStatement.setString(2, employee.getEmail());
      preparedStatement.setString(3, employee.getPassword());
      preparedStatement.setLong(4, employee.getPhone());
      preparedStatement.setString(5, employee.getRole());
      preparedStatement.setLong(6, employee.getSalary());
      preparedStatement.setString(7, employee.getProfile_pic());
      preparedStatement.setInt(8, employee.getId());
      
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
    String sql = "UPDATE employees SET is_verified = true, employee_salary=150000 where employee_id = ?";
    connection = DBConnection.openConnection();
    preparedStatement = connection.prepareStatement(sql);
    System.out.println("the id to update is " + id);
    preparedStatement.setString(1, id);
    int rowUpdated = preparedStatement.executeUpdate();
    return rowUpdated > 0;
  }  
  
  public boolean doesExist(String email) throws SQLException {
    
    System.out.println("The email in doesExist is " + email);
    String sql = "select employee_id from employees where employee_email = '" + email + "'";
    connection = DBConnection.openConnection();
    statement = connection.createStatement();
    resultSet = statement.executeQuery(sql);
    if (resultSet.next()) {
      System.out.println(true);
      return true;
    }
    System.out.println(false);
    return false;
  }
  
  
  public boolean update(String id, String name, String email, String phone) throws SQLException {
		// TODO Auto-generated method stub
		String sql = "update employees set employee_name = ?, employee_email = ?, employee_phone = ? where employee_id = ?";
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