import { Controller } from "@hotwired/stimulus";

/**
 * Tabs Container Stimulus Controller
 *
 * Handles tab switching behavior in two modes:
 * - JS mode: Client-side tab switching with all content in DOM
 * - Turbo mode: Navigation via Turbo Frames (content loaded from server)
 *
 * Connects to: data-controller="better-ui--tabs--container"
 *
 * Values:
 *   - mode (String): Operating mode ("js" or "turbo")
 *   - defaultTab (String): ID of the default active tab
 *   - persist (Boolean): Whether to persist active tab state
 *   - persistKey (String): localStorage key for persistence
 *   - frameId (String): Turbo Frame ID for turbo mode
 *
 * Targets:
 *   - tab: Individual tab elements
 *   - panel: Panel elements (JS mode only)
 *
 * Actions:
 *   - selectTab: Activate a tab on click
 *   - handleKeydown: Handle keyboard navigation (arrows, Home, End)
 *
 * @example HTML usage (JS mode)
 *   <div data-controller="better-ui--tabs--container"
 *        data-better-ui--tabs--container-mode-value="js">
 *     <button data-better-ui--tabs--container-target="tab"
 *             data-tab-id="profile"
 *             data-action="click->better-ui--tabs--container#selectTab">
 *       Profile
 *     </button>
 *     <div data-better-ui--tabs--container-target="panel"
 *          data-panel-id="profile">
 *       Profile content
 *     </div>
 *   </div>
 */
export default class extends Controller {
  // Stimulus Targets API
  static targets = ["tab", "panel", "loader", "loaderOverlay"];

  // Stimulus Values API
  static values = {
    mode: { type: String, default: "js" },
    defaultTab: { type: String, default: "" },
    persist: { type: Boolean, default: false },
    persistKey: { type: String, default: "" },
    frameId: { type: String, default: "" },
    showLoading: { type: Boolean, default: true },
    loaderDelay: { type: Number, default: 1000 },
  };

  /**
   * Lifecycle: Called when controller is connected to the DOM
   * Initializes the active tab state and sets up Turbo listeners
   */
  connect() {
    this.initializeActiveTab();
    this.setupTurboListeners();
  }

  /**
   * Lifecycle: Called when controller is disconnected from the DOM
   * Cleans up Turbo event listeners
   */
  disconnect() {
    this.teardownTurboListeners();
  }

  /**
   * Initialize the active tab based on:
   * 1. URL hash (if persist is enabled)
   * 2. localStorage (if persist and persistKey are set)
   * 3. defaultTab value
   * 4. First tab with aria-selected="true"
   * 5. First available tab
   */
  initializeActiveTab() {
    let activeTabId = null;

    // Check URL hash first
    if (this.persistValue && window.location.hash) {
      const hashId = window.location.hash.slice(1);
      if (this.findTabById(hashId)) {
        activeTabId = hashId;
      }
    }

    // Check localStorage
    if (!activeTabId && this.persistValue && this.persistKeyValue) {
      const storedId = localStorage.getItem(this.persistKeyValue);
      if (storedId && this.findTabById(storedId)) {
        activeTabId = storedId;
      }
    }

    // Use defaultTab value
    if (!activeTabId && this.defaultTabValue) {
      activeTabId = this.defaultTabValue;
    }

    // Find currently active tab (aria-selected="true")
    if (!activeTabId) {
      const activeTab = this.tabTargets.find(
        (tab) => tab.getAttribute("aria-selected") === "true"
      );
      if (activeTab) {
        activeTabId = activeTab.dataset.tabId;
      }
    }

    // Fallback to first tab
    if (!activeTabId && this.tabTargets.length > 0) {
      activeTabId = this.tabTargets[0].dataset.tabId;
    }

    // Activate the determined tab
    if (activeTabId) {
      this.activateTab(activeTabId);
    }
  }

  /**
   * Action: Select a tab on click
   * @param {Event} event - Click event
   */
  selectTab(event) {
    const tab = event.currentTarget;
    const tabId = tab.dataset.tabId;

    // Check if disabled
    if (tab.hasAttribute("disabled") || tab.getAttribute("aria-disabled") === "true") {
      event.preventDefault();
      return;
    }

    // For JS mode, prevent default and handle switching
    if (this.modeValue === "js") {
      event.preventDefault();
      this.activateTab(tabId);
    } else {
      // For Turbo mode, let the link navigate but update state
      this.updateTabState(tabId);
    }

    // Persist if enabled
    this.persistActiveTab(tabId);
  }

