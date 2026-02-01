import { Controller } from "@hotwired/stimulus";

/**
 * Tooltip Stimulus Controller
 *
 * Positions tooltips using `position: fixed` and `getBoundingClientRect()`
 * so they escape overflow:hidden/auto clipping contexts.
 *
 * Connects to: data-controller="better-ui--tooltip"
 *
 * Values:
 *   - position (String): Preferred position - "top", "right", "bottom", "left" (default: "top")
 *
 * Targets:
 *   - tooltip: The tooltip element to position and show/hide
 */
export default class extends Controller {
  static targets = ["tooltip"];

  static values = {
    position: { type: String, default: "top" },
  };

  connect() {
    this.showTooltip = this.showTooltip.bind(this);
    this.hideTooltip = this.hideTooltip.bind(this);

    this.element.addEventListener("mouseenter", this.showTooltip);
    this.element.addEventListener("mouseleave", this.hideTooltip);
    this.element.addEventListener("focusin", this.showTooltip);
    this.element.addEventListener("focusout", this.hideTooltip);
  }

  disconnect() {
    this.element.removeEventListener("mouseenter", this.showTooltip);
    this.element.removeEventListener("mouseleave", this.hideTooltip);
    this.element.removeEventListener("focusin", this.showTooltip);
    this.element.removeEventListener("focusout", this.hideTooltip);
  }

  showTooltip() {
    if (!this.hasTooltipTarget) return;

    const tooltip = this.tooltipTarget;
    const trigger = this.element;

    // Make visible so we can measure
    tooltip.style.visibility = "hidden";
    tooltip.style.display = "block";
    tooltip.classList.remove("invisible");

    const triggerRect = trigger.getBoundingClientRect();
    const tooltipRect = tooltip.getBoundingClientRect();
    const gap = 8;

    const position = this.resolvePosition(
      this.positionValue,
      triggerRect,
      tooltipRect,
      gap
    );

    const coords = this.calculateCoords(
      position,
      triggerRect,
      tooltipRect,
      gap
    );

    tooltip.style.position = "fixed";
    tooltip.style.top = `${coords.top}px`;
    tooltip.style.left = `${coords.left}px`;
    tooltip.style.visibility = "";
    tooltip.style.display = "";

    tooltip.classList.remove("opacity-0", "invisible");
    tooltip.classList.add("opacity-100");
  }

  hideTooltip() {
    if (!this.hasTooltipTarget) return;

    const tooltip = this.tooltipTarget;
    tooltip.classList.remove("opacity-100");
    tooltip.classList.add("opacity-0", "invisible");

    tooltip.style.position = "";
    tooltip.style.top = "";
    tooltip.style.left = "";
  }

  /**
   * Resolve position with viewport flip if tooltip would overflow.
   */
  resolvePosition(preferred, triggerRect, tooltipRect, gap) {
    const fits = {
      top: triggerRect.top - tooltipRect.height - gap >= 0,
      bottom:
        triggerRect.bottom + tooltipRect.height + gap <= window.innerHeight,
      left: triggerRect.left - tooltipRect.width - gap >= 0,
      right:
        triggerRect.right + tooltipRect.width + gap <= window.innerWidth,
    };

    if (fits[preferred]) return preferred;

    // Try opposite direction
    const opposites = { top: "bottom", bottom: "top", left: "right", right: "left" };
    const opposite = opposites[preferred];
    if (fits[opposite]) return opposite;

    // Fallback: try all
    for (const pos of ["top", "bottom", "right", "left"]) {
      if (fits[pos]) return pos;
    }

    return preferred;
  }

  /**
   * Calculate fixed coordinates for the tooltip.
   */
  calculateCoords(position, triggerRect, tooltipRect, gap) {
    switch (position) {
      case "top":
        return {
          top: triggerRect.top - tooltipRect.height - gap,
          left:
            triggerRect.left +
            triggerRect.width / 2 -
            tooltipRect.width / 2,
        };
      case "bottom":
        return {
          top: triggerRect.bottom + gap,
          left:
            triggerRect.left +
            triggerRect.width / 2 -
            tooltipRect.width / 2,
        };
      case "left":
        return {
          top:
            triggerRect.top +
            triggerRect.height / 2 -
            tooltipRect.height / 2,
          left: triggerRect.left - tooltipRect.width - gap,
        };
      case "right":
        return {
          top:
            triggerRect.top +
            triggerRect.height / 2 -
            tooltipRect.height / 2,
          left: triggerRect.right + gap,
        };
      default:
        return { top: 0, left: 0 };
    }
  }
}
