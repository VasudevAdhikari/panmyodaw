// Cart
let cartIcon = document.querySelector('#cart-icon');
let cart = document.querySelector('.cart');
let closeCart = document.querySelector('#close-cart');

// Open Cart
cartIcon.onclick = () => {
    cart.classList.add("active");
};

// Close Cart
closeCart.onclick = () => {
    cart.classList.remove("active");  
};

function addAllProductsToCart() {
    // Select all product elements
    var productBoxes = document.querySelectorAll('.product-box');

    productBoxes.forEach(function(productBox) {
        // Extract product details
        var title = productBox.querySelector('.product-title').innerText;
        var price = productBox.querySelector('.price').innerText;
        var productImg = productBox.querySelector('.product-img').src;

        // Call the function to add product to the cart
        var isAdded = addProductToCart(title, price, productImg);

        // Optionally, you could handle the case where the product was not added
        if (isAdded) {
            console.log(title + " added to cart.");
        } else {
            console.log(title + " was already in the cart.");
        }
    });

    // Update the total price after adding all products
    updateTotal();
}

function removeAllProductsFromCart() {
    var cartContent = document.getElementsByClassName('cart-content')[0];
    
    // Get all cart items
    var cartItems = cartContent.getElementsByClassName('cart-box');
    
    // Iterate over all cart items and remove them
    while (cartItems.length > 0) {
        var cartItem = cartItems[0];
        var productName = cartItem.getElementsByClassName('cart-product-title')[0].innerText;

        // Remove item from cart and notify server
        sendCartUpdateRequest('remove', productName, 0);

        // Remove item from DOM
        cartContent.removeChild(cartItem);
    }

    // Update total price after removing all products
    updateTotal();
}


function cleanCart() {
	console.log("clean cart method()");
	addAllProductsToCart();
	removeAllProductsFromCart();
}

// Display notification
function showNotification(message) {
    const notification = document.createElement('div');
    notification.className = 'notification';
    notification.innerText = message;

    document.body.appendChild(notification);

    // Show notification
    setTimeout(() => {
        notification.classList.add('show');
    }, 100);

    // Hide notification after 2 seconds
    setTimeout(() => {
        notification.classList.remove('show');
        // Remove notification from DOM after fading out
        setTimeout(() => {
            document.body.removeChild(notification);
        }, 500);
    }, 2000);
}

// Cart Working JS
if (document.readyState == 'loading'){
    document.addEventListener('DOMContentLoaded', ready);
}else {
    ready();
}

// Making Function
function ready(){
    //Remove Items From Cart
    var removeCartButtons = document.getElementsByClassName('cart-remove');
    console.log(removeCartButtons);
    for (var i = 0; i < removeCartButtons.length; i++){
        var button = removeCartButtons[i];
        button.addEventListener("click", removeCartItem);
    }
    // Quantity Changes
    var quantityInputs = document.getElementsByClassName('cart-quantity');
    for (var i = 0; i < quantityInputs.length; i++){
        var input = quantityInputs[i];
        input.addEventListener("change", quantityChanged);
    }
    // Add To Cart
    var addCart = document.getElementsByClassName('add-cart');
    for (var i = 0; i < addCart.length; i++){
        var button = addCart[i];
        button.addEventListener('click', addCartClicked);
    }
    // Buy Button Work
    document.getElementsByClassName('btn-buy')[0].addEventListener('click', buyButtonClicked);
}

// Buy Button
function buyButtonClicked(){
    var cartContent = document.getElementsByClassName('cart-content')[0];
    while(cartContent.hasChildNodes()){
        cartContent.removeChild(cartContent.firstChild);
    }
    updateTotal();
}

document.getElementById("orderCartForm").addEventListener("submit", function(event) {
    event.preventDefault(); // Prevent the default form submission

    if (confirm("Are you sure to place the order?")) {
        // If the user confirms, submit the form
        event.target.submit();
    }
    // If the user cancels, the form won't be submitted
});


