<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page import="dao.AdminDAO"%>
<%@ page import="model.Admin"%>
<%
// Retrieve cookies from the request
Cookie[] cookies = request.getCookies();
Cookie myCookie = null;
if (cookies != null) {
	for (Cookie cookie : cookies) {
		if ("admin".equals(cookie.getName())) {
	myCookie = cookie;
	break;
		}
	}
}
AdminDAO adminDAO = new AdminDAO();
Admin admin = adminDAO.get(Integer.parseInt(myCookie.getValue()));
System.out.println(
		String.format("%d\n%s\n%s\n%s", admin.getId(), admin.getEmail(), admin.getPassword(), admin.isVerified() + ""));
if (admin.isVerified()) {
	request.getRequestDispatcher("/dashboard.jsp").forward(request, response);
}
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0" />
<title>Waiting For Admin</title>
<link
	href="https://fonts.googleapis.com/css2?family=Quicksand:wght@400;600&display=swap"
	rel="stylesheet" />
<style>
body {
	background-image: linear-gradient(rgba(255, 255, 255, 0.6),
		rgba(255, 255, 255, 0.6)), url("yoghurtSplashLoginPage.png");
	background-size: cover;
	background-position: center;
	background-repeat: no-repeat;
	display: flex;
	justify-content: center;
	align-items: center;
	height: 100vh;
	margin: 0;
	font-family: "Quicksand", sans-serif;
	color: #333;
}

.container {
	text-align: center;
	background-color: rgba(255, 255, 255, 0.95);
	padding: 40px 60px;
	border-radius: 15px;
	box-shadow: 0px 8px 30px rgba(0, 0, 0, 0.2);
	border: 1px solid #ff4081;
	animation: fadeIn 1s ease-in-out;
	transition: transform 0.3s ease-in-out;
}

.container:hover {
	transform: scale(1.05);
}

.message {
	color: #ff4081;
	font-size: 26px;
	font-weight: 600;
	letter-spacing: 1px;
	margin: 0;
	text-shadow: 1px 1px 5px rgba(255, 64, 129, 0.4);
}

@
keyframes fadeIn {from { opacity:0;
	transform: translateY(60px);
}

to {
	opacity: 1;
	transform: translateY(0);
}

}
@media ( max-width : 768px) {
	.container {
		padding: 30px 40px;
		box-shadow: 0px 6px 20px rgba(0, 0, 0, 0.2);
	}
	.message {
		font-size: 22px;
	}
}

@media ( max-width : 480px) {
	.container {
		padding: 20px 30px;
		box-shadow: 0px 4px 15px rgba(0, 0, 0, 0.2);
	}
	.message {
		font-size: 18px;
	}
}
</style>
</head>
<body>
	<div class="container">
		<p class="message">Waiting for the admin approval</p>
	</div>
</body>
</html>