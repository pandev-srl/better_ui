# frozen_string_literal: true

require "test_helper"

module BetterUi
  module Forms
    class CheckboxComponentTest < ActiveSupport::TestCase
      # Basic rendering tests
      test "renders checkbox input with default options" do
        render_inline(CheckboxComponent.new(name: "user[terms]"))

        assert_selector "input[type='checkbox']"
        assert_selector "input[name='user[terms]']"
        assert_selector "input[value='1']"
      end

      test "renders with custom value" do
        render_inline(CheckboxComponent.new(name: "user[option]", value: "custom_value"))

        assert_selector "input[value='custom_value']"
      end

      test "renders as checked" do
        render_inline(CheckboxComponent.new(name: "user[terms]", checked: true))

        assert_selector "input[checked]"
      end

      test "renders as unchecked by default" do
        render_inline(CheckboxComponent.new(name: "user[terms]"))

        refute_selector "input[checked]"
      end

      # Label tests
      test "renders with label" do
        render_inline(CheckboxComponent.new(name: "terms", label: "I agree to the terms"))

        assert_selector "label", text: "I agree to the terms"
      end

      test "renders without label when not provided" do
        render_inline(CheckboxComponent.new(name: "terms"))

        refute_selector "label"
      end

      test "renders label on right by default" do
        render_inline(CheckboxComponent.new(name: "terms", label: "Label text"))

        assert_selector "div.flex-row"
        refute_selector "div.flex-row-reverse"
      end

      test "renders label on left when specified" do
        render_inline(CheckboxComponent.new(name: "terms", label: "Label text", label_position: :left))

        assert_selector "div.flex-row-reverse"
      end

      test "renders required indicator with label" do
        render_inline(CheckboxComponent.new(name: "terms", label: "Terms", required: true))

        assert_selector "label span.text-danger-600", text: "*"
        assert_selector "input[required]"
      end

      # Hint and error tests
      test "renders with hint text" do
        render_inline(CheckboxComponent.new(name: "terms", hint: "Please read before accepting"))

        assert_text "Please read before accepting"
        assert_selector "div.text-gray-600"
      end

      test "renders with errors" do
        render_inline(CheckboxComponent.new(name: "terms", errors: [ "You must accept the terms" ]))

        assert_text "You must accept the terms"
        assert_selector "div.text-danger-600"
        assert_selector "input.border-danger-500"
      end

      test "renders with multiple errors" do
        errors = [ "Error one", "Error two" ]
        render_inline(CheckboxComponent.new(name: "terms", errors: errors))

        assert_text "Error one"
        assert_text "Error two"
      end

      test "filters blank errors" do
        errors = [ "Valid error", "", nil, "Another error" ]
        render_inline(CheckboxComponent.new(name: "terms", errors: errors))

        assert_text "Valid error"
        assert_text "Another error"
      end

      # State tests
      test "renders as disabled" do
        render_inline(CheckboxComponent.new(name: "terms", disabled: true))

        assert_selector "input[disabled]"
        assert_selector "input.cursor-not-allowed"
        assert_selector "input.opacity-60"
      end

      test "renders disabled label style" do
        render_inline(CheckboxComponent.new(name: "terms", label: "Terms", disabled: true))

        assert_selector "label.text-gray-400"
      end

      test "renders as readonly" do
        render_inline(CheckboxComponent.new(name: "terms", readonly: true))

        assert_selector "input[aria-readonly='true']"
        assert_selector "input.pointer-events-none"
      end

      # Size tests
      test "renders xs size" do
        render_inline(CheckboxComponent.new(name: "terms", size: :xs))

        assert_selector "input.w-3.h-3"
        assert_selector "div.gap-1\\.5"
      end

      test "renders sm size" do
        render_inline(CheckboxComponent.new(name: "terms", size: :sm))

        assert_selector "input.w-4.h-4"
        assert_selector "div.gap-2"
      end

      test "renders md size by default" do
        render_inline(CheckboxComponent.new(name: "terms"))

        assert_selector "input.w-5.h-5"
        assert_selector "div.gap-2\\.5"
      end

      test "renders lg size" do
        render_inline(CheckboxComponent.new(name: "terms", size: :lg))

        assert_selector "input.w-6.h-6"
        assert_selector "div.gap-3"
      end

      test "renders xl size" do
        render_inline(CheckboxComponent.new(name: "terms", size: :xl))

        assert_selector "input.w-7.h-7"
        assert_selector "div.gap-3\\.5"
      end

      test "renders label size classes for xs" do
        render_inline(CheckboxComponent.new(name: "terms", label: "Label", size: :xs))

        assert_selector "label.text-xs"
      end

      test "renders label size classes for md" do
        render_inline(CheckboxComponent.new(name: "terms", label: "Label", size: :md))

        assert_selector "label.text-sm"
      end

      test "renders label size classes for xl" do
        render_inline(CheckboxComponent.new(name: "terms", label: "Label", size: :xl))

        assert_selector "label.text-lg"
      end

      # Variant tests
      test "renders primary variant by default" do
        render_inline(CheckboxComponent.new(name: "terms"))

        assert_selector "input.checked\\:bg-primary-600"
        assert_selector "input.focus\\:ring-primary-500"
      end

      test "renders secondary variant" do
        render_inline(CheckboxComponent.new(name: "terms", variant: :secondary))

        assert_selector "input.checked\\:bg-secondary-600"
        assert_selector "input.focus\\:ring-secondary-500"
      end

      test "renders accent variant" do
        render_inline(CheckboxComponent.new(name: "terms", variant: :accent))

        assert_selector "input.checked\\:bg-accent-600"
        assert_selector "input.focus\\:ring-accent-500"
      end

      test "renders success variant" do
        render_inline(CheckboxComponent.new(name: "terms", variant: :success))

        assert_selector "input.checked\\:bg-success-600"
        assert_selector "input.focus\\:ring-success-500"
      end

      test "renders danger variant" do
        render_inline(CheckboxComponent.new(name: "terms", variant: :danger))

        assert_selector "input.checked\\:bg-danger-600"
        assert_selector "input.focus\\:ring-danger-500"
      end

      test "renders warning variant" do
        render_inline(CheckboxComponent.new(name: "terms", variant: :warning))

        assert_selector "input.checked\\:bg-warning-600"
        assert_selector "input.focus\\:ring-warning-500"
      end

      test "renders info variant" do
        render_inline(CheckboxComponent.new(name: "terms", variant: :info))

        assert_selector "input.checked\\:bg-info-600"
        assert_selector "input.focus\\:ring-info-500"
      end

      test "renders light variant" do
        render_inline(CheckboxComponent.new(name: "terms", variant: :light))

        assert_selector "input.checked\\:bg-gray-200"
        assert_selector "input.checked-dark"
      end

      test "renders dark variant" do
        render_inline(CheckboxComponent.new(name: "terms", variant: :dark))

        assert_selector "input.checked\\:bg-gray-800"
        assert_selector "input.focus\\:ring-gray-600"
      end

      # Custom classes tests
      test "renders with custom container classes" do
        render_inline(CheckboxComponent.new(name: "terms", container_classes: "custom-wrapper"))

        assert_selector "div.custom-wrapper"
      end

      test "renders with custom label classes" do
        render_inline(CheckboxComponent.new(name: "terms", label: "Label", label_classes: "custom-label"))

        assert_selector "label.custom-label"
      end

      test "renders with custom checkbox classes" do
        render_inline(CheckboxComponent.new(name: "terms", checkbox_classes: "custom-checkbox"))

        assert_selector "input.custom-checkbox"
      end

      test "renders with custom hint classes" do
        render_inline(CheckboxComponent.new(name: "terms", hint: "Hint", hint_classes: "custom-hint"))

        assert_selector "div.custom-hint"
      end

      test "renders with custom error classes" do
        render_inline(CheckboxComponent.new(name: "terms", errors: [ "Error" ], error_classes: "custom-error"))

        assert_selector "div.custom-error"
      end

      # Additional HTML options tests
      test "passes through additional HTML options" do
        render_inline(CheckboxComponent.new(
          name: "terms",
          id: "custom-terms",
          data: { controller: "custom" },
          aria: { label: "Accept terms" }
        ))

        assert_selector "input#custom-terms"
        assert_selector "input[data-controller='custom']"
        assert_selector "input[aria-label='Accept terms']"
      end

      # Base checkbox classes test
      test "applies base checkbox classes" do
        render_inline(CheckboxComponent.new(name: "terms"))

        assert_selector "input.appearance-none"
        assert_selector "input.shrink-0"
        assert_selector "input.rounded"
        assert_selector "input.border"
        assert_selector "input.cursor-pointer"
        assert_selector "input.transition-colors"
      end

      # Focus state classes test
      test "applies focus ring classes" do
        render_inline(CheckboxComponent.new(name: "terms"))

        assert_selector "input.focus\\:ring-2"
        assert_selector "input.focus\\:ring-offset-2"
        assert_selector "input.focus\\:outline-none"
      end

      # Validation tests
      test "raises error for invalid size" do
        assert_raises(ArgumentError) do
          CheckboxComponent.new(name: "terms", size: :invalid)
        end
      end

      test "raises error for invalid variant" do
        assert_raises(ArgumentError) do
          CheckboxComponent.new(name: "terms", variant: :invalid)
        end
      end

      test "raises error for invalid label_position" do
        assert_raises(ArgumentError) do
          CheckboxComponent.new(name: "terms", label_position: :invalid)
        end
      end

      # Complete form field rendering test
      test "renders complete checkbox with all elements" do
        render_inline(CheckboxComponent.new(
          name: "user[newsletter]",
          value: "yes",
          checked: true,
          label: "Subscribe to newsletter",
          hint: "Receive weekly updates",
          variant: :success,
          size: :md,
          required: true
        ))

        assert_selector "input[type='checkbox']"
        assert_selector "input[name='user[newsletter]']"
        assert_selector "input[value='yes']"
        assert_selector "input[checked]"
        assert_selector "input[required]"
        assert_selector "label", text: "Subscribe to newsletter"
        assert_text "Receive weekly updates"
        assert_selector "input.checked\\:bg-success-600"
      end

      # State priority tests (disabled > readonly > error > normal)
      test "disabled state takes precedence over error state" do
        render_inline(CheckboxComponent.new(name: "terms", disabled: true, errors: [ "Error" ]))

        assert_selector "input.cursor-not-allowed"
        assert_selector "input.opacity-60"
        refute_selector "input.border-danger-500"
      end

      test "readonly state takes precedence over error state" do
        render_inline(CheckboxComponent.new(name: "terms", readonly: true, errors: [ "Error" ]))

        assert_selector "input.pointer-events-none"
        refute_selector "input.border-danger-500"
      end

      # Label association test
      test "label for attribute matches input id" do
        render_inline(CheckboxComponent.new(name: "user[terms]", label: "Terms", id: "terms-checkbox"))

        assert_selector "label[for='terms-checkbox']"
        assert_selector "input#terms-checkbox"
      end

      test "generates input id from name when not provided" do
        render_inline(CheckboxComponent.new(name: "user[terms]", label: "Terms"))

        assert_selector "label[for='user_terms']"
      end
    end
  end
end
