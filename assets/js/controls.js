const closePreview = (e) => {
  const el = e.target.closest(".dismissible");
  el.classList.add("hidden");
  setTimeout(() => {
    el.classList.remove("hidden");
  }, 1000);
};

const close = (e) => {
  const el = e.target.closest(".dismissible");
  el.classList.add("hidden");
};

const controls = {
  init: (el, isPreview) => {
    const button = el.querySelector(".dismiss-control");
    if (isPreview) {
      button.addEventListener("click", closePreview);
      return;
    }
    button.addEventListener("click", close);
  },
};

export default controls;
