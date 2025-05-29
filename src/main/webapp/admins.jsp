<%@ page import="java.sql.*, java.util.*, java.io.InputStream, java.nio.file.Paths" %>
<%@ page import="javax.servlet.http.*, javax.servlet.*, javax.servlet.annotation.MultipartConfig, javax.servlet.http.Part" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page isErrorPage="true" %>
<%@ page import="java.nio.file.Paths" %>
<%@ page import="java.io.InputStream" %>
<%@ page import="javax.servlet.*, java.sql.*" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admins' Info For Developers</title>
    <link rel="stylesheet" href="css/developerStyle.css">
</head>
<body>
    <div class="header">Developer Account</div>
    <div class="options">
        <table>
            <tr>
                <td>Admins</td>
                <td><a href='customers.jsp'>Customers</a></td>
                <td><a href="developers.jsp">Developers</a></td>
            </tr>
        </table>
    </div>

    <div class="header-container">
        <table>
            <tr>
                <td colspan="8">Admins</td>
            </tr>
            <tr>
                <td>ID</td>
                <td>Name</td>
                <td>Email</td>
                <td>Phone</td>
                <td>Password</td>
                <td>City</td>
                <td>Profile</td>
                <td>Action</td>
            </tr>
            <%@ page import="java.sql.*, java.util.Base64, javax.servlet.http.*, javax.servlet.*, java.io.*" %>

<%
    Connection conn = null;
    Statement stmt = null;
    ResultSet rs = null;

    String url = "jdbc:mysql://localhost:3306/panmyodaw";
    String user = "root"; // Update with your DB username
    String dbPassword = System.getenv("DB_PASSWORD"); // Update with your DB password

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection(url, user, dbPassword);
        stmt = conn.createStatement();
        System.out.println("Database connection successful.");
        String query = "SELECT * FROM admins";
        rs = stmt.executeQuery(query);
        System.out.println("Got the result set from customers table.");
        while (rs.next()) {
            int id = rs.getInt("admin_id");
            String name = rs.getString("admin_name");
            System.out.println("Got the name " + name);
            String email = rs.getString("admin_email");
            System.out.println("Got the email " + email);
            String phone = rs.getString("admin_phone");
            System.out.println("Got the phone " + phone);
            String pass = rs.getString("admin_password");
            System.out.println("Got the password " + pass);
            String city = rs.getString("admin_city");
            System.out.println("Got the city " + city);
            byte[] profilePic = rs.getBytes("admin_profile_pic");
            System.out.println("Got the profile pic");// Assuming column name is 'profile_picture'
            String base64Image = (profilePic != null) ? Base64.getEncoder().encodeToString(profilePic) : "";
            System.out.println("Turned the byte code to String (base64Image)");
            String image = (base64Image.isEmpty()) ? "No image" : "<img src='data:image/jpeg;base64," + base64Image + "' alt='Profile Picture'>";
            System.out.println("Got the html tag to add in the profile pic column.");
%>
            <tr>
                <td><%= id %></td>
                <td><%= name %></td>
                <td><%= email %></td>
                <td><%= phone %></td>
                <td>********</td>
                <td><%= city %></td>
                <td>
    				<a href="ImageServlet?id=<%= id %>" target="_blank">
        				<%=image%>
    				</a>
				</td>

                <td>
                    <form method="post" id="deleteAdminForm<%= id %>" action="DeleteAdminServlet" style="display:inline;">
                        <input type="hidden" name="id" value="<%= id %>">
                        <button type="submit" class="delete-button" onclick="checkPassword(event, 'deleteAdminForm<%= id %>')">Delete</button>
                    </form>
                </td>
            </tr>
<%
        }
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        try {
            if (rs != null) rs.close();
            if (stmt != null) stmt.close();
            if (conn != null) conn.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
%>

        </table>
        <div class="action-buttons">
            <form method="post" id="resetTableForm" action="ResetAdmins" style="display:inline;">
                <button type="submit" onclick="checkPassword(event, 'resetTableForm')" value="Reset Table">Reset Table</button>
            </form>
            <button onclick="showAddForm()">Add</button>
        </div>
    </div>

    <div id="addForm">
        <form method="post" action="AddAdminServlet" id="addAdminForm" enctype="multipart/form-data">
            <input type="hidden" name="action" value="add">
            <label for="name">Name:</label>
            <input type="text" id="name" name="name" required><br>
            <label for="email">Email:</label>
            <input type="email" id="email" name="email" required><br>
            <label for="phone">Phone:</label>
            <input type="text" id="phone" name="phone" required><br>
            <label for="password">Password:</label>
            <input type="password" id="password" name="password" required><br>
            <label for="city">City:</label>
            <input type="text" id="city" name="city" required><br>
            <label for="profilePicture">Profile Picture:</label>
            <input type="file" id="profilePicture" name="profilePicture" accept="image/*" required><br>
            <div class="action-buttons">
                <button type="submit" onclick="checkPassword(event, 'addAdminForm')">OK</button>
                <button type="button" onclick="hideAddForm()">Cancel</button>
            </div>
        </form>
    </div>

    <div class="overlay" id="overlay"></div>

    <script>
        function showAddForm() {
            document.getElementById('addForm').style.display = 'block';
            document.getElementById('overlay').style.display = 'block';
        }

        function hideAddForm() {
            document.getElementById('addForm').style.display = 'none';
            document.getElementById('overlay').style.display = 'none';
        }

        function checkPassword(event, formId) {
            event.preventDefault();
            const form = document.getElementById(formId);
            const enteredPassword = prompt("Enter database password: ");
            const correctPassword = '<%= dbPassword %>';

            if (enteredPassword === correctPassword) {
                form.submit();
            } else {
                alert("Wrong database password! Try again.");
            }
        }
    </script>
</body>
</html>
