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
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0" />
<title>Customer Home page</title>
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
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
<link
	href="https://fonts.googleapis.com/css2?family=Poppins:wght@100;200;300;400;500;600;700;800;900&display=swap"
	rel="stylesheet">

<style>
#feedbackContainer {
	position: fixed;
	top: 0;
	left: 0;
	width: 100%;
	height: 100%;
	background: rgba(0, 0, 0, 0.5); /* Darken background */
	display: flex;
	justify-content: center;
	align-items: center;
	z-index: 1000;
	transition: opacity 0.3s ease;
	opacity: 0;
	pointer-events: none;
}

#feedbackContainer.active {
	opacity: 1;
	pointer-events: auto;
}

#feedbackBox {
	font-size: 18px !important;
	background: white;
	padding: 20px;
	border-radius: 8px;
	width: 300px;
	box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
	text-align: center;
}

#feedbackInput {
	width: 100%;
	height: 100px;
	padding: 10px;
	border: 1px solid #ccc;
	border-radius: 4px;
	margin-bottom: 10px;
	resize: none;
}

.feedback-buttons {
	display: flex;
	justify-content: center;
}

.feedback-buttons button {
	padding: 8px 12px;
	border: none;
	border-radius: 4px;
	cursor: pointer;
}

#feedback-submitBtn {
	margin: 4px;
	background-color: #4CAF50;
	color: white;
	transition: transform 0.3s ease, box-shadow 0.3s ease;
}

#feedback-cancelBtn {
	margin: 4px;
	background-color: #f44336;
	color: white;
	transition: transform 0.3s ease, box-shadow 0.3s ease;
}

#feedback-submitBtn:hover {
	transform: scale(1.1); /* Scale up the button */
	box-shadow: 0 4px 8px rgba(0, 0, 0, 0.3);
	/* Add shadow for a lifted effect */
}

#feedback-cancelBtn:hover {
	transform: scale(1.1); /* Scale up the button */
	box-shadow: 0 4px 8px rgba(0, 0, 0, 0.3);
	/* Add shadow for a lifted effect */
}

.hidden {
	display: none;
}
</style>

