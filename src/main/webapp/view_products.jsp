<%@ page language="java" contentType="text/html; charset=UTF-8"
  pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page import="dao.*, model.*, java.sql.*, java.util.*"%>
<%
//get the admin's info
int admin_id = -1;
Cookie[] cookies = request.getCookies();
if (cookies != null ){
  for (Cookie cookie: cookies) {
    if ("admin".equals(cookie.getName())) {
      admin_id = Integer.parseInt(cookie.getValue());
      break;
    }
  }
}
if (admin_id == -1) request.getRequestDispatcher("/admin_login.jsp").forward(request, response);
AdminDAO adminDAO = new AdminDAO();
Admin admin = adminDAO.get(admin_id);

EnterpriseDAO enterprise = new EnterpriseDAO();
double last30dayincome = enterprise.get30DayIncome();
double last30dayprofit = enterprise.get30DayProfit();
double totalDebt = enterprise.getDebts();
double customerCount = enterprise.getCustomerCount();
ResultSet revenue = enterprise.getPastSixMonthRevenue();
int i = 0;
String[][] sales = new String[7][2];
while (revenue.next()) {
    String[] sale = {revenue.getString("sale_month"), revenue.getString("total_sales")};
    sales[i] = sale;
    i++;
}
while (i < 7) {
    String[] sale = {"", "0"};
    sales[i] = sale;
    i++;
}
for(String[]sale: sales) {
  for(String s: sale) {
    System.out.print(s + ":\t");
  }
  System.out.println();
}
String[][] pieChartData = enterprise.getPieChartData();

EmployeeDAO employeeDAO = new EmployeeDAO();
List<Employee> emps = employeeDAO.getUnverified();
int notiCount = 0;
for(Employee ee: emps) {
  notiCount++;
}
List<Admin> adms = adminDAO.getUnverified();
for(Admin aa: adms) {
  notiCount++;
}

%>
<%
ProductDAO productDAO = new ProductDAO();
List<Product> productlist = productDAO.get();
request.setAttribute("productlist", productDAO.get());
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Shop Products</title>
<link rel="stylesheet" href="css/header.css">
<link rel="stylesheet" href="css/footer.css">
<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css" rel="stylesheet">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
<link href="https://fonts.googleapis.com/css2?family=Poppins:ital,wght@0,100;0,200;0,300;0,400;0,500;0,600;0,700;0,800;0,900;1,100;1,200;1,300;1,400;1,500;1,600;1,700;1,800;1,900&display=swap" rel="stylesheet">
<link href="css/order.css" rel='stylesheet'>
<style>

header .navbar ul li a sup {
    font-size: 12px; /* Adjust font size */
    font-weight: bolder !important;
    color: black; 
}

.shop-content {
    padding-bottom: 150px; /* Ensure enough padding at the bottom */
    min-height: calc(100vh - 200px); /* Adjust according to your header height */
}

.product-details {
    display: flex;
    justify-content: space-between;
    align-items: center;
    width: 100%;
}

.product-actions {
  font-size: 1.1em;
    display: flex;
    justify-content: flex-end;
    gap: 4px;
    margin-top: -8px;
}

.edit-icon, .delete-icon {
  color: var(--bg-color);
  padding: 6px 9px 3px 9px;
  cursor: pointer;
  border: 0;
  margin-top: 1px;
  transition: transform 0.3s ease, background-color 0.3s ease;
}

.edit-icon {
  background: var(--text-color);
}

.edit-icon:hover {
  background: var(--text-color-hover);
  transform: scale(1.1);
}

.delete-icon {
  background: var(--main-color);
}

.delete-icon:hover {
  background: var(--main-color-hover);
  transform: scale(1.1);
}

#add-product {
    position: fixed;
    top: 50%;
    left: 50%;
    transform: translate(-50%, -50%);
    z-index: 1000;
    display: none; /* Initially hidden */
    animation: fadeIn 0.3s ease-in-out; /* Add animation for showing */
    max-width: 350px; /* Reduced width to match the form */
    width: 90%; /* Ensure it scales with the viewport */
}
#add-product.fadeOut {
    animation: fadeOut 0.3s ease-in-out forwards;
    display: none; /* Hide after animation completes */
}

