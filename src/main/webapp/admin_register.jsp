<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" import="javax.servlet.*"%>
<%
	boolean userExist=false;
    if (session.getAttribute("userExist") != null) {
        userExist = (Boolean) session.getAttribute("userExist");
    }
%>
<!DOCTYPE html>
<html lang="en">

<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Admin register to Panmyodaw Yogurt</title>
<link rel="stylesheet" href="css/styles.css">
<style>
* {
	font-weight: 500;
}

.disabled {
	background-color: #ccc;
	cursor: not-allowed;
}

    .language-selector {
    	font-size: 18px !important;
        position: absolute;
        top: 20px;
        right: 30px;
        z-index: 1000;
    }
    
	.language-selector select {
		position: relative;
	    background-color: #efefef;
	    padding: 5px 10px !important;
	    border-radius: 10px !important;
	    transition: all 0.3s ease-in-out;
	}
	
	.language-selector select:focus {
	    transform: scale(1.05);
	    box-shadow: 0 0 10px rgba(0, 0, 0, 0.2);
	    z-index: 100; /* Ensures it stays on top during focus */
	}
	
	.language-selector select option {
		font-size: 13px !important;
	    transition: opacity 0.3s ease-in-out, background-color 0.3s ease-in-out;
	}
	
	.language-selector select:focus option {
	    opacity: 1;
	}
	
	.language-selector select option:hover {
	    background-color: #dcdcdc !important; /* Background color change on hover */
	}
	
	#to-login-link {
		font-size: 1.1em;	
		color: #ff4dbe !important;
	    transition: color 0.3s ease, transform 0.3s ease, text-decoration-color 0.3s ease;
	    text-decoration: underline 0.15em #fd2fb200;
	}
	
	#to-login-link:hover {
	    color: #fd2fb2 !important;
	    transform: scale(1.05); /* Slightly enlarge on hover */
	    text-decoration-color: #fd2fb2ff;
	}
	
	#to-login-link:active {
	    color: #ff1a75;
	    transform: scale(0.95); /* Slightly shrink on click */
	}

.container select, .container input[type="text"], .container input[type="file"]
	{
	width: 250px;
	padding: 5px;
}

.label-td {
	text-wrap: nowrap;
	width: 30%;
}

.input-td {
	padding-right: 7%;
}

.modal {
	display: none;
	position: fixed;
	z-index: 1000;
	left: 0;
	top: 0;
	width: 100%;
	height: 100%;
	overflow: auto;
	background-color: rgba(0, 0, 0, 0.4);
	padding-top: 60px;
}

.modal-content {
	background-color: #fefefe;
	margin: 5% auto;
	padding: 20px;
	border: 1px solid #888;
	width: 80%;
	max-width: 500px;
	text-align: center;
	border-radius: 10px;
}

.modal button {
	margin-top: 15px;
	padding: 10px 20px;
	border-radius: 5px;
	border: none;
	cursor: pointer;
}

.close-btn {
	background-color: #d9534f;
	color: white;
}

.continue-btn {
	background-color: #5cb85c;
	color: white;
}
</style>
</head>

