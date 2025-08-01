document.addEventListener('DOMContentLoaded', () => {
  console.log("Filter slider script loaded");
  const minSlider = document.querySelector('.min-price');
  const maxSlider = document.querySelector('.max-price');
  const minValue = document.querySelector('.min-value');
  const maxValue = document.querySelector('.max-value');
  const minHidden = document.getElementById('min_price');
  const maxHidden = document.getElementById('max_price');
  const sliderRange = document.querySelector('.slider-range');

  if (!minSlider || !maxSlider || !minValue || !maxValue || !minHidden || !maxHidden || !sliderRange) {
    console.error("One or more slider elements not found:", {
      minSlider, maxSlider, minValue, maxValue, minHidden, maxHidden, sliderRange
    });
    return;
  }

  function updateSlider() {
    console.log("Updating slider");
    let min = parseInt(minSlider.value);
    let max = parseInt(maxSlider.value);

    // Prevent overlap with a minimum gap of 1
    const gap = 1;
    if (min > max - gap) {
      min = max - gap;
      minSlider.value = min;
    } else if (max < min + gap) {
      max = min + gap;
      maxSlider.value = max;
    }

    minValue.textContent = min;
    maxValue.textContent = max;
    minHidden.value = min;
    maxHidden.value = max;

    const minPercent = ((min - minSlider.min) / (minSlider.max - minSlider.min)) * 100;
    const maxPercent = ((max - maxSlider.min) / (maxSlider.max - maxSlider.min)) * 100;

    sliderRange.style.left = `${minPercent}%`;
    sliderRange.style.width = `${maxPercent - minPercent}%`;
  }

  minSlider.addEventListener('input', updateSlider);
  maxSlider.addEventListener('input', updateSlider);
  updateSlider();
});