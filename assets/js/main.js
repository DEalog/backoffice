import { Socket } from "phoenix";
import NProgress from "nprogress";
import { LiveSocket } from "phoenix_live_view";

export default {
  init: (initCallback) => {
    console.debug("Init main");
    let csrfToken = document
      .querySelector("meta[name='csrf-token']")
      .getAttribute("content");
    let liveSocket = new LiveSocket("/live", Socket, {
      params: { _csrf_token: csrfToken },
    });

    // Show progress bar on live navigation and form submits
    NProgress.configure({ showSpinner: false });
    window.addEventListener("phx:page-loading-start", (_info) =>
      NProgress.start()
    );
    window.addEventListener("phx:page-loading-stop", (_info) => {
      NProgress.done();
      initCallback();
    });

    // connect if there are any LiveViews on the page
    liveSocket.connect();

    // expose liveSocket on window for web console debug logs and latency simulation:
    // >> liveSocket.enableDebug()
    // >> liveSocket.enableLatencySim(1000)
    window.liveSocket = liveSocket;
  },
};
