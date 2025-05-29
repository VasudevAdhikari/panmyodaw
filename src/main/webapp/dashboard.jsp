<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page import="dao.*"%>
<%@ page import="model.Admin,java.sql.*,dao.*,model.*,java.util.*"%>
<%
//get the admin's info
int admin_id = -1;
Cookie[] cookies = request.getCookies();
if (cookies != null) {
	for (Cookie cookie : cookies) {
		if ("admin".equals(cookie.getName())) {
	admin_id = Integer.parseInt(cookie.getValue());
	break;
		}
	}
}
if (admin_id == -1)
	request.getRequestDispatcher("/admin_login.jsp").forward(request, response);
AdminDAO adminDAO = new AdminDAO();
Admin admin = adminDAO.get(admin_id);

EnterpriseDAO enterprise = new EnterpriseDAO();
double last30dayincome = enterprise.get30DayIncome();
double last30dayprofit = enterprise.get30DayProfit();
double todaySale = enterprise.getTodaySale();
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
for (String[] sale : sales) {
	for (String s : sale) {
		System.out.print(s + ":\t");
	}
	System.out.println();
}
String[][] pieChartData = enterprise.getPieChartData();

EmployeeDAO employeeDAO = new EmployeeDAO();
List<Employee> emps = employeeDAO.getUnverified();
int notiCount = 0;
for (Employee ee : emps) {
	notiCount++;
}
List<Admin> adms = adminDAO.getUnverified();
for (Admin aa : adms) {
	notiCount++;
}
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Admin Dashboard</title>
<script src="https://d3js.org/d3.v7.min.js"></script>
<!-- External CSS -->
<link rel="stylesheet" href="css/dashboardStyles.css">
<link rel="stylesheet" href="css/footer.css">
<link rel="stylesheet"
	href="https://cdn.jsdelivr.net/npm/remixicon@2.5.0/fonts/remixicon.css">
<link
	href="https://fonts.googleapis.com/css2?family=Poppins:wght@100;200;300;400;500;600;700;800;900&display=swap"
	rel="stylesheet">
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css"
	integrity="sha512-1ycn6IcaQQ40/MKBW2W4Rhis/DbILU74C1vSrLJxCq57o941Ym01SwNsOMqvEBFlcgUa6xLiPY/NS5R+E6ztJQ=="
	crossorigin="anonymous" referrerpolicy="no-referrer" />
<link href='https://unpkg.com/boxicons@2.1.4/css/boxicons.min.css'
	rel='stylesheet'>
<link rel='stylesheet' href='css/header.css'>

<!-- Your CSS -->
<style>
header .navbar ul li a sup {
	font-size: 12px; /* Adjust font size */
	font-weight: bolder !important;
	color: black;
}

.bis-info {
	font-weight: normal !important;
}

.product-info {
	font-size: 16px;
	margin-bottom: 8px;
}

.product-name {
	font-weight: bold;
	margin-right: 8px;
}

.customer-name {
	color: #555;
}

/* Star rating styles */
.rating-stars {
	margin-bottom: 8px;
	color: orange; /* Gold color for filled stars */
}

.rating-stars i {
	font-size: 20px;
}

/* Rating description text */
.rating-description p {
	margin: 0;
	font-size: 14px;
	color: #333;
	line-height: 1.4;
}

