<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" import="dao.*, model.*, additional.MyDevice"%>
<% 
int admin_id = -1;
Cookie[] cookies = request.getCookies();
if (cookies != null ){
	for (Cookie cookie: cookies) {
		if ("user_id".equals(cookie.getName())) {
			admin_id = Integer.parseInt(cookie.getValue());
			break;
		}
	}
}
if (admin_id == -1) request.getRequestDispatcher("/login.jsp").forward(request, response);
CustomerDAO customerDAO = new CustomerDAO();
Customer customer = customerDAO.get(admin_id);
// System.out.println("session " + session.getAttribute("profileChange"));
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Profile Page</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="profilecss/header.css">
    <link rel="stylesheet" href="profilecss/profile.css">
    <link rel="stylesheet" href="profilecss/history.css">
    <link rel="stylesheet" href="profilecss/password.css">
    <link rel="stylesheet" href="profilecss/logout.css">
    <link rel="stylesheet" href="css/footer.css">
    <style>
    	input:disabled{
    		color: black;
    		opacity: 1; /* Ensures the text has 100% opacity */
    		background-color: #f0f0f0; /* Optional: change the background to distinguish disabled state */
    		-webkit-text-fill-color: black; /* For better compatibility with some browsers */
		}
		textarea:disabled{
			color: black;
			opacity: 0.7;
			background-color: pink;
			text-decoration: italic;
		}
    </style>
