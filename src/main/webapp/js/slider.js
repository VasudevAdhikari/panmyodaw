$(document).ready(function() {
  var $sliderWrapper = $('.slider-wrapper'),
      $slides = $('.slide'),
      slideIndex = 0,
      slideCount = $slides.length,
      slideWidth = $(window).width();

  function setWidths() {
      slideWidth = $(window).width();
      $slides.each(function() {
          $(this).css('width', slideWidth + 'px');
      });
      $sliderWrapper.css('width', slideWidth * slideCount + 'px');
      slideTo(slideIndex, false);
  }

  function slideTo(index, animate = true) {
      if (index < 0) index = slideCount - 1;
      if (index >= slideCount) index = 0;

      const translateValue = -slideWidth * index + 'px';
      if (animate) {
          $sliderWrapper.css({
              'transition': 'transform 0.4s ease-in-out',
              'transform': 'translateX(' + translateValue + ')'
          });
      } else {
          $sliderWrapper.css({
              'transition': 'none',
              'transform': 'translateX(' + translateValue + ')'
          });
      }
      slideIndex = index;
  }

  $('.arrow.next').click(function(e) {
      e.preventDefault();
      slideIndex++;
      slideTo(slideIndex);
  });

  $('.arrow.prev').click(function(e) {
      e.preventDefault();
      slideIndex--;
      slideTo(slideIndex);
  });

  var debounceTimeout;
  $(window).resize(function() {
      clearTimeout(debounceTimeout);
      debounceTimeout = setTimeout(setWidths, 250);
  });

  setWidths();
});
