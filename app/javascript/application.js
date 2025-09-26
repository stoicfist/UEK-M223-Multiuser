// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"
import "chartkick/chart.js"

document.addEventListener("turbo:load", () => {
  document.querySelectorAll("button[data-copy-to]").forEach(btn => {
    btn.addEventListener("click", () => {
      const srcSel = btn.getAttribute("data-source");
      const dstSel = btn.getAttribute("data-copy-to");
      const src = document.querySelector(srcSel);
      const dst = document.querySelector(dstSel);
      if (src && dst) {
        dst.value = src.value;
        dst.focus();
        // optional kleines Feedback
        const old = btn.textContent;
        btn.textContent = "Übernommen ✓";
        setTimeout(() => (btn.textContent = old), 1200);
      }
    });
  });
});
