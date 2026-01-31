# frozen_string_literal: true

require "test_helper"

module BetterUi
  module Forms
    class SelectComponentTest < ActiveSupport::TestCase
      COUNTRIES = [
        [ "Italy", "it" ],
        [ "France", "fr" ],
        [ "Germany", "de" ],
        [ "Spain", "es" ]
      ].freeze

      # ==========================================
      # Basic rendering
      # ==========================================

      test "renders hidden input with name" do
        render_inline(SelectComponent.new(name: "user[country]", collection: COUNTRIES))

        assert_selector "input[type='hidden'][name='user[country]']"
      end

      test "renders trigger button with role combobox" do
        render_inline(SelectComponent.new(name: "country", collection: COUNTRIES))

        assert_selector "button[role='combobox']"
      end

      test "renders listbox with options" do
        render_inline(SelectComponent.new(name: "country", collection: COUNTRIES))

        assert_selector "ul[role='listbox']"
        assert_selector "li[role='option']", count: 4
      end

      test "renders options with correct data attributes" do
        render_inline(SelectComponent.new(name: "country", collection: COUNTRIES))

        assert_selector "li[data-value='it']"
        assert_selector "li[data-value='fr']"
        assert_text "Italy"
        assert_text "France"
      end

      test "renders hidden input with value when provided" do
        render_inline(SelectComponent.new(name: "country", collection: COUNTRIES, value: "fr"))

        assert_selector "input[type='hidden'][value='fr']"
      end

      test "displays selected label when value matches collection item" do
        render_inline(SelectComponent.new(name: "country", collection: COUNTRIES, value: "fr"))

        assert_text "France"
      end

      test "displays placeholder when no value selected" do
        render_inline(SelectComponent.new(name: "country", collection: COUNTRIES, placeholder: "Select a country"))

        assert_text "Select a country"
      end

      test "displays default placeholder when none specified" do
        render_inline(SelectComponent.new(name: "country", collection: COUNTRIES))

        assert_text "Select..."
      end

      # ==========================================
      # Collection formats
      # ==========================================

      test "handles simple array collection" do
        render_inline(SelectComponent.new(name: "color", collection: [ "Red", "Blue", "Green" ]))

        assert_selector "li[role='option']", count: 3
        assert_selector "li[data-value='Red']"
        assert_text "Red"
      end

      test "handles label/value pair collection" do
        render_inline(SelectComponent.new(name: "country", collection: COUNTRIES))

        assert_selector "li[data-value='it']"
        assert_text "Italy"
      end

      test "handles empty collection" do
        render_inline(SelectComponent.new(name: "country", collection: []))

        assert_selector "ul[role='listbox']"
        refute_selector "li[role='option']"
      end

      # ==========================================
      # Label, hint, errors
      # ==========================================

      test "renders label when provided" do
        render_inline(SelectComponent.new(name: "country", collection: COUNTRIES, label: "Country"))

        assert_selector "label", text: "Country"
      end

      test "does not render label when not provided" do
        render_inline(SelectComponent.new(name: "country", collection: COUNTRIES))

        refute_selector "label"
      end

      test "renders required asterisk in label" do
        render_inline(SelectComponent.new(name: "country", collection: COUNTRIES, label: "Country", required: true))

        assert_selector "label"
        assert_selector "span.text-danger-600", text: "*"
      end

      test "renders hint text" do
        render_inline(SelectComponent.new(name: "country", collection: COUNTRIES, hint: "Select your country"))

        assert_text "Select your country"
        assert_selector "div.text-gray-600"
      end

      test "renders error messages" do
        render_inline(SelectComponent.new(name: "country", collection: COUNTRIES, errors: [ "Country is required" ]))

        assert_text "Country is required"
        assert_selector "div.text-danger-600"
      end

      test "renders multiple errors" do
        errors = [ "Country is required", "Country is invalid" ]
        render_inline(SelectComponent.new(name: "country", collection: COUNTRIES, errors: errors))

        assert_text "Country is required"
        assert_text "Country is invalid"
      end

      # ==========================================
      # States
      # ==========================================

      test "renders disabled state" do
        render_inline(SelectComponent.new(name: "country", collection: COUNTRIES, disabled: true))

        assert_selector "button[disabled]"
        assert_selector "button.cursor-not-allowed"
        assert_selector "button.opacity-60"
      end

      test "renders readonly state" do
        render_inline(SelectComponent.new(name: "country", collection: COUNTRIES, readonly: true))

        assert_selector "button[aria-readonly='true']"
        assert_selector "button.bg-gray-50"
        assert_selector "button.cursor-default"
      end

      test "renders error state styling on trigger" do
        render_inline(SelectComponent.new(name: "country", collection: COUNTRIES, errors: [ "Error" ]))

        assert_selector "button.border-danger-500"
      end

      test "disabled state takes priority over error" do
        render_inline(SelectComponent.new(name: "country", collection: COUNTRIES, disabled: true, errors: [ "Error" ]))

        assert_selector "button.cursor-not-allowed"
        refute_selector "button.border-danger-500"
      end

      test "readonly state takes priority over error" do
        render_inline(SelectComponent.new(name: "country", collection: COUNTRIES, readonly: true, errors: [ "Error" ]))

        assert_selector "button.bg-gray-50"
        refute_selector "button.border-danger-500"
      end

      # ==========================================
      # Sizes
      # ==========================================

      test "renders xs size" do
        render_inline(SelectComponent.new(name: "country", collection: COUNTRIES, size: :xs))

        assert_selector "button.text-xs"
        assert_selector "button.py-1"
      end

      test "renders sm size" do
        render_inline(SelectComponent.new(name: "country", collection: COUNTRIES, size: :sm))

        assert_selector "button.text-sm"
      end

      test "renders md size by default" do
        render_inline(SelectComponent.new(name: "country", collection: COUNTRIES))

        assert_selector "button.text-base"
        assert_selector "button.py-2"
      end

      test "renders lg size" do
        render_inline(SelectComponent.new(name: "country", collection: COUNTRIES, size: :lg))

        assert_selector "button.text-lg"
      end

      test "renders xl size" do
        render_inline(SelectComponent.new(name: "country", collection: COUNTRIES, size: :xl))

        assert_selector "button.text-xl"
      end

      test "raises ArgumentError for invalid size" do
        assert_raises(ArgumentError) do
          SelectComponent.new(name: "country", collection: COUNTRIES, size: :xxl)
        end
      end

      # ==========================================
      # Clearable
      # ==========================================

      test "does not show clear button by default" do
        render_inline(SelectComponent.new(name: "country", collection: COUNTRIES, value: "it"))

        refute_selector "[data-better-ui--forms--select-target='clearButton']"
      end

      test "shows clear button when clearable and value present" do
        render_inline(SelectComponent.new(name: "country", collection: COUNTRIES, value: "it", clearable: true))

        assert_selector "[data-better-ui--forms--select-target='clearButton']"
      end

      test "hides clear button when clearable but no value" do
        render_inline(SelectComponent.new(name: "country", collection: COUNTRIES, clearable: true))

        # The clear button exists but is hidden
        assert_selector "[data-better-ui--forms--select-target='clearButton'].hidden"
      end

      # ==========================================
      # Prefix icon slot
      # ==========================================

      test "renders prefix icon when provided" do
        render_inline(SelectComponent.new(name: "country", collection: COUNTRIES)) do |component|
          component.with_prefix_icon { '<svg class="test-icon"></svg>'.html_safe }
        end

        assert_selector "svg.test-icon"
      end

      # ==========================================
      # Custom classes
      # ==========================================

      test "applies custom container classes" do
        render_inline(SelectComponent.new(name: "country", collection: COUNTRIES, container_classes: "my-custom-wrapper"))

        assert_selector "div.my-custom-wrapper"
      end

      test "applies custom label classes" do
        render_inline(SelectComponent.new(name: "country", collection: COUNTRIES, label: "Country", label_classes: "custom-label"))

        assert_selector "label.custom-label"
      end

      test "applies custom input classes to trigger" do
        render_inline(SelectComponent.new(name: "country", collection: COUNTRIES, input_classes: "custom-trigger"))

        assert_selector "button.custom-trigger"
      end

      test "applies custom hint classes" do
        render_inline(SelectComponent.new(name: "country", collection: COUNTRIES, hint: "Hint", hint_classes: "custom-hint"))

        assert_selector "div.custom-hint"
      end

      test "applies custom error classes" do
        render_inline(SelectComponent.new(name: "country", collection: COUNTRIES, errors: [ "Error" ], error_classes: "custom-error"))

        assert_selector "div.custom-error"
      end

      test "applies custom dropdown classes" do
        render_inline(SelectComponent.new(name: "country", collection: COUNTRIES, dropdown_classes: "custom-dropdown"))

        assert_selector "ul.custom-dropdown"
      end

      # ==========================================
      # Stimulus controller
      # ==========================================

      test "renders Stimulus controller wrapper" do
        render_inline(SelectComponent.new(name: "country", collection: COUNTRIES))

        assert_selector "[data-controller='better-ui--forms--select']"
      end

      test "renders Stimulus targets" do
        render_inline(SelectComponent.new(name: "country", collection: COUNTRIES))

        assert_selector "[data-better-ui--forms--select-target='hiddenInput']"
        assert_selector "[data-better-ui--forms--select-target='trigger']"
        assert_selector "[data-better-ui--forms--select-target='display']"
        assert_selector "[data-better-ui--forms--select-target='caret']"
        assert_selector "[data-better-ui--forms--select-target='listbox']"
      end

      test "renders Stimulus actions on trigger" do
        render_inline(SelectComponent.new(name: "country", collection: COUNTRIES))

        assert_selector "button[data-action*='better-ui--forms--select#toggle']"
      end

      test "renders Stimulus actions on options" do
        render_inline(SelectComponent.new(name: "country", collection: COUNTRIES))

        assert_selector "li[data-action*='better-ui--forms--select#selectOption']"
      end

      test "renders clearable Stimulus value" do
        render_inline(SelectComponent.new(name: "country", collection: COUNTRIES, clearable: true))

        assert_selector "[data-better-ui--forms--select-clearable-value='true']"
      end

      # ==========================================
      # Shadow
      # ==========================================

      test "renders with default shadow-sm" do
        render_inline(SelectComponent.new(name: "country", collection: COUNTRIES))

        assert_selector "button.shadow-sm"
      end

      test "renders with custom shadow" do
        render_inline(SelectComponent.new(name: "country", collection: COUNTRIES, shadow: :md))

        assert_selector "button.shadow-md"
      end

      test "renders without shadow when disabled" do
        render_inline(SelectComponent.new(name: "country", collection: COUNTRIES, shadow: false))

        refute_selector "button.shadow-sm"
        refute_selector "button.shadow-md"
      end

      # ==========================================
      # ARIA attributes
      # ==========================================

      test "trigger has aria-expanded false by default" do
        render_inline(SelectComponent.new(name: "country", collection: COUNTRIES))

        assert_selector "button[aria-expanded='false']"
      end

      test "trigger has aria-haspopup listbox" do
        render_inline(SelectComponent.new(name: "country", collection: COUNTRIES))

        assert_selector "button[aria-haspopup='listbox']"
      end

      test "options have aria-selected attribute" do
        render_inline(SelectComponent.new(name: "country", collection: COUNTRIES, value: "it"))

        assert_selector "li[data-value='it'][aria-selected='true']"
        assert_selector "li[data-value='fr'][aria-selected='false']"
      end

      test "listbox has proper id for aria-controls" do
        render_inline(SelectComponent.new(name: "country", collection: COUNTRIES))

        # Trigger has aria-controls pointing to listbox id
        assert_selector "button[aria-controls]"
        assert_selector "ul[id]"
      end

      # ==========================================
      # HTML attributes passthrough
      # ==========================================

      test "passes through id attribute" do
        render_inline(SelectComponent.new(name: "country", collection: COUNTRIES, id: "my-select"))

        assert_selector "input[id='my-select']"
      end

      test "passes through data attributes" do
        render_inline(SelectComponent.new(name: "country", collection: COUNTRIES, data: { custom: "value" }))

        assert_selector "input[data-custom='value']"
      end

      # ==========================================
      # Base input classes
      # ==========================================

      test "trigger has base input classes" do
        render_inline(SelectComponent.new(name: "country", collection: COUNTRIES))

        assert_selector "button.w-full"
        assert_selector "button.rounded-md"
        assert_selector "button.border"
      end

      test "trigger has cursor-pointer class" do
        render_inline(SelectComponent.new(name: "country", collection: COUNTRIES))

        assert_selector "button.cursor-pointer"
      end

      test "trigger has flex layout" do
        render_inline(SelectComponent.new(name: "country", collection: COUNTRIES))

        assert_selector "button.flex.items-center"
      end

      test "trigger has text-left alignment" do
        render_inline(SelectComponent.new(name: "country", collection: COUNTRIES))

        assert_selector "button.text-left"
      end

      # ==========================================
      # Caret icon
      # ==========================================

      test "renders caret icon" do
        render_inline(SelectComponent.new(name: "country", collection: COUNTRIES))

        assert_selector "[data-better-ui--forms--select-target='caret'] svg"
      end

      # ==========================================
      # Dropdown styling
      # ==========================================

      test "dropdown is hidden by default" do
        render_inline(SelectComponent.new(name: "country", collection: COUNTRIES))

        assert_selector "ul.hidden"
      end

      test "dropdown has positioning classes" do
        render_inline(SelectComponent.new(name: "country", collection: COUNTRIES))

        assert_selector "ul.absolute"
        assert_selector "ul.z-50"
        assert_selector "ul.w-full"
      end
    end
  end
end
