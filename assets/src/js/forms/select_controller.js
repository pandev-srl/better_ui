import { Controller } from "@hotwired/stimulus";

/**
 * Select Stimulus Controller
 *
 * Custom dropdown select with keyboard navigation, type-ahead search,
 * and full ARIA support.
 *
 * Connects to: data-controller="better-ui--forms--select"
 *
 * Targets:
 *   - hiddenInput: Hidden input for form submission
 *   - trigger: Button that opens/closes the dropdown
 *   - display: Span showing selected label or placeholder
 *   - clearButton: Clear selection button (when clearable)
 *   - caret: Chevron icon (rotates when open)
 *   - listbox: UL element containing options
 *   - option: LI option elements
 *
 * Values:
 *   - clearable (Boolean): Show clear button
 *   - placeholder (String): Placeholder text
 *   - disabled (Boolean): Disabled state
 *   - readonly (Boolean): Readonly state
 */
export default class extends Controller {
  static targets = [
    "hiddenInput",
    "trigger",
    "display",
    "clearButton",
    "caret",
    "listbox",
    "option",
  ];

  static values = {
    clearable: { type: Boolean, default: false },
    placeholder: { type: String, default: "Select..." },
    disabled: { type: Boolean, default: false },
    readonly: { type: Boolean, default: false },
  };

  connect() {
    this.isOpen = false;
    this.highlightedIndex = -1;
    this.typeAheadBuffer = "";
    this.typeAheadTimeout = null;

    // Bind click-outside handler
    this.handleClickOutside = this.handleClickOutside.bind(this);
    document.addEventListener("click", this.handleClickOutside);

    // Listen for form reset
    this.handleFormReset = this.handleFormReset.bind(this);
    const form = this.element.closest("form");
    if (form) {
      form.addEventListener("reset", this.handleFormReset);
    }
  }

  disconnect() {
    document.removeEventListener("click", this.handleClickOutside);

    const form = this.element.closest("form");
    if (form) {
      form.removeEventListener("reset", this.handleFormReset);
    }

    if (this.typeAheadTimeout) {
      clearTimeout(this.typeAheadTimeout);
    }
  }

  /**
   * Toggle dropdown open/closed
   */
  toggle() {
    if (this.disabledValue || this.readonlyValue) return;

    if (this.isOpen) {
      this.close();
    } else {
      this.open();
    }
  }

  /**
   * Open the dropdown
   */
  open() {
    if (this.disabledValue || this.readonlyValue) return;

    this.isOpen = true;

    // Show listbox
    this.listboxTarget.classList.remove("hidden");

    // Update ARIA
    this.triggerTarget.setAttribute("aria-expanded", "true");

    // Rotate caret
    if (this.hasCaretTarget) {
      this.caretTarget.querySelector("svg")?.classList.add("rotate-180");
    }

    // Highlight currently selected option
    const selectedIndex = this.optionTargets.findIndex(
      (opt) => opt.getAttribute("aria-selected") === "true"
    );
    if (selectedIndex >= 0) {
      this.highlightOption(selectedIndex);
    }
  }

  /**
   * Close the dropdown
   */
  close() {
    this.isOpen = false;

    // Hide listbox
    this.listboxTarget.classList.add("hidden");

    // Update ARIA
    this.triggerTarget.setAttribute("aria-expanded", "false");
    this.triggerTarget.removeAttribute("aria-activedescendant");

    // Reset caret rotation
    if (this.hasCaretTarget) {
      this.caretTarget.querySelector("svg")?.classList.remove("rotate-180");
    }

    // Remove highlight from all options
    this.highlightedIndex = -1;
    this.optionTargets.forEach((opt) => {
      opt.classList.remove("bg-gray-100");
    });
  }

