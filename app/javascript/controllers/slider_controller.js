import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["slide"]

  connect() {
    this.index = 0
    if (this.slideTargets.length > 1) {
      this.timer = setInterval(() => this.next(), 4000)
    }
  }

  disconnect() {
    clearInterval(this.timer)
  }

  next() {
    this.goTo((this.index + 1) % this.slideTargets.length)
  }

  prev() {
    this.goTo((this.index - 1 + this.slideTargets.length) % this.slideTargets.length)
  }

  goTo(n) {
    this.slideTargets[this.index].classList.replace("opacity-100", "opacity-0")
    this.index = n
    this.slideTargets[this.index].classList.replace("opacity-0", "opacity-100")
  }
}
