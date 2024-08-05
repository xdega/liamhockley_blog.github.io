/** @type {import('tailwindcss').Config} */
module.exports = {
  theme: {
    extend: {
      fontFamily: {
        viga: ["Viga", "sans-serif"],
      },
    },
  },
  variants: {},
  plugins: [],
  content: ["./source/**/*.jinja"],
};
