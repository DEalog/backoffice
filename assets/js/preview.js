import "alpinejs";
import controls from "./controls";

// Component preview controls
if (document.querySelector(".preview .dismissible")) {
  console.debug("Init dismissible behavior in preview mode");
  document.querySelectorAll(".dismissible").forEach((el) => {
    controls.init(el, true);
  });
}
