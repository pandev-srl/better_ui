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

    // Set up loader behavior based on context
    if (this.showLoaderOnClickValue) {
      this.form = this.element.closest("form");

      if (this.element.type === "submit" && this.form) {
        // For submit buttons in forms: use form submit event (fires after validation)
        this.boundShowLoading = this.showLoading.bind(this);
        this.form.addEventListener("submit", this.boundShowLoading);
      }
      // For standalone buttons: handled in handleClick
    }
  }

  disconnect() {
    // Clean up Turbo event listeners
    document.removeEventListener("turbo:submit-end", this.boundResetLoading);
    document.removeEventListener("turbo:frame-load", this.boundResetLoading);
    document.removeEventListener(
      "turbo:before-stream-render",
      this.boundResetLoading
    );

    // Clean up form submit listener
    if (this.form && this.boundShowLoading) {
      this.form.removeEventListener("submit", this.boundShowLoading);
    }
  }

  handleClick(event) {
    if (this.element.disabled) {
      event.preventDefault();
      event.stopImmediatePropagation();
      return false;
    }

    // For standalone buttons (no form or not submit type): show loader on click
    // Submit buttons in forms use the form submit event listener instead (respects validation)
    if (
      this.showLoaderOnClickValue &&
      (!this.form || this.element.type !== "submit")
    ) {
      requestAnimationFrame(() => {
        this.showLoading();
      });
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