</head>
<body
	style="font-family: 'Poppins', sans-serif;">
	<!-- Header -->
	<header>
		<a href="#" class="logo">Panmyodaw</a> <input type="checkbox"
			id="menu-bar" class="hidden-desktop"> <label for="menu-bar"
			class="initial">Menu</label>
		<nav class="navbar">
			<ul>
				<li><a href="#home">home</a></li>
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

	<div id="feedbackContainer" class="hidden">
		<form method="post" action="FeedbackController">
			<div id="feedbackBox">
				<textarea id="feedbackInput" name="description"
					placeholder="Enter your feedback" maxlength="500" required></textarea>
				<div class="feedback-buttons">
					<button id="feedback-submitBtn">Submit</button>
					<input type="hidden" name="customer" value="<%=customer.getId()%>">
					<button id="feedback-cancelBtn" type="button">Cancel</button>
				</div>
			</div>
		</form>
	</div>

	<!-- First Page (Slider) -->
	<div class="slider" id="home">
		<div class="slider-wrapper flex">
			<!-- Slide 1 -->
			<%
			ProductDAO productDAO = new ProductDAO();
			List<Product> products = productDAO.get();
			int iterator = 0;
			for (Product product : products) {
			%>
			<div class="slide flex" style="margin-left: -40px;">
				<div class="slide-image"
					style="background-image: radial-gradient(circle, <%=product.getTheme_color()%> 15%, transparent 60%);  filter: hue-rotate(<%=color.getHueRotation("#ff4dbeee", product.getTheme_color())%>);">
					<img
						src="<%=request.getContextPath() + "/userProfile/" + product.getProfile_pic()%>"
						alt="Strawberry Yogurt">
				</div>
				<div class="slide-content">
					<div class="slide-title pink-text"
						style="color: <%=product.getTheme_color()%>;"><%=product.getName()%></div>
					<div class="slide-text"><%=product.getProduct_description()%></div>
					<a href="order.jsp" class="order-button pink"
						style="background-color: <%=product.getTheme_color()%>;">Order
						Now</a>
				</div>
			</div>
			<%
			iterator++;
			if (iterator > 10) {
				break;
			}
			}
			%>
		</div>

		<div class="arrows">
			<a href="#" title="Previous" class="arrow slider-link prev"></a> <a
				href="#" title="Next" class="arrow slider-link next"></a>
		</div>
	</div>

	<!-- Catalog Page -->

	<%
			ProductRatingDAO ratingDAO = new ProductRatingDAO();
			List<Integer>stars = new ArrayList<Integer>();
			for (Product product: products) {
				stars.add(ratingDAO.getOverallRating(product.getId()));
			}
			for (int s: stars) {
				System.out.println(s);
			}
			int j = 0;
	%>
	<div class="catalog-page">
		<h1 class="catalog-title">Featured Yogurt Flavors</h1>
		<div class="gallery">

			<%
    iterator = 0;
    for (Product p : products) {
        if (iterator >= 4) break;
    %>
			<div class="content">
				<img
					src="<%=request.getContextPath() + "/userProfile/" + p.getProfile_pic()%>"
					alt="<%=p.getName() %> Image">
				<h3><%=p.getName() %></h3>
				<p style="min-height: 40px;">
					"<%=p.getProduct_description()%>"
				</p>
				<h6><%=p.getPrice()%>
					ks
				</h6>
				<ul>
					<%
						for (int s=0; s<stars.get(j); s++) {
						%>
					<li><i class='fa fa-star checked'></i></li>
					<%
						}
						for (int s=stars.get(j); s<5; s++) {
						%>
					<li style="color: #1f2c2ccc; font-size: 24px;"><i
						class='far fa-star'></i></li>
					<%
						}
						j++;
					%>
				</ul>
				<a href="order.jsp">
					<button id="<%=p.getName()%>" class="buy-1">Buy Now</button>
				</a>
			</div>

			<%
        iterator++;
    }
    %>

		</div>
	</div>

	<!-- About Us -->
	<div class="wrapper">
		<div class="title">
			<h1>About Us</h1>
		</div>
		<div class="about" id='aboutUs'>
			<div class="image-section">
				<img src="images/slider/yogurt-fruit-salad.png">
			</div>
			<article>
				<h3>
					Nestled in the scenic town of Pyin Oo Lwin, our yogurt company is
					dedicated to delivering the finest, most nutritious yogurt to your
					table.
					<p>Crafted from the freshest local ingredients, our yogurt is
						not only delicious but also packed with essential micronutrients,
						making it a perfect addition to your daily diet. Whether you're
						looking for a wholesome snack or a healthy treat, our yogurt
						offers a delightful blend of taste and wellness that you can feel
						good about. Experience the richness of Pyin Oo Lwin in every
						spoonful, where quality and health come first.
				</h3>
				</p>
				<div class="button" id="feedbackBtn">
					<a href="#">Give Feedback</a>
				</div>
			</article>
		</div>
	</div>

	<!-- Footer Section -->
	<footer id='footer'>
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

	<!-- Header Javascript -->
	<script>
	document.getElementById('feedbackBtn').addEventListener('click', function() {
	    document.getElementById('feedbackContainer').classList.add('active');
	});

	document.getElementById('feedback-cancelBtn').addEventListener('click', function() {
	    document.getElementById('feedbackContainer').classList.remove('active');
	});

	
    document.addEventListener("DOMContentLoaded", function() {
        <%for (Product p : products) {%>
            var button = document.getElementById("<%=p.getName()%>");
            if (button) {
                button.style.backgroundColor = "<%=p.getTheme_color()%>";
            }
        <%}%>
    });
    
        let subMenu = document.getElementById("subMenu");

        function toggleMenu(){
            subMenu.classList.toggle("open-menu");
        }
        
        if (<%=session.getAttribute("feedback")!=null%>) {
        	if (<%=session.getAttribute("feedback")=="successful"%>) {
        		alert("Your feedback is sent to the admin");
        		<%
        		session.setAttribute("feedback", "");
        		%>
        	}
        }
        
     // Active state for header
        document.addEventListener('DOMContentLoaded', () => {
            let sections = document.querySelectorAll('div[id], .wrapper, footer');
            let navLinks = document.querySelectorAll('.navbar ul li a');
            let footer = document.querySelector('footer');
        
            function setActive() {
                let current = null;
                const footerOffsetThreshold = window.innerHeight * 0.3;
        
                sections.forEach(section => {
                    const sectionTop = section.offsetTop - 80;
                    const sectionBottom = sectionTop + section.offsetHeight;
        
                    if (scrollY >= sectionTop && scrollY < sectionBottom) {
                        current = section.getAttribute('id');
                    }
                });
        
                const footerTop = footer.offsetTop;
                const footerHeight = footer.offsetHeight;
                const viewportBottom = scrollY + window.innerHeight;
        
                if (viewportBottom >= footerTop + footerHeight - footerOffsetThreshold) {
                    current = 'footer';
                }
        
                // If no section is currently in view, clear all active states
                if (!current) {
                    navLinks.forEach(link => link.classList.remove('active'));
                } else {
                    navLinks.forEach(link => {
                        link.classList.remove('active');
        
                        if (link.getAttribute('href').includes(current)) {
                            link.classList.add('active');
                        }
                    });
                }
            }
        
            setActive();
            window.addEventListener('scroll', setActive);
        
            navLinks.forEach(link => {
                link.addEventListener('click', function(e) {
                    const href = this.getAttribute('href');
        
                    if (href.startsWith("#")) {
                        e.preventDefault();
                        const targetElement = document.querySelector(href);
                        const offset = document.querySelector('header').offsetHeight;
                        const targetPosition = targetElement.getBoundingClientRect().top + window.pageYOffset - offset;
        
                        window.scrollTo({
                            top: targetPosition,
                            behavior: 'smooth'
                        });
        
                        // Manually set the active class on click
                        navLinks.forEach(l => l.classList.remove('active'));
                        this.classList.add('active');
                    }
                });
            });
        });
    </script>

	<script
		src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
	<script src="js/slider.js"></script>
	<script src="js/footer.js"></script>
</body>
</html>
