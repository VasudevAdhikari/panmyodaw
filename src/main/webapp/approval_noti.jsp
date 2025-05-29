<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="model.*"%>
<%@ page import="java.util.List"%>
<%@ page import="dao.*,java.sql.*"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%
//get the admin's info
int admin_id = -1;
Cookie[] cookies = request.getCookies();
if (cookies != null ){
	for (Cookie cookie: cookies) {
		if ("admin".equals(cookie.getName())) {
			admin_id = Integer.parseInt(cookie.getValue());
			break;
		}
	}
}
if (admin_id == -1) request.getRequestDispatcher("/admin_login.jsp").forward(request, response);
AdminDAO adminDAO = new AdminDAO();
Admin admin = adminDAO.get(admin_id);

EnterpriseDAO enterprise = new EnterpriseDAO();
double last30dayincome = enterprise.get30DayIncome();
double last30dayprofit = enterprise.get30DayProfit();
double totalDebt = enterprise.getDebts();
double customerCount = enterprise.getCustomerCount();
ResultSet revenue = enterprise.getPastSixMonthRevenue();
int i = 0;
String[][] sales = new String[7][2];
while (revenue.next()) {
    String[] sale = {revenue.getString("sale_month"), revenue.getString("total_sales")};
    sales[i] = sale;
    i++;
}
while (i < 7) {
    String[] sale = {"", "0"};
    sales[i] = sale;
    i++;
}
for(String[]sale: sales) {
	for(String s: sale) {
		System.out.print(s + ":\t");
	}
	System.out.println();
}
String[][] pieChartData = enterprise.getPieChartData();

EmployeeDAO employeeDAO = new EmployeeDAO();
List<Employee> emps = employeeDAO.getUnverified();
int notiCount = 0;
for(Employee ee: emps) {
	notiCount++;
}
List<Admin> adms = adminDAO.getUnverified();
for(Admin aa: adms) {
	notiCount++;
}

