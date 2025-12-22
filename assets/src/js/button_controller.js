import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static values = {
    showLoaderOnClick: Boolean,
  };

  static targets = ["spinner", "content"];

  connect() {
    // Set up accessibility attributes
    if (this.element.disabled) {
      this.element.setAttribute("aria-disabled", "true");
    }

    // Set up Turbo event listeners for auto-reset
    this.boundResetLoading = this.hideLoading.bind(this);
    document.addEventListener("turbo:submit-end", this.boundResetLoading);
    document.addEventListener("turbo:frame-load", this.boundResetLoading);
    document.addEventListener(
      "turbo:before-stream-render",
      this.boundResetLoading
    );
  }

  disconnect() {
    // Clean up Turbo event listeners
    document.removeEventListener("turbo:submit-end", this.boundResetLoading);
    document.removeEventListener("turbo:frame-load", this.boundResetLoading);
    document.removeEventListener(
      "turbo:before-stream-render",
      this.boundResetLoading
    );
  }

  handleClick(event) {
    if (this.element.disabled) {
      event.preventDefault();
      event.stopImmediatePropagation();
      return false;
    }

    // Activate loading state if show_loader_on_click is enabled and button is submit type
    if (this.showLoaderOnClickValue && this.element.type === "submit") {
      this.showLoading();
    }
  }

  showLoading() {
    // Show spinner, hide content, disable button
    if (this.hasSpinnerTarget && this.hasContentTarget) {
      this.spinnerTarget.classList.remove("hidden");
      this.contentTarget.classList.add("hidden");
      this.element.disabled = true;
      this.element.setAttribute("aria-disabled", "true");
    }
  }

  hideLoading() {
    // Hide spinner, show content, enable button (if not disabled by server)
    if (this.hasSpinnerTarget && this.hasContentTarget) {
      this.spinnerTarget.classList.add("hidden");
      this.contentTarget.classList.remove("hidden");

      // Only re-enable if the button wasn't disabled server-side
      // Check if disabled attribute was set by server (not by our JS)
      if (
        this.element.disabled &&
        !this.element.hasAttribute("data-server-disabled")
      ) {
        this.element.disabled = false;
        this.element.removeAttribute("aria-disabled");
      }
    }
  }
}
