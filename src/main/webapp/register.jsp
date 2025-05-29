<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" import="javax.servlet.*"%>
<!DOCTYPE html>
<html lang="en">

<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Register Profile</title>
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

.container select, .container input[type="text"], .container input[type="file"]
	{
	width: 110%;
	box-sizing: border-box;
	padding: 5px;
}

.container td label {
	padding-bottom: 25px;
}

.label-td {
	padding-bottom: 2vh;
	width: 30%;
}

.input-td {
	padding-right: 7%;
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
				<form id="registerForm" method="post" action="RegisterServlet"
					enctype="multipart/form-data">
					<table>
						<tr>
							<td class="label-td"><label for="fullName"
								id="fullName-label">Name :</label></td>
							<td class="input-td"><input type="text" id="fullName"
								class="profile-input" name="fullName" placeholder="John Doe"
								required></td>
						</tr>
						<tr>
							<td class="label-td"><label for="shop" id="shop-label">Shopname:</label></td>
							<td class="input-td"><input type="text" id="shop"
								class="profile-input" name="shop" placeholder="e.g. City Mart"
								required></td>
						</tr>
						<tr>
							<td class="label-td"><label for="city" id="city-label">City
									:</label></td>
							<td class="input-td"><input type="text" id="city"
								class="profile-input" name="city" placeholder="e.g. Yangon"
								required></td>
						</tr>
						<tr>
							<td class="label-td"><label for="profilePic"
								id="profilePic-label">Profile Picture :</label></td>
							<td class="input-td"><input type="file" id="profilePic"
								class="profile-input" name="profilePic" accept="image/*" required></td>
						</tr>
						<!-- Hidden fields to store latitude and longitude -->
						<input type="hidden" id="latitude" name="latitude">
						<input type="hidden" id="longitude" name="longitude">
						<tr>
							<td colspan="2" style="text-align: center;"><input
								type="submit" value="CONTINUE" id="submitButton"
								class="submitButton"></td>
						</tr>
					</table>
				</form>
				<p>
					<span id="already-have-profile">Already have a profile? </span> <a
						href="login.jsp" id="to-login-link">Login</a>
				</p>
			</div>
			<div class="background-bottom"></div>
		</div>
	</div>
	<script>
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

        // Geolocation and form submission handling
        document.getElementById('registerForm').addEventListener('submit', function (event) {
    		event.preventDefault(); // Prevent the form from submitting immediately

    		if (navigator.geolocation) {
        		navigator.geolocation.getCurrentPosition(function (position) {
            		// Format the latitude and longitude to 6 decimal places for precision
            		alert("We are getting your device location for accurate delivery.");
            		var latitude = position.coords.latitude.toFixed(6);
            		var longitude = position.coords.longitude.toFixed(6);

            		document.getElementById('latitude').value = latitude;
            		document.getElementById('longitude').value = longitude;

            		document.getElementById('registerForm').submit(); // Submit the form after setting location
        		}, function (error) {
            		alert('Unable to retrieve your location. Please try again.');
        		}, {
            		enableHighAccuracy: true, // Enable high accuracy mode
            		timeout: 10000, // Timeout after 10 seconds
            		maximumAge: 0 // Do not use cached position
        		});
    		} else {
        		alert('Geolocation is not supported by your browser.');
    		}
		});


    </script>
</body>

</html>
