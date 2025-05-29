<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="javax.servlet.http.Cookie"%>
<%@ page import="dao.CustomerDAO"%>
<%@ page
	import="model.*, dao.*, java.util.*, additional.HueRotationCalculator"%>
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

FeedbackDAO feedbackDAO = new FeedbackDAO();
List<Feedback> feedbacks = feedbackDAO.getByCustomer(id);
for (Feedback feedback: feedbacks) {
	System.out.println(feedback.getDescription() + feedback.getReply());
}
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link rel="stylesheet" href="css/header.css">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">

<style>
body {
	background: linear-gradient(#FFE4E1, white, #FFE4E1);
	color: #000000;
	font-family: 'Poppins', sans-serif;
	margin: 0;
	padding: 20px;
	font-family: 'Poppins', sans-serif;
	font-size: 18px;
}

.notification-container {
    border: 1px solid #ddd;
    border-radius: 8px;
    padding: 15px;
    margin-bottom: 20px;
    width: 95vw;
    background-color: #f9f9f9;
}

.notification-header {
    margin-bottom: 10px;
}

.notification-details span {
    display: block;
    margin-bottom: 5px;
    font-weight: bold;
}

.chat-section {
    display: flex;
    flex-direction: column;
    gap: 10px;
}

.customer-chat-box {
    background-color: #e0f7fa;
    padding: 10px;
    border-radius: 8px;
    align-self: flex-start;
}

.admin-reply-box {
    background-color: pink;
    padding: 10px;
    max-width: 70vw;
    border-radius: 8px;
    align-self: flex-end;
}

.customer-message, .admin-message {
    margin: 0;
    font-size: 17px;
    line-height: 1.5;
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
</style>
<link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">

</head>
<body>
	<header>
		<a href="#" class="logo">Panmyodaw</a> <input type="checkbox"
			id="menu-bar" class="hidden-desktop"> <label for="menu-bar"
			class="initial">Menu</label>
		<nav class="navbar">
			<ul>
				<li><a href="customer_home_page.jsp">home</a></li>
				<li><a href="#aboutUs">about</a></li>
				<li><a href="#footer">contact</a></li>
				<li><a href="customer_notifications.jsp"><i
						class="fas fa-comments"></i></a>
				<li class="hidden-desktop initial"><a href="#">user +</a>
					<ul>
						<li><a href="customer_profile_view.jsp">account</a></li>
						<li><a href="customer_history.jsp">history</a></li>
					</ul></li>
				<li class="hidden-desktop initial"><a href="order.jsp">order</a></li>
				<div class="profile-container hidden-mobile-avg">
					<img
						src="<%=request.getContextPath() + "/userProfile/" + customer.getProfile_pic()%>"
						class="user-pic hide" onclick="toggleMenu()">
				</div>
				<div class="sub-menu-wrap" id="subMenu">
					<div class="sub-menu">
						<div class="user-info">
							<img
								src='<%=request.getContextPath() + "/userProfile/" + customer.getProfile_pic()%>'>
							<h3><%=customer.getName()%></h3>
							<h3>
								&nbsp;(ID:
								<%=customer.getId()%>)
							</h3>
						</div>
						<hr>

						<a href="customer_profile_view.jsp" class="sub-menu-link"> <i
							class="fa-solid fa-user"></i>
							<p>account</p> <span>></span>
						</a> <a href="customer_history.jsp" class="sub-menu-link"> <i
							class="fa-regular fa-clipboard"></i>
							<p>history</p> <span>></span>
						</a>
					</div>
				</div>
				<a href="order.jsp" class="hidden-mobile-avg"><i
					class="fa-solid fa-cart-shopping"></i></a>
			</ul>
		</nav>
	</header>
	<br>
	<br>
	<br>
	<%
	for (Feedback feedback: feedbacks) {
		String rep = "";
		if (feedback.getReply() != null) {
			rep = feedback.getReply();
		}
	%>
	<div class="notification-container">
		<div class="chat-section">
			<b style="opacity: 0.7; font-size: 14px; margin-bottom: -10px;">You: </b><div class="customer-chat-box">
				<p class="customer-message"><%=feedback.getDescription()%></p>
			</div>
			<b style="opacity: 0.7; font-size: 14px; margin-bottom: -10px; margin-left: 90vw;">Admin: </b><div class="admin-reply-box">
				<p class="admin-message"><%=rep %></p>
			</div>
		</div>
	</div>
	<%
	}
	%>
	<script
		src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
	<script src="js/slider.js"></script>
</body>
</html>



