#delete-confirmation {
  display: none;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  position: fixed;
  top: 50%;
  left: 50%;
  transform: translate(-50%, -50%);
  background-color: #f8f9fa;
  padding: 40px;
  border-radius: 10px;
  box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
  z-index: 1001;
  text-align: center;
  opacity: 0;
  animation: fadeIn 0.3s ease-in-out;
  transition: opacity 0.3s ease, transform 0.3s ease;
}

#delete-confirmation.show {
    display: block;
    opacity: 1;
    transform: translate(-50%, -50%) scale(1);
}

#delete-confirmation.hide {
    opacity: 0;
    transform: translate(-50%, -50%) scale(0.8);
    transition: opacity 0.3s ease, transform 0.3s ease;
}

#delete-confirmation p {
  margin-bottom: 20px;
  font-size: 1.1em;
  color: var(--text-color);
}

#delete-confirmation button {
  border-radius: 5px;
  margin-right: 10px;
  padding: 8px 15px;
  cursor: pointer;
  font-size: 16px;
  transition: background-color 0.3s ease, transform 0.3s ease;
  border: none;
  color: var(--bg-color);
}

#delete-confirmation button:hover {
  transform: scale(1.05);
}

#delete-confirmation button:last-child {
  margin-right: 0;
  background-color: var(--main-color);
}

#delete-confirmation button:last-child:hover {
  background-color: var(--main-color-hover);
}  

.add-product-box {
    display: flex;
    flex-direction: column; /* Stack the icon and button vertically */
    align-items: center;
    justify-content: flex-end;
    width: 100%; /* Adjust width as necessary */
    height: 100%;
    min-height: 300px;
    border: 2px dashed var(--main-color); /* Optional: add dashed border to indicate it's a button */
    border-radius: 5px;
    cursor: pointer;
}

.add-product-box i {
    font-size: 3.5em; /* Size of the plus icon */
    color: var(--main-color);
    margin-bottom: 100px; /* Space between the icon and button */
    transition: color 0.3s ease;
}

#add-product-button {
    margin: 0; /* Ensure no margin to center in box */
    width: 100%;
    padding: 16px 20px;
    background-color: var(--main-color);
    color: var(--bg-color);
    border: none;
    border-radius: 5px;
    box-shadow: 0 2px 5px rgba(0, 0, 0, 0.2);
    font-size: 1.3em;
    transition: background-color 0.3s ease;
}
  
.add-product-box:hover #add-product-button {
  background-color: var(--text-color-hover);
}

.add-product-box:hover i {
  color: var(--text-color-hover);
}

#delete-confirmation .confirmation-box {
    text-align: center;
}

#delete-confirmation button {
    display: inline-block;
    margin-right: 10px;
}

#delete-confirmation button:last-child {
    margin-right: 0;
}

.btn-delete, .btn-delete-cancel {
    font-size: 0.9rem; /* Decrease button font size */
    padding: 8px 12px; /* Adjust padding */
    border: none !important;
  transition: background-color 0.3s ease, transform 0.2s ease !important;
  box-shadow: rgba(0, 0, 0, 0.1) !important;
}

.btn-delete {
  margin-right: 15px;
    background-color: var(--main-color) !important;
    color: white !important;
}

.btn-delete:hover {
  background-color: var(--main-color-hover) !important;
  transform: scale(1.05) !important;
}

.btn-delete-cancel {
  color: var(--text-color) !important;
    background-color: #e0e0e0 !important;
}

.btn-delete-cancel:hover {
  background-color: #c9c9c9 !important;
  transform: scale(1.05) !important;
}

.btn-delete:active, .btn-delete-cancel:active{
    transform: scale(0.95) !important;
}

/* Animation for the pop-up */
@keyframes fadeIn {
    from { opacity: 0; transform: translate(-50%, -60%); }
    to { opacity: 1; transform: translate(-50%, -50%); }
}

@keyframes fadeOut {
    from { opacity: 1; transform: translate(-50%, -50%); }
    to { opacity: 0; transform: translate(-50%, -60%); }
}

