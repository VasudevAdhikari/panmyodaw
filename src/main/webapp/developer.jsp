<%@ page import="java.sql.*, javax.servlet.*, javax.servlet.http.*" %>
<!DOCTYPE html>
<html>
<head>
    <title>Developer Interface</title>
    <style>
        table {
            width: 100%;
            border-collapse: collapse;
        }
        th, td {
            border: 1px solid #ddd;
            padding: 8px;
        }
        th {
            background-color: #f2f2f2;
        }
    </style>
</head>
<body>
    <h1>Developer Interface</h1>

    <% 
        // Database connection parameters
        String jdbcURL = "jdbc:mysql://localhost:3306/panmyodaw";
        String dbUser = "root";
        String dbPassword = System.getenv("DB_PASSWORD");

        // Retrieve and display data
        Connection connection = null;
        Statement statement = null;
        ResultSet resultSet = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            connection = DriverManager.getConnection(jdbcURL, dbUser, dbPassword);
            statement = connection.createStatement();
            String query = "SELECT * FROM customers";
            resultSet = statement.executeQuery(query);
    %>

    <h2>User Data</h2>
    <table>
        <thead>
            <tr>
                <th>ID</th>
                <th>Name</th>
                <th>City</th>
                <th>Email</th>
                <th>Phone</th>
                <th>Password</th>
                <th>Profile Picture</th>
                <th>Action</th>
            </tr>
        </thead>
        <tbody>
            <% 
                while (resultSet.next()) { 
                    int id = resultSet.getInt("customer_id");
                    String name = resultSet.getString("customer_name");
                    String city = resultSet.getString("customer_city");
                    String email = resultSet.getString("customer_email");
                    long phone = resultSet.getLong("customer_phone");
                    String password = resultSet.getString("customer_password");
                    Blob profilePicBlob = resultSet.getBlob("customer_profile_pic");
                    byte[] profilePicBytes = profilePicBlob != null ? profilePicBlob.getBytes(1, (int) profilePicBlob.length()) : null;
            %>
            <tr>
                <td><%= id %></td>
                <td><%= name %></td>
                <td><%= city %></td>
                <td><%= email %></td>
                <td><%= phone %></td>
                <td><%= password %></td>
                <td>
                    <% if (profilePicBytes != null) { %>
                        <img src="data:image/jpeg;base64,<%= java.util.Base64.getEncoder().encodeToString(profilePicBytes) %>" width="100" height="100" />
                    <% } else { %>
                        No Image
                    <% } %>
                </td>
                <td>
                    <form action="deleteCustomer" method="post">
                        <input type="hidden" name="id" value="<%= id %>" />
                        <input type="submit" value="Delete" />
                    </form>
                </td>
            </tr>
            <% 
                } 
            %>
        </tbody>
    </table>

    <% 
        } catch (Exception e) {
            e.printStackTrace();
    %>
    <p>Error: <%= e.getMessage() %></p>
    <% 
        } finally {
            if (resultSet != null) try { resultSet.close(); } catch (SQLException ignore) {}
            if (statement != null) try { statement.close(); } catch (SQLException ignore) {}
            if (connection != null) try { connection.close(); } catch (SQLException ignore) {}
        }
    %>

</body>
</html>