  /**
   * Action: Handle keyboard navigation
   * @param {KeyboardEvent} event - Keyboard event
   */
  handleKeydown(event) {
    const currentTab = event.currentTarget;
    const currentIndex = this.tabTargets.indexOf(currentTab);
    let newIndex = currentIndex;

    switch (event.key) {
      case "ArrowLeft":
      case "ArrowUp":
        event.preventDefault();
        newIndex = this.findPreviousEnabledTab(currentIndex);
        break;
      case "ArrowRight":
      case "ArrowDown":
        event.preventDefault();
        newIndex = this.findNextEnabledTab(currentIndex);
        break;
      case "Home":
        event.preventDefault();
        newIndex = this.findFirstEnabledTab();
        break;
      case "End":
        event.preventDefault();
        newIndex = this.findLastEnabledTab();
        break;
      case "Enter":
      case " ":
        event.preventDefault();
        this.selectTab(event);
        return;
      default:
        return;
    }

    if (newIndex !== currentIndex && newIndex !== -1) {
      const newTab = this.tabTargets[newIndex];
      newTab.focus();

      // Automatically select on focus for better UX
      const tabId = newTab.dataset.tabId;
      if (this.modeValue === "js") {
        this.activateTab(tabId);
      }
      this.persistActiveTab(tabId);
    }
  }

  /**
   * Activate a tab by its ID
   * @param {string} tabId - The tab ID to activate
   */
  activateTab(tabId) {
    this.updateTabState(tabId);

    // In JS mode, also update panels
    if (this.modeValue === "js") {
      this.updatePanelState(tabId);
    }
  }

  /**
   * Update tab states (aria-selected, tabindex, classes)
   * @param {string} activeTabId - The active tab ID
   */
  updateTabState(activeTabId) {
    this.tabTargets.forEach((tab) => {
      const isActive = tab.dataset.tabId === activeTabId;
      const activeClasses = tab.dataset.activeClasses?.split(" ") || [];
      const inactiveClasses = tab.dataset.inactiveClasses?.split(" ") || [];

      // Update ARIA
      tab.setAttribute("aria-selected", isActive.toString());
      tab.setAttribute("tabindex", isActive ? "0" : "-1");

      // Update visual state via data attribute for CSS
      tab.dataset.active = isActive.toString();

      // Toggle CSS classes
      if (isActive) {
        // Remove inactive classes, add active classes
        inactiveClasses.forEach((cls) => {
          if (cls) tab.classList.remove(cls);
        });
        activeClasses.forEach((cls) => {
          if (cls) tab.classList.add(cls);
        });
      } else {
        // Remove active classes, add inactive classes
        activeClasses.forEach((cls) => {
          if (cls) tab.classList.remove(cls);
        });
        inactiveClasses.forEach((cls) => {
          if (cls) tab.classList.add(cls);
        });
      }
    });
  }

  /**
   * Update panel visibility (JS mode only)
   * @param {string} activePanelId - The active panel ID
   */
  updatePanelState(activePanelId) {
    this.panelTargets.forEach((panel) => {
      const isActive = panel.dataset.panelId === activePanelId;

      if (isActive) {
        panel.classList.remove("hidden");
        panel.removeAttribute("hidden");
      } else {
        panel.classList.add("hidden");
        panel.setAttribute("hidden", "");
      }
    });
  }

  /**
   * Find a tab by its ID
   * @param {string} tabId - The tab ID to find
   * @returns {HTMLElement|undefined} The tab element or undefined
   */
  findTabById(tabId) {
    return this.tabTargets.find((tab) => tab.dataset.tabId === tabId);
  }

  /**
   * Find the previous enabled tab index
   * @param {number} currentIndex - Current tab index
   * @returns {number} Previous enabled tab index or -1
   */
  findPreviousEnabledTab(currentIndex) {
    for (let i = currentIndex - 1; i >= 0; i--) {
      if (!this.isTabDisabled(this.tabTargets[i])) {
        return i;
      }
    }
    // Wrap around
    for (let i = this.tabTargets.length - 1; i > currentIndex; i--) {
      if (!this.isTabDisabled(this.tabTargets[i])) {
        return i;
      }
    }
    return currentIndex;
  }

  /**
   * Find the next enabled tab index
   * @param {number} currentIndex - Current tab index
   * @returns {number} Next enabled tab index or -1
   */
  findNextEnabledTab(currentIndex) {
    for (let i = currentIndex + 1; i < this.tabTargets.length; i++) {
      if (!this.isTabDisabled(this.tabTargets[i])) {
        return i;
      }
    }
    // Wrap around
    for (let i = 0; i < currentIndex; i++) {
      if (!this.isTabDisabled(this.tabTargets[i])) {
        return i;
      }
    }
    return currentIndex;
  }