a {
  text-decoration: none !important;
}

header .navbar {
	padding: 0 !important;
}

</style>
</head>
<body >
   <header>
        <a href ="#" class = "logo">Panmyodaw</a>

        <input type="checkbox" id = "menu-bar" class = "hidden-desktop">
        <label for="menu-bar" class= "initial">Menu</label>
        <nav class = "navbar">
            <ul>
                <li><a href="dashboard.jsp">dashboard</a></li>
                <li><a href="view_orders.jsp">orders</a></li>
                <li><a href="view_products.jsp">products</a></li>
                <li><a href="approval_noti.jsp"><i class="fa-solid fa-bell"></i><sup><%=notiCount%></sup></a></li>
                <li  class = "hidden-desktop initial"><a href = "#">user +</a>
                    <ul>
                        <li><a href = "view_profile.jsp">account</a></li>
                        <li><a href = "customerList.jsp">customers</a></li>
                        <li><a href = "adminList.jsp">admins</a></li>
                        <li><a href = "employeeList.jsp">employees</a></li>
                    </ul>
                </li>
                <li class = "hidden-desktop initial"><a href = "order.jsp">order</a></li>
                <div class = "profile-container hidden-mobile-avg">
                    <img src = '<%=request.getContextPath() + "/userProfile/" + admin.getProfile_pic()%>' class = "user-pic hide" onclick="toggleMenu()">
                </div>
                <div class="sub-menu-wrap" id = "subMenu">
                    <div class="sub-menu">
                        <div class="user-info">
                           <img src = '<%=request.getContextPath() + "/userProfile/" + admin.getProfile_pic()%>'  style="height: 65px !important; width: 65px !important;">
                           <h3><%=admin.getName() %></h3>
                        </div>
                        <hr style="background-color: #1f2c2c !important;">
            <a href="view_profile.jsp" class="sub-menu-link"> 
              <i class="fa-solid fa-user"></i>
              <p>account</p> <span>></span>
            </a> 
            <a href="adminList.jsp" class="sub-menu-link">
              <i class="fa-solid fa-user-plus"></i>
              <p>admins</p> <span>></span>
            </a> 
            <a href="customerList.jsp" class="sub-menu-link"> 
              <i class="fa-regular fa-address-card"></i>
              <p>customers</p> <span>></span>
            </a> 
            <a href="employeeList.jsp" class="sub-menu-link">
              <i class="fa-solid fa-id-card-clip"></i>
              <p>employees</p> <span>></span>
            </a>
                    </div>
                </div>
            </ul>
        </nav>
    </header>
  
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
  <section class="shop container">
    <h2 class="section-title">Shop Products</h2>
    <div class="shop-content">
      <c:forEach items="${productlist}" var="product">
      <c:set var="p" value="${product}"/>
        <div class="product-box">
        <span style="color: orange;">
          <%
            for (int s=0; s<stars.get(j); s++) {
            %>
            <i class='bi bi-star-fill'></i>
            <%
            }
            for (int s=stars.get(j); s<5; s++) {
            %>
            <i class='bi bi-star'></i>
            <%
            }
            j++;
            %>
        </span>
          
          
          <img
            src="http://localhost:8080/JavaServerPagesFirst/userProfile/${product.profile_pic}"
            alt="${product.name}" class="product-img"
            style="background-image: radial-gradient(circle, ${product.getTheme_color()} 10%, white 70%);">
          <h2 class="product-title">${product.getName()}</h2>
          <div class = "product-details">
            <span class="price">${product.getPrice()}</span>
            <div class="product-actions">
              <button class="edit-icon" onclick="showAddProduct(${product.id})">
                <i class="bi bi-pencil-square"></i>
              </button>
              <button class="delete-icon"
                onclick="confirmDelete('${product.getId()}')">
                <i class="bi bi-trash"></i>
              </button>
            </div>
          </div>
        </div>
      </c:forEach>
      
      <div class = "product-box add-product-box" onclick="showAddProductAdd()">
        <i class="fa-solid fa-circle-plus"></i>
        <button value="Add Product" id="add-product-button"
          onclick="showAddProductAdd()">Add Product</button>
      </div>
    </div>
  </section>

  <div id="add-product" style="display: none;">
    <%@ include file="additionalhtml/add_product.jsp"%>
  </div>

  <!-- Delete Confirmation Box -->
    <div id="delete-confirmation" style="display: none;">
        <div class="confirmation-box">
            <p>Are you sure you want to delete this product?</p>
            <button type="button" class="btn btn-delete" onclick="deleteProduct()">Delete</button>
            <button type="button" class="btn btn-delete-cancel" onclick="hideDeleteConfirmation()">Cancel</button>
        </div>
    </div>
    
    <!-- Footer Section  -->
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
  <script>
    
  
    function hideAddProduct() {
        const addProductBox = document.getElementById('add-product');
        addProductBox.classList.add('fadeOut');
        setTimeout(() => {
            addProductBox.style.display = 'none';
            addProductBox.classList.remove('fadeOut');
        }, 300); // Match the duration of the fadeOut animation
    }
    let p = null;
    
    function sendAjaxRequest(id) {
        // Create a new XMLHttpRequest object
        var xhr = new XMLHttpRequest();

        // Define the URL with the id and action parameters
        var url = "ProductController?action=edit&id=" + encodeURIComponent(id);

        // Set up the request as a GET request
        xhr.open("GET", url, true);
        
        // Set a callback to handle the response
        xhr.onreadystatechange = function () {
            if (xhr.readyState === 4 && xhr.status === 200) {
                // Assuming the server returns JSON data with product details
                var product = JSON.parse(xhr.responseText);
                

                // Add other fields as necessary

                // Show the form
                const addProductBox = document.getElementById('add-product');
                addProductBox.style.display = 'block';
                addProductBox.classList.remove('fadeOut');
                
                // Populate the form fields with the data
                document.getElementById('productName').value = product.name;
                document.getElementById('productDiscount').value = product.discount;
                document.getElementById('productPrice').value = product.price;
                document.getElementById('productProfit').value = product.profit;
                document.getElementById('productDescription').value = product.product_description;
          document.getElementById('updateaction').value = product.id;
          document.getElementById('add-product-button-id').textContent = "Update";
            }
        };

        // Send the request
        xhr.send();
    }
    function showAddProduct(pid) {
        // Call the AJAX function to get the product details and show the form
        sendAjaxRequest(pid);
    }
    
    function showAddProductAdd() {
            const addProductBox = document.getElementById('add-product');
            addProductBox.style.display = 'block';
            addProductBox.classList.remove('fadeOut');
    }


    let currentProduct = null;
    
      function showDeleteConfirmation() {
          const deleteConfirmation = document.getElementById("delete-confirmation");
          deleteConfirmation.classList.add("show");
      }
      
    // Function to hide the Delete Confirmation box
        function hideDeleteConfirmation() {
            document.getElementById("delete-confirmation").style.display = "none";
        }

        // Function to confirm delete
    function confirmDelete(productId) {
        currentProduct = productId;
        const deleteConfirmation = document.getElementById("delete-confirmation");
        deleteConfirmation.classList.add('show'); // Add the 'show' class
        deleteConfirmation.style.display = "flex"; // Ensure the box is displayed as flex
    }
        
    function hideDeleteConfirmation() {
        const deleteConfirmation = document.getElementById("delete-confirmation");
        deleteConfirmation.classList.remove('show'); // Remove the 'show' class
        deleteConfirmation.classList.add('hide'); // Add the 'hide' class to trigger the fade-out animation

        // Wait for the animation to complete before setting display to none
        setTimeout(() => {
            deleteConfirmation.style.display = "none";
            deleteConfirmation.classList.remove('hide'); // Remove the 'hide' class after hiding
        }, 300); // The delay matches the animation duration
    }
    
    function deleteProduct() {
        window.location.href='<%=request.getContextPath()%>/ProductController?id=' + currentProduct + '&action=delete';
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
  <script src="js/main.js"></script>
  <script src="js/footer.js"></script>
</body>
</html>