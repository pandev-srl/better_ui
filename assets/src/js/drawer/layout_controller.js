import { Controller } from "@hotwired/stimulus";

/**
 * Drawer Layout Stimulus Controller
 *
 * Handles mobile sidebar drawer behavior including:
 * - Toggle sidebar open/close
 * - Overlay click to close
 * - ESC key to close
 * - Body scroll lock when open
 * - Slide animation from left or right
 *
 * Connects to: data-controller="better-ui--drawer--layout"
 *
 * Values:
 *   - open (Boolean): Whether the drawer is currently open
 *   - position (String): Sidebar position ("left" or "right")
 *   - breakpoint (String): CSS breakpoint for desktop mode ("md", "lg", "xl")
 *
 * Targets:
 *   - sidebar: The sidebar element to animate
 *   - overlay: The overlay backdrop element
 *
 * Actions:
 *   - toggle: Toggle the drawer open/closed
 *   - open: Open the drawer
 *   - close: Close the drawer
 *
 * @example HTML usage
 *   <div data-controller="better-ui--drawer--layout"
 *        data-better-ui--drawer--layout-position-value="left"
 *        data-better-ui--drawer--layout-breakpoint-value="lg">
 *     <div data-better-ui--drawer--layout-target="overlay"
 *          data-action="click->better-ui--drawer--layout#close">
 *     </div>
 *     <aside data-better-ui--drawer--layout-target="sidebar">
 *       Sidebar content
 *     </aside>
 *     <button data-action="click->better-ui--drawer--layout#toggle">
 *       Toggle Menu
 *     </button>
 *   </div>
 */
export default class extends Controller {
  // Stimulus Targets API
  static targets = ["sidebar", "overlay"];

  // Stimulus Values API
  static values = {
    open: { type: Boolean, default: false },
    position: { type: String, default: "left" },
    breakpoint: { type: String, default: "lg" },
  };

  /**
   * Lifecycle: Called when controller is connected to the DOM
   * Sets up keyboard event listeners and initial state
   */
  connect() {
    // Bind keyboard handler for ESC key
    this.handleKeydown = this.handleKeydown.bind(this);
    document.addEventListener("keydown", this.handleKeydown);

    // Bind resize handler for responsive behavior
    this.handleResize = this.handleResize.bind(this);
    window.addEventListener("resize", this.handleResize);

    // Set initial state based on value
    this.updateDrawerState();
  }

  /**
   * Lifecycle: Called when controller is disconnected from the DOM
   * Cleans up event listeners and restores body scroll
   */
  disconnect() {
    document.removeEventListener("keydown", this.handleKeydown);
    window.removeEventListener("resize", this.handleResize);

    // Ensure body scroll is restored
    this.enableBodyScroll();
  }

  /**
   * Value callback: Called when open value changes
   * Updates the drawer state based on new value
   */
  openValueChanged() {
    this.updateDrawerState();
  }

  /**
   * Action: Toggle the drawer open/closed
   */
  toggle() {
    this.openValue = !this.openValue;
  }

  /**
   * Action: Open the drawer
   */
  open() {
    this.openValue = true;
  }

  /**
   * Action: Close the drawer
   */
  close() {
    this.openValue = false;
  }

  /**
   * Handle keyboard events (ESC to close)
   * @param {KeyboardEvent} event
   */
  handleKeydown(event) {
    if (event.key === "Escape" && this.openValue) {
      this.close();
    }
  }

  /**
   * Handle window resize to close drawer on desktop breakpoint
   */
  handleResize() {
    if (this.isDesktopBreakpoint() && this.openValue) {
      this.close();
    }
  }

  /**
   * Check if current viewport is at desktop breakpoint
   * @returns {Boolean}
   */
  isDesktopBreakpoint() {
    const breakpoints = {
      md: 768,
      lg: 1024,
      xl: 1280,
    };
    const breakpointWidth = breakpoints[this.breakpointValue] || 1024;
    return window.innerWidth >= breakpointWidth;
  }

  /**
   * Update the visual state of the drawer based on openValue
   * Handles sidebar visibility, overlay, and body scroll
   */
  updateDrawerState() {
    if (this.openValue) {
      this.showDrawer();
    } else {
      this.hideDrawer();
    }
  }

  /**
   * Show the drawer with animation
   */
  showDrawer() {
    // Show overlay with fade in
    if (this.hasOverlayTarget) {
      this.overlayTarget.classList.remove("hidden", "opacity-0");
      this.overlayTarget.classList.add("opacity-100");
    }

    // Slide in sidebar
    if (this.hasSidebarTarget) {
      const translateClass =
        this.positionValue === "right" ? "translate-x-full" : "-translate-x-full";
      this.sidebarTarget.classList.remove(translateClass);
      this.sidebarTarget.classList.add("translate-x-0");
    }

    // Lock body scroll
    this.disableBodyScroll();

    // Update ARIA
    this.element.setAttribute("aria-expanded", "true");
  }

  /**
   * Hide the drawer with animation
   */
  hideDrawer() {
    // Hide overlay with fade out
    if (this.hasOverlayTarget) {
      this.overlayTarget.classList.remove("opacity-100");
      this.overlayTarget.classList.add("opacity-0");
      // Hide after transition
      setTimeout(() => {
        if (!this.openValue) {
          this.overlayTarget.classList.add("hidden");
        }
      }, 300);
    }

    // Slide out sidebar
    if (this.hasSidebarTarget) {
      const translateClass =
        this.positionValue === "right" ? "translate-x-full" : "-translate-x-full";
      this.sidebarTarget.classList.remove("translate-x-0");
      this.sidebarTarget.classList.add(translateClass);
    }

    // Restore body scroll
    this.enableBodyScroll();

    // Update ARIA
    this.element.setAttribute("aria-expanded", "false");
  }

  /**
   * Disable body scrolling
   */
  disableBodyScroll() {
    document.body.style.overflow = "hidden";
  }

  /**
   * Enable body scrolling
   */
  enableBodyScroll() {
    document.body.style.overflow = "";
  }
}