  /**
   * Find the first enabled tab index
   * @returns {number} First enabled tab index or -1
   */
  findFirstEnabledTab() {
    return this.tabTargets.findIndex((tab) => !this.isTabDisabled(tab));
  }

  /**
   * Find the last enabled tab index
   * @returns {number} Last enabled tab index or -1
   */
  findLastEnabledTab() {
    for (let i = this.tabTargets.length - 1; i >= 0; i--) {
      if (!this.isTabDisabled(this.tabTargets[i])) {
        return i;
      }
    }
    return -1;
  }

  /**
   * Check if a tab is disabled
   * @param {HTMLElement} tab - The tab element
   * @returns {boolean} Whether the tab is disabled
   */
  isTabDisabled(tab) {
    return tab.hasAttribute("disabled") || tab.getAttribute("aria-disabled") === "true";
  }

  /**
   * Persist the active tab state
   * @param {string} tabId - The tab ID to persist
   */
  persistActiveTab(tabId) {
    if (!this.persistValue) return;

    // Update URL hash
    if (window.history.replaceState) {
      const url = new URL(window.location);
      url.hash = tabId;
      window.history.replaceState(null, "", url);
    }

    // Update localStorage if key is set
    if (this.persistKeyValue) {
      try {
        localStorage.setItem(this.persistKeyValue, tabId);
      } catch (e) {
        // localStorage might be disabled or full
        console.warn("Could not persist tab state:", e);
      }
    }
  }

  /**
   * Set up Turbo event listeners for loading indicator
   * Only active in turbo mode with showLoading enabled
   */
  setupTurboListeners() {
    if (this.modeValue !== "turbo" || !this.showLoadingValue || !this.frameIdValue) {
      return;
    }

    this.turboFrame = document.getElementById(this.frameIdValue);
    if (!this.turboFrame) return;

    this.boundShowLoader = this.showLoader.bind(this);
    this.boundHideLoader = this.hideLoader.bind(this);

    this.turboFrame.addEventListener("turbo:before-fetch-request", this.boundShowLoader);
    this.turboFrame.addEventListener("turbo:frame-load", this.boundHideLoader);
    this.turboFrame.addEventListener("turbo:fetch-request-error", this.boundHideLoader);
  }

  /**
   * Remove Turbo event listeners
   */
  teardownTurboListeners() {
    if (this.turboFrame) {
      this.turboFrame.removeEventListener("turbo:before-fetch-request", this.boundShowLoader);
      this.turboFrame.removeEventListener("turbo:frame-load", this.boundHideLoader);
      this.turboFrame.removeEventListener("turbo:fetch-request-error", this.boundHideLoader);
    }
  }

  /**
   * Show the loading overlay positioned over the Turbo Frame.
   * Uses loaderDelay value to delay showing the loader, so it only
   * appears for slow-loading content.
   */
  showLoader() {
    if (!this.hasLoaderTarget || !this.turboFrame) return;

    // Clear any existing timeout
    if (this.loaderTimeoutId) {
      clearTimeout(this.loaderTimeoutId);
      this.loaderTimeoutId = null;
    }

    const delay = this.loaderDelayValue || 0;

    if (delay > 0) {
      this.loaderTimeoutId = setTimeout(() => {
        this._displayLoader();
      }, delay);
    } else {
      this._displayLoader();
    }
  }

  /**
   * Actually display the loader overlay.
   * @private
   */
  _displayLoader() {
    if (!this.hasLoaderTarget || !this.turboFrame) return;

    // Position the overlay over the Turbo Frame
    const rect = this.turboFrame.getBoundingClientRect();
    const overlay = this.hasLoaderOverlayTarget ? this.loaderOverlayTarget : this.loaderTarget.firstElementChild;

    if (overlay) {
      overlay.style.position = "fixed";
      overlay.style.top = `${rect.top}px`;
      overlay.style.left = `${rect.left}px`;
      overlay.style.width = `${rect.width}px`;
      overlay.style.height = `${rect.height}px`;
    }

    this.loaderTarget.classList.remove("hidden");
    this.loaderTarget.setAttribute("aria-hidden", "false");
  }

  /**
   * Hide the loading overlay.
   * Also clears any pending timeout if the loader hasn't shown yet.
   */
  hideLoader() {
    // Clear timeout if loader hasn't shown yet
    if (this.loaderTimeoutId) {
      clearTimeout(this.loaderTimeoutId);
      this.loaderTimeoutId = null;
    }

    if (!this.hasLoaderTarget) return;

    this.loaderTarget.classList.add("hidden");
    this.loaderTarget.setAttribute("aria-hidden", "true");
  }
}
