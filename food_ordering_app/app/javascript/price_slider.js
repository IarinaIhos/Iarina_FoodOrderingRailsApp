document.addEventListener('turbo:load', function() {
  initializePriceSlider();
});

document.addEventListener('DOMContentLoaded', function() {
  initializePriceSlider();
});

function initializePriceSlider() {
  const minSlider = document.querySelector('.min-price');
  const maxSlider = document.querySelector('.max-price');
  const sliderRange = document.querySelector('.slider-range');
  const minValue = document.querySelector('.min-value');
  const maxValue = document.querySelector('.max-value');
  const minPriceInput = document.getElementById('min_price');
  const maxPriceInput = document.getElementById('max_price');

  if (!minSlider || !maxSlider) return;

  const min = parseInt(minSlider.min);
  const max = parseInt(maxSlider.max);
  const gap = 5; 

  function updateSliderRange() {
    const minVal = parseInt(minSlider.value);
    const maxVal = parseInt(maxSlider.value);
    
    const percent1 = ((minVal - min) / (max - min)) * 100;
    const percent2 = ((maxVal - min) / (max - min)) * 100;
    
    if (sliderRange) {
      sliderRange.style.left = percent1 + '%';
      sliderRange.style.width = (percent2 - percent1) + '%';
    }
    
    if (minValue) minValue.textContent = '$' + minVal;
    if (maxValue) maxValue.textContent = '$' + maxVal;
    
    if (minPriceInput) minPriceInput.value = minVal;
    if (maxPriceInput) maxPriceInput.value = maxVal;
  }

  function handleMinSlider() {
    const minVal = parseInt(minSlider.value);
    const maxVal = parseInt(maxSlider.value);
    
    if (minVal >= maxVal - gap) {
      minSlider.value = maxVal - gap;
    }
    updateSliderRange();
  }

  function handleMaxSlider() {
    const minVal = parseInt(minSlider.value);
    const maxVal = parseInt(maxSlider.value);

    if (maxVal <= minVal + gap) {
      maxSlider.value = minVal + gap;
    }
    updateSliderRange();
  }

  function submitForm() {
    const form = document.querySelector('.filter-form');
    if (form) {
      const formData = new FormData(form);
      
      const params = new URLSearchParams();
      for (let [key, value] of formData.entries()) {
        if (value) {
          params.append(key, value);
        }
      }
      
      const currentUrl = new URL(window.location);
      currentUrl.search = params.toString();
      
      window.location.href = currentUrl.toString();
    }
  }

  minSlider.addEventListener('input', function() {
    handleMinSlider();
    
    if (window.priceSubmitTimeout) {
      clearTimeout(window.priceSubmitTimeout);
    }
    
    window.priceSubmitTimeout = setTimeout(submitForm, 1000);
  });

  maxSlider.addEventListener('input', function() {
    handleMaxSlider();
    
    if (window.priceSubmitTimeout) {
      clearTimeout(window.priceSubmitTimeout);
    }
    
    window.priceSubmitTimeout = setTimeout(submitForm, 1000);
  });

  updateSliderRange();
}
