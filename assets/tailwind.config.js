module.exports = {
  purge: ["../lib/**/*.html.eex"],
  theme: {
    extend: {
      height: {
        128: "32rem",
      },
      minWidth: {
        sm: "24rem",
      },
    },
  },
  variants: {},
  plugins: [
    require("@tailwindcss/custom-forms"),
    require("@tailwindcss/typography"),
  ],
};
