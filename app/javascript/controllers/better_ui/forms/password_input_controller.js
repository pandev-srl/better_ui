import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="better-ui--forms--password-input"
export default class extends Controller {
  static targets = ["input", "eyeIcon", "eyeSlashIcon"];

  /**
   * Toggles the password visibility between hidden (type="password") and visible (type="text").
   * Also toggles the visibility of the eye icons to reflect the current state.
   *
   * Uses mousedown event instead of click to prevent the input from losing focus.
   *
   * @param {Event} event - The mousedown event from the toggle button
   * @example
   *   <button data-action="mousedown->better-ui--forms--password-input#toggle">
   *     Toggle
   *   </button>
   */
  toggle(event) {
    // Prevent default to stop button from stealing focus
    event.preventDefault();
    event.stopPropagation();

    const input = this.inputTarget;
    const isPassword = input.type === "password";

    // Toggle input type between "password" and "text"
    input.type = isPassword ? "text" : "password";

    // Toggle icon visibility
    this.eyeIconTarget.classList.toggle("hidden");
    this.eyeSlashIconTarget.classList.toggle("hidden");

    // Ensure input stays focused
    input.focus();
  }
}
