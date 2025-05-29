<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="javax.servlet.http.Cookie"%>
<%@ page import="dao.CustomerDAO"%>
<%@ page import="model.*, dao.*, java.util.*, additional.HueRotationCalculator, java.sql.*"%>
<%
System.out.println("Got into the customer_home_page.jsp");
Cookie[] cookies = request.getCookies();
Customer customer = null;
int id = 0;
if (cookies != null) {
	for (Cookie cookie : cookies) {
		if ("user_id".equals(cookie.getName())) {
	id = Integer.parseInt(cookie.getValue());
	System.out.println("The id is " + id);
	CustomerDAO customerDAO = new CustomerDAO();
	customer = customerDAO.get(id);
		}
	}
}
HueRotationCalculator color = new HueRotationCalculator();

EnterpriseDAO enterprise = new EnterpriseDAO();
ResultSet resultSet = enterprise.getCustomerBriefOrderDetail(id + "");
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0" />
<title>Home page</title>
<link rel="stylesheet" href="css/header.css">
<link rel="stylesheet" href="css/slider.css">
<link rel="stylesheet" href="css/catalog.css">
<link rel="stylesheet" href="css/aboutUs.css">
<link rel="stylesheet" href="css/footer.css">
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link
	href="https://fonts.googleapis.com/css2?family=Taviraj:wght@200;300;400;500;600;700&display=swap"
	rel="stylesheet">
<link
	href="https://fonts.googleapis.com/css2?family=Poppins:wght@100;200;300;400;500;600;700;800;900&display=swap"
	rel="stylesheet">
<link rel="stylesheet"
	href="//cdn.datatables.net/2.1.3/css/dataTables.dataTables.min.css" />
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
}

table {
	border-radius: 8vh;
}

h1 {
	margin-right: 0;
	color: #ff66b2;
	text-align: center;
	padding: 20px 0;
	background: #fff;
	margin-bottom: 20px;
	border-bottom: 2px solid #ff66b2;
}

.circle-photo {
	border-radius: 50%;
	width: 50px;
	height: 50px;
	object-fit: cover;
}

/* Table Styles */
table.dataTable {
	width: 80%;
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
	padding: 5px;
	text-align: center;
	border-bottom: 2px solid #fff;
}

table.dataTable tbody td {
	padding: 5px;
	text-align: center;
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

/* Responsive adjustments */

/* Password Form Styles */
#passwordFormDiv {
	display: none;
	border: 1px solid #ccc;
	padding: 20px;
	margin-top: 20px;
	width: 300px;
	height: 170px;
	border-radius: 5vh;
	position: fixed;
	top: 50%;
	left: 50%;
	transform: translate(-50%, -50%);
	background-color: white;
	z-index: 1001;
	box-shadow: 0 4px 10px rgba(0, 0, 0, 0.2);
}

input {
	margin-top: 5%;
	margin-left: 15%;
	width: 63%;
	padding: 5px;
	height: 20px;
	border-radius: 3vh;
}

#password-label {
	width: 100%;
	margin: 37.5%;
	color: pink;
	font-weight: bold;
	font-size: 18px;
}

.buttons-class {
	display: flex;
	justify-content: center;
	flex-wrap: wrap;
}

.btn {
	border-radius: 3vh;
	padding: 10px 20px;
	font-size: 16px;
	border: none;
	cursor: pointer;
	margin: 5px;
}

.cancel-btn {
	background-color: red;
	color: white;
}

.confirm-btn {
	background-color: blue;
	color: white;
}

.btn:hover {
	font-size: 17px;
}

