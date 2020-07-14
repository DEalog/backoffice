const resizer = {
  init: (element) => {
    let md; // remember mouse down info
    const first = element.querySelector(".first");
    const second = element.querySelector(".second");
    const separator = element.querySelector(".separator");
    const overlay = element.querySelector(".overlay");

    separator.onpointerdown = startResize;

    function startResize(e) {
      md = {
        e,
        offsetLeft: separator.offsetLeft,
        firstWidth: first.offsetWidth,
        secondWidth: second.offsetWidth,
      };
      overlay.classList.toggle("hidden");
      document.onpointermove = resize;
      document.onpointerup = () => {
        overlay.classList.toggle("hidden");
        document.onpointermove = null;
      };
    }

    function resize(e) {
      var delta = {
        x: e.clientX - md.e.clientX,
        y: e.clientY - md.e.clientY,
      };

      delta.x = Math.min(Math.max(delta.x, -md.firstWidth), md.secondWidth);

      separator.style.left = md.offsetLeft + delta.x + "px";
      first.style.width = md.firstWidth + delta.x + "px";
      second.style.width = md.secondWidth - delta.x + "px";
    }
  },
};

export default resizer;
