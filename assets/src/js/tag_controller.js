import { Controller } from "@hotwired/stimulus";
import { dismissElement } from "./utils/dismiss";

/**
 * Tag Stimulus Controller
 *
 * Handles dismiss functionality for Tag component.
 * Provides smooth fade-out animation when tags are dismissed.
 *
 * Connects to: data-controller="better-ui--tag"
 *
 * Actions:
 *   - dismiss: Remove the tag element from DOM (triggered by dismiss button)
 *
 * @example HTML usage
 *   <span data-controller="better-ui--tag">
 *     Tag Label
 *     <button data-action="click->better-ui--tag#dismiss">
 *       X
 *     </button>
 *   </span>
 */
export default class extends Controller {
  /**
   * Action: Dismiss the tag with fade-out animation
   * Triggered by clicking the dismiss (X) button
   */
  dismiss() {
    dismissElement(this.element, { duration: 200 });
  }
}
