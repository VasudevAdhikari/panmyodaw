<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page import="dao.*, model.*, java.util.*" %>
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
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css" rel="stylesheet">
    <link href="css/order.css" rel='stylesheet'>
<style>
.product-actions {
	margin-top: 10px;
}

.edit-icon, .delete-icon {
	cursor: pointer;
	background-color: transparent;
	border: none;
	font-size: 1.2em;
	transition: font-size 0.3s ease;
	margin-right: 5px;
}

.edit-icon .delete-icon:hover {
	font-size: 3em;
}

#delete-confirmation {
    display: flex;
    flex-direction: column; /* Stack elements vertically */
    align-items: center; /* Center align items horizontally */
    justify-content: center; /* Center align items vertically */
    position: fixed;
    top: 50%;
    left: 50%;
    transform: translate(-50%, -50%);
    background-color: ivory;
    padding: 50px;
    border-radius: 3vh;
    box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
    z-index: 1001;
    text-align: center; /* Center the text */
}

#delete-confirmation p {
    margin-bottom: 20px;
}

#delete-confirmation button {
	border-radius: 3vh;
    margin-right: 10px;
    padding: 5px 10px;
    cursor: pointer;
    font-size: 16px;
	trainsition: font-size 1s ease;
}

#delete-confirmation button:hover {
	font-size: 18px;
    padding: 5px 10px;
}

/* Ensure last button has no margin-right */
#delete-confirmation button:last-child {
    margin-right: 0;
}

</style>
</head>
<body> 
    <section class="shop container">
        <h2 class="section-title">Shop Products</h2>

        <!-- Content -->
        
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
	<div class="shop-content">
    	<c:forEach items="${productlist}" var="product">
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
            	<img src="http://localhost:8080/JavaServerPagesFirst/userProfile/${product.profile_pic}" 
                 	alt="${product.name}" 
                 	class="product-img" 
                 	style="background-image: radial-gradient(circle, ${product.getTheme_color()} 10%, white 70%);">
            	<h2 class="product-title">${product.getName()}</h2>
            	<span class="price">${product.getPrice()}</span>
              	</div>
    	</c:forEach>
	</div>
    </section>
    
    <div id="add-product" style="display: none;">
        <%@ include file="additionalhtml/add_product.jsp" %>
    </div>
    
    <div id="delete-confirmation" style="display: none;">
    	<p>Are you sure you want to delete this product?</p>
    	<button>Confirm</button>
    	<button onclick="hideDeleteConfirmation()">Cancel</button>
	</div>


	<script>
	function showAddProduct() {
	    const addProductElement = document.getElementById("add-product");
	    addProductElement.style.display = "block";
	    document.getElementById("delete-confirmation").style.display = "none"; // Hide delete confirmation if visible
	}

	let currentProduct = null;

	function confirmDelete(productId) {
	    currentProduct = productId;
	    const deleteConfirmation = document.getElementById("delete-confirmation");
	    deleteConfirmation.style.display = "block";
	}

	function deleteProduct() {
	    if (currentProduct) {
	        // Make an AJAX request to delete the product
	        fetch(`/ProductController?action=delete&id=${currentProduct}`, {
	            method: 'POST'
	        })
	        .then(response => {
	            if (response.ok) {
	                window.location.href = 'shop.jsp'; // Redirect to the shop page after deletion
	            } else {
	                alert('Failed to delete the product.');
	            }
	        })
	        .catch(error => {
	            console.error('Error:', error);
	            alert('Failed to delete the product.');
	        });
	    }
	}

	function hideDeleteConfirmation() {
	    document.getElementById("delete-confirmation").style.display = "none";
	}

	document.getElementById("delete-confirmation").querySelector("button:first-child").addEventListener("click", deleteProduct);



		function hide() {
			document.getElementById('add-product').style.display = "none"; // Hide the card
		}
	</script>
</body>
</html>
