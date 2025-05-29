<%@ page language="java" contentType="text/html; charset=UTF-8"
  pageEncoding="UTF-8"%>
<%@ page import="javax.servlet.http.Cookie"%>
<%@ page import="dao.CustomerDAO"%>
<%@ page import="model.Customer"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Home page</title>
    <link rel="stylesheet" href="css/header.css">
    <link rel="stylesheet" href="css/slider.css">
     <link rel="stylesheet" href="css/checklogin.css">
    <link rel="stylesheet" href="css/catalog.css">
    <link rel="stylesheet" href="css/aboutUs.css">
    <link rel="stylesheet" href="css/footer.css">

    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Taviraj:wght@200;300;400;500;600;700&display=swap" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@100;200;300;400;500;600;700;800;900&display=swap" rel="stylesheet">
</head>
<style>
  .image-container {
      background-image: url('images/milk-background.png'); 
      background-size: cover; 
      background-position: calc(50% + 50px) center;
      display: flex; 
      justify-content: center; 
      align-items: center; 
      height: 100%; 
      padding: 25px; 
      filter: brightness(1.1);
  }
  
  .image-container img {
      max-width: 100%;
      height: auto;
  }
</style>
<body>    
    <div id="blur-wrapper">
    <!-- Your home page content -->
    <div id="homepage-content">
        <!-- Include your home page content here -->
       <!-- First Page (Slider) -->
       <!-- Header -->
      <header>
          <a href ="#" class = "logo">Panmyodaw</a>
  
          <input type="checkbox" id = "menu-bar" class = "hidden-desktop">
          <label for="menu-bar" class= "initial">Menu</label>
          <nav class = "navbar">
              <ul>
                  <li><a href="#home">home</a></li>
                  <li><a href="#aboutUs">about</a></li>
                  <li><a href="#footer">contact</a></li>
                  <li>
                    <a href="#home" id = "no-active">Login</a>
                    <ul class="dropdown">
                      <li><a href="login.jsp">Customer Login</a></li>
                      <li><a href="emp_login.jsp">Employee Login</a></li>
                      <li><a href="admin_login.jsp">Admin Login</a></li>
                    </ul>
                  </li>
                    <li>
                    <a href="#home" id = "no-active">Register</a>
                    <ul class="dropdown">
                      <li><a href="index.jsp">Customer Register</a></li>
                      <li><a href="emp_register.jsp">Employee Register</a></li>
                      <li><a href="admin_register.jsp">Admin Register</a></li>
                    </ul>
                  </li>
                  
              </ul>
          </nav>
      </header>
      
    <div class="slider-wrapper flex" id = "home" style="margin-top: 10px; background: linear-gradient(to bottom, #ff63cd, #ffcaf0, #fff 70%, #fff 100%) !important;
 padding: 0 50px;">
        <!-- Slide 1 -->
        <div class="slide flex" style="padding: 0 !important; margin: 0 !important; justify-content: space-between;">
            <div class="image-container" style="margin-right: 20px;">
                <img style="transform: rotate(0deg) !important; height: 30em; padding: 0 25px;" src="images/frontpage_img.png">
            </div>
            <div class="slide-content" style="max-width: 60%;">
                <div class="slide-title pink-text">Panmyodaw Yogurt</div>
                <div class="slide-text">Experience Pyin Oo Lwin's finest yogurt—locally crafted for great taste and essential nutrition. Made with fresh ingredients, every spoonful offers a perfect blend of flavor and health. Enjoy a wholesome treat that delights your taste buds.</div>
                </div>
        </div>
    </div>
    <!-- Catalog Page -->
    <div class = "catalog-page">  
      <h1 class="catalog-title">Featured Yogurt Flavors</h1>
        <div class="gallery">
            <div class = "content">
                <img src = "images/slider/strawberry.png">
                <h3>Strawberry Yogurt</h3>
                <p>"Sun-kissed sweetness"</p>
                <h6>40000.0 ks per dozen</h6>
                <ul>
                    <li><i class = "fa fa-star checked"></i></li>
                    <li><i class = "fa fa-star checked"></i></li>
                    <li><i class = "fa fa-star checked"></i></li>
                    <li><i class = "fa fa-star checked"></i></li>
                    <li><i class = "fa fa-star checked"></i></li>
                </ul>
                <a href=''><button class = "buy-1" id = " " onclick="alert('To place an order, you need to register or login first.');">Buy Now</button></a>
            </div>
            <div class = "content">
                <img src = "images/slider/peach.png">
                <h3>Peach Yogurt</h3>
                <p>"Orchard-fresh delight."</p>
                <h6>42000.0 ks per dozen</h6>
                <ul>
                    <li><i class = "fa fa-star checked"></i></li>
                    <li><i class = "fa fa-star checked"></i></li>
                    <li><i class = "fa fa-star checked"></i></li>
                    <li><i class = "fa fa-star checked"></i></li>
                    <li><i class = "fa fa-star checked"></i></li>
                </ul>
                <button class = "buy-2" id=" " onclick="alert('To place an order, you need to register or login first.');">Buy Now</button>
            </div>

            <div class = "content">
                <img src = "images/slider/banana.png">
                <h3>Banana Yogurt</h3>
                <p>"Homemade comfort."</p>
                <h6>40000.0 ks per dozen</h6>
                <ul>
                    <li><i class = "fa fa-star checked"></i></li>
                    <li><i class = "fa fa-star checked"></i></li>
                    <li><i class = "fa fa-star checked"></i></li>
                    <li><i class = "fa fa-star checked"></i></li>
                    <li><i class = "fa fa-star checked"></i></li>
                </ul>
                <button class = "buy-3" onclick="alert('To place an order, you need to register or login first.');" id = " ">Buy Now</button>
            </div>

            <div class = "content">
                <img src = "images/slider/chocolate.png">
                <h3>Chocolate Yogurt</h3>
                <p>"Decadent satisfaction."</p>
                <h6>38000.0 ks per dozen</h6>
                <ul>
                    <li><i class = "fa fa-star checked"></i></li>
                    <li><i class = "fa fa-star checked"></i></li>
                    <li><i class = "fa fa-star checked"></i></li>
                    <li><i class = "fa fa-star checked"></i></li>
                    <li><i class = "fa fa-star checked"></i></li>
                </ul>
                <button class = "buy-4" id = " " onclick="alert('To place an order, you need to register or login first.');">Buy Now</button>
            </div>
        </div>
    </div>
    <!-- About Us -->
    <div class = "wrapper" id = "aboutUs">
        <div class="title">
            <h1>About Us</h1>
        </div>
        <div class="about" id='about'>
            <div class="image-section">
                <img src = "images/slider/yogurt-fruit-salad.png">
            </div>
            <article>
                <h3>Nestled in the scenic town of Pyin Oo Lwin, our yogurt company is dedicated to delivering the finest, most nutritious yogurt to your table.
                    <p>
                      Crafted from the freshest local ingredients, our yogurt is not only delicious but also packed with essential micronutrients, making it a perfect addition to your daily diet. Whether you're looking for a wholesome snack or a healthy treat, our yogurt offers a delightful blend of taste and wellness that you can feel good about. Experience the richness of Pyin Oo Lwin in every spoonful, where quality and health come first.
                </h3>
                    </p>
                    <div class="button">
                        <a href = "">Learn More</a>
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
                    <li><a href="#" class = "cancel-animation"><i class="fa-brands fa-telegram"></i></a></li>
                </ul>
            </div>
        </div>
        <div class="bottom-bar">
            <p>&copy; Kode Samurai. All rights reserved.</p>
        </div>
    </footer>
       
    </div>
    
              <!-- Modal for account creation -->
   <div id="account-modal" class="modal">
        <div class="modal-content">
            <span id="close-modal" class="close-button">&times;</span>
            <h2>Create an Account</h2>
            <p>To proceed with your purchase, please create an account or log in.</p>
            <button id="login-btn">Log In</button>
            <button id="stay-logout-btn">Stay Logged Out</button>
        </div>
    </div>

