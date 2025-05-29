function changePassword() {
    const oldPasswordInput = document.getElementById('old-password');
    const newPasswordInput = document.getElementById('new-password');
    const notification = document.querySelector('.notification');

    clearErrors(); // Clear any previous error messages

    // Validate fields
    if (!oldPasswordInput.value.trim()) {
        showError(oldPasswordInput, "Old password cannot be empty");
        return;
    }
    if (!newPasswordInput.value.trim()) {
        showError(newPasswordInput, "New password cannot be empty");
        return;
    }
    if (newPasswordInput.value.trim().length < 6) {
        showError(newPasswordInput, "Password must be at least 6 characters");
        return;
    }

    // Simulate password change logic
    notification.textContent = "Password changed successfully!";
    notification.classList.add('active');

    // Clear input fields after successful password change
    oldPasswordInput.value = '';
    newPasswordInput.value = '';
}

function showError(inputElement, message) {
    const errorMessageElement = inputElement.closest('.input-container').querySelector('.error-message');
    errorMessageElement.textContent = message;
    errorMessageElement.style.display = 'flex';  // Show the error message
    errorMessageElement.classList.add('active'); // Add any active class for styling if needed
}

function clearErrors() {
    const errorMessages = document.querySelectorAll('.error-message');
    errorMessages.forEach(error => {
        error.style.display = 'none';  // Hide the error message
        error.classList.remove('active'); // Remove the active class if it was added
    });
    document.querySelector('.notification').classList.remove('active');
}

function togglePasswordVisibility(inputId) {
    const inputElement = document.getElementById(inputId);
    const toggleIcon = inputElement.nextElementSibling;

    if (inputElement.type === "password") {
        inputElement.type = "text";
        toggleIcon.classList.remove("fa-eye");
        toggleIcon.classList.add("fa-eye-slash");
    } else {
        inputElement.type = "password";
        toggleIcon.classList.remove("fa-eye-slash");
        toggleIcon.classList.add("fa-eye");
    }
}