  /**
   * Select an option from click or keyboard
   */
  selectOption(event) {
    const option =
      event.currentTarget || event.target.closest("[role='option']");
    if (!option) return;

    const value = option.dataset.value;
    const label = option.dataset.label;

    // Update hidden input
    this.hiddenInputTarget.value = value;

    // Update display text
    this.displayTarget.textContent = label;
    this.displayTarget.classList.remove("text-gray-400");
    this.displayTarget.classList.add("text-gray-900");

    // Update aria-selected on all options
    this.optionTargets.forEach((opt) => {
      const isSelected = opt.dataset.value === value;
      opt.setAttribute("aria-selected", isSelected ? "true" : "false");
    });

    // Show clear button if clearable
    if (this.clearableValue && this.hasClearButtonTarget) {
      this.clearButtonTarget.classList.remove("hidden");
      this.clearButtonTarget.classList.add("flex", "items-center", "ml-1");
    }

    // Dispatch change event on hidden input
    this.hiddenInputTarget.dispatchEvent(
      new Event("change", { bubbles: true })
    );
    this.hiddenInputTarget.dispatchEvent(
      new Event("input", { bubbles: true })
    );

    this.close();
    this.triggerTarget.focus();
  }

  /**
   * Clear the current selection
   */
  clear(event) {
    event.stopPropagation();
    event.preventDefault();

    // Reset hidden input
    this.hiddenInputTarget.value = "";

    // Reset display to placeholder
    this.displayTarget.textContent = this.placeholderValue;
    this.displayTarget.classList.remove("text-gray-900");
    this.displayTarget.classList.add("text-gray-400");

    // Reset aria-selected on all options
    this.optionTargets.forEach((opt) => {
      opt.setAttribute("aria-selected", "false");
    });

    // Hide clear button
    if (this.hasClearButtonTarget) {
      this.clearButtonTarget.classList.add("hidden");
      this.clearButtonTarget.classList.remove("flex", "items-center", "ml-1");
    }

    // Dispatch change event
    this.hiddenInputTarget.dispatchEvent(
      new Event("change", { bubbles: true })
    );
    this.hiddenInputTarget.dispatchEvent(
      new Event("input", { bubbles: true })
    );

    this.triggerTarget.focus();
  }

  /**
   * Handle keydown on the trigger button
   */
  handleTriggerKeydown(event) {
    if (this.disabledValue || this.readonlyValue) return;

    switch (event.key) {
      case "Enter":
      case " ":
      case "ArrowDown":
      case "ArrowUp":
        event.preventDefault();
        if (!this.isOpen) {
          this.open();
          // If ArrowUp, highlight last option; otherwise first
          if (event.key === "ArrowUp") {
            this.highlightOption(this.optionTargets.length - 1);
          } else {
            const selectedIndex = this.optionTargets.findIndex(
              (opt) => opt.getAttribute("aria-selected") === "true"
            );
            this.highlightOption(selectedIndex >= 0 ? selectedIndex : 0);
          }
          // Move focus to listbox for keyboard nav
          if (this.highlightedIndex >= 0) {
            this.optionTargets[this.highlightedIndex]?.focus();
          }
        }
        break;
      case "Escape":
        if (this.isOpen) {
          event.preventDefault();
          this.close();
        }
        break;
      default:
        // Type-ahead: printable characters
        if (event.key.length === 1 && !event.ctrlKey && !event.metaKey) {
          event.preventDefault();
          if (!this.isOpen) {
            this.open();
          }
          this.typeAhead(event.key);
        }
        break;
    }
  }

