/**
 * Dismiss an element with a fade-out animation, then remove it from the DOM.
 *
 * @param {HTMLElement} element - The DOM element to dismiss
 * @param {Object} [options] - Options
 * @param {number} [options.duration=200] - Fade-out duration in milliseconds
 */
export function dismissElement(element, { duration = 200 } = {}) {
  element.style.transition = `opacity ${duration / 1000}s ease-out`;
  element.style.opacity = "0";

  setTimeout(() => {
    element.remove();
  }, duration);
}
