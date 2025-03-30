import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["menu", "button"]

  connect() {
    this.isOpen = false
  }

  toggle() {
    this.isOpen = !this.isOpen
    this.menuTarget.classList.toggle("hidden")
    this.buttonTarget.querySelector(".block").classList.toggle("hidden")
    this.buttonTarget.querySelector(".hidden").classList.toggle("block")
    this.buttonTarget.querySelector("button").setAttribute("aria-expanded", this.isOpen)
  }
} 