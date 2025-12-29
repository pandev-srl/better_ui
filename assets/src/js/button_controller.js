import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static values = {
    showLoaderOnClick: Boolean,
  };

  static targets = ["spinner", "content"];

  connect() {
    // Detect element type
    this.isLink = this.element.tagName.toLowerCase() === "a";

    // Check if component was rendered with show_loader: true (server-side loading state)
    // We preserve this state and don't auto-reset it
    this.initiallyLoading = this.hasSpinnerTarget && !this.spinnerTarget.classList.contains("hidden");

    // Set up accessibility attributes
    if (this.isDisabled) {
      this.element.setAttribute("aria-disabled", "true");
    }

    // Set up Turbo event listeners for auto-reset (only if not initially loading)
    // If server rendered with show_loader: true, we don't want to auto-hide
    if (!this.initiallyLoading) {
      this.boundResetLoading = this.hideLoading.bind(this);
      document.addEventListener("turbo:submit-end", this.boundResetLoading);
      document.addEventListener("turbo:frame-load", this.boundResetLoading);
      document.addEventListener(
        "turbo:before-stream-render",
        this.boundResetLoading
      );

      // For links with Turbo methods, also listen to turbo:load
      if (this.isLink) {
        document.addEventListener("turbo:load", this.boundResetLoading);
      }
    }

    // Set up loader behavior based on context
    if (this.showLoaderOnClickValue) {
      this.form = this.element.closest("form");

      if (!this.isLink && this.element.type === "submit" && this.form) {
        // For submit buttons in forms: use form submit event (fires after validation)
        this.boundShowLoading = this.showLoading.bind(this);
        this.form.addEventListener("submit", this.boundShowLoading);
      }
      // For standalone buttons and links: handled in handleClick
    }
  }

  disconnect() {
    // Clean up Turbo event listeners (only if they were set up)
    if (this.boundResetLoading) {
      document.removeEventListener("turbo:submit-end", this.boundResetLoading);
      document.removeEventListener("turbo:frame-load", this.boundResetLoading);
      document.removeEventListener(
        "turbo:before-stream-render",
        this.boundResetLoading
      );

      if (this.isLink) {
        document.removeEventListener("turbo:load", this.boundResetLoading);
      }
    }

    // Clean up form submit listener
    if (this.form && this.boundShowLoading) {
      this.form.removeEventListener("submit", this.boundShowLoading);
    }
  }

  // Check if element is disabled (works for both buttons and links)
  get isDisabled() {
    if (this.isLink) {
      return this.element.getAttribute("aria-disabled") === "true";
    }
    return this.element.disabled;
  }

  handleClick(event) {
    if (this.isDisabled) {
      event.preventDefault();
      event.stopImmediatePropagation();
      return false;
    }

    // Show loader on click for:
    // - Links (always immediate, no form validation)
    // - Standalone buttons (not submit type or no form)
    if (this.showLoaderOnClickValue) {
      if (this.isLink || !this.form || this.element.type !== "submit") {
        requestAnimationFrame(() => {
          this.showLoading();
        });
      }
    }
  }

  showLoading() {
    // Show spinner, hide content, disable element
    if (this.hasSpinnerTarget && this.hasContentTarget) {
      this.spinnerTarget.classList.remove("hidden");
      this.contentTarget.classList.add("hidden");

      if (this.isLink) {
        this.element.setAttribute("aria-disabled", "true");
        this.element.style.pointerEvents = "none";
      } else {
        this.element.disabled = true;
        this.element.setAttribute("aria-disabled", "true");
      }
    }
  }

  hideLoading() {
    // Hide spinner, show content, enable element (if not disabled by server)
    if (this.hasSpinnerTarget && this.hasContentTarget) {
      this.spinnerTarget.classList.add("hidden");
      this.contentTarget.classList.remove("hidden");

      if (this.isLink) {
        // Only re-enable if not originally disabled
        if (!this.element.hasAttribute("data-server-disabled")) {
          this.element.removeAttribute("aria-disabled");
          this.element.style.pointerEvents = "";
        }
      } else {
        // Only re-enable if the button wasn't disabled server-side
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
}