//Remove Items From Cart
function removeCartItem(event){
    var buttonClicked = event.target;
    buttonClicked.parentElement.remove();
    updateTotal();
    var productName = buttonClicked.parentElement.getElementsByClassName('cart-product-title')[0].innerText;
    sendCartUpdateRequest('remove', productName, 0);
}

// Quantity Changes
function quantityChanged(event){
    var input = event.target;
    if (isNaN(input.value) || input.value <= 0) {
        input.value = 1;
    }
    var productName = input.parentElement.getElementsByClassName('cart-product-title')[0].innerText;
    updateTotal();
    sendCartUpdateRequest('update', productName, input.value);
}

// Add To Cart 
function addCartClicked(event) {
    var button = event.target;
    var shopProducts = button.parentElement;
    var title = shopProducts.getElementsByClassName('product-title')[0].innerText;
    var price = shopProducts.getElementsByClassName('price')[0].innerText;
    var productImg = shopProducts.getElementsByClassName('product-img')[0].src;

    var isAdded = addProductToCart(title, price, productImg);
    
    if (isAdded) {
        // If the product was added successfully, update total and send to the server.
        updateTotal();
        sendCartUpdateRequest('add', title, 1);
    } else {
        // Optionally, handle the case where the product was not added (e.g., show notification)
        showNotification("You have already added this item to the cart");
    }
}

function addProductToCart(title, price, productImg) {
    var cartItems = document.getElementsByClassName('cart-content')[0];
    var cartItemsNames = cartItems.getElementsByClassName('cart-product-title');
    
    for (var i = 0; i < cartItemsNames.length; i++) {
        if (cartItemsNames[i].innerText == title) {
            return false;  // Indicate that the item was not added because it already exists
        }
    }

    var cartShopBox = document.createElement('div');
    cartShopBox.classList.add('cart-box');

    var cartBoxContent = `
        <img src="${productImg}" alt="" class="cart-img">
        <div class="detail-box">
            <div class="cart-product-title">${title}</div>
            <div class="cart-price">${price}</div>
            <input type="number" value="1" class="cart-quantity">
        </div>
        <i class='bx bx-trash cart-remove'></i>`;

    cartShopBox.innerHTML = cartBoxContent;
    cartItems.append(cartShopBox);

    cartShopBox.getElementsByClassName('cart-remove')[0].addEventListener('click', removeCartItem);
    cartShopBox.getElementsByClassName('cart-quantity')[0].addEventListener('change', quantityChanged);
    
    return true;  // Indicate that the item was successfully added
}

// Update Total
function updateTotal(){
    var cartContent = document.getElementsByClassName('cart-content')[0];
    var cartBoxes = cartContent.getElementsByClassName('cart-box');
    var total = 0;
    for (var i = 0; i < cartBoxes.length; i++){
        var cartBox = cartBoxes[i];
        var priceElement = cartBox.getElementsByClassName('cart-price')[0];
        var quantityElement = cartBox.getElementsByClassName('cart-quantity')[0];
        var price = parseFloat(priceElement.innerText.replace("$", ""));
        var quantity = quantityElement.value;
        total = total + (price * quantity);
    }
    // If price contains some cents value
    total = Math.round(total * 100) / 100;
    document.getElementsByClassName('total-price')[0].innerText = '$' + total;
}

function sendCartUpdateRequest(action, productName, quantity) {
    var xhr = new XMLHttpRequest();
    xhr.open("POST", "CartServlet", true);
    xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");

    // Add a cache-busting parameter (timestamp)
    var cacheBuster = new Date().getTime();
    
    // Append cache-busting parameter to the URL
    var url = "CartServlet?cacheBuster=" + cacheBuster;

    xhr.onreadystatechange = function () {
        if (xhr.readyState === 4 && xhr.status === 200) {
            console.log(xhr.responseText);
        }
    };

    // Send the request with cache-busting parameter
    xhr.send("action=" + action + "&productName=" + encodeURIComponent(productName) + "&quantity=" + quantity);
}