</div>


    
    <!-- Header Javascript -->
    <script>
        let subMenu = document.getElementById("subMenu");

        function toggleMenu(){
            subMenu.classList.toggle("open-menu");
        }
        // Active state for header
    document.addEventListener('DOMContentLoaded', () => {
        let sections = document.querySelectorAll('div[id], .wrapper, footer');
        let navLinks = document.querySelectorAll('.navbar ul li a');
        let footer = document.querySelector('footer');
    
        function setActive() {
            let current = '';
            const footerOffsetThreshold = window.innerHeight * 0.3; // 80% of the viewport height
    
            sections.forEach(section => {
                const sectionTop = section.offsetTop - 80;
    
                if (scrollY >= sectionTop && scrollY < sectionTop + section.offsetHeight) {
                    current = section.getAttribute('id');
                }
            });
    
            // Special handling for the footer
            const footerTop = footer.offsetTop;
            const footerHeight = footer.offsetHeight;
            const viewportBottom = scrollY + window.innerHeight;
    
            if (viewportBottom >= footerTop + footerHeight - footerOffsetThreshold) {
                current = 'footer';
            }
    
            navLinks.forEach(link => {
                link.classList.remove('active');
    
                if (link.getAttribute('href').includes(current) && !link.closest('.dropdown')) {
                    link.classList.add('active');
                }
            });
        }
    
        setActive();
        window.addEventListener('scroll', setActive);
    
        // Click event to manage active state
        navLinks.forEach(link => {
            link.addEventListener('click', function(e) {
                const href = this.getAttribute('href');
    
                // Scroll to the target section smoothly
                if (href.startsWith("#")) {
                    e.preventDefault();
                    const targetElement = document.querySelector(href);
                    const offset = document.querySelector('header').offsetHeight;
                    const targetPosition = targetElement.getBoundingClientRect().top + window.pageYOffset - offset;
    
                    window.scrollTo({
                        top: targetPosition,
                        behavior: 'smooth'
                    });
    
                    // Prevent login and register buttons from retaining active state
                    if (!this.closest('li').querySelector('.dropdown')) {
                        navLinks.forEach(l => l.classList.remove('active'));
                        this.classList.add('active');
                    }
                }
            });
        });
    });
    </script>

    <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
    <script src="js/slider.js"></script>
    <script src="js/footer.js"></script>
</body>
</html>