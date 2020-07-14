import "../css/app.css";

// webpack automatically bundles all modules in your
// entry points. Those entry points can be configured
// in "webpack.config.js".
//
// Import deps with the dep name or local files with a relative path, for example:
//
//     import {Socket} from "phoenix"
//     import socket from "./socket"
//
import "phoenix_html";
import "alpinejs";
import resizer from "./utils/resizer";
import controls from "./controls";

//
// Design System
//

// Responsive preview for the Disign System
if (document.querySelector(".responsive-preview-enabled")) {
  console.debug("Init responsive resize for previews");
  document.querySelectorAll(".responsive-preview").forEach((el) => {
    resizer.init(el);
  });
}

// Component preview controls
if (document.querySelector(".preview .dismissible")) {
  console.debug("Init dismissible in preview mode");
  document.querySelectorAll(".dismissible").forEach((el) => {
    controls.init(el, true);
  });
}
