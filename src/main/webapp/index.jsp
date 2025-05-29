<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"
	import="javax.servlet.*, javax.servlet.http.*, java.io.*, additional.UserChecker"%>
<%@ page errorPage="myerrorpage.jsp"%>
<% 
    boolean userExist = false;
    HttpSession sess = request.getSession(false);
    if (sess != null) {
        Object userExistAttr = sess.getAttribute("userExist");
        if (userExistAttr != null) {
            userExist = Boolean.parseBoolean(userExistAttr.toString());
        }
    }
    System.out.println("User Exists: " + userExist);
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Register Account to Pan Myo Daw Yoghurt</title>
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
	background-color: #dcdcdc !important;
	/* Background color change on hover */
}

#to-login-link {
	font-size: 1.1em;
	color: #ff4dbe !important;
	transition: color 0.3s ease, transform 0.3s ease, text-decoration-color
		0.3s ease;
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

#password-strength {
	display: block;
	margin-top: 5px;
	font-size: 0.9em;
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
		<label for="language" id="language-label">Language: </label> <select
			id="language" name="language">
			<option id="eng" value="en">English</option>
			<option id="myan" value="my">မြန်မာ</option>
		</select>
	</div>
	<div class="container">
		<div class="background-top"></div>
		<div class="register-container">
			<div class="register-box">
				<h2 id="register-your-account">REGISTER YOUR ACCOUNT</h2>
				<form id="form" method="post" action="FirstRegisterServlet">
					<table>
						<tr>
							<td align="right"><label for="email" id="email-label">Gmail
									:</label></td>
							<td><input type="email" id="email" name="email"
								class="profile-input" placeholder="something@something.com"
								required></td>
						</tr>
						<tr>
							<td align="right"><label for="phone-no" id="phone-label">Phone
									No :</label></td>
							<td><input type="tel" id="phone-no" name="phone-no"
								class="profile-input" placeholder="09 xxx xxx xxx"
								maxlength="11" minlength="7" required></td>
						</tr>
						<tr>
							<td align="right"><label for="password" id="password-label">Password
									:</label></td>
							<td><input type="password" id="password" name="password"
								class="profile-input" placeholder="Must have at least 6 characters" required
								minlength="6"> <span id="password-strength"></span></td>
						</tr>
						<tr>
							<td colspan="2" style="text-align: center;"><input
								type="submit" value="CONTINUE" id="submitButton"
								class="submitButton"></td>
						</tr>
					</table>
				</form>
				<p>
					<span id="already-have-account">Already have an account? </span> <a
						href="login.jsp" id="to-login-link">Login</a>
				</p>
			</div>
			<div class="background-bottom"></div>
		</div>
		<div id="noAccountModal" class="modal">
			<div class="modal-content">
				<p>An account already exists with this email. Go to Login Page?</p>
				<button class="continue-btn"
					onclick="window.location.href='login.jsp'">Login</button>
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

	document.getElementById("form").addEventListener("submit", function(event) {
	    event.preventDefault();  // Prevents the form from submitting by default
	    
	    if (!isValidPhoneNumber(document.getElementById("phone-no"))) {
	        alert("Enter a valid phone number");
	    } else {
	        // If the phone number is valid, submit the form
	        document.getElementById("form").submit();
	    }
	});

	
	function tryAgain() {
		<%sess.removeAttribute("userExist");%>
		window.location.href='index.jsp';
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
        function convertToEng() {
            document.getElementById("register-your-account").textContent = "REGISTER YOUR ACCOUNT";
            document.getElementById("email-label").textContent = "Gmail :";
            document.getElementById("password-label").textContent = "Password :";
            document.getElementById("submitButton").value = "CONTINUE";
            document.getElementById("already-have-account").textContent = "Already have an account? ";
            document.getElementById("to-login-link").textContent = "Login";
            document.getElementById("language-label").textContent = "Language: ";
        }
        function convertToMyanmar() {
            document.getElementById("register-your-account").textContent = "သင်၏အကောင့်ကိုမှတ်ပုံတင်ပါ";
            document.getElementById("email-label").textContent = "ဂျီမေးလ် :";
            document.getElementById("password-label").textContent = "စကားဝှက် :";
            document.getElementById("submitButton").value = "ဆက်လက်လုပ်ဆောင်ပါ";
            document.getElementById("already-have-account").textContent = "အကောင့်ရှိပြီးသားလား? ";
            document.getElementById("to-login-link").textContent = "လော့ဂ်အင်";
            document.getElementById("language-label").textContent = "ဘာသာစကား";
        }
        function applyLanguage(language) {
            if (language === 'en') {
                convertToEng();
            } else if (language === 'my') {
                convertToMyanmar();
            }
        }
        const storedLanguage = localStorage.getItem('selectedLanguage') || 'en';
        document.getElementById('language').value = storedLanguage;
        applyLanguage(storedLanguage);
        document.getElementById('language').addEventListener('change', function () {
            const selectedLanguage = this.value;
            localStorage.setItem('selectedLanguage', selectedLanguage);
            applyLanguage(selectedLanguage);
        });
    });
</script>

</body>
</html>
