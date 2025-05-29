<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"
	import="dao.*, model.*,additional.TomcatRestart,java.util.*"%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%
if (session.getAttribute("cartmap") != null && !session.getAttribute("cartmap").equals("")) {
	System.out.println("before cleaning up: " + session.getAttribute("cartmap"));
	System.out.println("cleaning cartmap session");
	session.setAttribute("cartmap", "");
	System.out.println("after cleaning up: " + session.getAttribute("cartmap"));
}
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
ProductDAO productDAO = new ProductDAO();
List<Product> productlist = productDAO.getInStock();
request.setAttribute("productlist", productDAO.getInStock());
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Order Page</title>
<link rel="stylesheet" href="css/order.css">
<link rel="stylesheet" href="css/footer.css">
<link href='https://unpkg.com/boxicons@2.1.4/css/boxicons.min.css'
	rel='stylesheet'>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
<link
	href="https://fonts.googleapis.com/css2?family=Poppins:ital,wght@0,100;0,200;0,300;0,400;0,500;0,600;0,700;0,800;0,900;1,100;1,200;1,300;1,400;1,500;1,600;1,700;1,800;1,900&display=swap"
	rel="stylesheet">
<style>
.product-rating {
	margin: 5px 0;
}

.product-rating .bx-star, .product-rating .bxs-star {
	color: orange; /* Gold color for the stars */
	font-size: 23px;
	margin-right: 2px;
}

.give-rating-btn {
	display: none;
	margin-left: 10px;
	background-color: #007bff;
	color: white;
	border: none;
	padding: 5px 10px;
	cursor: pointer;
	border-radius: 5px;
	transition: opacity 4s ease;
}

.product-box:hover .give-rating-btn {
	display: inline-block;
}

.rating-div {
	display: none;
	position: fixed;
	top: 50%;
	left: 50%;
	transform: translate(-50%, -50%);
	background-color: white;
	padding: 20px;
	box-shadow: 0px 0px 10px rgba(0, 0, 0, 0.5);
	z-index: 1000;
}

.rating-div textarea {
	width: 100%;
	height: 100px;
	margin: 10px 0;
	padding: 10px;
	border: 1px solid #ddd;
	border-radius: 5px;
}

.rating-buttons {
	text-align: right;
}

.submit-rating, .cancel-rating {
	margin-left: 10px;
	background-color: #007bff;
	color: white;
	border: none;
	padding: 5px 10px;
	cursor: pointer;
	border-radius: 5px;
}

.cancel-rating {
	background-color: #ff4d4d;
}

.dark-overlay {
	position: fixed;
	top: 0;
	left: 0;
	width: 100%;
	height: 100%;
	background-color: rgba(0, 0, 0, 0.5);
	z-index: 500;
	display: none;
}

.rating-stars {
	direction: rtl; /* To make stars right to left */
	display: inline-flex;
	font-size: 24px;
}

.rating-stars input[type="radio"] {
	display: none;
}

.rating-stars label {
	cursor: pointer;
	color: #ccc; /* Gray color for unselected stars */
}

.rating-stars input[type="radio"]:checked ~ label {
	color: #ffcc00; /* Gold color for selected stars */
}