/* Hover effect to highlight the rating container */
.ratings:hover {
	background-color: #f1f1f1;
	border-color: #ccc;
}
</style>
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
					<img
						src='<%=request.getContextPath() + "/userProfile/" + admin.getProfile_pic()%>'
						class="user-pic hide" onclick="toggleMenu()">
				</div>
				<div class="sub-menu-wrap" id="subMenu">
					<div class="sub-menu">
						<div class="user-info">
							<img
								src='<%=request.getContextPath() + "/userProfile/" + admin.getProfile_pic()%>'>
							<h3><%=admin.getName()%></h3>
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

	<div class="bis-info-container" style="margin-top: 16vh;">
		<div class="bis-info">
			<div class="info">
				<h3>Income</h3>
				<p>Last 30 days</p>
				<span><%=last30dayincome%>ks</span>
			</div>
		</div>
		<div class="bis-info">
			<div class="info">
				<h3>Today's Sale</h3>
				<p>Last 24 hours</p>
				<span><%=todaySale%>ks</span>
			</div>
		</div>
		<div class="bis-info">
			<div class="info">
				<h3>Profit</h3>
				<p>Last 30 days</p>
				<span><%=last30dayprofit%>ks</span>
			</div>
		</div>
		<div class="bis-info">
			<div class="info">
				<h3>Customers</h3>
				<p>Active past 30 days</p>
				<span><%=customerCount%></span>
			</div>
		</div>
	</div>

	<div class="container">
		<div class="box">
			<select id="chart-type" onchange="initializeChart()">
				<option value="line">Line Chart</option>
				<option value="bar">Bar Chart</option>
			</select> <br>
			<div id="chart"></div>
		</div>
		<div class="box">
			<div id="pie-chart"></div>
		</div>
	</div>

	<div class="additionals-container">
		<div class="additional" style="max-height: 90vh; overflow: auto;">
			<%
		//get all the non-replied feedbacks from the db
		FeedbackDAO feedbackDAO = new FeedbackDAO();
		CustomerDAO customerDAO = new CustomerDAO();
		List<Feedback> feedbacks = feedbackDAO.getNotResponded();
		int j = 0;
		for (Feedback feedback: feedbacks) {
			String date = feedback.getFeedback_date();
			String customer = customerDAO.getName(feedback.getCustomer_id()+"");
			String description = feedback.getDescription();
			String profile = request.getContextPath() + "/userProfile/" + customerDAO.getProfile(feedback.getCustomer_id()+"");
		%>
			<div class="feedback" id="feedback1">
				<img src="<%=profile%>" height="50px" width="50px"
					alt="Customer Profile Pic" class="profile-pic">
				<div class="feedback-content">
					<div class="timestamp" id="timestamp1"><%=date %></div>
					<h4 class="customer-name" id="customer-name1"><%=customer%></h4>
					<p id="feedback-text1"><%=description%></p>
					<button class="reply-btn" id="reply-btn1"
						onclick="setReplyDetail(<%=feedback.getId()%>, '<%=date%>', '<%=customer%>', '<%=description%>', '<%=profile%>')">Reply</button>
				</div>
			</div>
			<%
		if (j>4) {
			break;
		}
		j++;
		}
		%>

			<!-- Reply box -->
			<div class="reply-overlay" id="reply-overlay">
				<div class="reply-box">
					<div class="timestamp" id="reply-timestamp">time</div>
					<h4 id="reply-customer-name">Customer Name 1</h4>
					<img src="images/apple.png" height="50px" width="50px"
						alt="Customer Profile Pic" id="reply-img" class="profile-pic">
					<p id="reply-feedback-text">I loved it that was quite good. I
						loved the taste of every yogurt. But it's a bit expensive.</p>
					<form action="FeedbackController?action=reply" method="post">
						<textarea id="reply-textarea"
							placeholder="Type your reply here..." maxlength="500" required
							name="reply-input"></textarea>
						<input type="hidden" name="feedback" id="reply-feedback-id">
						<button class="submit-btn" id="submit-reply1">Submit</button>
						<button class="cancel-btn" id="cancel-reply1">Cancel</button>
					</form>
				</div>
				<!-- Additional reply boxes for other feedbacks can be added here -->
			</div>
		</div>

		<div class="additional" style="max-height: 90vh; overflow: auto;">
			<%
		ProductDAO productDAO = new ProductDAO();
		ProductRatingDAO ratingDAO = new ProductRatingDAO();
		List<ProductRating> ratings = ratingDAO.get();
		for (ProductRating rating: ratings) {
			int stars = rating.getStars();
			int rated_product_id = rating.getProduct_id();
			int rating_customer_id = rating.getCustomer_id();
		%>
			<div class="ratings" style="margin-bottom: 10px">
				<div class="product-info">
					<span class="product-name"><%=productDAO.getProductName(rated_product_id)%></span>
					<span class="customer-name">By <%=customerDAO.getName(rating_customer_id+"")%></span>
				</div>
				<div class="rating-stars">
					<%for (int k=0; k<stars; k++) { %>
					<i class='bx bxs-star'></i>
					<%} %>
					<%for (int k=stars; k<5; k++) { %>
					<i class='bx bx-star'></i>
					<%} %>
				</div>
				<div class="rating-description">
					<p><%=rating.getDescription() %></p>
				</div>
			</div>
			<%
		}
		%>
		</div>
	</div>

	<!--  Footer  -->
	<footer id='footer' style="margin-bottom: -60px;">
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
					<li><a href="#">Home</a></li>
					<li><a href="#">About Products</a></li>
					<li><a href="#">Review Section</a></li>
				</ul>
			</div>
			<div class="footer-content">
				<h3>Follow Us</h3>
				<ul class="social-icons">
					<li><a href="#" class="cancel-animation"><i
							class="fa-brands fa-telegram"></i></a></li>
				</ul>
			</div>
		</div>
		<div class="bottom-bar">
			<p>&copy; Kode Samurai. All rights reserved.</p>
		</div>
	</footer>

	<!-- Your JavaScript files -->
	<script src="js/main.js"></script>
	<script src="javascript/chartScript.js"></script>
	<script>
	
	let subm = document.getElementById("subMenu");

    function toggleMenu(){
        subm.classList.toggle("open-menu");
    }
	
	function setReplyDetail(id, time, customername, description, profile) {
	    console.log("got into the set reply details method");
	    console.log(id,time,customername,description,profile);

	    // Set the reply details
	    document.getElementById("reply-customer-name").textContent = customername;
	    document.getElementById("reply-feedback-text").textContent = description;
	    document.getElementById("reply-timestamp").textContent = time;
	    document.getElementById("reply-img").src = profile;
	    document.getElementById("reply-feedback-id").value = id;

	    // Show the overlay and reply box
	    const overlay = document.getElementById('reply-overlay');
	    const replyBox = document.getElementById('reply-box'); // Ensure this element is correctly referenced
	    overlay.style.display = 'flex';
	    replyBox.style.display = 'block';
	}

	function hideReplyBox() {
	    const overlay = document.getElementById('reply-overlay');
	    const replyBox = document.getElementById('reply-box'); // Ensure this element is correctly referenced
	    overlay.style.display = 'none';
	    replyBox.style.display = 'none';
	}

	// Example usage for a cancel button or other interaction
	document.querySelectorAll('.cancel-btn').forEach(button => {
	    button.addEventListener('click', hideReplyBox);
	});


		document
				.addEventListener(
						"DOMContentLoaded",
						function() {
							// Convert the sales data from JSP to JavaScript
							let sales =
	<%=new com.google.gson.Gson().toJson(sales)%>
		;
							console.log(sales);
							setSales(sales);
							setPieChartData(
	<%=new com.google.gson.Gson().toJson(pieChartData)%>
		)
							drawLineChart(sales);
							drawPieChart();// Assuming this function is defined in chartScript.js
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
	<script src="js/footer.js"></script>
</body>
</html>