%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Approval Notification</title>
<link
	href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700&display=swap"
	rel="stylesheet">
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
<style>
body {
	background: linear-gradient(#FFE4E1, white, #FFE4E1);
	color: #000000;
	font-family: 'Poppins', sans-serif;
	margin: 0;
	padding: 20px;
}

.notification-container {
	border: 1px solid #ff4dbe;
	padding: 15px;
	margin-bottom: 10px;
	border-radius: 10px;
	background-color: #ffffff;
}

.notification-header {
	display: flex;
	justify-content: space-between;
	align-items: center;
	margin-bottom: 10px;
	color: #ff4dbe;
	font-size: 1.2em;
	flex-wrap: wrap;
}

.notification-details {
	display: flex;
	flex-direction: column;
	margin-right: 10px;
}

.notification-content {
	margin-bottom: 10px;
	color: #000000;
}

.approve-button {
	background-color: #ff4dbe;
	color: white;
	border: none;
	padding: 10px 35px;
	text-align: center;
	text-decoration: none;
	font-size: 1em;
	font-weight: bold;
	cursor: pointer;
	border-radius: 15px;
	box-shadow: rgba(0, 0, 0, 0.1);
	transition: background-color 0.3s ease, transform 0.2s ease;
}

.approve-button:hover {
	background-color: #fb2fb2;
	transform: scale(1.05);
}

.approve-button:active {
	transform: scale(0.95); /* Shrink slightly on click */
}

@media screen and (max-width: 768px) {
	.notification-header {
		font-size: 1.1em;
		flex-direction: row;
		justify-content: space-between;
	}
	.notification-content {
		font-size: 0.9en;
	}
	.notification-details {
		flex: 1;
	}
	.approve-button {
		font-size: 0.9em;
		padding: 8px 20px;
		width: auto;
	}
	form {
		margin-left: auto;
	}
}

@media screen and (max-width: 500px) {
	.notification-header {
		flex-direction: column;
		align-items: flex-start;
	}
	.notification-details {
		margin-bottom: 10px; /* Adds space between details and the button */
	}
	form {
		width: 100%; /* Make the form take the full width */
	}
	.approve-button {
		width: 100%; /* Make the button take the full width */
		text-align: center;
		padding: 10px 0; /* Center the text vertically */
	}
}

a {
	text-decoration: none !important;
	box-sizing: border-box !important;
	font-family: 'Poppins', sans-serif !important;
	text-transform: capitalize;
}

.user-info h3 {
	font-size: 1.17em;
}

header .navbar ul li a sup {
	font-size: 12px; /* Adjust font size */
	font-weight: bolder !important;
	color: white;
}
</style>
<link rel='stylesheet' href='css/header.css'>
</head>
<body>
	<header style="padding-bottom: 10 !important;">
		<a href="#" class="logo">Panmyodaw</a> <input type="checkbox"
			id="menu-bar" class="hidden-desktop"> <label for="menu-bar"
			class="initial">Menu</label>
		<nav class="navbar">
			<ul>
				<li><a href="dashboard.jsp">dashboard</a></li>
				<li><a href="view_orders.jsp">orders</a></li>
				<li><a href="view_products.jsp">products</a></li>
				<li><a href="approval_noti.jsp"><i class="fa-solid fa-bell"></i><sup><%=notiCount%></sup></a></li>
				<li class="hidden-desktop initial"><a href="#">user +</a>
					<ul>
						<li><a href="view_profile.jsp">account</a></li>
						<li><a href="customerList.jsp">customers</a></li>
						<li><a href="adminList.jsp">admins</a></li>
						<li><a href="employeeList.jsp">employees</a></li>
					</ul></li>
				<li class="hidden-desktop initial"><a href="order.jsp">order</a></li>
				<div class="profile-container hidden-mobile-avg">
					<img style="z-index: 1000;"
						style=""
						src='<%=request.getContextPath() + "/userProfile/" + admin.getProfile_pic()%>'
						class="user-pic hide" onclick="toggleMenu()">
				</div>
				<div class="sub-menu-wrap" id="subMenu">
					<div class="sub-menu">
						<div class="user-info">
							<img style="height: 65px; width: 65px !important;"
								src='<%=request.getContextPath() + "/userProfile/" + admin.getProfile_pic()%>'>
							<h3><%=admin.getName() %></h3>
						</div>
						<hr>

						<a href="view_profile.jsp" class="sub-menu-link"> <i
							class="fa-solid fa-user"></i>
							<p>account</p> <span>></span>
						</a> <a href="adminList.jsp" class="sub-menu-link"> <i
							class="fa-solid fa-user-plus"></i>
							<p>admins</p> <span>></span>
						</a> <a href="customerList.jsp" class="sub-menu-link"> <i
							class="fa-regular fa-address-card"></i>
							<p>customers</p> <span>></span>
						</a> <a href="employeeList.jsp" class="sub-menu-link"> <i
							class="fa-solid fa-id-card-clip"></i>
							<p>employees</p> <span>></span>
						</a>
					</div>
				</div>
			</ul>
		</nav>
	</header>
	<br>
	<br>
	<br>
	<br>

	<%
		// Fetch unverified admins list
		System.out.println("Got into the approval_noti.jsp");
		AdminDAO aDAO = new AdminDAO();
		List<Admin> unverifiedAdmins = aDAO.getUnverified();
		System.out.println("Got the unverified admins");
		
		EmployeeDAO eDAO = new EmployeeDAO();
		List<Employee> unverifiedEmployees = employeeDAO.getUnverified();
		System.out.println("Got the unverified employees");

		// Set the list as a request attribute to be accessed in JSTL
		request.setAttribute("unverifiedAdmins", unverifiedAdmins);
		request.setAttribute("unverifiedEmployees", unverifiedEmployees);
		
	%>
	<!-- Iterate over the list using JSTL -->
	<c:forEach var="admin" items="${unverifiedAdmins}">
		<div class="notification-container">
			<div class="notification-header">
				<div class="notification-details">
					<span class="notification-name">Name: ${admin.getName()}</span> <span
						class="notification-phone">Phone: ${admin.getPhone()}</span> <span
						class="notification-email">Email: ${admin.getEmail()}</span>
				</div>
				<form action="AdminController" method="get">
					<input type='hidden' name='action' value='approve'> <input
						type='hidden' name='id' value='${admin.getId()}'>
					<button class="approve-button" type="submit">Approve</button>
				</form>
			</div>

			<div class="notification-content">New admin account created.
				Waiting for your approval.</div>
		</div>
	</c:forEach>

	<c:forEach var="admin" items="${unverifiedEmployees}">
		<div class="notification-container">
			<div class="notification-header">
				<div class="notification-details">
					<span class="notification-name">Name: ${admin.getName()}</span> <span
						class="notification-phone">Phone: ${admin.getPhone()}</span> <span
						class="notification-email">Email: ${admin.getEmail()}</span>
				</div>
				<form action="EmployeeController" method="get">
					<input type='hidden' name='action' value='approve'> <input
						type='hidden' name='id' value='${admin.getId()}'>
					<button class="approve-button" type="submit">Approve</button>
				</form>
			</div>

			<div class="notification-content">New employee account created.
				Waiting for your approval.</div>
		</div>
	</c:forEach>
	<script src="js/main.js"></script>
	<script>
    document.addEventListener('DOMContentLoaded', function() {
        // Get the current page URL path (without the query string)
        const currentPage = window.location.pathname;

        // Select all the navigation links
        const navLinks = document.querySelectorAll('header .navbar ul li a');

        navLinks.forEach(link => {
            // Check if the link's href matches the current page
            if (link.href.includes(currentPage)) {
                link.classList.add('active'); // Add the 'active' class to the current link
            }
        });
    });
    </script>
</body>
</html>
