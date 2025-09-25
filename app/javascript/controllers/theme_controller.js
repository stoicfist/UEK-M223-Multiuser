import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["button"]

  connect() {
    this.updateLabel()
  }

  toggle() {
    const current = document.documentElement.dataset.theme || "light"
    const next = current === "dark" ? "light" : "dark"
    document.documentElement.dataset.theme = next
    try { localStorage.setItem("theme", next) } catch(e) {}
    this.updateLabel()
  }

  updateLabel() {
    const t = document.documentElement.dataset.theme || "light"
    if (this.hasButtonTarget) {
      this.buttonTarget.textContent = t === "dark" ? "☀️ Light" : "🌙 Dark"
    }
  }
}
