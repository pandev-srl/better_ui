# frozen_string_literal: true

module BetterUi
  module Forms
    # @label Number Input
    class NumberInputComponentPreview < ViewComponent::Preview
      # @label Default
      # @display bg_color #f5f5f5
      def default
        render BetterUi::Forms::NumberInputComponent.new(
          name: "example",
          label: "Example Number",
          placeholder: "Enter a number"
        )
      end

      # @label With Value
      # @display bg_color #f5f5f5
      def with_value
        render BetterUi::Forms::NumberInputComponent.new(
          name: "age",
          label: "Age",
          value: 25
        )
      end

      # @label With Min, Max, and Step
      # @display bg_color #f5f5f5
      def with_constraints
        render BetterUi::Forms::NumberInputComponent.new(
          name: "price",
          label: "Price",
          placeholder: "0.00",
          min: 0,
          max: 10000,
          step: 0.01,
          hint: "Enter a price between $0 and $10,000"
        )
      end

      # @label With Hint
      # @display bg_color #f5f5f5
      def with_hint
        render BetterUi::Forms::NumberInputComponent.new(
          name: "quantity",
          label: "Quantity",
          hint: "Enter the number of items you want to order",
          min: 1,
          max: 100
        )
      end

      # @label With Errors
      # @display bg_color #f5f5f5
      def with_errors
        render BetterUi::Forms::NumberInputComponent.new(
          name: "age",
          label: "Age",
          value: -5,
          min: 0,
          max: 120,
          errors: [
            "Age must be positive",
            "Age must be a valid number"
          ]
        )
      end

      # @label Required Field
      # @display bg_color #f5f5f5
      def required
        render BetterUi::Forms::NumberInputComponent.new(
          name: "employee_count",
          label: "Number of Employees",
          required: true,
          min: 1,
          placeholder: "Enter number"
        )
      end

      # @label Disabled State
      # @display bg_color #f5f5f5
      def disabled
        render BetterUi::Forms::NumberInputComponent.new(
          name: "disabled_field",
          label: "Disabled Field",
          value: 42,
          disabled: true
        )
      end

      # @label Readonly State
      # @display bg_color #f5f5f5
      def readonly
        render BetterUi::Forms::NumberInputComponent.new(
          name: "readonly_field",
          label: "Readonly Field",
          value: 100,
          readonly: true
        )
      end

      # @label Without Spinners
      # @display bg_color #f5f5f5
      def without_spinners
        render BetterUi::Forms::NumberInputComponent.new(
          name: "price",
          label: "Price (No Spinners)",
          placeholder: "0.00",
          min: 0,
          step: 0.01,
          show_spinner: false,
          hint: "Clean input without up/down arrows"
        )
      end

      # @label With Prefix Icon (Currency)
      # @display bg_color #f5f5f5
      def with_prefix_icon
        render BetterUi::Forms::NumberInputComponent.new(
          name: "price",
          label: "Price",
          placeholder: "0.00",
          min: 0,
          step: 0.01
        ) do |component|
          component.with_prefix_icon do
            '<span class="text-gray-500 text-sm font-medium">$</span>'.html_safe
          end
        end
      end

      # @label With Suffix Icon (Unit)
      # @display bg_color #f5f5f5
      def with_suffix_icon
        render BetterUi::Forms::NumberInputComponent.new(
          name: "weight",
          label: "Weight",
          placeholder: "0",
          min: 0,
          step: 0.1
        ) do |component|
          component.with_suffix_icon do
            '<span class="text-gray-500 text-sm font-medium">kg</span>'.html_safe
          end
        end
      end

      # @label With Both Icons
      # @display bg_color #f5f5f5
      def with_both_icons
        render BetterUi::Forms::NumberInputComponent.new(
          name: "temperature",
          label: "Temperature",
          placeholder: "0",
          min: -100,
          max: 100,
          step: 0.5
        ) do |component|
          component.with_prefix_icon do
            '<svg class="h-5 w-5 text-danger-500" fill="currentColor" viewBox="0 0 20 20">
              <path fill-rule="evenodd" d="M10 2a1 1 0 011 1v1a1 1 0 11-2 0V3a1 1 0 011-1zm4 8a4 4 0 11-8 0 4 4 0 018 0zm-.464 4.95l.707.707a1 1 0 001.414-1.414l-.707-.707a1 1 0 00-1.414 1.414zm2.12-10.607a1 1 0 010 1.414l-.706.707a1 1 0 11-1.414-1.414l.707-.707a1 1 0 011.414 0zM17 11a1 1 0 100-2h-1a1 1 0 100 2h1zm-7 4a1 1 0 011 1v1a1 1 0 11-2 0v-1a1 1 0 011-1zM5.05 6.464A1 1 0 106.465 5.05l-.708-.707a1 1 0 00-1.414 1.414l.707.707zm1.414 8.486l-.707.707a1 1 0 01-1.414-1.414l.707-.707a1 1 0 011.414 1.414zM4 11a1 1 0 100-2H3a1 1 0 000 2h1z" clip-rule="evenodd"/>
            </svg>'.html_safe
          end
          component.with_suffix_icon do
            '<span class="text-gray-500 text-sm font-medium">°C</span>'.html_safe
          end
        end
      end

      # @label All Sizes
      # @display bg_color #f5f5f5
      def all_sizes
        render_with_template
      end

      # @label Form Integration
      # @display bg_color #f5f5f5
      def form_integration
        render_with_template
      end

      # @label Playground
      # @param size select { choices: [xs, sm, md, lg, xl] }
      # @param disabled toggle
      # @param readonly toggle
      # @param required toggle
      # @param show_spinner toggle
      # @param with_hint toggle
      # @param with_error toggle
      # @param with_constraints toggle
      def playground(size: :md, disabled: false, readonly: false, required: false, show_spinner: true, with_hint: false, with_error: false, with_constraints: false)
        render BetterUi::Forms::NumberInputComponent.new(
          name: "playground",
          label: "Playground Number Input",
          placeholder: "Enter a number...",
          size: size.to_sym,
          disabled: disabled,
          readonly: readonly,
          required: required,
          show_spinner: show_spinner,
          min: with_constraints ? 0 : nil,
          max: with_constraints ? 100 : nil,
          step: with_constraints ? 5 : nil,
          hint: with_hint ? "This is a helpful hint" : nil,
          errors: with_error ? [ "This field has an error" ] : nil
        )
      end
    end
  end
end
