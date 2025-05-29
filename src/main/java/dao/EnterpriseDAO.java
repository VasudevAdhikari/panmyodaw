package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

import util.DBConnection;

public class EnterpriseDAO {
    Connection connection = null;
    ResultSet resultSet = null;
    Statement statement = null;
    PreparedStatement preparedStatement = null;

    // Method to get the top 10 most selling shop names
    public ResultSet getTopTenSellingShops() {
        try {
            String sql = "SELECT c.shop_name, SUM(mo.quantity) AS total_sold " +
                         "FROM customers c " +
                         "JOIN orders o ON c.customer_id = o.customer_id " +
                         "JOIN miniorders mo ON o.order_id = mo.order_id " +
                         "GROUP BY c.shop_name " +
                         "ORDER BY total_sold DESC " +
                         "LIMIT 10";
            connection = DBConnection.openConnection();
            statement = connection.createStatement();
            resultSet = statement.executeQuery(sql);

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return resultSet;
    }

    // Method to get the top 10 most selling products
    public ResultSet getTopTenSellingProducts() {
        try {
            String sql = "SELECT p.product_name, SUM(mo.quantity) AS total_sold " +
                         "FROM products p " +
                         "JOIN miniorders mo ON p.product_id = mo.product_id " +
                         "GROUP BY p.product_name " +
                         "ORDER BY total_sold DESC " +
                         "LIMIT 10";
            connection = DBConnection.openConnection();
            statement = connection.createStatement();
            resultSet = statement.executeQuery(sql);

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return resultSet;
    }

    // Method to get each month's total sale for the past 6 months
    public ResultSet getPastSixMonthRevenue() {
        try {
            String sql = "SELECT DATE_FORMAT(o.order_date, '%Y-%m') AS sale_month, " +
                         "SUM(p.product_price * mo.quantity) AS total_sales " +
                         "FROM orders o " +
                         "JOIN miniorders mo ON o.order_id = mo.order_id " +
                         "JOIN products p ON mo.product_id = p.product_id " +
                         "WHERE o.order_date >= DATE_SUB(CURDATE(), INTERVAL 7 MONTH) " +
                         "GROUP BY sale_month " +
                         "ORDER BY sale_month ASC";
            connection = DBConnection.openConnection();
            statement = connection.createStatement();
            resultSet = statement.executeQuery(sql);

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return resultSet;
    }

    // Method to get each month's total sale for the past 6 months for a specific customer
    public ResultSet getPastSixMonthRevenueByCustomer(String customerId) {
        try {
            String sql = "SELECT DATE_FORMAT(o.order_date, '%Y-%m') AS sale_month, " +
                         "SUM(p.product_price * mo.quantity) AS total_sales " +
                         "FROM orders o " +
                         "JOIN miniorders mo ON o.order_id = mo.order_id " +
                         "JOIN products p ON mo.product_id = p.product_id " +
                         "WHERE o.customer_id = ? " +
                         "AND o.order_date >= DATE_SUB(CURDATE(), INTERVAL 7 MONTH) " +
                         "GROUP BY sale_month " +
                         "ORDER BY sale_month DESC";
            connection = DBConnection.openConnection();
            preparedStatement = connection.prepareStatement(sql);
            preparedStatement.setString(1, customerId);
            resultSet = preparedStatement.executeQuery();

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return resultSet;
    }

    // Method to get the most purchased top 10 customers for the past 28 days
    public ResultSet getTopTenCustomersPast28Days() {
        try {
            String sql = "SELECT c.customer_name, c.shop_name, SUM(mo.quantity) AS total_purchased " +
                         "FROM customers c " +
                         "JOIN orders o ON c.customer_id = o.customer_id " +
                         "JOIN miniorders mo ON o.order_id = mo.order_id " +
                         "WHERE o.order_date >= DATE_SUB(CURDATE(), INTERVAL 28 DAY) " +
                         "GROUP BY c.customer_id " +
                         "ORDER BY total_purchased DESC " +
                         "LIMIT 10";
            connection = DBConnection.openConnection();
            statement = connection.createStatement();
            resultSet = statement.executeQuery(sql);

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return resultSet;
    }

    // Method to get order details by order ID
    public ResultSet getOrderDetail(String orderId) {
    	System.out.println("Got into get order details method");
        try {
            String sql = "SELECT c.customer_name, c.customer_phone, c.latitude AS customer_latitude, delivery_date," +
                         "c.longitude AS customer_longitude, c.customer_city, " +
                         "e.employee_name AS deliverer, o.delivery_status, o.is_paid " +
                         "FROM orders o " +
                         "JOIN customers c ON o.customer_id = c.customer_id " +
                         "JOIN employees e ON o.deliverer_id = e.employee_id " +
                         "WHERE o.order_id = ?";
            connection = DBConnection.openConnection();
            preparedStatement = connection.prepareStatement(sql);
            preparedStatement.setString(1, orderId);
            resultSet = preparedStatement.executeQuery();

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return resultSet;
    }
    
    public ResultSet getBriefOrderDetail(String orderId) throws SQLException {
    	String sql = "SELECT o.order_id as order_id, is_paid, delivery_status, c.customer_id as customer_id, c.shop_name as shop_name, c.customer_city as customer_city, o.order_date as order_date " +
                "FROM orders o " +
                "JOIN customers c ON o.customer_id = c.customer_id " +
                "WHERE o.order_id = ?";
    	connection = DBConnection.openConnection();
    	preparedStatement = connection.prepareStatement(sql);
    	preparedStatement.setInt(1, Integer.parseInt(orderId));
    	resultSet = preparedStatement.executeQuery();
//    	List<Object> row = new ArrayList<Object>();
//    	while (resultSet.next()) {
//    		List<Object> column = new ArrayList<Object>();
//    		column.add(""+resultSet.getInt("customer_id"));
//    		column.add(resultSet.getString("shop_name"));
//    		column.add(resultSet.getString("customer_city"));
//    		column.add(resultSet.getString("order_date"));
//    		column.add(this.getTotalPrice(orderId));
//    		
//    		row.add(column);
//    	}
//    	
//    	return row;
    	
    	return resultSet;
    }
    
    public ResultSet getBriefOrderDetail() throws SQLException {
    	String sql = "SELECT o.order_id, o.order_date, delivery_status, c.customer_id as customer_id, c.shop_name as shop_name, c.customer_city as customer_city " +
                "FROM orders o " +
                "JOIN customers c ON o.customer_id = c.customer_id";
    	connection = DBConnection.openConnection();
    	statement = connection.createStatement();
    	resultSet = statement.executeQuery(sql);
//    	List<Object> row = new ArrayList<Object>();
//    	while (resultSet.next()) {
//    		List<Object> column = new ArrayList<Object>();
//    		column.add(""+resultSet.getInt("customer_id"));
//    		column.add(resultSet.getString("shop_name"));
//    		column.add(resultSet.getString("customer_city"));
//    		column.add(resultSet.getString("order_date"));
//    		column.add(this.getTotalPrice(orderId));
//    		
//    		row.add(column);
//    	}
//    	
//    	return row;
    	
    	return resultSet;
    }
    
    
    public ResultSet getBriefDeliveredOrderDetail() throws SQLException {
    	String sql = "SELECT o.order_id, o.order_date, delivery_status, c.customer_id as customer_id, c.shop_name as shop_name, c.customer_city as customer_city " +
                "FROM orders o " +
                "JOIN customers c ON o.customer_id = c.customer_id WHERE delivery_status = 'delivered'";
    	connection = DBConnection.openConnection();
    	statement = connection.createStatement();
    	resultSet = statement.executeQuery(sql);
//    	List<Object> row = new ArrayList<Object>();
//    	while (resultSet.next()) {
//    		List<Object> column = new ArrayList<Object>();
//    		column.add(""+resultSet.getInt("customer_id"));
//    		column.add(resultSet.getString("shop_name"));
//    		column.add(resultSet.getString("customer_city"));
//    		column.add(resultSet.getString("order_date"));
//    		column.add(this.getTotalPrice(orderId));
//    		
//    		row.add(column);
//    	}
//    	
//    	return row;
    	
    	return resultSet;
    }
    
    public ResultSet getBriefUndeliveredOrderDetail() throws SQLException {
    	String sql = "SELECT o.order_id, o.order_date, delivery_status, deliverer_id, c.customer_id as customer_id, c.shop_name as shop_name, c.customer_city as customer_city " +
                "FROM orders o " +
                "JOIN customers c ON o.customer_id = c.customer_id WHERE delivery_status = 'not-delivered'";
    	connection = DBConnection.openConnection();
    	statement = connection.createStatement();
    	resultSet = statement.executeQuery(sql);
//    	List<Object> row = new ArrayList<Object>();
//    	while (resultSet.next()) {
//    		List<Object> column = new ArrayList<Object>();
//    		column.add(""+resultSet.getInt("customer_id"));
//    		column.add(resultSet.getString("shop_name"));
//    		column.add(resultSet.getString("customer_city"));
//    		column.add(resultSet.getString("order_date"));
//    		column.add(this.getTotalPrice(orderId));
//    		
//    		row.add(column);
//    	}
//    	
//    	return row;
    	
    	return resultSet;
    }

    // Method to get a list of all miniorders for a specific order ID
    public ResultSet getMiniorders(String orderId) {
        try {
        	System.out.println("The order id is " + orderId);
            String sql = "SELECT mo.miniorder_id, p.product_name, mo.quantity, p.product_price, " +
                         "(mo.quantity * p.product_price) AS total_price " +
                         "FROM miniorders mo " +
                         "JOIN products p ON mo.product_id = p.product_id " +
                         "WHERE mo.order_id = ?";
            connection = DBConnection.openConnection();
            preparedStatement = connection.prepareStatement(sql);
            preparedStatement.setString(1, orderId);
            resultSet = preparedStatement.executeQuery();

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return resultSet;
    }

    // Method to get miniorder_id list
    public ResultSet getMiniorderIDList(String miniorderId) {
        try {
            String sql = "SELECT p.product_name, p.product_price, mo.quantity, " +
                         "(mo.quantity * p.product_price) AS total_price " +
                         "FROM miniorders mo " +
                         "JOIN products p ON mo.product_id = p.product_id " +
                         "WHERE mo.miniorder_id = ?";
            connection = DBConnection.openConnection();
            preparedStatement = connection.prepareStatement(sql);
            preparedStatement.setString(1, miniorderId);
            resultSet = preparedStatement.executeQuery();

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return resultSet;
    }

    // Method to get the total price of a specific order
    public long getTotalPrice(String orderId) throws SQLException {
        try {
            String sql = "SELECT SUM(mo.quantity * p.product_price) AS total_order_price " +
                         "FROM miniorders mo " +
                         "JOIN products p ON mo.product_id = p.product_id " +
                         "WHERE mo.order_id = ?";
            connection = DBConnection.openConnection();
            preparedStatement = connection.prepareStatement(sql);
            preparedStatement.setString(1, orderId);
            resultSet = preparedStatement.executeQuery();

        } catch (SQLException e) {
            e.printStackTrace();
        }
        if (resultSet.next()) {
        	return resultSet.getLong("total_order_price");
        }
        return -1;
    }

    // Method to get customer details by customer ID
    public ResultSet getCustomerDetail(String customerId) {
        try {
            String sql = "SELECT customer_id, customer_name, shop_name, customer_city, latitude, " +
                         "longitude, customer_email, customer_password, customer_address, customer_phone, " +
                         "customer_profile_pic " +
                         "FROM customers " +
                         "WHERE customer_id = ?";
            connection = DBConnection.openConnection();
            preparedStatement = connection.prepareStatement(sql);
            preparedStatement.setString(1, customerId);
            resultSet = preparedStatement.executeQuery();

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return resultSet;
    }

    // Method to get the total purchased amount by a specific customer in the last 30 days
    public ResultSet getTotalPurchasedAmount(String customerId) {
        try {
            String sql = "SELECT SUM(p.product_price * mo.quantity) AS total_purchased " +
                         "FROM orders o " +
                         "JOIN miniorders mo ON o.order_id = mo.order_id " +
                         "JOIN products p ON mo.product_id = p.product_id " +
                         "WHERE o.customer_id = ? " +
                         "AND o.order_date >= DATE_SUB(CURDATE(), INTERVAL 30 DAY)";
            connection = DBConnection.openConnection();
            preparedStatement = connection.prepareStatement(sql);
            preparedStatement.setString(1, customerId);
            resultSet = preparedStatement.executeQuery();

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return resultSet;
    }

    public double get30DayIncome() {
    	System.out.println("got into get 30 day income method");
        double totalAmount = 0.0;
        try {
            String sql = "SELECT SUM(mo.quantity * p.product_price) AS total_income_last_30_days " +
                         "FROM miniorders mo " +
                         "JOIN products p ON mo.product_id = p.product_id " +
                         "JOIN orders o ON mo.order_id = o.order_id " +
                         "WHERE o.order_date >= DATE_SUB(CURDATE(), INTERVAL 30 DAY) " +
                         "AND o.is_paid = true";
            connection = DBConnection.openConnection();
            statement = connection.createStatement();
            resultSet = statement.executeQuery(sql);
            if (resultSet.next()) {
                totalAmount = resultSet.getDouble("total_income_last_30_days");
                System.out.println(totalAmount);
            } else {
            	System.out.println("null result set");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            // Close resources to avoid memory leaks
            try {
                if (resultSet != null) resultSet.close();
                if (statement != null) statement.close();
                if (connection != null) connection.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        return totalAmount;
    }

    
    public double get30DayProfit() {
        double totalAmount = 0.0;
        try {
            String sql = "SELECT SUM(mo.quantity * p.profit) AS total_income_last_30_days " +
                         "FROM miniorders mo " +
                         "JOIN products p ON mo.product_id = p.product_id " +
                         "JOIN orders o ON mo.order_id = o.order_id " +
                         "WHERE o.order_date >= DATE_SUB(CURDATE(), INTERVAL 30 DAY) " +
                         "AND o.is_paid = TRUE";
            connection = DBConnection.openConnection();
            statement = connection.createStatement();
            resultSet = statement.executeQuery(sql);
            if (resultSet.next()) {
                totalAmount = resultSet.getDouble("total_income_last_30_days");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            // Close resources to avoid memory leaks
            try {
                if (resultSet != null) resultSet.close();
                if (statement != null) statement.close();
                if (connection != null) connection.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        return totalAmount;
    }
    
    public double getTodaySale() {
        double totalAmount = 0.0;
        try {
        	String sql = "SELECT SUM(mo.quantity * p.product_price) AS total_income_last_24_hours " +
                    "FROM miniorders mo " +
                    "JOIN products p ON mo.product_id = p.product_id " +
                    "JOIN orders o ON mo.order_id = o.order_id " +
                    "WHERE o.order_date >= NOW() - INTERVAL 24 HOUR " +
                    "AND o.is_paid = TRUE";
            connection = DBConnection.openConnection();
            statement = connection.createStatement();
            resultSet = statement.executeQuery(sql);
            if (resultSet.next()) {
                totalAmount = resultSet.getDouble("total_income_last_24_hours");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        System.out.println("the total sale today is " + totalAmount);
        return totalAmount;
    }
	
    
    public double getDebts() throws SQLException {
    	System.out.println("got into get debts method");
    	String sql = "SELECT SUM(mo.quantity * p.product_price) AS total_debt " +
                "FROM miniorders mo " +
                "JOIN products p ON mo.product_id = p.product_id " +
                "JOIN orders o ON mo.order_id = o.order_id " +
                "WHERE o.is_paid = FALSE";
    	connection = DBConnection.openConnection();
    	statement = connection.createStatement();
    	resultSet = statement.executeQuery(sql);
    	if (resultSet.next()) {
    		return resultSet.getDouble("total_debt");
    	}
    	return 0;
    }
	
    public int getCustomerCount() {
        int totalCount = 0;
        try {
            String sql = "SELECT COUNT(*) AS total_customers FROM customers";
            connection = DBConnection.openConnection();
            statement = connection.createStatement();
            resultSet = statement.executeQuery(sql);
            if (resultSet.next()) {
                totalCount = resultSet.getInt("total_customers");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            // Close resources to avoid memory leaks
            try {
                if (resultSet != null) resultSet.close();
                if (statement != null) statement.close();
                if (connection != null) connection.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        return totalCount;
    }

	
    public int getActiveCustomerCount() {
        int totalCount = 0;
        try {
            String sql = "SELECT COUNT(DISTINCT o.customer_id) AS active_customers_last_30_days " +
                         "FROM orders o " +
                         "WHERE o.order_date >= DATE_SUB(CURDATE(), INTERVAL 30 DAY) " +
                         "AND o.is_paid = TRUE";
            connection = DBConnection.openConnection();
            statement = connection.createStatement();
            resultSet = statement.executeQuery(sql);
            if (resultSet.next()) {
                totalCount = resultSet.getInt("active_customers_last_30_days");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            // Close resources to avoid memory leaks
            try {
                if (resultSet != null) resultSet.close();
                if (statement != null) statement.close();
                if (connection != null) connection.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        return totalCount;
    }
    
    public boolean verify(String order, String deliverer) throws SQLException {
    	
    	String sql = "UPDATE orders SET delivery_status = ?, deliverer_id=?, delivery_date=?, is_paid=? WHERE order_id = ?";
    	connection = DBConnection.openConnection();
    	preparedStatement = connection.prepareStatement(sql);
    	preparedStatement.setString(1, "delivered");
    	preparedStatement.setInt(2, Integer.parseInt(deliverer));
    	preparedStatement.setTimestamp(3, Timestamp.valueOf(LocalDateTime.now()));
    	preparedStatement.setBoolean(4, true);
    	preparedStatement.setInt(5, Integer.parseInt(order));
    	
    	int updated = preparedStatement.executeUpdate();
    	
    	return updated > 0;
    }
    
    public String[][] getPieChartData() throws SQLException {
    	String sql = "SELECT\r\n"
    			+ "    p.product_name,\r\n"
    			+ "    p.product_id,\r\n"
    			+ "    COALESCE(SUM(mo.quantity * p.product_price), 0) AS total_sales\r\n"
    			+ "FROM\r\n"
    			+ "    products p\r\n"
    			+ "LEFT JOIN\r\n"
    			+ "    miniorders mo ON p.product_id = mo.product_id\r\n"
    			+ "LEFT JOIN\r\n"
    			+ "    orders o ON mo.order_id = o.order_id\r\n"
    			+ "WHERE\r\n"
    			+ "    o.order_date >= NOW() - INTERVAL 30 DAY\r\n"
    			+ "GROUP BY\r\n"
    			+ "    p.product_name, p.product_id\r\n"
    			+ "ORDER BY\r\n"
    			+ "	total_sales DESC";
    	connection = DBConnection.openConnection();
    	statement = connection.createStatement();
        resultSet = statement.executeQuery(sql);
        
        String[][] dataSet = new String[5][2];
        int i = 0;
        double others = 0;
        while (resultSet.next()) {
        	if (i<4) {
        		String product = resultSet.getString("product_name");
            	String totalSales = resultSet.getString("total_sales");
            	
            	dataSet[i][0] = product;
            	dataSet[i][1] = totalSales;
            	i++;
        	} else {
        		Double total = resultSet.getDouble("total_sales");
        		others += total;
        		i++;
        	}
        }
        dataSet[4][0] = "others";
        dataSet[4][1] = others+"";
        
        return dataSet;
    }
    
	public void startDelivery(String deliverer, String order) throws SQLException {
		
    	String sql = "UPDATE orders SET delivery_status = ?, deliverer_id=? WHERE order_id = ?";
    	connection = DBConnection.openConnection();
    	preparedStatement = connection.prepareStatement(sql);
    	preparedStatement.setString(1, "ongoing");
    	preparedStatement.setInt(2, Integer.parseInt(deliverer));
    	preparedStatement.setInt(3, Integer.parseInt(order));
    	
    	int updated = preparedStatement.executeUpdate();
    	
	}

	
    public ResultSet getBriefOngoingOrderDetail() throws SQLException {
    	String sql = "SELECT o.order_id, o.order_date, delivery_status, c.customer_id as customer_id, c.shop_name as shop_name, c.customer_city as customer_city " +
                "FROM orders o " +
                "JOIN customers c ON o.customer_id = c.customer_id WHERE delivery_status = 'ongoing'";
    	connection = DBConnection.openConnection();
    	statement = connection.createStatement();
    	resultSet = statement.executeQuery(sql);
//    	List<Object> row = new ArrayList<Object>();
//    	while (resultSet.next()) {
//    		List<Object> column = new ArrayList<Object>();
//    		column.add(""+resultSet.getInt("customer_id"));
//    		column.add(resultSet.getString("shop_name"));
//    		column.add(resultSet.getString("customer_city"));
//    		column.add(resultSet.getString("order_date"));
//    		column.add(this.getTotalPrice(orderId));
//    		
//    		row.add(column);
//    	}
//    	
//    	return row;
    	
    	return resultSet;
    }
    
    public ResultSet getCustomerBriefOrderDetail(String id) throws SQLException {
    	String sql = "SELECT o.order_id, o.order_date, delivery_status, c.customer_id as customer_id, c.shop_name as shop_name, c.customer_city as customer_city " +
                "FROM orders o " +
                "JOIN customers c ON o.customer_id = c.customer_id WHERE c.customer_id = " + id;
    	connection = DBConnection.openConnection();
    	statement = connection.createStatement();
    	resultSet = statement.executeQuery(sql);
//    	List<Object> row = new ArrayList<Object>();
//    	while (resultSet.next()) {
//    		List<Object> column = new ArrayList<Object>();
//    		column.add(""+resultSet.getInt("customer_id"));
//    		column.add(resultSet.getString("shop_name"));
//    		column.add(resultSet.getString("customer_city"));
//    		column.add(resultSet.getString("order_date"));
//    		column.add(this.getTotalPrice(orderId));
//    		
//    		row.add(column);
//    	}
//    	
//    	return row;
    	
    	return resultSet;
    }

}




















