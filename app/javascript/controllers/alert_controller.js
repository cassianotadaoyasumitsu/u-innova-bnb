import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    // Hide the alert after 3 seconds
    setTimeout(() => {
      this.element.classList.add('translate-y-full', 'opacity-0')
      setTimeout(() => {
        this.element.remove()
      }, 500)
    }, 3000)
  }
} 