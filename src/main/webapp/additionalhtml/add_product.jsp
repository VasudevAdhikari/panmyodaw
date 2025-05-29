<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add New Product</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
    	:root {
    	    --a-pink: #ff4dbe;
    		--b-pink: #fd2fb2;
    	}
        .card {
            max-width: 350px; /* Reduce width for smaller screen */
            margin: 30px auto; /* Reduce margin */
            border-radius: 10px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            overflow: hidden;
        }

        .card-header {
            font-size: 1.2rem; /* Decrease font size */
            padding: 10px; /* Reduce padding */
    		background: linear-gradient(45deg, #ff4dbe, #ff8ce6);
            color: white;
        }

        .card-body {
            padding: 15px; /* Reduce padding */
        }

        .profile-pic {
            margin-bottom: 15px; /* Adjust margin */
        }

        .profile-pic img {
            width: 80px; /* Decrease image size */
            height: 80px; /* Decrease image size */
            border-radius: 50%;
            cursor: pointer;
            object-fit: cover;
        }

        .form-label {
            font-size: 1rem; /* Adjust font size */
            font-weight: bold;
            color: #333;
        }

        .form-control {
            border: 2px solid #ddd;
            border-radius: 5px;
            padding: 8px; /* Adjust padding */
            font-size: 0.9rem; /* Adjust font size */
            transition: border-color 0.3s;
        }

        .form-control:focus {
            border-color: #007bff;
        }

        .btn-confirm, .btn-cancel {
            font-size: 0.9rem; /* Decrease button font size */
            padding: 8px 12px; /* Adjust padding */
            border: none !important;
    		transition: background-color 0.3s ease, transform 0.2s ease !important;
			box-shadow: rgba(0, 0, 0, 0.1) !important;
        }
        
        .btn-confirm {
        	margin-right: 15px;
		    background-color: var(--a-pink) !important;
		    color: white !important;
		}
		
		.btn-confirm:hover {
			background-color: var(--b-pink) !important;
			transform: scale(1.05) !important;
		}
		
        .btn-cancel {
		    background-color: #e0e0e0 !important;
		}
		
		.btn-cancel:hover {
			background-color: #c9c9c9 !important;
			transform: scale(1.05) !important;
		}
		
		.btn-confirm:active, .btn-cancel:active{
		    transform: scale(0.95) !important;
		}

        .form-row {
            display: flex;
            justify-content: space-between;
        }

        .form-row .col {
            flex: 0 0 48%;
        }

        @keyframes fadeIn {
            from { opacity: 0; transform: translate(-50%, -60%); }
            to { opacity: 1; transform: translate(-50%, -50%); }
        }
    </style>
</head>
<body>
    <div class="card">
        <div class="card-header text-center">
            Add New Product
        </div>
        <div class="card-body">
            <form id="productForm" method="post" action="ProductController" enctype="multipart/form-data">
                <div class="profile-pic text-center">
                    <label for="productImage">
                        <img src="https://via.placeholder.com/80" id="profileImage" alt="Product Image">
                        <br><span>Product Pic</span>
                    </label>
                    <input type="file" class="d-none" id="productImage" name="profile_pic" accept="image/*" required>
                </div>
                
                <div class="mb-3">
                    <input type="text" name="name" class="form-control" id="productName" required>
                    <label for="productName" class="form-label">Product Name</label>
                </div>

                <div class="form-row mb-3">
                    <div class="col">
                        <input type="number" name="price" class="form-control" id="productPrice" required>
                        <label for="productPrice" class="form-label">Product Price</label>
                    </div>
                    <div class="col">
                        <input type="number" name="profit" class="form-control" id="productProfit" required>
                        <label for="productProfit" class="form-label">Profit</label>
                    </div>
                </div>

                <div class="form-row mb-3">
                    <div class="col">
                        <input type="number" name="discount" class="form-control" id="productDiscount" required>
                        <label for="productDiscount" class="form-label">Discount (%)</label>
                    </div>
                    <div class="col">
                        <select class="form-select" name="stockStatus" id="stockStatus" required>
                            <option value="" disabled>Select Stock Status</option>
                            <option value="in-stock" selected>In Stock</option>
                            <option value="out-of-stock">Out of Stock</option>
                        </select>
                        <input type="hidden" id="inStock" name="inStock">
                        <label for="stockStatus" class="form-label">Stock Status</label>
                    </div>
                </div>
                
                <div class="mb-3">
                    <label for="themeColor" class="form-label">Theme Color</label>
                    <input type="color" name="themeColor" class="form-control" required>
                </div>

                <div class="mb-3">
                    <textarea class="form-control" name="description" id="productDescription" rows="2" required></textarea>
                    <label for="productDescription" class="form-label">Product Description</label>
                </div>

                <div class="text-center">
                    <button type="submit" id="add-product-button-id" class="btn btn-confirm">Add Product</button>
                    <button type="button" class="btn btn-cancel" onclick="hideAddProduct()">Cancel</button>
                </div>
                <input type="hidden" id="updateaction" name="id">
            </form>
        </div>
    </div>

    <script>
        document.getElementById('productImage').addEventListener('change', function() {
            const file = this.files[0];
            if (file) {
                const reader = new FileReader();
                reader.onload = function(event) {
                    document.getElementById('profileImage').setAttribute('src', event.target.result);
                };
                reader.readAsDataURL(file);
            }
        });
    </script>
</body>
</html>
