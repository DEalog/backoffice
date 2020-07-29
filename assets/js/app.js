import "../css/app.css";

import "alpinejs";
import main from "./main";
import resizer from "./utils/resizer";

const init = () => {
  //
  // Design System
  //

  // Responsive preview for the Design System
  if (document.querySelector(".responsive-preview-enabled")) {
    console.debug("Init responsive resize for previews");
    document.querySelectorAll(".responsive-preview").forEach((el) => {
      resizer.init(el);
    });
  }
};

main.init(init);
