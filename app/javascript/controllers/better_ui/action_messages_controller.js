import { Controller } from "@hotwired/stimulus";

/**
 * ActionMessages Stimulus Controller
 *
 * Handles dismiss functionality and auto-dismiss timer for ActionMessages component.
 * Provides smooth fade-out animation when messages are dismissed.
 *
 * Connects to: data-controller="better-ui--action-messages"
 *
 * Values:
 *   - autoDismiss (Number): Seconds until auto-dismiss (optional)
 *
 * Actions:
 *   - dismiss: Manually dismiss the message (triggered by dismiss button)
 *
 * @example HTML usage
 *   <div data-controller="better-ui--action-messages"
 *        data-better-ui--action-messages-auto-dismiss-value="5">
 *     <button data-action="click->better-ui--action-messages#dismiss">
 *       Dismiss
 *     </button>
 *   </div>
 */
export default class extends Controller {
  // Stimulus Values API - defines component data attributes
  static values = {
    autoDismiss: Number, // Number of seconds until auto-dismiss
  };

  /**
   * Lifecycle: Called when controller is connected to the DOM
   * Starts auto-dismiss timer if autoDismiss value is configured
   */
  connect() {
    // Start auto-dismiss timer if configured (value > 0)
    if (this.hasAutoDismissValue && this.autoDismissValue > 0) {
      this.timeout = setTimeout(() => {
        this.dismiss();
      }, this.autoDismissValue * 1000); // Convert seconds to milliseconds
    }
  }

  /**
   * Lifecycle: Called when controller is disconnected from the DOM
   * Cleans up timeout to prevent memory leaks
   */
  disconnect() {
    // Cleanup timer to prevent memory leaks
    if (this.timeout) {
      clearTimeout(this.timeout);
      this.timeout = null;
    }
  }

  /**
   * Action: Dismiss the message with fade-out animation
   * Can be triggered manually (button click) or automatically (timer)
   *
   * Process:
   * 1. Clear any existing auto-dismiss timer
   * 2. Apply CSS transition for smooth fade-out
   * 3. Set opacity to 0
   * 4. Remove element from DOM after animation completes
   */
  dismiss() {
    // Cleanup timer if manually dismissed before auto-dismiss
    if (this.timeout) {
      clearTimeout(this.timeout);
      this.timeout = null;
    }

    // Add fade-out CSS transition (300ms duration)
    this.element.style.transition = "opacity 0.3s ease-out";
    this.element.style.opacity = "0";

    // Remove element from DOM after animation completes
    // Timeout matches CSS transition duration (300ms)
    setTimeout(() => {
      this.element.remove();
    }, 300);
  }
}
