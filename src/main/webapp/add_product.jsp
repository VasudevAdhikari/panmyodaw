<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Product Profile Card</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        .card {
            max-width: 500px;
            margin: 50px auto;
        }
        .profile-pic {
            display: flex;
            justify-content: center;
            align-items: center;
            margin-bottom: 20px;
        }
        .profile-pic img {
            width: 120px;
            height: 120px;
            border-radius: 50%;
            cursor: pointer;
            object-fit: cover;
        }
        .form-label {
            font-size: 1.2rem;
        }
        .form-row {
            display: flex;
            justify-content: space-between;
        }
        .form-row .col {
            flex: 0 0 48%;
        }
    </style>
</head>
<body>
    <div class="card">
        <div class="card-header text-center bg-primary text-white">
            Add New Product
        </div>
        <div class="card-body">
            <form id="productForm" method="post" action="ProductController" enctype="multipart/form-data">
                <!-- Profile Picture Input -->
                <div class="profile-pic">
                    <label for="productImage">
                        <img src="https://via.placeholder.com/120" id="profileImage" alt="Product Image">
                        <br><span>Product Pic</span>
                    </label>
                    <input type="file" class="d-none" id="productImage" name="profile_pic" accept="image/*" required>
                </div>
                
                <!-- Product Name -->
                <div class="mb-3">
                    <input type="text" name="name" class="form-control" id="productName" required>
                    <label for="productName" class="form-label">Product Name</label>
                </div>

                <!-- Product Price and Profit -->
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

                <!-- Discount and Stock Status -->
                <div class="form-row mb-3">
                    <div class="col">
                        <input type="number" name="discount" class="form-control" id="productDiscount" required>
                        <label for="productDiscount" class="form-label">Discount (%)</label>
                    </div>
                    <div class="col">
                        <select class="form-select" id="stockStatus" required>
                            <option value="" disabled>Select Stock Status</option>
                            <option value="in-stock" selected>In Stock</option>
                            <option value="out-of-stock">Out of Stock</option>
                        </select>
                        <input type="hidden" id="inStock" name="inStock">
                        <label for="stockStatus" class="form-label">Stock Status</label>
                    </div>
                </div>
                
                <div class="form-row mb-3">
                			
                    <label for="themeColor" class="form-label">ThemeColor</label>
                	<input type="color" name="themeColor" class="form-control" required style="width: 27vw !important;">
                </div>

                <!-- Product Description -->
                <div class="mb-3">
                    <textarea class="form-control" name="description" id="productDescription" rows="3" required></textarea>
                    <label for="productDescription" class="form-label">Product Description</label>
                </div>

                <!-- Submit Button -->
                <div class="text-center">
                    <button type="submit" class="btn btn-success">Add Product</button>
                </div>
            </form>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
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

        document.querySelectorAll('.form-control').forEach(input => {
            input.addEventListener('focus', () => {
                input.classList.add('active');
            });
            input.addEventListener('blur', () => {
                if (input.value !== '') {
                    input.classList.add('active');
                } else {
                    input.classList.remove('active');
                }
            });
        });
        
        const form = document.getElementById('productForm');
        form.addEventListener('submit', (event) => {
            event.preventDefault();
            // You can add additional logic here if needed, such as validation or form handling
            const inStockStatus = document.getElementById("stockStatus");
            if (inStockStatus.value == 'in-stock') {
            	document.getElementById("inStock").value=true;
            } else {
            	document.getElementById("inStock").value=true;
            }
            form.submit();
        });
    </script>
</body>
</html>
