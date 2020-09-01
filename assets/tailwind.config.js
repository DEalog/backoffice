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
    },
  },
  variants: {},
  plugins: [require("@tailwindcss/ui"), require("@tailwindcss/typography")],
};
