<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="javax.servlet.http.Cookie"%>
<%@ page import="dao.EmployeeDAO"%>
<%@ page import="model.Employee"%>
<% 
int employee_id = -1;
Cookie[] cookies = request.getCookies();
if (cookies != null ){
	for (Cookie cookie: cookies) {
		if ("user".equals(cookie.getName())) {
			employee_id= Integer.parseInt(cookie.getValue());
			break;
		}
	}
}
if (employee_id == -1) request.getRequestDispatcher("/emp_login.jsp").forward(request, response);
EmployeeDAO employeeDAO = new EmployeeDAO();
Employee employee = employeeDAO.get(employee_id);
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Home page</title>
    <link rel="stylesheet" href="css/header.css">
    <link rel="stylesheet" href="css/slider.css">
    <link rel="stylesheet" href="css/catalog.css">
    <link rel="stylesheet" href="css/aboutUs.css">
    <link rel="stylesheet" href="css/footer.css">
    <link href="https://fonts.googleapis.com/css2?family=Taviraj:wght@200;300;400;500;600;700&display=swap" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@100;200;300;400;500;600;700;800;900&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <style>
    	header .navbar{
			padding: 0 !important;
    	}
    	
	    .navbar a {
	    text-decoration: none;
	     /* Optional: to ensure the text color is consistent */
	}
	    .logo {
	    text-decoration: none;
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
                <li><a href="emphomeorder.jsp">Orders</a></li>
                <li><a href="employeehomepage.jsp">Ongoing Orders</a></li>
                <li><a href="deliveredordersemp.jsp">Delivered Orders</a></li>
                <li><a href="productemployee.jsp">Products</a></li>
                <li  class = "hidden-desktop initial"><a href = "#">user +</a>
                    <ul>
                        <li><a href = "#">account</a></li>
                        <li><a href = "#">password</a></li>
                        <li><a href = "#">logout</a></li>
                    </ul>
                </li>
                <li class = "hidden-desktop initial"><a href = "order.jsp">order</a></li>
                <div class = "profile-container hidden-mobile-avg">
                    <img src = '<%=request.getContextPath() + "/userProfile/" + employee.getProfile_pic()%>' class = "user-pic hide" onclick="toggleMenu()">
                </div>
                <div class="sub-menu-wrap" id = "subMenu">
                    <div class="sub-menu">
                        <div class="user-info">
                           <img src = '<%=request.getContextPath() + "/userProfile/" + employee.getProfile_pic()%>' style="height:65px; width: 65px;">
                           <h3><%=employee.getName() %></h3>
                        </div>
                        <hr>

                        <a href="employeeprofile.jsp" class = "sub-menu-link">
                            <i class="fa-solid fa-user"></i>
                            <p>account</p>
                            <span>></span>
                        </a>
                        
                        <a href="#" class = "sub-menu-link">
                            <i class="fa-solid fa-envelope"></i>
                            <p><%=employee.getEmail()%></p><span>></span>
                            
                        </a>
                        <a href="#" class = "sub-menu-link">
                            <i class="fa-solid fa-id-badge"></i>
                            <p><%=employee.getRole()%></p><span>></span>
                            
                        </a>
                    </div>
                </div>
               
            </ul>
        </nav>
    </header>
    <!-- View order data table -->
	<div>
     <jsp:include page="/productemp.jsp" />
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
                    <li><a href="emphomeorder.jsp">Home</a></li>
                    <li><a href="productemployee.jsp">About Products</a></li>
                    <li><a href="employeehomepage.jsp">Delivered Status</a></li>
                </ul>
            </div>
            <div class="footer-content">
                <h3>Follow Us</h3>
                <ul class="social-icons">
                    <li><a href="https://t.me/sapyaephyokyaw" class = "cancel-animation"><i class="fa-brands fa-telegram"></i></a></li>
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
    </script>

    
    <script src="js/slider.js"></script>
	<script src="js/footer.js"></script>
</body>
</html>
