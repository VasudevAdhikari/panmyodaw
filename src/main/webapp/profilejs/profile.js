// Global Variables
let originalData = {}; // Initialize outside the DOMContentLoaded

// Global Functions
function handleCancel() {
    console.log("resetMenu called");
    const profileForm = document.querySelector('.profile-form');
    if (profileForm) {
        profileForm.classList.remove('editable');
    }
    
    const menuButton = document.querySelector('.menu-button');
    if (menuButton) {
        menuButton.addEventListener('click', toggleMenu);
    }
    
    const profileHeader = document.querySelector('.profile-header');
    const menu = document.querySelector('.menu');
    if (profileHeader) {
        profileHeader.style.zIndex = 'auto';
    }
    if (menu) {
        menu.style.zIndex = 'auto';
    }
}

function toggleEdit(editMode) {
    const inputs = document.querySelectorAll('.account-edit input:not([data-ignore-edit]), .account-edit textarea:not([data-ignore-edit])');
    const editBtn = document.getElementById('edit-btn');
    const cancelBtn = document.getElementById('cancel-btn');
    const saveBtn = document.getElementById('save-btn');

    if (editMode) {
        originalData = saveCurrentData(inputs); // Save the original data before editing
        inputs.forEach(input => input.disabled = false);
        editBtn.style.display = 'none';
        cancelBtn.style.display = 'inline-block';
        saveBtn.style.display = 'inline-block';
    } else {
        restoreOriginalData(inputs); // Restore the original data if editing is canceled
        inputs.forEach(input => input.disabled = true);
        editBtn.style.display = 'inline-block';
        cancelBtn.style.display = 'none';
        saveBtn.style.display = 'none';
        clearErrors(); // Clear any error messages
    }
}

function saveProfile() {
    const usernameInput = document.getElementById('username');
    const firstNameInput = document.getElementById('first-name');
    const lastNameInput = document.getElementById('last-name');
    const emailInput = document.getElementById('email');
    const phoneNumberInput = document.getElementById('phone-number');
    const addressInput = document.getElementById('address');

    clearErrors(); // Clear any previous error messages

    // Validate fields
    let isValid = true;
    
    if (!usernameInput.value.trim()) {
        showError(usernameInput, "Username cannot be empty");
        isValid = false;
    }
    if (!firstNameInput.value.trim()) {
        showError(firstNameInput, "First name cannot be empty");
        isValid = false;
    }
    if (!lastNameInput.value.trim()) {
        showError(lastNameInput, "Last name cannot be empty");
        isValid = false;
    }
    if (!validateEmail(emailInput.value.trim())) {
        showError(emailInput, "Invalid email format");
        isValid = false;
    }
    if (!validatePhoneNumber(phoneNumberInput.value.trim())) {
        showError(phoneNumberInput, "Invalid phone number");
        isValid = false;
    }
    if (!addressInput.value.trim()) {
        showError(addressInput, "Address cannot be empty");
        isValid = false;
    }

    if (!isValid) return;

    // Update the profile details with the new data
    document.getElementById('profile-username').textContent = '@' + usernameInput.value.trim();
    document.getElementById('profile-email').textContent = emailInput.value.trim();

    // Save the updated data
    originalData = saveCurrentData(document.querySelectorAll('input, textarea'));

    // Disable edit mode after saving
    toggleEdit(false);

    // Optionally, show a success notification
    showNotification("Profile updated successfully!");
}

function validateEmail(email) {
    const emailPattern = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    return emailPattern.test(email);
}

function validatePhoneNumber(phoneNumber) {
    const phonePattern = /^09\d{9}$/;
    return phonePattern.test(phoneNumber);
}

function showError(inputElement, message) {
    const errorMessageElement = inputElement.parentElement.querySelector('.error-message');
    if (errorMessageElement) {
        errorMessageElement.textContent = message;
        errorMessageElement.classList.add('active');
    }
}

function clearErrors() {
    const errorMessages = document.querySelectorAll('.error-message.active');
    errorMessages.forEach(error => error.classList.remove('active'));
}

