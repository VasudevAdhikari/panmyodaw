<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" import="dao.*, java.util.*, java.sql.*, model.*"%>
<%@ page import="javax.servlet.http.Cookie"%>
<%@ page import="dao.EmployeeDAO"%>
<%@ page import="model.Employee"%>
<%
int employee_id = -1;
Cookie[] cookies = request.getCookies();
if (cookies != null) {
	for (Cookie cookie : cookies) {
		if ("user".equals(cookie.getName())) {
	employee_id = Integer.parseInt(cookie.getValue());
	break;
		}
	}
}
if (employee_id == -1)
	request.getRequestDispatcher("/emp_login.jsp").forward(request, response);
EmployeeDAO employeeDAO = new EmployeeDAO();
Employee employee = employeeDAO.get(employee_id);
%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%
if (!employee.isVerified()) {
	request.getRequestDispatcher("/waitingEmployee.jsp").forward(request, response);
}

EnterpriseDAO enterprise = new EnterpriseDAO();
ResultSet resultSet = enterprise.getBriefUndeliveredOrderDetail();

if (session.getAttribute("cartmap") != null) {
	session.removeAttribute("cartmap");
}
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0" />
<title>Employee Home page</title>
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
	font-family: 'Poppins', sans-serif;
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
	padding: 20px 0px;
	margin: 0px;
	width: 30vw;
	height: 150px;
	border-radius: 15px;
	position: fixed;
	top: 50%;
	left: 50%;
	transform: translate(-50%, -50%);
	background-color: white;
	z-index: 1001;
	box-shadow: 0 4px 10px rgba(0, 0, 0, 0.2);
}

#passwordForm {
	text-align: center;
}
	
input {
	margin-left: 15%;
	width: 63%;
	padding: 5px;
	height: 20px;
	border-radius: 3vh;
}

#password-label {
	width: 100%;
	color: #2b3c3d;
	font-size: 19px;
}

.buttons-class {
	position: relative;
	bottom: -25px;
	display: flex;
	justify-content: center;
	flex-wrap: wrap;
}

.btn {
	border-radius: 20px;
	padding: 10px 20px;
	font-size: 15px;
	font-weight: bold;
	border: none;
	cursor: pointer;
    transition: background-color 0.3s ease, transform 0.2s ease;
}

.cancel-btn {
	background-color: #e0e0e0;
	color: #1f2c2c;
}

.cancel-btn:hover {
    background-color: #c9c9c9;
}

.confirm-btn {
	background-color: #ff4d4d;
	color: white;
	margin-right: 100px;
}

.confirm-btn:hover {
    background-color: #e60000; /* Darker red on hover */
    transform: scale(1.05); /* Slightly enlarge on hover */
}

.confirm-btn:active {
    transform: scale(0.95); /* Shrink slightly on click */
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
}

#mainSection {
    margin-top: 50px;
    padding: 20px 0 60px; 
}

/* Animation Keyframes */
@keyframes scaleUp {
    from {
        transform: translate(-50%, -50%) scale(0.8);
        opacity: 0;
    }
    to {
        transform: translate(-50%, -50%) scale(1);
        opacity: 1;
    }
}

@keyframes scaleDown {
    from {
        transform: translate(-50%, -50%) scale(1);
        opacity: 1;
    }
    to {
        transform: translate(-50%, -50%) scale(0.8);
        opacity: 0;
    }
}

@keyframes fadeIn {
    from {
        opacity: 0;
    }
    to {
        opacity: 1;
    }
}

@keyframes fadeOut {
    from {
        opacity: 1;
    }
    to {
        opacity: 0;
    }
}

#passwordFormDiv.show {
    animation: scaleUp 0.3s ease-out forwards;
}

#passwordFormDiv.scaleDown {
    animation: scaleDown 0.3s ease-out forwards;
}

/* Apply Animations to Backdrop */
#backdrop.show {
    animation: fadeIn 0.3s ease-out forwards;
}

#backdrop.hide {
    animation: fadeOut 0.3s ease-out forwards;
}

