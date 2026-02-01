import { Controller } from "@hotwired/stimulus";

/**
 * Dropdown Stimulus Controller
 *
 * Handles dropdown menu behavior including:
 * - Toggle open/close with scale+opacity animation
 * - Click-outside detection to close
 * - Keyboard navigation: Escape, ArrowDown/Up, Enter/Space, Tab, Home/End
 * - Skip disabled items in keyboard navigation
 * - ARIA state management (aria-expanded on trigger)
 * - Custom events: dropdown:opened, dropdown:closed, dropdown:item-selected
 * - Return focus to trigger on close
 *
 * Connects to: data-controller="better-ui--dropdown--dropdown"
 *
 * Values:
 *   - autoClose (Boolean): Close when clicking outside (default: true)
 *   - closeOnItemClick (Boolean): Close when clicking an item (default: true)
 *
 * Targets:
 *   - trigger: The trigger wrapper element
 *   - menu: The dropdown menu panel
 *   - item: Individual menu items (role="menuitem")
 */
export default class extends Controller {
  static targets = ["trigger", "menu", "item"];

  static values = {
    autoClose: { type: Boolean, default: true },
    closeOnItemClick: { type: Boolean, default: true },
  };

  connect() {
    this.isOpen = false;
    this.currentIndex = -1;

    this.handleClickOutside = this.handleClickOutside.bind(this);
    this.handleKeydown = this.handleKeydown.bind(this);
    this.handleCloseAll = this.handleCloseAll.bind(this);

    document.addEventListener("click", this.handleClickOutside);
    document.addEventListener("keydown", this.handleKeydown);
    document.addEventListener("better-ui--dropdown:close-all", this.handleCloseAll);
  }

  disconnect() {
    document.removeEventListener("click", this.handleClickOutside);
    document.removeEventListener("keydown", this.handleKeydown);
    document.removeEventListener("better-ui--dropdown:close-all", this.handleCloseAll);
  }

  /**
   * Action: Toggle the dropdown
   */
  toggle(event) {
    if (this.isOpen) {
      this.close();
    } else {
      this.open();
    }
  }

  /**
   * Open the dropdown menu
   */
  open() {
    if (this.isOpen) return;

    // Close all other open dropdowns first
    document.dispatchEvent(
      new CustomEvent("better-ui--dropdown:close-all", {
        detail: { except: this.element },
      })
    );

    this.isOpen = true;
    this.currentIndex = -1;

    if (!this.hasMenuTarget) return;

    // Update ARIA
    if (this.hasTriggerTarget) {
      this.triggerTarget.setAttribute("aria-expanded", "true");
    }

    // Show menu
    this.menuTarget.removeAttribute("hidden");

    // Animate in on next frame
    requestAnimationFrame(() => {
      this.menuTarget.classList.remove("opacity-0", "scale-95");
      this.menuTarget.classList.add("opacity-100", "scale-100");
    });

    this.dispatch("opened", { bubbles: true });
  }

  /**
   * Close the dropdown menu
   */
  close() {
    if (!this.isOpen) return;
    this.isOpen = false;
    this.currentIndex = -1;

    if (!this.hasMenuTarget) return;

    // Update ARIA
    if (this.hasTriggerTarget) {
      this.triggerTarget.setAttribute("aria-expanded", "false");
    }

    // Animate out
    this.menuTarget.classList.remove("opacity-100", "scale-100");
    this.menuTarget.classList.add("opacity-0", "scale-95");

    // Hide after animation
    setTimeout(() => {
      if (!this.isOpen) {
        this.menuTarget.setAttribute("hidden", "");
      }
    }, 150);

    // Return focus to trigger
    if (this.hasTriggerTarget) {
      const focusable = this.triggerTarget.querySelector(
        "button, a, [tabindex]"
      );
      if (focusable) {
        focusable.focus();
      } else {
        this.triggerTarget.focus();
      }
    }

    this.dispatch("closed", { bubbles: true });
  }