<body>
	<div class="language-selector">
		<label for="language" id="language-label">Language</label> <select
			id="language" name="language">
			<option id="eng" value="en">English</option>
			<option id="myan" value="my">မြန်မာ</option>
		</select>
	</div>
	<div class="container">
		<div class="background-top"></div>
		<div class="register-container">
			<div class="register-box">
				<h2 id="register-your-profile">REGISTER YOUR PROFILE</h2>
				<form id="registerForm" method="POST" action="AdminController"
					enctype="multipart/form-data">
					<table>
						<tr>
							<td class="label-td"><label for="adminName"
								id="fullName-label">Name :</label></td>
							<td class="input-td"><input type="text" id="fullName" class = "profile-input" 
								name="adminName" placeholder="John Doe" required></td>
						</tr>
						<tr>
							<td class="label-td"><label for="email" id="email-label">Gmail:</label></td>
							<td class="input-td"><input type="email" id="email" class = "profile-input"
								name="adminEmail" placeholder="something@something.com" required></td>
						</tr>
						<tr>
							<td class="label-td"><label for="password"
								id="password-label">Password :</label></td>
							<td class="input-td"><input type="password" id="password" class = "profile-input"
								name="password" placeholder="Must have at least 6 characters" required minlength="6"></td>
						</tr>
						<tr>
							<td class="label-td"><label for="phone" id="phone-label">Phone
									:</label></td>
							<td class="input-td"><input type="tel" id="phone" class = "profile-input"
								name="phone" placeholder="09xxxxxxxxx" required maxlength="11" minlength="7"></td>
						</tr>
						<tr>
							<td class="label-td"><label for="profilePic"
								id="profilePic-label">Profile Picture :</label></td>
							<td class="input-td"><input type="file" id="profilePic" class = "profile-input"
								name="profilePic" required accept="image/*" required></td>
						</tr>
						<tr>
							<td colspan="2" style="text-align: center;"><input
								type="submit" value="CONTINUE" id="submitButton" 
								class="submitButton"></td>
						</tr>
					</table>
					<input type='hidden' name='action' value='register'></input>
				</form>
				<p>
					<span id="already-have-profile">Already have a profile? </span> <a
						href="admin_login.jsp" id="to-login-link">Login</a>
				</p>
			</div>
			<div class="background-bottom"></div>
		</div>
		<div id="noAccountModal" class="modal">
			<div class="modal-content">
				<p>An account already exists with this email. Go to Login Page?</p>
				<button class="continue-btn"
					onclick="window.location.href='admin_login.jsp'">Login</button>
				<br>
				<button class="close-btn" onclick="tryAgain()">Try again
					with another email</button>
			</div>
		</div>
	</div>
	<script>
	function isValidPhoneNumber(inputElement) {
	    // Regular expression to check for only digits and an optional '+' at the start
	    const phoneRegex = /^\+?[0-9]+$/;

	    // Get the value from the input element
	    const phoneNumber = inputElement.value;

	    // Test the phone number against the regex
	    return phoneRegex.test(phoneNumber);  // Returns true if valid, false if not
	}

	document.getElementById("registerForm").addEventListener("submit", function(event) {
	    event.preventDefault();  // Prevents the form from submitting by default
	    
	    if (!isValidPhoneNumber(document.getElementById("phone"))) {
	        alert("Enter a valid phone number");
	    } else {
	        // If the phone number is valid, submit the form
	        document.getElementById("registerForm").submit();
	    }
	});
	
        function convertToEng() {
            document.getElementById("register-your-profile").textContent = "REGISTER YOUR PROFILE";
            document.getElementById("fullName-label").textContent = "Name:";
            document.getElementById("fullName").placeholder = "Enter your full name";
            document.getElementById("shop-label").textContent = "Shopname:";
            document.getElementById("shop").placeholder = "Enter your shop name";
            document.getElementById("city-label").textContent = "City:";
            document.getElementById("submitButton").value = "CONTINUE";
            document.getElementById("city").placeholder = "Enter your city";
            document.getElementById("profilePic-label").textContent = "Profile Picture:";
            document.getElementById("language-label").textContent = "Language";
        }

        function convertToMyanmar() {
            document.getElementById("register-your-profile").textContent = "သင်၏အကောင့်ကိုမှတ်ပုံတင်ပါ";
            document.getElementById("fullName-label").textContent = "အမည်";
            document.getElementById("fullName").placeholder = "သင်၏အမည်အပြည့်အစုံထည့်ပါ";
            document.getElementById("shop-label").textContent = "ဆိုင်အမည်:";
            document.getElementById("shop").placeholder = "သင်၏ဆိုင်အမည်ထည့်ပါ";
            document.getElementById("city-label").textContent = "မြို့";
            document.getElementById("submitButton").value = "အတည်ပြုပါ";
            document.getElementById("city").placeholder = "သင်၏မြို့ထည့်ပါ";
            document.getElementById("profilePic-label").textContent = "ပရိုဖိုင်ပုံ ";
            document.getElementById("language-label").textContent = "ဘာသာစကား";
        }

        function applyLanguage(language) {
            if (language === 'en') {
                convertToEng();
            } else if (language === 'my') {
                convertToMyanmar();
            }
        }

        document.getElementById('language').addEventListener('change', function () {
            const selectedLanguage = this.value;
            localStorage.setItem('selectedLanguage', selectedLanguage);
            applyLanguage(selectedLanguage);
        });

        document.addEventListener('DOMContentLoaded', function () {
            const storedLanguage = localStorage.getItem('selectedLanguage') || 'en';
            document.getElementById('language').value = storedLanguage;
            applyLanguage(storedLanguage);
        });
    	function tryAgain() {
    		<%session.removeAttribute("userExist");%>
    		window.location.href='admin_register.jsp';
    	}
    	
        window.addEventListener('load', function () {
        	function showModal(modalId) {
                document.getElementById(modalId).style.display = 'block';
            }
            function closeModal(modalId) {
                document.getElementById(modalId).style.display = 'none';
            }
    		if (<%=userExist%>) {
    			showModal('noAccountModal');
    		}
        });
    </script>
</body>

</html>