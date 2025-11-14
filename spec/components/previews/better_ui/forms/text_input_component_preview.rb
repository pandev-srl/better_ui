# frozen_string_literal: true

module BetterUi
  module Forms
    # @label Text Input
    class TextInputComponentPreview < ViewComponent::Preview
      # @label Default
      # @display bg_color #f5f5f5
      def default
        render BetterUi::Forms::TextInputComponent.new(
          name: "example",
          label: "Example Field",
          placeholder: "Enter text here"
        )
      end

      # @label With Value
      # @display bg_color #f5f5f5
      def with_value
        render BetterUi::Forms::TextInputComponent.new(
          name: "example",
          label: "Name",
          value: "John Doe"
        )
      end

      # @label With Hint
      # @display bg_color #f5f5f5
      def with_hint
        render BetterUi::Forms::TextInputComponent.new(
          name: "email",
          label: "Email Address",
          hint: "We'll never share your email with anyone else.",
          placeholder: "you@example.com"
        )
      end

      # @label With Errors
      # @display bg_color #f5f5f5
      def with_errors
        render BetterUi::Forms::TextInputComponent.new(
          name: "email",
          label: "Email Address",
          value: "invalid-email",
          errors: [
            "Email can't be blank",
            "Email is invalid"
          ]
        )
      end

      # @label Required Field
      # @display bg_color #f5f5f5
      def required
        render BetterUi::Forms::TextInputComponent.new(
          name: "username",
          label: "Username",
          required: true,
          placeholder: "Enter your username"
        )
      end

      # @label Disabled State
      # @display bg_color #f5f5f5
      def disabled
        render BetterUi::Forms::TextInputComponent.new(
          name: "disabled_field",
          label: "Disabled Field",
          value: "Cannot edit this",
          disabled: true
        )
      end

      # @label Readonly State
      # @display bg_color #f5f5f5
      def readonly
        render BetterUi::Forms::TextInputComponent.new(
          name: "readonly_field",
          label: "Readonly Field",
          value: "View only",
          readonly: true
        )
      end

      # @label With Prefix Icon
      # @display bg_color #f5f5f5
      def with_prefix_icon
        render BetterUi::Forms::TextInputComponent.new(
          name: "search",
          label: "Search",
          placeholder: "Search..."
        ) do |component|
          component.with_prefix_icon do
            '<svg class="h-5 w-5 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z"/>
            </svg>'.html_safe
          end
        end
      end

      # @label With Suffix Icon
      # @display bg_color #f5f5f5
      def with_suffix_icon
        render BetterUi::Forms::TextInputComponent.new(
          name: "verified_email",
          label: "Verified Email",
          value: "user@example.com"
        ) do |component|
          component.with_suffix_icon do
            '<svg class="h-5 w-5 text-success-600" fill="currentColor" viewBox="0 0 20 20">
              <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" clip-rule="evenodd"/>
            </svg>'.html_safe
          end
        end
      end

      # @label With Both Icons
      # @display bg_color #f5f5f5
      def with_both_icons
        render BetterUi::Forms::TextInputComponent.new(
          name: "website",
          label: "Website URL",
          placeholder: "example.com"
        ) do |component|
          component.with_prefix_icon do
            '<span class="text-gray-500 text-sm">https://</span>'.html_safe
          end
          component.with_suffix_icon do
            '<svg class="h-5 w-5 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 6H6a2 2 0 00-2 2v10a2 2 0 002 2h10a2 2 0 002-2v-4M14 4h6m0 0v6m0-6L10 14"/>
            </svg>'.html_safe
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
      # @param with_hint toggle
      # @param with_error toggle
      def playground(size: :md, disabled: false, readonly: false, required: false, with_hint: false, with_error: false)
        render BetterUi::Forms::TextInputComponent.new(
          name: "playground",
          label: "Playground Input",
          placeholder: "Type something...",
          size: size.to_sym,
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
