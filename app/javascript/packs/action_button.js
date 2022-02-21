function action_button() {

  const fab = document.querySelector('.fab');
  if (fab) {
    fab.addEventListener('click', () => {
      fab.classList.toggle('active');
    })
  }
}

export { action_button }
