const defaultTheme = require("tailwindcss/defaultTheme");

module.exports = {
  purge: ["../lib/**/*.html.leex", "../lib/**/*.html.eex"],
  theme: {
    extend: {
      fontFamily: {
        sans: ["Inter", ...defaultTheme.fontFamily.sans],
      },
      height: {
        128: "32rem",
      },
      minWidth: {
        sm: "24rem",
      },
      opacity: {
        90: ".90",
      },
    },
  },
  variants: {},
  plugins: [require("@tailwindcss/forms"), require("@tailwindcss/typography")],
};
