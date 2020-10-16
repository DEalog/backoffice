import "phoenix_html";
import { Socket } from "phoenix";
import NProgress from "nprogress";
import { LiveSocket } from "phoenix_live_view";

let Hooks = {};

Hooks.Relogin = {
  mounted() {
    console.debug("Init Relogin hook");
    this.handleEvent("relogin", ({ email, password }) => {
      const csfrToken = document
        .querySelector("meta[name='csrf-token']")
        .getAttribute("content");
      const formData = new FormData();
      formData.set("email", email);
      formData.set("password", password);
      formData.set("_csrf_token", csfrToken);
      fetch("/api/users/relogin", {
        method: "post",
        body: formData,
      });
    });
  },
};

export default {
  init: (initCallback) => {
    console.debug("Init main");
    let csrfToken = document
      .querySelector("meta[name='csrf-token']")
      .getAttribute("content");

    // Show progress bar on live navigation and form submits
    NProgress.configure({ showSpinner: false });
    window.addEventListener("phx:page-loading-start", (_info) =>
      NProgress.start()
    );
    window.addEventListener("phx:page-loading-stop", (_info) => {
      NProgress.done();
      initCallback();
    });

    // Setup live socket
    let liveSocket = new LiveSocket("/live", Socket, {
      params: { _csrf_token: csrfToken },
      hooks: Hooks,
    });

    // connect if there are any LiveViews on the page
    liveSocket.connect();

    // expose liveSocket on window for web console debug logs and latency simulation:
    // >> liveSocket.enableDebug()
    // >> liveSocket.enableLatencySim(1000)
    window.liveSocket = liveSocket;
  },
};