</style>
</head>
<body>
	<!-- Header -->
	<header>
		<a href="#" class="logo">Panmyodaw</a> <input type="checkbox" id="menu-bar"
			class="hidden-desktop"> <label for="menu-bar" class="initial">Menu</label>
		<nav class="navbar">
			<ul>
				<li><a href="emphomeorder.jsp">Orders</a></li>
				<li><a href="employeehomepage.jsp">Ongoing Orders</a></li>
				<li><a href="deliveredordersemp.jsp">Delivered Orders</a></li>
				<li><a href="productemployee.jsp">Products</a></li>
				<li class="hidden-desktop initial"><a href="#">user +</a>
					<ul>
						<li><a href="#">account</a></li>
						<li><a href="#">password</a></li>
						<li><a href="#">logout</a></li>
					</ul></li>
				<li class="hidden-desktop initial"><a href="order.jsp">order</a></li>
				<div class="profile-container hidden-mobile-avg">
					<img
						src='<%=request.getContextPath() + "/userProfile/" + employee.getProfile_pic()%>'
						class="user-pic hide" onclick="toggleMenu()">
				</div>
				<div class="sub-menu-wrap" id="subMenu">
					<div class="sub-menu">
						<div class="user-info">
							<img
								src='<%=request.getContextPath() + "/userProfile/" + employee.getProfile_pic()%>'>
							<h3><%=employee.getName()%>
							</h3>
						</div>
						<hr>

						<a href="employeeprofile.jsp" class="sub-menu-link"> <i
							class="fa-solid fa-user"></i>
							<p>account</p> <span>></span>
						</a> <a href="#" class="sub-menu-link"> <i
							class="fa-solid fa-envelope"></i>
							<p><%=employee.getEmail()%></p><span>></span>

						</a> <a href="#" class="sub-menu-link"> <i
							class="fa-solid fa-id-badge"></i>
							<p><%=employee.getRole()%></p><span>></span>

						</a>
					</div>
				</div>

			</ul>
		</nav>
	</header>


	<div id="backdrop"></div>
	<div class="passworFromDiv" id="passwordFormDiv">
		<form id="passwordForm" action="OrderController" method="get">
			<label id="password-label" for="password">Confirm to start delivery?</label>
			<input type="hidden" id="c_id" name="c_id">
			<input type="hidden" name="action" value="ongoing">
			<input type="hidden" name="deliverer" value="<%=employee_id%>">
			<div class="buttons-class">
				<button type="submit" class="btn confirm-btn">Confirm</button>
				<button type="button" class="btn cancel-btn" id="cancelBtn"
					onclick="hidePasswordForm()">Cancel</button>
			</div>
		</form>
	</div>

	<section id="mainSection">
		<h1>Order List</h1>
		<table id="myTable" class="display">
			<thead>
				<tr>
					<th>Date</th>
					<th>Shop Name</th>
					<th>Amount</th>
					<th>Check-out</th>
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
					<td><%=resultSet.getString("shop_name")%> ( <%=resultSet.getString("customer_city")%>)
					</td>
					<td><%=enterprise.getTotalPrice(resultSet.getString("order_id"))%></td>
					<td>
						<%
						String customer = resultSet.getString("customer_id");
						String status = "Start Delivery";
						%>
						<button class="view-detail" id="showFormBtn"
							onclick='showConfirmBox(<%=resultSet.getString("order_id")%>)'>
							<%=status%>
						</button>

					</td>
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
	<footer id='footer' style="margin-top: 85px;">
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
    	    const formDiv = document.getElementById("passwordFormDiv");
    	    const backdrop = document.getElementById("backdrop");
    	    
    	    formDiv.classList.add("show");
    	    backdrop.classList.add("show");

    	    formDiv.style.display = "block";
    	    backdrop.style.display = "block";
    	}

      function hidePasswordForm() {
    	    const formDiv = document.getElementById("passwordFormDiv");
    	    const backdrop = document.getElementById("backdrop");

    	    formDiv.classList.remove("show");
    	    backdrop.classList.remove("show");

    	    formDiv.classList.add("scaleDown");
    	    backdrop.classList.add("hide");
    	    
    	    setTimeout(() => {
    	        formDiv.style.display = "none";
    	        backdrop.style.display = "none";
    	        formDiv.classList.remove("scaleDown");
    	        backdrop.classList.remove("hide");
    	    }, 300); // Match the duration with the fadeOut animation
    	}
      
      //Header active state
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
      
		if (<%=session.getAttribute("ongoing") != null && session.getAttribute("ongoing").equals("success")%>) {
    	 	alert("The order is marked as ongoing");
    	 	<%
    	 	session.setAttribute("ongoing", "");
    	 	%>
      	}
    </script>	


	<script src="js/slider.js"></script>
	<script src="js/footer.js"></script>
</body>
</html>
