document.addEventListener("DOMContentLoaded", function() {
    const footer = document.querySelector('footer');
    const footerContent = document.querySelectorAll('.footer-content');
	
    const observerOptions = {
        root: null, // Use the viewport as the root
        rootMargin: '0px',
        threshold: 0.1 // Trigger when 10% of the footer is in view
    };
	
    const observer = new IntersectionObserver((entries, observer) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                footerContent.forEach((content, index) => {
                    content.style.setProperty('--delay', index); // Setting the delay for each item
                    content.classList.add('fadeInUp');
                });
            } else {
                footerContent.forEach(content => {
                    content.classList.remove('fadeInUp'); // Remove the class to reset the animation
                });
            }
        });
    }, observerOptions);
	
    observer.observe(footer);
});