</head>
<body>
    <!-- Header Section -->
    <header>
        <a href ="#" class = "logo">Panmyodaw</a>
        <input type="checkbox" id = "menu-bar" class = "hidden-desktop">
        <label for="menu-bar" class= "initial">Menu</label>
        <nav class = "navbar">
            <ul>
                <li><a href="customer_home_page.jsp">home</a></li>
                <li><a href="#">about</a></li>
                <li><a href="#">contact</a></li>
                <li class = "hidden-desktop initial"><a href = "order.jsp">order</a></li>
                <a href = "order.jsp" class = "hidden-mobile-avg"><i class="fa-solid fa-cart-shopping"></i></a>
            </ul>
        </nav>
    </header>

    <!-- Profile Page -->
    <div class="account-container">
        <!-- Side Bar -->
        <div class="profile">
            <div class="profile-header">
            <form action="CustomerController" id="profilePicChange" method="post" enctype="multipart/form-data">
            <input type="hidden" name="action" value="updateProfileImage">
            <input type="hidden" name="id" value="<%=customer.getId() %>">
                <div class="profile-img-container">
                    <img src="<%=request.getContextPath() + "/userProfile/" + customer.getProfile_pic() %>" alt="profile" class="profile-img" id="profile-img"/>
                    <div class="profile-img-overlay">
                        <i class="fa fa-pencil"></i>
                        <input type="file" id="profile-img-input" data-ignore-edit="true" name="profileImage" style="display: none;" onchange="submitForm();">
                    </div>
                </div>
             </form>
                <div class="profile-text-container">
                    <h1 class="profile-title" id="profile-username">@<%=customer.getName()%></h1>
                    <p class="profile-email" id="profile-email"><%=customer.getEmail()%></p>
                </div>
            </div>
            <div class="menu">
                <a href="#" class="menu-link active" id="account-link"><i class="fa-solid fa-user icon"></i>Account</a>
                <a href="#" class="menu-link" id="password-link"><i class="fa-solid fa-user-shield icon"></i>Password</a>
                <a href="#" class="menu-link logout-link"><i class="fa-solid fa-arrow-right-from-bracket icon"></i>Logout</a>
            </div>
        </div>

        <!-- Account Section -->
        <div class="account" id="account-section">
        <form method="post" action="CustomerController">
            <div class="account-header">
                <h1 class="account-title">Account Setting</h1>
                <div class="btn-container">
                    <button type="button" id="delete-btn" class="btn-delete">Delete Account</button>
                    <button type="button" id="edit-btn" class="btn-edit" onclick="toggleEdit(true)">Edit</button>
                    <button type="button" id="cancel-btn"  class="btn-cancel" onclick="window.location.href='customer_profile_view.jsp';" style="display: none;">Cancel</button>
                    <button type = "submit" id="save-btn" class="btn-save" onclick="saveProfile()" style="display: none;">Save</button>
                </div>
            </div>
            <div class="account-edit">
                <div class="input-container">
                    <label>Username</label>
                    <input autofocus id="username" type="text" placeholder="Username" name="name" value="<%=customer.getName()%>" disabled/>    
                    <span class="error-message"><i class="fa fa-times-circle"></i> Error message</span>
                </div>
                <div class="input-container">
                    <label>Email</label>
                    <input autofocus  id="email" type="text" name="email" value="<%=customer.getEmail()%>" placeholder="First Name" disabled/>    
                    <span class="error-message"><i class="fa fa-times-circle"></i> Error message</span>
                </div>
                <div class="input-container">
                    <label>Phone Number</label>
                    <input autofocus id="phone-number" type="text" name="phone" value="<%=customer.getPhone()%>" placeholder="Last Name" disabled/>    
                    <span class="error-message"><i class="fa fa-times-circle"></i> Error message</span>
                </div>
                <input type="hidden" name="action" value="update">
            </div>
            <div class="account-edit">
                <div class="input-container">
                    <label>Shop Name</label>
                    <input autofocus id="id" name="shop" type="text" value="<%=customer.getShop_name()%>" placeholder="Email" disabled/>    
                    <span class="error-message"><i class="fa fa-times-circle"></i> Error message</span>
                </div>
                <div class="input-container">
                    <label>City</label>
                    <input autofocus id="verification" name="city" type="text" placeholder="Phone Number" value="<%=customer.getAddress()%>" disabled/>    
                    <span class="error-message"><i class="fa fa-times-circle"></i> Error message</span>
                </div>
            </div>
            <div class="account-edit">
                <div class="input-container">
                    <label style="color: red;">Note**</label>
                    <textarea id="address" placeholder="Address" readonly disabled>Please Note: As a customer, any changes you make to this profile will be reflected across the entire system. This means that all users who have access to this profile will see the updated information. Please ensure that the changes are accurate and necessary before saving.
                    </textarea>
                    <span class="error-message"><i class="fa fa-times-circle"></i> Error message</span>
                </div>
            </div>
            <input type="hidden" name="id" value="<%=customer.getId()%>">
            </form>
        </div>

        <!-- Password Section -->
        <div class="account" id="password-section" style="display: none;">
            <div class="account-header">
                <h1 class="account-title">Change Password</h1>
            </div>
            <div class = "notification"></div>
			<form action="CustomerController" method="post">		
            <div class="account-edit">
                <div class="input-container">
                    <label>Old Password</label>
                    <div class="password-wrapper">
                        <input id="old-password" type="password" name="old-password" placeholder="Old Password"/>  
                        <i class="fa fa-eye toggle-password" onclick="togglePasswordVisibility('old-password')"></i>
                    </div>
                    <span class="error-message"><i class="fa fa-times-circle"></i>Error message</span>
                </div>
                <div class="input-container">
                    <label>New Password</label>
                    <div class="password-wrapper">
                        <input id="new-password" name="new-password" type="password" placeholder="New Password"/> 
                        <i class="fa fa-eye toggle-password" onclick="togglePasswordVisibility('new-password')"></i>   
                    </div>
                    <span class="error-message"><i class="fa fa-times-circle"></i> Error message</span>
                </div>
                <input type="hidden" name="action" value="passwordChange">
                <input type='hidden' name='id' value="<%=customer.getId()%>">
            </div>
            <button type="submit" id="change-password-btn" class="pass-save">Change Password</button>
            </form>
        </div>
    </div>

    <!-- Delete confirmation modal from account -->
    <div class="confirmation-overlay hide">
        <div class="confirmation-box">
            <p>Are you sure you want to delete your account?</p>
            <div class="confirmation-buttons">
            	<form action="CustomerController" method="get">
            		<input type="hidden" name="id" value="<%=customer.getId()%>">
            		<input type="hidden" name="action" value="delete">
            		<button type="submit" id="confirm-delete-btn">Delete</button>
            	</form>
                <button id="cancel-delete-btn">Cancel</button>
            </div>
        </div>
    </div>
    
    <!-- Logout confirmation modal -->
    <div class="logout-confirmation-overlay">
        <div class="logout-confirmation-box">
            <p>Are you sure you want to logout?</p>
            <div class="logout-confirmation-buttons">
            <form action="CustomerController" method="get">
            	<input type="hidden" name="action" value="logout">
            	<input type="hidden" name="id" value="<%=customer.getId()%>">
                <button type="submit" id="confirm-logout-btn">Logout</button>
            </form>
                <button id="cancel-logout-btn">Cancel</button>
            </div>
        </div>
    </div>

    <!--  Footer Section -->
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
    	if (<%=session.getAttribute("MSG") != null && session.getAttribute("MSG").equals("passwordchange")%>) {
    		alert("Password changed successfully");
    		<%
    			session.removeAttribute("MSG");
    		%>
    	}
    	else if (<%=session.getAttribute("MSGwrong") != null && session.getAttribute("MSGwrong").equals("wrongpassword")%>) {
    		localStorage.setItem('wrong-attempt', 1);
    		alert("Wrong password. Try again!");
    		<%
    			session.removeAttribute("MSGwrong");
    			session.setAttribute("attempt", "one");
    		%>
    	}
    	else if (<%=session.getAttribute("MSGwrong") != null && session.getAttribute("MSGwrong").equals("wrongpassword1")%>) {
    		localStorage.setItem('wrong-attempt', 2);
    		alert("Wrong password again.\nAfter two more failed attempts, your account will be suspended for 3 days.\nTry again!");
    		<%
    			session.removeAttribute("MSGwrong");
    			session.setAttribute("attempt", "two");
    		%>
    	}
    	else if (<%=session.getAttribute("MSGwrong") != null && session.getAttribute("MSGwrong").equals("wrongpassword2")%>) {
    		localStorage.setItem('wrong-attempt', 3);
    		alert("Wrong password again.\nAfter one more failed attempt, your account will be suspended for 3 days.\nTry again!");
    		<%
    			System.out.println("\n\n\n\n\n\n\n\n\n**************************"+session.getAttribute("MSGwrong"));
    			session.removeAttribute("MSGwrong");
    			session.setAttribute("attempt", "three");
    			session.setAttribute("userId", admin_id+"");
    			session.setAttribute("userType", "customer");
    			session.removeAttribute("MSGwrong");
    		%>
    	}
    	else if (<%=session.getAttribute("MSGupdate") != null && session.getAttribute("MSGupdate").equals("update")%>) {
    		alert("Account Info Update Successful");
    		<%
    			session.removeAttribute("MSGupdate");
    		%>
    	}
        let subMenu = document.getElementById("subMenu");

        function toggleMenu(){
            subMenu.classList.toggle("open-menu");
        }
        if (<%=session.getAttribute("profileChange") != null && ((String)session.getAttribute("profileChange")).equals("success")%>) {
              alert("Proflie picture update successful");
              <%
              session.setAttribute("profileChange", "");
              %>
        }
        function submitForm() {
        	document.getElementById("profilePicChange").submit();
        }
    </script>
    <script src="profilejs/profile.js"></script>
    <script src="profilejs/password.js"></script>
    <script src="profilejs/logout.js"></script>
    <script src="js/footer.js"></script>
</body>
</html>
