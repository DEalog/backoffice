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
import { Socket } from "phoenix";
import NProgress from "nprogress";
import { LiveSocket } from "phoenix_live_view";
import "alpinejs";
import resizer from "./utils/resizer";
import controls from "./controls";

let csrfToken = document
  .querySelector("meta[name='csrf-token']")
  .getAttribute("content");
let liveSocket = new LiveSocket("/live", Socket, {
  params: { _csrf_token: csrfToken },
});

// Show progress bar on live navigation and form submits
NProgress.configure({ showSpinner: false });
window.addEventListener("phx:page-loading-start", (_info) => NProgress.start());
window.addEventListener("phx:page-loading-stop", (_info) => NProgress.done());

// connect if there are any LiveViews on the page
liveSocket.connect();

// expose liveSocket on window for web console debug logs and latency simulation:
// >> liveSocket.enableDebug()
// >> liveSocket.enableLatencySim(1000)
window.liveSocket = liveSocket;

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
