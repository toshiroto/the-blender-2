import flatpickr from "flatpickr";

const initFlatpickr = () => {
  flatpickr(".datepicker", {
    onChange: function (selectedDates, dateStr, instance) {
      instance.element.parentElement.parentElement.parentElement.submit();
    }});
}

export { initFlatpickr };
