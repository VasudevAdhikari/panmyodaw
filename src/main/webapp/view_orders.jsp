<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"
	import="dao.*, java.util.*, java.sql.*,model.*,java.util.*"%>
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
<%
	EnterpriseDAO entDAO = new EnterpriseDAO();
	ResultSet resultSet = entDAO.getBriefOrderDetail();
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8" />
<meta name="viewport" content="width=device-width, initial-scale=1.0" />
<title>Customer List</title>
<link rel="stylesheet"
	href="//cdn.datatables.net/2.1.3/css/dataTables.dataTables.min.css" />
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

<script src="//code.jquery.com/jquery-3.7.1.js"></script>
<script src="//cdn.datatables.net/2.1.3/js/dataTables.min.js"></script>
<style>
/* General Page Styles */
body {
	font-family: Arial, sans-serif;
	color: #333;
	background-color: #f9f9f9;
	margin: 0;
	padding: 0;
	border-radius: 8vh;
}

table {
	border-radius: 8vh;
}

h1 {
	color: #ff66b2;
	text-align: center;
	padding: 20px 0;
	background: #fff;
	margin-bottom: 20px;
	border-bottom: 2px solid #ff66b2;
}
/* Table Styles */
table.dataTable {
	width: 90%;
	margin: 20px auto;
	border-collapse: separate;
	border-spacing: 0;
	background: #fff;
	border-radius: 10px;
	box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
}

table.dataTable thead {
	background: #ff66b2;
	color: #fff;
}

table.dataTable thead th {
	padding: 15px;
	text-align: center; /* Center align column headers */
	border-bottom: 2px solid #fff;
}

table.dataTable thead th:nth-child(3) {
	text-align: center;
}

table.dataTable tbody td {
	padding: 15px;
	text-align: center; /* Center align table data */
	vertical-align: middle;
	border-bottom: 1px solid #ddd;
}

table.dataTable tbody tr:hover {
	background: #f2f2f2;
}

table.dataTable tbody td img {
	display: block;
	margin: 0 auto;
}

table.dataTable button.view-detail {
	background-color: #ff66b2;
	color: #fff;
	border: none;
	padding: 7px 15px;
	border-radius: 5px;
	cursor: pointer;
}

table.dataTable button.view-detail:hover {
	background-color: #e55b9d;
}

/* Ensure consistent column spacing */
table.dataTable tbody tr td, table.dataTable thead th {
	width: 20%; /* Distribute columns evenly */
}

table.dataTable tbody td:nth-child(3) {
	text-align: center;
	/* Ensure the Phone Number column is center-aligned */
}

/* Responsive adjustments */
@media ( max-width : 400px) {
	table.dataTable thead {
		display: none;
	}
	table.dataTable tbody td {
		display: block;
		text-align: right;
		padding-left: 50%;
		position: relative;
	}
	table.dataTable tbody td:before {
		content: attr(data-label);
		position: absolute;
		left: 0;
		width: 50%;
		padding-left: 15px;
		font-weight: bold;
		text-align: left;
	}
	table.dataTable tbody td img {
		margin: 10px auto;
	}
}

@media ( min-width : 1000px) {
	#mainSection {
		width: 90vw;
		margin: auto;
		border-radius: 8vh;
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
          color: black; 
      }
</style>
<link rel='stylesheet' href='css/header.css'>
<link
	href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap"
	rel="stylesheet">
</head>
<body>
	<header>
		<a href="#" class="logo">Panmyodaw</a> <input type="checkbox"
			id="menu-bar" class="hidden-desktop"> <label for="menu-bar"
			class="initial">Menu</label>
		<nav class="navbar">
			<ul>
				<li><a href="dashboard.jsp">dashboard</a></li>
				<li><a href="view_orders.jsp">orders</a></li>
				<li><a href="view_products.jsp">products</a></li>
				<li><a href="approval_noti.jsp"><i class="fa-solid fa-bell"></i><sup
						><%=notiCount%></sup></a></li>
				<li class="hidden-desktop initial"><a href="#">user +</a>
					<ul>
						<li><a href="view_profile.jsp">account</a></li>
						<li><a href="customerList.jsp">customers</a></li>
						<li><a href="adminList.jsp">admins</a></li>
						<li><a href="employeeList.jsp">employees</a></li>
					</ul></li>
				<li class="hidden-desktop initial"><a href="order.jsp">order</a></li>
				<div class="profile-container hidden-mobile-avg">
					<img style=""
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
	<section id='mainSection' style="margin-top: 85px;">
		<h1>Order List</h1>
		<table id="myTable" class="display">
			<thead>
				<tr>
					<th>Date</th>
					<th>Shop Name</th>
					<th>Amount</th>
					<th>Status</th>
					<th>View Detail</th>
				</tr>
			</thead>
			<tbody>
				<%
        		int j = 1;
        		while (resultSet.next()) {
        			%>
				<tr data-id="<%=j%>">
					<td data-label="Date"><%=resultSet.getString("order_date")%></td>
					<td><%=resultSet.getString("shop_name")%> (<%=resultSet.getString("customer_city")%>)</td>
					<td><%=enterprise.getTotalPrice(resultSet.getString("order_id"))%></td>
					<td><%=resultSet.getString("delivery_status")%></td>
					<td><a
						href='view_order_details.jsp?order_id=<%=resultSet.getString("order_id")%>&id=<%=resultSet.getString("customer_id")%>'>
							<button class='view-detail'>View Detail</button>
					</a></td>
				</tr>
				<%
                  	j++;
        		}
        	%>
			</tbody>
		</table>
	</section>

	<script>
      $(document).ready(function () {
        $("#myTable").DataTable({
          columnDefs: [{ orderable: false, targets: [0, 3] }],
        });

        $("#myTable").on("click", ".view-detail", function () {
          let $row = $(this).closest("tr");
          let itemId = $row.data("id");
          window.location.href = `details.html?id=${itemId}`;
        });
      });
      
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
	<script src="js/main.js"></script>
</body>
</html>