  /**
   * Handle close-all event: close this dropdown unless it's the one being opened
   */
  handleCloseAll(event) {
    if (!this.isOpen) return;
    if (event.detail?.except === this.element) return;
    this.close();
  }

  /**
   * Handle click outside to close
   */
  handleClickOutside(event) {
    if (!this.isOpen || !this.autoCloseValue) return;

    if (!this.element.contains(event.target)) {
      this.close();
    }
  }

  /**
   * Handle keyboard navigation
   */
  handleKeydown(event) {
    // Only handle when dropdown is open, except for open triggers
    if (!this.isOpen) {
      // Allow ArrowDown/Space/Enter to open when trigger is focused
      if (this.isTriggerFocused()) {
        if (
          event.key === "ArrowDown" ||
          event.key === "Enter" ||
          event.key === " "
        ) {
          event.preventDefault();
          this.open();
          this.focusFirstItem();
          return;
        }
      }
      return;
    }

    switch (event.key) {
      case "Escape":
        event.preventDefault();
        this.close();
        break;

      case "ArrowDown":
        event.preventDefault();
        this.focusNextItem();
        break;

      case "ArrowUp":
        event.preventDefault();
        this.focusPreviousItem();
        break;

      case "Home":
        event.preventDefault();
        this.focusFirstItem();
        break;

      case "End":
        event.preventDefault();
        this.focusLastItem();
        break;

      case "Enter":
      case " ":
        event.preventDefault();
        this.activateCurrentItem();
        break;

      case "Tab":
        this.close();
        break;
    }
  }

  /**
   * Check if the trigger element or its children are focused
   */
  isTriggerFocused() {
    if (!this.hasTriggerTarget) return false;
    return this.triggerTarget.contains(document.activeElement);
  }

  /**
   * Get all enabled menu items
   */
  get enabledItems() {
    return this.itemTargets.filter(
      (item) => item.getAttribute("aria-disabled") !== "true" && !item.disabled
    );
  }

  /**
   * Focus the next enabled item
   */
  focusNextItem() {
    const items = this.enabledItems;
    if (items.length === 0) return;

    this.currentIndex = this.currentIndex + 1;
    if (this.currentIndex >= items.length) {
      this.currentIndex = 0;
    }

    items[this.currentIndex].focus();
  }

  /**
   * Focus the previous enabled item
   */
  focusPreviousItem() {
    const items = this.enabledItems;
    if (items.length === 0) return;

    this.currentIndex = this.currentIndex - 1;
    if (this.currentIndex < 0) {
      this.currentIndex = items.length - 1;
    }

    items[this.currentIndex].focus();
  }

  /**
   * Focus the first enabled item
   */
  focusFirstItem() {
    const items = this.enabledItems;
    if (items.length === 0) return;

    this.currentIndex = 0;
    items[0].focus();
  }

  /**
   * Focus the last enabled item
   */
  focusLastItem() {
    const items = this.enabledItems;
    if (items.length === 0) return;

    this.currentIndex = items.length - 1;
    items[this.currentIndex].focus();
  }

  /**
   * Activate (click) the currently focused item
   */
  activateCurrentItem() {
    const items = this.enabledItems;
    if (this.currentIndex < 0 || this.currentIndex >= items.length) return;

    const item = items[this.currentIndex];
    this.dispatch("item-selected", { detail: { item }, bubbles: true });

    item.click();

    if (this.closeOnItemClickValue) {
      this.close();
    }
  }

  /**
   * Handle item clicks (connected via action on items)
   */
  itemClicked(event) {
    const item = event.currentTarget;
    if (item.getAttribute("aria-disabled") === "true" || item.disabled) {
      event.preventDefault();
      return;
    }

    this.dispatch("item-selected", { detail: { item }, bubbles: true });

    if (this.closeOnItemClickValue) {
      this.close();
    }
  }
}
