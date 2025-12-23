# frozen_string_literal: true

module BetterUi
  module Forms
    # @label Checkbox
    class CheckboxComponentPreview < ViewComponent::Preview
      # @label Default
      # @display bg_color #f5f5f5
      def default
        render BetterUi::Forms::CheckboxComponent.new(
          name: "newsletter",
          label: "Subscribe to newsletter"
        )
      end

      # @label Checked
      # @display bg_color #f5f5f5
      def checked
        render BetterUi::Forms::CheckboxComponent.new(
          name: "terms",
          label: "I agree to the terms and conditions",
          checked: true
        )
      end

      # @label With Hint
      # @display bg_color #f5f5f5
      def with_hint
        render BetterUi::Forms::CheckboxComponent.new(
          name: "marketing",
          label: "Receive marketing emails",
          hint: "We'll send you occasional updates about new features and promotions."
        )
      end

      # @label With Errors
      # @display bg_color #f5f5f5
      def with_errors
        render BetterUi::Forms::CheckboxComponent.new(
          name: "terms",
          label: "I agree to the terms and conditions",
          errors: [ "You must accept the terms and conditions to continue" ]
        )
      end

      # @label Required Field
      # @display bg_color #f5f5f5
      def required
        render BetterUi::Forms::CheckboxComponent.new(
          name: "terms",
          label: "I agree to the terms and conditions",
          required: true
        )
      end

      # @label Disabled State
      # @display bg_color #f5f5f5
      def disabled
        render BetterUi::Forms::CheckboxComponent.new(
          name: "disabled_option",
          label: "This option is disabled",
          disabled: true,
          checked: true
        )
      end

      # @label Readonly State
      # @display bg_color #f5f5f5
      def readonly
        render BetterUi::Forms::CheckboxComponent.new(
          name: "readonly_option",
          label: "This option is readonly",
          readonly: true,
          checked: true
        )
      end

      # @label Label on Left
      # @display bg_color #f5f5f5
      def label_left
        render BetterUi::Forms::CheckboxComponent.new(
          name: "active",
          label: "Active",
          label_position: :left
        )
      end

      # @label All Sizes
      # @display bg_color #f5f5f5
      def all_sizes
        render_with_template
      end

      # @label All Variants
      # @display bg_color #f5f5f5
      def all_variants
        render_with_template
      end

      # @label Form Integration
      # @display bg_color #f5f5f5
      def form_integration
        render_with_template
      end

      # @label Playground
      # @param variant select { choices: [primary, secondary, accent, success, danger, warning, info, light, dark] }
      # @param size select { choices: [xs, sm, md, lg, xl] }
      # @param label_position select { choices: [left, right] }
      # @param checked toggle
      # @param disabled toggle
      # @param readonly toggle
      # @param required toggle
      # @param with_hint toggle
      # @param with_error toggle
      def playground(
        variant: :primary,
        size: :md,
        label_position: :right,
        checked: false,
        disabled: false,
        readonly: false,
        required: false,
        with_hint: false,
        with_error: false
      )
        render BetterUi::Forms::CheckboxComponent.new(
          name: "playground",
          label: "Playground Checkbox",
          variant: variant.to_sym,
          size: size.to_sym,
          label_position: label_position.to_sym,
          checked: checked,
          disabled: disabled,
          readonly: readonly,
          required: required,
          hint: with_hint ? "This is a helpful hint" : nil,
          errors: with_error ? [ "This field has an error" ] : nil
        )
      end
    end
  end
end
