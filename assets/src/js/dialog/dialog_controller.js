import { Controller } from "@hotwired/stimulus";

/**
 * Dialog Stimulus Controller
 *
 * Handles modal dialog behavior including:
 * - Open/close with animation
 * - Backdrop click to close (configurable)
 * - ESC key to close (configurable)
 * - Focus trap (Tab/Shift+Tab)
 * - Body scroll lock
 * - Confirm/cancel actions with custom events
 *
 * Connects to: data-controller="better-ui--dialog--dialog"
 *
 * Values:
 *   - open (Boolean): Whether the dialog is currently open
 *   - closeOnBackdrop (Boolean): Close when clicking backdrop
 *   - closeOnEscape (Boolean): Close when pressing Escape
 *
 * Targets:
 *   - backdrop: The backdrop overlay element
 *   - panel: The dialog panel element
 *
 * Actions:
 *   - open: Open the dialog
 *   - close: Close the dialog
 *   - toggle: Toggle open/closed
 *   - backdropClick: Handle backdrop clicks
 *   - confirm: Dispatch confirmed event and close
 *   - cancel: Dispatch cancelled event and close
 */
export default class extends Controller {
  static targets = ["backdrop", "panel"];

  static values = {
    open: { type: Boolean, default: false },
    closeOnBackdrop: { type: Boolean, default: true },
    closeOnEscape: { type: Boolean, default: true },
  };

  connect() {
    this.handleKeydown = this.handleKeydown.bind(this);
    document.addEventListener("keydown", this.handleKeydown);

    // Store the element that had focus before dialog opened
    this.previousFocus = null;

    // If initially open, show the dialog
    if (this.openValue) {
      this.showDialog();
    }
  }

  disconnect() {
    document.removeEventListener("keydown", this.handleKeydown);
    this.enableBodyScroll();
  }

  /**
   * Value callback: Called when open value changes
   */
  openValueChanged() {
    if (this.openValue) {
      this.showDialog();
    } else {
      this.hideDialog();
    }
  }

  /**
   * Action: Open the dialog
   */
  open() {
    this.openValue = true;
  }

  /**
   * Action: Close the dialog
   */
  close() {
    this.openValue = false;
    this.dispatch("closed", { bubbles: true });
  }

  /**
   * Action: Toggle the dialog
   */
  toggle() {
    this.openValue = !this.openValue;
  }

  /**
   * Action: Handle backdrop click
   * Only closes if closeOnBackdrop is true and click was on the backdrop itself
   */
  backdropClick(event) {
    if (this.closeOnBackdropValue && event.target === event.currentTarget) {
      this.close();
    }
  }

  /**
   * Action: Confirm - dispatches cancelable confirmed event, closes unless prevented
   */
  confirm() {
    const event = this.dispatch("confirmed", {
      bubbles: true,
      cancelable: true,
    });

    if (!event.defaultPrevented) {
      this.close();
    }
  }

  /**
   * Action: Cancel - dispatches cancelled event and closes
   */
  cancel() {
    this.dispatch("cancelled", { bubbles: true });
    this.close();
  }

  /**
   * Handle keyboard events
   */
  handleKeydown(event) {
    if (!this.openValue) return;

    if (event.key === "Escape" && this.closeOnEscapeValue) {
      event.preventDefault();
      this.close();
      return;
    }

    // Focus trap
    if (event.key === "Tab") {
      this.trapFocus(event);
    }
  }

  /**
   * Trap focus within the dialog panel
   */
  trapFocus(event) {
    if (!this.hasPanelTarget) return;

    const focusableSelectors =
      'a[href], button:not([disabled]), textarea:not([disabled]), input:not([disabled]), select:not([disabled]), [tabindex]:not([tabindex="-1"])';
    const focusableElements =
      this.panelTarget.querySelectorAll(focusableSelectors);

    if (focusableElements.length === 0) return;

    const firstFocusable = focusableElements[0];
    const lastFocusable = focusableElements[focusableElements.length - 1];

    if (event.shiftKey) {
      // Shift+Tab: if on first element, wrap to last
      if (document.activeElement === firstFocusable) {
        event.preventDefault();
        lastFocusable.focus();
      }
    } else {
      // Tab: if on last element, wrap to first
      if (document.activeElement === lastFocusable) {
        event.preventDefault();
        firstFocusable.focus();
      }
    }
  }

  /**
   * Show the dialog with animation
   */
  showDialog() {
    // Store current focus
    this.previousFocus = document.activeElement;

    // Remove hidden
    this.element
      .querySelectorAll("[data-dialog-overlay]")
      .forEach((el) => el.removeAttribute("hidden"));

    // Animate in on next frame
    requestAnimationFrame(() => {
      // Backdrop fade in
      if (this.hasBackdropTarget) {
        this.backdropTarget.classList.remove("opacity-0");
        this.backdropTarget.classList.add("opacity-100");
      }

      // Panel animate in
      if (this.hasPanelTarget) {
        this.panelTarget.classList.remove(
          "opacity-0",
          "scale-95",
          "translate-y-4",
          "sm:translate-y-0",
          "sm:scale-95"
        );
        this.panelTarget.classList.add(
          "opacity-100",
          "scale-100",
          "translate-y-0",
          "sm:scale-100"
        );
      }
    });

    // Lock body scroll
    this.disableBodyScroll();

    // Focus first focusable element in panel
    requestAnimationFrame(() => {
      if (this.hasPanelTarget) {
        const focusableSelectors =
          'a[href], button:not([disabled]), textarea:not([disabled]), input:not([disabled]), select:not([disabled]), [tabindex]:not([tabindex="-1"])';
        const firstFocusable =
          this.panelTarget.querySelector(focusableSelectors);
        if (firstFocusable) {
          firstFocusable.focus();
        }
      }
    });
  }

  /**
   * Hide the dialog with animation
   */
  hideDialog() {
    // Backdrop fade out
    if (this.hasBackdropTarget) {
      this.backdropTarget.classList.remove("opacity-100");
      this.backdropTarget.classList.add("opacity-0");
    }

    // Panel animate out
    if (this.hasPanelTarget) {
      this.panelTarget.classList.remove(
        "opacity-100",
        "scale-100",
        "translate-y-0",
        "sm:scale-100"
      );
      this.panelTarget.classList.add(
        "opacity-0",
        "scale-95",
        "translate-y-4",
        "sm:translate-y-0",
        "sm:scale-95"
      );
    }

    // Hide after animation completes
    setTimeout(() => {
      if (!this.openValue) {
        this.element
          .querySelectorAll("[data-dialog-overlay]")
          .forEach((el) => el.setAttribute("hidden", ""));
      }
    }, 200);

    // Restore body scroll
    this.enableBodyScroll();

    // Restore previous focus
    if (this.previousFocus && typeof this.previousFocus.focus === "function") {
      this.previousFocus.focus();
    }
  }

  disableBodyScroll() {
    document.body.style.overflow = "hidden";
  }

  enableBodyScroll() {
    document.body.style.overflow = "";
  }
}