function saveCurrentData(inputs) {
    let data = {};
    inputs.forEach(input => {
        data[input.id] = input.value;
    });
    return data;
}

function restoreOriginalData(inputs) {
    inputs.forEach(input => {
        input.value = originalData[input.id] || ''; // Restore original data or empty if not set
    });
}

function showConfirmationBox() {
    const overlay = document.querySelector('.confirmation-overlay');
    if (overlay) {
        overlay.classList.remove('hide');
        overlay.classList.add('show');
    }
}

function hideConfirmationBox() {
    const overlay = document.querySelector('.confirmation-overlay');
    if (overlay) {
        overlay.classList.remove('show');
        overlay.classList.add('hide');
    }
}

function changeProfileImage(event) {
    const profileImg = document.getElementById('profile-img');
    const file = event.target.files[0];
    if (file && profileImg) {
        const reader = new FileReader();
        reader.onload = function(e) {
            profileImg.src = e.target.result;
        };
        reader.readAsDataURL(file);
    }
}

function switchSection(showSectionId, hideSectionIds, activeLink) {
    document.getElementById(showSectionId).style.display = 'block';
    hideSectionIds.forEach(id => {
        const section = document.getElementById(id);
        if (section) section.style.display = 'none';
    });

    const activeMenuLink = document.querySelector('.menu-link.active');
    if (activeMenuLink) {
        activeMenuLink.classList.remove('active');
    }

    if (activeLink) {
        activeLink.classList.add('active');
    }
}

function showNotification(message) {
    const notification = document.querySelector('.notification');
    if (notification) {
        notification.textContent = message;
        notification.classList.add('active');

        // Hide notification after 3 seconds
        setTimeout(() => {
            notification.classList.remove('active');
        }, 3000);
    }
}

document.addEventListener('DOMContentLoaded', function() {
    // Delete Account button
    const deleteBtn = document.getElementById('delete-btn');
    if (deleteBtn) {
        deleteBtn.addEventListener('click', showConfirmationBox);
    }

    // Cancel Delete button in confirmation box
    const cancelDeleteBtn = document.getElementById('cancel-delete-btn');
    if (cancelDeleteBtn) {
        cancelDeleteBtn.addEventListener('click', hideConfirmationBox);
    }
    
    // Edit button
    const editBtn = document.getElementById('edit-btn');
    if (editBtn) {
        editBtn.addEventListener('click', () => toggleEdit(true));
    }

    // Save button
    const saveBtn = document.getElementById('save-btn');
    if (saveBtn) {
        saveBtn.addEventListener('click', () => {
            saveProfile();
            handleCancel();
        });
    }

    // Cancel button
    const cancelBtn = document.getElementById('cancel-btn');
    if (cancelBtn) {
        cancelBtn.addEventListener('click', () => {
            toggleEdit(false);
            handleCancel();
        });
    }

    // Profile Image Upload
    const profileImgOverlay = document.querySelector('.profile-img-overlay');
    if (profileImgOverlay) {
        profileImgOverlay.addEventListener('click', () => {
            const profileImgInput = document.getElementById('profile-img-input');
            if (profileImgInput) profileImgInput.click();
        });
    }

    const profileImgInput = document.getElementById('profile-img-input');
    if (profileImgInput) {
        profileImgInput.addEventListener('change', changeProfileImage);
    }

    // Navigation Links
    const passwordLink = document.getElementById('password-link');
    const accountLink = document.getElementById('account-link');
    const historyLink = document.getElementById('history-link');

    if (passwordLink) {
        passwordLink.addEventListener('click', function() {
            switchSection('password-section', ['account-section', 'history-section'], this);
        });
    }

    if (accountLink) {
        accountLink.addEventListener('click', function() {
            switchSection('account-section', ['password-section', 'history-section'], this);
        });
    }

    if (historyLink) {
        historyLink.addEventListener('click', function() {
            switchSection('history-section', ['account-section', 'password-section'], this);
        });
    }
});

