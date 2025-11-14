# frozen_string_literal: true

module BetterUi
  module Forms
    # A password input component with visibility toggle functionality.
    #
    # This component extends {TextInputComponent} to provide a password input field with
    # a toggle button that allows users to show or hide the password text. The toggle
    # button displays an eye icon when the password is hidden and an eye-slash icon when
    # the password is visible.
    #
    # The component inherits all features from TextInputComponent including labels, hints,
    # errors, validation states, sizes, and the prefix_icon slot. The suffix position is
    # reserved for the password visibility toggle button.
    #
    # @example Basic password input
    #   <%= render BetterUi::Forms::PasswordInputComponent.new(
    #     name: "user[password]",
    #     label: "Password",
    #     placeholder: "Enter your password"
    #   ) %>
    #
    # @example Password input with prefix icon (lock)
    #   <%= render BetterUi::Forms::PasswordInputComponent.new(
    #     name: "user[password]",
    #     label: "Password",
    #     required: true
    #   ) do |component| %>
    #     <% component.with_prefix_icon do %>
    #       <svg class="h-5 w-5 text-gray-400">...</svg>
    #     <% end %>
    #   <% end %>
    #
    # @example With validation errors
    #   <%= render BetterUi::Forms::PasswordInputComponent.new(
    #     name: "user[password]",
    #     label: "Password",
    #     errors: ["Password is too short", "Password must include a number"]
    #   ) %>
    #
    # @example With hint text
    #   <%= render BetterUi::Forms::PasswordInputComponent.new(
    #     name: "user[password]",
    #     label: "Password",
    #     hint: "Must be at least 8 characters with 1 number and 1 special character",
    #     required: true
    #   ) %>
    #
    # @example Using with Rails form builder
    #   <%= form_with model: @user, builder: BetterUi::UiFormBuilder do |f| %>
    #     <%= f.ui_password_input :password, hint: "Minimum 8 characters" %>
    #   <% end %>
    #
    # @note The suffix_icon slot from TextInputComponent is not available in PasswordInputComponent
    #   as the suffix position is occupied by the visibility toggle button.
    #
    # @see TextInputComponent
    # @see BaseComponent
    # @see BetterUi::UiFormBuilder#ui_password_input
    class PasswordInputComponent < TextInputComponent
      # Initializes a new password input component.
      #
      # All parameters are passed to {TextInputComponent#initialize}. See the parent class
      # for detailed parameter descriptions.
      #
      # @param (see TextInputComponent#initialize)
      # @option (see TextInputComponent#initialize)
      # @raise (see TextInputComponent#initialize)
      #
      # @see TextInputComponent#initialize
      def initialize(
        name:,
        value: nil,
        label: nil,
        hint: nil,
        placeholder: nil,
        size: :md,
        disabled: false,
        readonly: false,
        required: false,
        errors: nil,
        container_classes: nil,
        label_classes: nil,
        input_classes: nil,
        hint_classes: nil,
        error_classes: nil,
        **options
      )
        super(
          name: name,
          value: value,
          label: label,
          hint: hint,
          placeholder: placeholder,
          size: size,
          disabled: disabled,
          readonly: readonly,
          required: required,
          errors: errors,
          container_classes: container_classes,
          label_classes: label_classes,
          input_classes: input_classes,
          hint_classes: hint_classes,
          error_classes: error_classes,
          **options
        )
      end

      private

      # Returns the HTML input type attribute.
      #
      # For password inputs, this returns "password" by default. The Stimulus controller
      # toggles this between "password" and "text" to show/hide the password.
      #
      # @return [String] the input type ("password")
      # @api private
      def input_type
        "password"
      end

      # Checks if the password visibility toggle button is present.
      #
      # For PasswordInputComponent, the toggle button is always present unless the
      # input is disabled or readonly (as toggling would not be functional).
      #
      # @return [Boolean] true if toggle button should be rendered
      # @api private
      def has_toggle_button?
        !@disabled && !@readonly
      end

      # Returns size-specific classes for the toggle button icon.
      #
      # Icon sizes are proportional to the input size to maintain visual balance.
      #
      # @return [String] the icon size class for the current component size
      # @api private
      def toggle_icon_size
        case @size
        when :xs then "w-4 h-4"
        when :sm then "w-4 h-4"
        when :md then "w-5 h-5"
        when :lg then "w-5 h-5"
        when :xl then "w-6 h-6"
        end
      end

      # Returns the CSS classes for the toggle button wrapper.
      #
      # Positions the toggle button absolutely within the input wrapper.
      #
      # @return [String] the merged CSS class string for the toggle button wrapper
      # @api private
      def toggle_button_classes
        css_classes([
          "absolute",
          "inset-y-0",
          "right-0",
          "flex",
          "items-center",
          icon_size_padding
        ].flatten.compact)
      end

      # Returns the complete set of HTML attributes for the input element.
      #
      # Extends the parent implementation to add Stimulus target attribute
      # for the password visibility toggle functionality.
      #
      # @return [Hash] hash of HTML attributes for the input element
      # @api private
      def input_attributes
        attrs = super
        attrs[:data] ||= {}
        attrs[:data][:"better-ui--forms--password-input-target"] = "input"
        attrs
      end

      # Returns the HTML attributes for the input wrapper div.
      #
      # Adds Stimulus controller to the wrapper so all child targets are accessible.
      #
      # @return [Hash] hash of HTML attributes for the wrapper div
      # @api private
      def input_wrapper_attributes
        {
          class: input_wrapper_classes,
          data: {
            controller: "better-ui--forms--password-input"
          }
        }
      end

      # Override parent method to always consider toggle button as suffix icon.
      #
      # This ensures input padding is adjusted for the toggle button.
      #
      # @return [Boolean] true if toggle button is present
      # @api private
      def has_suffix_icon?
        has_toggle_button?
      end
    end
  end
end
