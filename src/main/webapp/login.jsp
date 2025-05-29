<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"
	import="javax.servlet.*, javax.servlet.http.*, java.io.*, additional.UserChecker"%>
<%@ page errorPage="myerrorpage.jsp"%>
<% 
    boolean userExist = false, correctPassword=true;
    boolean sessionExist = false;
    HttpSession sess = request.getSession(false);
    if (sess != null) {
        Object userExistAttr = sess.getAttribute("userExist");
        if (userExistAttr != null) {
            sessionExist = true;
            userExist = Boolean.parseBoolean(userExistAttr.toString());
        }
    }
    System.out.println("User Exists: " + userExist);
   	Object correctPasswordAttr = session.getAttribute("checkPassword");
   	if (correctPasswordAttr != null) {
   		correctPassword = Boolean.parseBoolean(correctPasswordAttr.toString());
   	}
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
    #password-strength {
        display: block;
        margin-top: 5px;
        font-size: 0.9em;
    }
    /* Modal styles */
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
        <label for="language" id="language-label">Language:</label>
        <select id="language" name="language">
            <option id="eng" value="en">English</option>
            <option id="myan" value="my">မြန်မာ</option>
        </select>
    </div>
    <div class="container">
        <div class="background-top"></div>
        <div class="register-container">
            <div class="register-box">
                <h2 id="register-your-account">LOGIN TO YOUR ACCOUNT</h2>
                <form method="post" action="CheckLoginServlet">
					<table>
						<tr>
							<td align="right"><label for="email" id="email-label">Gmail:</label></td>
							<td><input type="email" id="email" name="email" class = "profile-input"
								placeholder="something@something.com" required></td>
						</tr>
						<tr>
							<td align="right"><label for="password" id="password-label">Password:</label></td>
							<td><input type="password" id="password" name="password" class = "profile-input"
								placeholder="Must have at least 6 characters" required> <span
								id="password-strength"></span></td>
						</tr>
						<tr>
							<td colspan="2" ><input type="submit"
								value="CONTINUE" id="submitButton" class="submitButton"></td>
						</tr>
					</table>
	            </form>
                <p>
                    <span id="already-have-account">Don't have an account? </span> 
                    <a href="index.jsp" id="to-login-link">Create Account</a>
                </p>
            </div>
            <div class="background-bottom"></div>
        </div>
    </div>

    <!-- Modal for No Account Exists -->
    <div id="noAccountModal" class="modal">
        <div class="modal-content">
            <p>No account exists with this email. Create an account first?</p>
            <button class="continue-btn" onclick="window.location.href='index.jsp'">Create Account</button>
            <br>
            <button class="close-btn" onclick="tryAgain()">Try again with another email</button>
        </div>
    </div>
    <div id='wrongPasswordModal' class='modal'>
    	<div class='modal-content'>
    		<p>Incorrect Password for the given email.<p>
    		<%session.removeAttribute("checkPassword");%>
    		<button class='close-btn' onclick='document.getElementById("wrongPasswordModal").style.display="none"'>Try again</button>
    	</div>
    </div>
    
    <script>
    	function tryAgain() {
    		<%sess.removeAttribute("userExist");%>
    		window.location.href='login.jsp';
    	}
    	
        window.addEventListener('load', function () {
            function showModal(modalId) {
                document.getElementById(modalId).style.display = 'block';
            }
            function closeModal(modalId) {
                document.getElementById(modalId).style.display = 'none';
            }

            function checkUserSession() {
                const userExist = <%= userExist %>;
                const sessionExist = <%= sessionExist %>;
                if (sessionExist) {
                    if (!userExist) {
                        showModal('noAccountModal');
                    }
                }
                
                let correctPassword = <%=correctPassword%>;
                if (!correctPassword) {
                	<%session.removeAttribute("checkPassword");%>
                	showModal('wrongPasswordModal');
                }
            }

            checkUserSession();

            function convertToEng() {
                document.getElementById("register-your-account").textContent = "LOGIN TO YOUR ACCOUNT";
                document.getElementById("email-label").textContent = "Gmail :";
                document.getElementById("password-label").textContent = "Password :";
                document.getElementById("submitButton").value = "CONTINUE";
                document.getElementById("already-have-account").textContent = "Don't have an account? ";
                document.getElementById("to-login-link").textContent = "Create Account";
                document.getElementById("language-label").textContent = "Language: ";
            }
            function convertToMyanmar() {
                document.getElementById("register-your-account").textContent = "သင့်အကောင့်သို့ Loginဝင်ပါ";
                document.getElementById("email-label").textContent = "ဂျီမေးလ် :";
                document.getElementById("password-label").textContent = "စကားဝှက် :";
                document.getElementById("submitButton").value = "ဆက်လက်လုပ်ဆောင်ပါ";
                document.getElementById("already-have-account").textContent = "အကောင့်မရှိဘူးလား? ";
                document.getElementById("to-login-link").textContent = "အကောင့်ပြုလုပ်ပါ";
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
