# frozen_string_literal: true

module BetterUi
  module Forms
    # @label Password Input
    class PasswordInputComponentPreview < ViewComponent::Preview
      # @label Default
      # @display bg_color #f5f5f5
      def default
        render BetterUi::Forms::PasswordInputComponent.new(
          name: "user[password]",
          label: "Password",
          placeholder: "Enter your password"
        )
      end

      # @label With Value
      # @display bg_color #f5f5f5
      def with_value
        render BetterUi::Forms::PasswordInputComponent.new(
          name: "user[password]",
          label: "Password",
          value: "secret123"
        )
      end

      # @label With Hint
      # @display bg_color #f5f5f5
      def with_hint
        render BetterUi::Forms::PasswordInputComponent.new(
          name: "user[password]",
          label: "Password",
          hint: "Must be at least 8 characters with 1 number and 1 special character",
          placeholder: "Enter your password"
        )
      end

      # @label With Errors
      # @display bg_color #f5f5f5
      def with_errors
        render BetterUi::Forms::PasswordInputComponent.new(
          name: "user[password]",
          label: "Password",
          value: "weak",
          errors: [
            "Password is too short (minimum is 8 characters)",
            "Password must include at least one number",
            "Password must include at least one special character"
          ]
        )
      end

      # @label Required Field
      # @display bg_color #f5f5f5
      def required
        render BetterUi::Forms::PasswordInputComponent.new(
          name: "user[password]",
          label: "Password",
          required: true,
          placeholder: "Enter your password"
        )
      end

      # @label Disabled State
      # @display bg_color #f5f5f5
      def disabled
        render BetterUi::Forms::PasswordInputComponent.new(
          name: "user[password]",
          label: "Password",
          value: "password123",
          disabled: true
        )
      end

      # @label Readonly State
      # @display bg_color #f5f5f5
      def readonly
        render BetterUi::Forms::PasswordInputComponent.new(
          name: "user[password]",
          label: "Password",
          value: "••••••••",
          readonly: true
        )
      end

      # @label With Prefix Icon (Lock)
      # @display bg_color #f5f5f5
      def with_prefix_icon
        render BetterUi::Forms::PasswordInputComponent.new(
          name: "user[password]",
          label: "Password",
          placeholder: "Enter your password"
        ) do |component|
          component.with_prefix_icon do
            '<svg class="h-5 w-5 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 15v2m-6 4h12a2 2 0 002-2v-6a2 2 0 00-2-2H6a2 2 0 00-2 2v6a2 2 0 002 2zm10-10V7a4 4 0 00-8 0v4h8z"/>
            </svg>'.html_safe
          end
        end
      end

      # @label Complete Example
      # @display bg_color #f5f5f5
      def complete_example
        render BetterUi::Forms::PasswordInputComponent.new(
          name: "user[password]",
          label: "Password",
          hint: "Use 8 or more characters with a mix of letters, numbers & symbols",
          placeholder: "Create a strong password",
          required: true
        ) do |component|
          component.with_prefix_icon do
            '<svg class="h-5 w-5 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 15v2m-6 4h12a2 2 0 002-2v-6a2 2 0 00-2-2H6a2 2 0 00-2 2v6a2 2 0 002 2zm10-10V7a4 4 0 00-8 0v4h8z"/>
            </svg>'.html_safe
          end
        end
      end

      # @label Confirm Password Example
      # @display bg_color #f5f5f5
      def confirm_password_example
        render_with_template
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
      # @param with_hint toggle
      # @param with_error toggle
      # @param with_prefix_icon toggle
      def playground(
        size: :md,
        disabled: false,
        readonly: false,
        required: false,
        with_hint: false,
        with_error: false,
        with_prefix_icon: false
      )
        component = BetterUi::Forms::PasswordInputComponent.new(
          name: "user[password]",
          label: "Password",
          placeholder: "Enter your password",
          size: size.to_sym,
          disabled: disabled,
          readonly: readonly,
          required: required,
          hint: with_hint ? "Must be at least 8 characters" : nil,
          errors: with_error ? [ "Password is too weak" ] : nil
        )

        if with_prefix_icon
          render component do |c|
            c.with_prefix_icon do
              '<svg class="h-5 w-5 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 15v2m-6 4h12a2 2 0 002-2v-6a2 2 0 00-2-2H6a2 2 0 00-2 2v6a2 2 0 002 2zm10-10V7a4 4 0 00-8 0v4h8z"/>
              </svg>'.html_safe
            end
          end
        else
          render component
        end
      end
    end
  end
end