  /**
   * Handle keydown on the listbox (when an option is focused)
   */
  handleListboxKeydown(event) {
    switch (event.key) {
      case "ArrowDown":
        event.preventDefault();
        this.highlightOption(
          Math.min(this.highlightedIndex + 1, this.optionTargets.length - 1)
        );
        this.optionTargets[this.highlightedIndex]?.focus();
        break;
      case "ArrowUp":
        event.preventDefault();
        this.highlightOption(Math.max(this.highlightedIndex - 1, 0));
        this.optionTargets[this.highlightedIndex]?.focus();
        break;
      case "Home":
        event.preventDefault();
        this.highlightOption(0);
        this.optionTargets[this.highlightedIndex]?.focus();
        break;
      case "End":
        event.preventDefault();
        this.highlightOption(this.optionTargets.length - 1);
        this.optionTargets[this.highlightedIndex]?.focus();
        break;
      case "Enter":
      case " ":
        event.preventDefault();
        if (this.highlightedIndex >= 0) {
          const option = this.optionTargets[this.highlightedIndex];
          this.selectOption({ currentTarget: option });
        }
        break;
      case "Escape":
        event.preventDefault();
        this.close();
        this.triggerTarget.focus();
        break;
      case "Tab":
        this.close();
        break;
      default:
        // Type-ahead in listbox
        if (event.key.length === 1 && !event.ctrlKey && !event.metaKey) {
          event.preventDefault();
          this.typeAhead(event.key);
        }
        break;
    }
  }

  /**
   * Handle click outside to close dropdown
   */
  handleClickOutside(event) {
    if (!this.isOpen) return;

    if (!this.element.contains(event.target)) {
      this.close();
    }
  }

  /**
   * Handle form reset
   */
  handleFormReset() {
    // Delay to run after form reset has cleared values
    setTimeout(() => {
      const value = this.hiddenInputTarget.value;

      if (value) {
        // Find matching option and display its label
        const option = this.optionTargets.find(
          (opt) => opt.dataset.value === value
        );
        if (option) {
          this.displayTarget.textContent = option.dataset.label;
          this.displayTarget.classList.remove("text-gray-400");
          this.displayTarget.classList.add("text-gray-900");
        }
      } else {
        // Reset to placeholder
        this.displayTarget.textContent = this.placeholderValue;
        this.displayTarget.classList.remove("text-gray-900");
        this.displayTarget.classList.add("text-gray-400");
      }

      // Reset aria-selected
      this.optionTargets.forEach((opt) => {
        opt.setAttribute(
          "aria-selected",
          opt.dataset.value === value ? "true" : "false"
        );
      });

      // Update clear button visibility
      if (this.clearableValue && this.hasClearButtonTarget) {
        if (value) {
          this.clearButtonTarget.classList.remove("hidden");
        } else {
          this.clearButtonTarget.classList.add("hidden");
        }
      }
    }, 0);
  }

  /**
   * Type-ahead search: accumulate typed characters and find matching option
   */
  typeAhead(char) {
    // Clear existing timeout
    if (this.typeAheadTimeout) {
      clearTimeout(this.typeAheadTimeout);
    }

    // Accumulate buffer
    this.typeAheadBuffer += char.toLowerCase();

    // Find first option starting with buffer
    const matchIndex = this.optionTargets.findIndex((opt) =>
      (opt.dataset.label || opt.textContent.trim())
        .toLowerCase()
        .startsWith(this.typeAheadBuffer)
    );

    if (matchIndex >= 0) {
      this.highlightOption(matchIndex);
      this.optionTargets[matchIndex]?.focus();
    }

    // Clear buffer after 500ms of inactivity
    this.typeAheadTimeout = setTimeout(() => {
      this.typeAheadBuffer = "";
    }, 500);
  }

  /**
   * Highlight an option at the given index
   */
  highlightOption(index) {
    if (index < 0 || index >= this.optionTargets.length) return;

    // Remove previous highlight
    this.optionTargets.forEach((opt) => {
      opt.classList.remove("bg-gray-100");
    });

    // Add highlight to new option
    this.highlightedIndex = index;
    const option = this.optionTargets[index];
    option.classList.add("bg-gray-100");

    // Update aria-activedescendant on trigger
    this.triggerTarget.setAttribute("aria-activedescendant", option.id);

    // Scroll into view
    option.scrollIntoView({ block: "nearest" });
  }
}
