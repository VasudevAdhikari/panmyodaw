document.addEventListener('DOMContentLoaded', function() {
    const logoutLink = document.querySelector('.logout-link');
    const logoutOverlay = document.querySelector('.logout-confirmation-overlay');
    const confirmLogoutBtn = document.getElementById('confirm-logout-btn');
    const cancelLogoutBtn = document.getElementById('cancel-logout-btn');

    // Display the confirmation box when logout is clicked
    logoutLink.addEventListener('click', function(event) {
        event.preventDefault();
        logoutOverlay.classList.add('show');
    });

    // Hide the confirmation box when cancel is clicked
    cancelLogoutBtn.addEventListener('click', function() {
        logoutOverlay.classList.remove('show');
    });

    // Handle the logout confirmation
    confirmLogoutBtn.addEventListener('click', function() {
        // Proceed with logout logic here
        window.location.href = 'logout.php'; // Adjust this link based on your actual logout process
    });
});
