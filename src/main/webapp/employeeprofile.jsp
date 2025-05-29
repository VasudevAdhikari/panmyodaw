<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" import="dao.*, model.*"%>
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
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Profile Page</title>
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
<link
	href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;700&display=swap"
	rel="stylesheet">
<link rel="stylesheet" href="profilecss/header.css">
<link rel="stylesheet" href="profilecss/profile.css">
<link rel="stylesheet" href="profilecss/history.css">
<link rel="stylesheet" href="profilecss/password.css">
<link rel="stylesheet" href="profilecss/logout.css">
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
<style>
input:disabled {
	color: black;
	opacity: 1; /* Ensures the text has 100% opacity */
	background-color: #f0f0f0;
	/* Optional: change the background to distinguish disabled state */
	-webkit-text-fill-color: black;
	/* For better compatibility with some browsers */
}

textarea:disabled {
	color: black;
	opacity: 0.7;
	background-color: pink;
	text-decoration: italic;
}
.toggle-password {
	top: initial !important;
	transform: none;
}
.toggle-password:hover {
	transform: none;
}
</style>
</head>
<body>
	<!-- Header -->
	<header>
		<a href="#" class="logo">Panmyodaw</a> <input type="checkbox"
			id="menu-bar" class="hidden-desktop"> <label for="menu-bar"
			class="initial">Menu</label>
		<nav class="navbar">
			<ul>
				<li><a href="emphomeorder.jsp">Orders</a></li>
				<li><a href="employeehomepage.jsp">Ongoing Orders</a></li>
				<li><a href="deliveredordersemp.jsp">Delivered Orders</a></li>
				<li><a href="productemployee.jsp">Products</a></li>
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
							<h3><%=employee.getName() %>
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


	<!-- Profile Page -->
	<div class="account-container">
		<!-- Side Bar -->
		<div class="profile">
			<div class="profile-header">
				<form action="EmployeeController" id="profilePicChangeEmp"
					method="post" enctype="multipart/form-data">
					<input type="hidden" name="action" value="updateProfileImage">
					<input type="hidden" name="id" value="<%=employee.getId() %>">
					<div class="profile-img-container">
						<img
							src="<%=request.getContextPath() + "/userProfile/" + employee.getProfile_pic() %>"
							alt="profile" class="profile-img" id="profile-img" />
						<div class="profile-img-overlay">
							<i class="fa fa-pencil"></i> <input type="file"
								id="profile-img-input" data-ignore-edit="true"
								name="profileImage" style="display: none;"
								onchange="document.getElementById('profilePicChangeEmp').submit();">
						</div>
					</div>
				</form>
				<div class="profile-text-container">
					<h1 class="profile-title" id="profile-username">
						@<%=employee.getName()%></h1>
					<p class="profile-email" id="profile-email"><%=employee.getEmail()%></p>
				</div>
			</div>
			<div class="menu">
				<a href="#" class="menu-link active" id="account-link"><i
					class="fa-solid fa-user icon"></i>Account</a> <a href="#"
					class="menu-link" id="password-link"><i
					class="fa-solid fa-user-shield icon"></i>Password</a> <a href="#"
					class="menu-link logout-link"><i
					class="fa-solid fa-arrow-right-from-bracket icon"></i>Logout</a>
			</div>
		</div>

		<!-- Account Section -->
		<div class="account" id="account-section">
			<form method="post" action="EmployeeController">
				<div class="account-header">
					<h1 class="account-title">Account Setting</h1>
					<div class="btn-container">
						<button type="button" id="delete-btn" class="btn-delete">Delete
							Account</button>
						<button type="button" id="edit-btn" class="btn-edit"
							onclick="toggleEdit(true)">Edit</button>
						<button type="button" id="cancel-btn" class="btn-cancel"
							onclick="window.location.href='employeeprofile.jsp';" style="display: none;">Cancel</button>
						<button type="submit" id="save-btn" class="btn-save"
							onclick="saveProfile()" style="display: none;">Save</button>
					</div>
				</div>
				<div class="account-edit">
					<div class="input-container">
						<label>Username</label> <input autofocus id="username" type="text"
							placeholder="Username" name="name"
							value="<%=employee.getName()%>" disabled /> <span
							class="error-message"><i class="fa fa-times-circle"></i>
							Error message</span>
					</div>
					<div class="input-container">
						<label>Email</label> <input autofocus id="email" type="text"
							name="email" value="<%=employee.getEmail()%>"
							placeholder="First Name" disabled /> <span class="error-message"><i
							class="fa fa-times-circle"></i> Error message</span>
					</div>
					<div class="input-container">
						<label>Phone Number</label> <input autofocus id="phone-number"
							type="text" name="phone" value="<%=employee.getPhone()%>"
							placeholder="Last Name" disabled /> <span class="error-message"><i
							class="fa fa-times-circle"></i> Error message</span>
					</div>
					<input type="hidden" name="action" value="update">
				</div>
				<div class="account-edit">
					<div class="input-container">
						<label>Employee ID</label> <input autofocus id="id" name="id"
							readonly type="text" value="<%=employee.getId()%>"
							placeholder="Email" disabled /> <span class="error-message"><i
							class="fa fa-times-circle"></i> Error message</span>
					</div>
					<div class="input-container">
						<label>Role</label> <input autofocus id="id" name="id" readonly
							type="text" value="<%=employee.getRole()%>" placeholder="Email"
							disabled /> <span class="error-message"><i
							class="fa fa-times-circle"></i> Error message</span>
					</div>
				</div>
				<div class="account-edit">
					<div class="input-container">
						<label>Salary</label> <input autofocus id="id" name="id" readonly
							type="text" value="<%=employee.getSalary()%>" placeholder="Email"
							disabled /> <span class="error-message"><i
							class="fa fa-times-circle"></i> Error message</span>
					</div>
					<div class="input-container">
						<label>Verification</label> <input autofocus id="verification"
							readonly type="text" placeholder="Phone Number" value="verified"
							disabled /> <span class="error-message"><i
							class="fa fa-times-circle"></i> Error message</span>
					</div>
				</div>
				<div class="account-edit">
					<div class="input-container">
						<label style="color: red;">Note**</label>
						<textarea id="address" placeholder="Address" readonly disabled>Please Note: As an Employee, any changes you make to this profile will be reflected across the entire system. This means that all users who have access to this profile will see the updated information. Please ensure that the changes are accurate and necessary before saving.
                    </textarea>
						<span class="error-message"><i class="fa fa-times-circle"></i>
							Error message</span>
					</div>
				</div>
			</form>
		</div>

		<!-- Password Section -->
		<div class="account" id="password-section" style="display: none;">
			<div class="account-header">
				<h1 class="account-title">Change Password</h1>
			</div>
			<div class="notification"></div>
			<form action="EmployeeController" method="post">
				<div class="account-edit">
					<div class="input-container">
						<label>Old Password</label>
						<div class="password-wrapper">
							<input id="old-password" type="password" name="old-password"
								placeholder="Old Password" /> <i
								class="fa fa-eye toggle-password"
								onclick="togglePasswordVisibility('old-password')"></i>
						</div>
						<span class="error-message"><i class="fa fa-times-circle"></i>Error
							message</span>
					</div>
					<div class="input-container">
						<label>New Password</label>
						<div class="password-wrapper">
							<input id="new-password" name="new-password" type="password"
								placeholder="New Password" /> <i
								class="fa fa-eye toggle-password"
								onclick="togglePasswordVisibility('new-password')"></i>
						</div>
						<span class="error-message"><i class="fa fa-times-circle"></i>
							Error message</span>
					</div>
					<input type="hidden" name="action" value="passwordChange">
					<input type='hidden' name='id' value="<%=employee.getId()%>">
				</div>
				<button type="submit" id="change-password-btn" class="pass-save">Change
					Password</button>
			</form>
		</div>
	</div>

	<!-- Delete confirmation modal from account -->
	<div class="confirmation-overlay hide">
		<div class="confirmation-box">
			<p>Are you sure you want to delete your account?</p>
			<div class="confirmation-buttons">
				<form action="EmployeeController" method="get">
					<input type="hidden" name="id" value="<%=employee.getId()%>">
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
				<form action="EmployeeController" method="get">
					<input type="hidden" name="action" value="logout"> <input
						type="hidden" name="id" value="<%=employee.getId()%>">
					<button type="submit" id="confirm-logout-btn">Logout</button>
				</form>
				<button id="cancel-logout-btn">Cancel</button>
			</div>
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
    	if (<%=session.getAttribute("MSG") != null && session.getAttribute("MSG").equals("passwordchange")%>) {
    		alert("Password changed successfully");
    		<%
    			session.removeAttribute("MSG");
    		%>
    	}
    	else if (<%=session.getAttribute("MSGwrong") != null && session.getAttribute("MSGwrong").equals("wrongpassword")%>) {
    		alert("Wrong password. Try again!");
    		<%
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
        
        if (<%=session.getAttribute("deletionemp") != null && ((String)session.getAttribute("deletionemp")).equals("fail")%>) {
            alert("Cannot delete your account. You have ongoin orders.");
            <%
            session.setAttribute("deletionemp", "");
            %>
            window.location.href="employeeprofile.jsp";
     	 }
        if (<%=session.getAttribute("profileChangeEmp") != null && ((String)session.getAttribute("profileChangeEmp")).equals("success")%>) {
            alert("Proflie picture update successful");
            <%
            session.setAttribute("profileChangeEmp", "");
            %>
            window.location.href="employeeprofile.jsp";
      }
    </script>
	<!-- Header Javascript -->
	<script>
        let subMenu = document.getElementById("subMenu");

        function toggleMenu(){
            subMenu.classList.toggle("open-menu");
        }
    </script>
	<script src="js/slider.js"></script>

	<script src="profilejs/profile.js"></script>
	<script src="profilejs/password.js"></script>
	<script src="profilejs/logout.js"></script>
	<script src="js/footer.js"></script>
</body>
</html>