.rating-stars label:hover, .rating-stars label:hover ~ label {
	color: #ffcc00; /* Gold color on hover */
}
</style>
</head>
<body onload="cleanCart();">
	<header>
		<!-- Nav -->
		<div class="nav container">
			<a href="customer_home_page.jsp" class="logo">Home</a>
			<!-- Cart Icon -->
			<i class='bx bx-shopping-bag' id="cart-icon"></i>
			<div class="cart">
				<h2 class="cart-title">Your Cart</h2>
				<!-- Content -->
				<div class="cart-content"></div>
				<!-- Total -->
				<div class="total">
					<div class="total-title">Total</div>
					<div class="total-price">$0</div>
				</div>
				<!-- Buy Button -->
				<form action="OrderController" method="post" id="orderCartForm">
					<input type="hidden" name="action" value="save"> <input
						type="hidden" name="customer_id" value="<%=customer.getId()%>">
					<button type="submit" class="btn-buy">Buy Now</button>
				</form>
				<!-- Cart Close -->
				<i class='bx bx-x' id="close-cart"></i>
			</div>
		</div>
	</header>

	<!-- Shop -->
	<section class="shop container">
		<h2 class="section-title">Shop Products</h2>
		<!-- Content -->
		<div class="shop-content">
			<!-- Box-1 -->
			<%
			ProductRatingDAO ratingDAO = new ProductRatingDAO();
			List<Integer>stars = new ArrayList<Integer>();
			for (Product product: productlist) {
				stars.add(ratingDAO.getOverallRating(product.getId()));
			}
			for (int s: stars) {
				System.out.println(s);
			}
			int j = 0;
			%>
			<c:forEach var="product" items="${productlist}" varStatus="status">
				<div class="product-box"
					onmouseover="showRatingButton(${status.index})"
					onmouseout="hideRatingButton(${status.index})">
					<div class="product-rating">
						<%
						for (int s=0; s<stars.get(j); s++) {
						%>
						<i class='bx bxs-star'></i>
						<%
						}
						for (int s=stars.get(j); s<5; s++) {
						%>
						<i class='bx bx-star'></i>
						<%
						}
						j++;
						%>
						<button class="give-rating-btn"
							id="give-rating-btn-${status.index}"
							onclick="showRatingDiv(${status.index})">Give Rating</button>
					</div>
					<img src="userProfile/${product.getProfile_pic()}"
						alt="${product.getName()}" class="product-img"
						style="background-image: radial-gradient(circle, ${product.getTheme_color()} 10%, white 70%);">
					<h2 class="product-title">${product.getName()}</h2>
					<span class="price">${product.getPrice()}</span>ks per dozen <i
						class='bx bx-shopping-bag add-cart'></i>
				</div>

				<!-- Hidden Rating Div -->
				<div class="rating-div" id="rating-div-${status.index}"
					style="width: 50vw;">
					<form action="ProductRatingController" method="post">
						<input type="hidden" name="action" value="save"> <input
							type="hidden" name="customer_id" value="<%=customer.getId()%>">
						<input type="hidden" name="product_id" value="${product.getId()}">
						<input type="hidden" name="index" value="${status.index}">
						<h3>Rate ${product.getName()}</h3>
						<div class="rating-stars">
							<!-- Star inputs -->
							<input type="radio" id="star5-${status.index}" name="rating"
								value="5" /> <label for="star5-${status.index}"
								class="bx bxs-star"></label> <input type="radio"
								id="star4-${status.index}" name="rating" value="4" /> <label
								for="star4-${status.index}" class="bx bxs-star"></label> <input
								type="radio" id="star3-${status.index}" name="rating" value="3" />
							<label for="star3-${status.index}" class="bx bxs-star"></label> <input
								type="radio" id="star2-${status.index}" name="rating" value="2" />
							<label for="star2-${status.index}" class="bx bxs-star"></label> <input
								type="radio" id="star1-${status.index}" name="rating" value="1" />
							<label for="star1-${status.index}" class="bx bxs-star"></label>
						</div>
						<textarea name="rating-description"
							placeholder="Write your review here..."></textarea>
						<div class="rating-buttons">
							<button class="submit-rating">Submit</button>
							<button class="cancel-rating" type="button"
								onclick="hideRatingDiv(${status.index})">Cancel</button>
						</div>

					</form>
				</div>
			</c:forEach>

		</div>
	</section>

	<!-- Footer Section -->
	<footer style="bottom: -8vw;">
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
	<script>
	function showRatingButton(index) {
	    document.getElementById("give-rating-btn-"+index).style.display = 'inline-block';
	}

	function hideRatingButton(index) {
	    document.getElementById("give-rating-btn-"+index).style.display = 'none';
	}

	function showRatingDiv(index) {
	    document.getElementById("rating-div-"+index).style.display = 'block';
	    document.querySelector('.dark-overlay').style.display = 'block';
	}

	function hideRatingDiv(index) {
	    document.getElementById("rating-div-"+index).style.display = 'none';
	    document.querySelector('.dark-overlay').style.display = 'none';
	}
	</script>

	<!-- Link To Js -->
	<script src="js/order.js"></script>
	<script src="js/footer.js"></script>
	<div class="dark-overlay"></div>
</body>
</html>