/* Backdrop Styles */
#backdrop {
	display: none;
	position: fixed;
	top: 0;
	left: 0;
	width: 100%;
	height: 100%;
	background: rgba(0, 0, 0, 0.5);
	z-index: 1000;
	backdrop-filter: blur(5px);
}
</style>
</head>
<body>
	<!-- Header -->
	    <header>
        <a href ="#" class = "logo">Panmyodaw</a>

        <input type="checkbox" id = "menu-bar" class = "hidden-desktop">
        <label for="menu-bar" class= "initial">Menu</label>
        <nav class = "navbar">
            <ul>
                <li><a href="customer_home_page.jsp">home</a></li>
                <li><a href="#aboutUs">about</a></li>
                <li><a href="#footer">contact</a></li>
                <li  class = "hidden-desktop initial"><a href = "#">user +</a>
                    <ul>
                        <li><a href = "#">account</a></li>
                        <li><a href = "#">history</a></li>
                    </ul>
                </li>
                <li class = "hidden-desktop initial"><a href = "order.jsp">order</a></li>
                <div class = "profile-container hidden-mobile-avg">
                    <img src = "<%=request.getContextPath() + "/userProfile/" + customer.getProfile_pic()%>" class = "user-pic hide" onclick="toggleMenu()">
                </div>
                <div class="sub-menu-wrap" id = "subMenu">
                    <div class="sub-menu">
                        <div class="user-info">
                           <img src = '<%=request.getContextPath() + "/userProfile/" + customer.getProfile_pic()%>'>
                           <h3><%=customer.getName() %></h3>
                           <h3><%=customer.getId()%></h3>
                        </div>
                        <hr>

                        <a href="customer_profile_view.jsp" class = "sub-menu-link">
                            <i class="fa-solid fa-user"></i>
                            <p>account</p>
                            <span>></span>
                        </a>
                        <a href="#" class = "sub-menu-link">
                            <i class="fa-regular fa-clipboard"></i>
                            <p>history</p>
                            <span>></span>
                        </a>
                    </div>
                </div>
                <a href = "order.jsp" class = "hidden-mobile-avg"><i class="fa-solid fa-cart-shopping"></i></a>
            </ul>
        </nav>
    </header>

	<section id="mainSection" style="margin-top: 85px;">
		<h1>Order List</h1>
		<table id="myTable" class="display">
			<thead>
				<tr>
					<th>Date</th>
					<th>Amount</th>
					<th>Status</th>
					<th>View Detail</th>
				</tr>
			</thead>
			<tbody>
				<%
				int i = 1;
				while (resultSet.next()) {
				%>
				<tr data-id="<%=i%>">
					<td data-label="Date"><%=resultSet.getString("order_date")%></td>
					<td><%=enterprise.getTotalPrice(resultSet.getString("order_id"))%></td>
					<td><%=resultSet.getString("delivery_status") %></td>
					<td><a
						href="view_order_details.jsp?order_id=<%=resultSet.getString("order_id")%>&id=<%=resultSet.getString("customer_id")%>">
							<button class="view-detail" id="view-detail">View Detail</button>
					</a></td>
				</tr>
				<%
				i++;
				}
				%>
			</tbody>
		</table>
	</section>

	<!-- Footer Section -->
	<footer id='footer' style="bottom: -20vh !important;">
		<div class="container">
			<div class="footer-content">
				<h3>Contact Us</h3>
				<p>Email: panmyotawyoghurt@gmail.com</p>
				<p>Phone: 09-941785612</p>
				<p>Address: Pyin Oo Lwin</p>
			</div>
			<div class="footer-content">
				<h3>Quick Links</h3>
				<ul class="list">
					<li><a href="emphomeorder.jsp">Home</a></li>
					<li><a href="productemployee.jsp">About Products</a></li>
					<li><a href="employeehomepage.jsp">Delivered Status</a></li>
				</ul>
			</div>
			<div class="footer-content">
				<h3>Follow Us</h3>
				<ul class="social-icons">
					<li><a href="https://t.me/sapyaephyokyaw"
						class="cancel-animation"><i class="fa-brands fa-telegram"></i></a></li>
				</ul>
			</div>
		</div>
		<div class="bottom-bar">
			<p>&copy; Kode Samurai. All rights reserved.</p>
		</div>
	</footer>

	<!-- Header Javascript -->
    <script>
        let subMenu = document.getElementById("subMenu");

        function toggleMenu(){
            subMenu.classList.toggle("open-menu");
        }
    </script>
	<script>
      $(document).ready(function () {
        $("#myTable").DataTable({
          columnDefs: [{ orderable: false, targets: [0, 3] }],
        });

        $("#myTable").on("click", "#view-detail", function () {
          let $row = $(this).closest("tr");
          let itemId = $row.data("id");
          window.location.href = `details.html?id=${itemId}`;
        });
      });

      function showConfirmBox(id) {
    	document.getElementById("c_id").value = id;
        document.getElementById("passwordFormDiv").style.display = "block";
        document.getElementById("backdrop").style.display = "block";
      }
     
		
      function hidePasswordForm() {
        document.getElementById("passwordFormDiv").style.display = "none";
        document.getElementById("backdrop").style.display = "none";
      }
    </script>

	<script src="js/footer.js"></script>
	<script src="js/slider.js"></script>
</body>
</html>
