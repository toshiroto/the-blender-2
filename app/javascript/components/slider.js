const rangeSlider = () => {
  var slider = $('.range-slider'),
    range = $('.range-slider__range'),
    value = $('.range-slider__value');
  console.log(slider);
  console.log(range);
  console.log(value);

  slider.each(function () {
    value.each(function () {
      var value = $(this).prev().attr('value');
      $(this).html(value);
    });
    range.on('input', function () {
      $(this).parent().next(value).html(this.value);
    });
  });
};

export { rangeSlider };
