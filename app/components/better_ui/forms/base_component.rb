# frozen_string_literal: true

module BetterUi
  module Forms
    # Base component for all form input components in the BetterUi::Forms namespace.
    #
    # This abstract class provides a common structure and behavior for form input components,
    # including label positioning (vertical/above input), hint text display, error message
    # handling, and consistent sizing/styling across all input types.
    #
    # @abstract Subclasses must implement the {#call} method to render the specific input type.
    #
    # @example Extending BaseComponent to create a custom input
    #   module BetterUi
    #     module Forms
    #       class CustomInputComponent < BaseComponent
    #         def call
    #           content_tag :div, class: wrapper_classes do
    #             # Render label, input, hint, and errors
    #           end
    #         end
    #       end
    #     end
    #   end
    #
    # @example Usage with Rails form builder (via BetterUi::UiFormBuilder)
    #   <%= form_with model: @user, builder: BetterUi::UiFormBuilder do |f| %>
    #     <%= f.ui_text_input :email, label: "Email Address", hint: "We'll never share your email" %>
    #   <% end %>
    #
    # @see TextInputComponent
    # @see NumberInputComponent
    # @see BetterUi::UiFormBuilder
    class BaseComponent < ApplicationComponent
      # Available size variants for form inputs.
      # Each size adjusts font size, padding, and spacing proportionally.
      #
      # @return [Array<Symbol>] the list of valid size options (:xs, :sm, :md, :lg, :xl)
      SIZES = %i[xs sm md lg xl].freeze

      # Initializes a new form input component with common form field attributes.
      #
      # @param name [String] the name attribute for the input field (required for form submission)
      # @param value [String, nil] the current value of the input field
      # @param label [String, nil] the label text to display above the input
      # @param hint [String, nil] helpful hint text displayed below the input
      # @param placeholder [String, nil] placeholder text shown when input is empty
      # @param size [Symbol] the size variant (:xs, :sm, :md, :lg, :xl), defaults to :md
      # @param disabled [Boolean] whether the input should be disabled (non-interactive), defaults to false
      # @param readonly [Boolean] whether the input should be readonly (viewable but not editable), defaults to false
      # @param required [Boolean] whether the field is required (shows asterisk indicator), defaults to false
      # @param errors [Array<String>, String, nil] validation error messages to display below the input
      # @param container_classes [String, Array<String>, nil] additional CSS classes for the outer wrapper
      # @param label_classes [String, Array<String>, nil] additional CSS classes for the label element
      # @param input_classes [String, Array<String>, nil] additional CSS classes for the input element
      # @param hint_classes [String, Array<String>, nil] additional CSS classes for the hint text
      # @param error_classes [String, Array<String>, nil] additional CSS classes for error messages
      # @param options [Hash] additional HTML attributes to pass through to the input element
      #
      # @raise [ArgumentError] if size is not one of the valid SIZES
      #
      # @example Basic initialization
      #   BetterUi::Forms::TextInputComponent.new(
      #     name: "user[email]",
      #     label: "Email Address",
      #     hint: "We'll never share your email",
      #     required: true
      #   )
      #
      # @example With errors
      #   BetterUi::Forms::TextInputComponent.new(
      #     name: "user[email]",
      #     value: "invalid",
      #     errors: ["Email is invalid", "Email can't be blank"]
      #   )
      #
      # @example Custom styling
      #   BetterUi::Forms::TextInputComponent.new(
      #     name: "search",
      #     size: :lg,
      #     container_classes: "my-4",
      #     input_classes: "font-mono"
      #   )
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
        @name = name
        @value = value
        @label = label
        @hint = hint
        @placeholder = placeholder
        @size = validate_size(size)
        @disabled = disabled
        @readonly = readonly
        @required = required
        @errors = Array(errors).compact.reject(&:blank?)
        @container_classes = container_classes
        @label_classes = label_classes
        @input_classes = input_classes
        @hint_classes = hint_classes
        @error_classes = error_classes
        @options = options
      end

      # Renders the component markup.
      #
      # This method must be implemented by subclasses to define the specific
      # rendering logic for each input type (text, number, select, etc.).
      #
      # @abstract Subclasses must implement this method
      # @raise [NotImplementedError] if called directly on BaseComponent
      # @return [String] the rendered HTML markup
      def call
        raise NotImplementedError, "Subclasses must implement the #call method"
      end

      private

      # Validates that the provided size is one of the allowed SIZES.
      #
      # @param size [Symbol] the size to validate
      # @return [Symbol] the validated size
      # @raise [ArgumentError] if size is not in SIZES
      # @api private
      def validate_size(size)
        unless SIZES.include?(size)
          raise ArgumentError, "Invalid size: #{size}. Must be one of #{SIZES.join(', ')}"
        end
        size
      end

      # Checks if the component has any validation errors to display.
      #
      # @return [Boolean] true if errors are present, false otherwise
      # @api private
      def has_errors?
        @errors.present?
      end

      # Returns the CSS classes for the outermost wrapper element.
      #
      # Merges base wrapper classes with any custom container_classes provided.
      #
      # @return [String] the merged CSS class string
      # @api private
      def wrapper_classes
        css_classes([
          "form-field-wrapper",
          @container_classes
        ].flatten.compact)
      end

      # Returns the CSS classes for the label element.
      #
      # Combines base label styles with size-specific classes and custom label_classes.
      #
      # @return [String] the merged CSS class string for the label
      # @api private
      def label_element_classes
        css_classes([
          "block",
          "font-medium",
          "text-gray-700",
          "mb-1",
          label_size_classes,
          @label_classes
        ].flatten.compact)
      end

      # Returns size-specific CSS classes for the label text.
      #
      # @return [String] the text size class for the current component size
      # @api private
      def label_size_classes
        case @size
        when :xs then "text-xs"
        when :sm then "text-sm"
        when :md then "text-sm"
        when :lg then "text-base"
        when :xl then "text-lg"
        end
      end

      # Returns the CSS classes for the input wrapper element.
      #
      # This wrapper is used to position prefix/suffix icons relative to the input.
      #
      # @return [String] the merged CSS class string for the input wrapper
      # @api private
      def input_wrapper_classes
        css_classes([
          "relative",
          "flex",
          "items-center"
        ].flatten.compact)
      end

      # Returns the CSS classes for the input element itself.
      #
      # Combines base input styles, size-specific classes, state-specific classes,
      # and any custom input_classes.
      #
      # @return [String] the merged CSS class string for the input element
      # @api private
      def input_element_classes
        css_classes([
          base_input_classes,
          size_input_classes,
          state_input_classes,
          @input_classes
        ].flatten.compact)
      end

      # Returns the base CSS classes common to all input elements.
      #
      # These classes apply regardless of size, state, or variant.
      #
      # @return [Array<String>] array of base CSS class strings
      # @api private
      def base_input_classes
        [
          "block",
          "w-full",
          "rounded-md",
          "border",
          "shadow-sm",
          "transition-colors",
          "duration-200"
        ]
      end

      # Returns size-specific CSS classes for the input element.
      #
      # Controls font size, padding, and spacing based on the component size.
      #
      # @return [Array<String>] array of size-specific CSS class strings
      # @api private
      def size_input_classes
        case @size
        when :xs
          [ "text-xs", "py-1", "px-2" ]
        when :sm
          [ "text-sm", "py-1.5", "px-3" ]
        when :md
          [ "text-base", "py-2", "px-4" ]
        when :lg
          [ "text-lg", "py-2.5", "px-5" ]
        when :xl
          [ "text-xl", "py-3", "px-6" ]
        end
      end

      # Returns state-specific CSS classes for the input element.
      #
      # Determines which state classes to apply based on the input's current state:
      # disabled, readonly, error, or normal. Only one state is applied at a time,
      # with priority: disabled > readonly > error > normal.
      #
      # @return [Array<String>] array of state-specific CSS class strings
      # @api private
      def state_input_classes
        if @disabled
          disabled_classes
        elsif @readonly
          readonly_classes
        elsif has_errors?
          error_state_classes
        else
          normal_state_classes
        end
      end

      # Returns CSS classes for the normal (default) input state.
      #
      # Applied when the input is not disabled, readonly, or in error state.
      # Includes border, background, text colors, and focus ring styles.
      #
      # @return [Array<String>] array of CSS class strings for normal state
      # @api private
      def normal_state_classes
        [
          "border-gray-300",
          "bg-white",
          "text-gray-900",
          "placeholder-gray-400",
          "focus:border-primary-500",
          "focus:ring-2",
          "focus:ring-primary-500",
          "focus:ring-opacity-20",
          "focus:outline-none"
        ]
      end

      # Returns CSS classes for the error input state.
      #
      # Applied when the input has validation errors. Uses danger color variant
      # for border and focus ring to indicate the error state visually.
      #
      # @return [Array<String>] array of CSS class strings for error state
      # @api private
      def error_state_classes
        [
          "border-danger-500",
          "bg-white",
          "text-gray-900",
          "placeholder-gray-400",
          "focus:border-danger-600",
          "focus:ring-2",
          "focus:ring-danger-500",
          "focus:ring-opacity-20",
          "focus:outline-none"
        ]
      end

      # Returns CSS classes for the disabled input state.
      #
      # Applied when the input is disabled (non-interactive).
      # Reduces opacity and changes cursor to indicate non-interactive state.
      #
      # @return [Array<String>] array of CSS class strings for disabled state
      # @api private
      def disabled_classes
        [
          "border-gray-300",
          "bg-gray-100",
          "text-gray-500",
          "placeholder-gray-400",
          "cursor-not-allowed",
          "opacity-60"
        ]
      end

      # Returns CSS classes for the readonly input state.
      #
      # Applied when the input is readonly (viewable but not editable).
      # Uses lighter background and default cursor to differentiate from disabled state.
      #
      # @return [Array<String>] array of CSS class strings for readonly state
      # @api private
      def readonly_classes
        [
          "border-gray-300",
          "bg-gray-50",
          "text-gray-700",
          "cursor-default"
        ]
      end

      # Returns the CSS classes for the hint text element.
      #
      # Combines base hint styles with size-specific classes and custom hint_classes.
      #
      # @return [String] the merged CSS class string for the hint text
      # @api private
      def hint_element_classes
        css_classes([
          "block",
          "text-gray-600",
          "mt-1",
          hint_size_classes,
          @hint_classes
        ].flatten.compact)
      end

      # Returns size-specific CSS classes for the hint text.
      #
      # Hint text is typically smaller than the input text for visual hierarchy.
      #
      # @return [String] the text size class for the current component size
      # @api private
      def hint_size_classes
        case @size
        when :xs then "text-xs"
        when :sm then "text-xs"
        when :md then "text-sm"
        when :lg then "text-sm"
        when :xl then "text-base"
        end
      end

      # Returns the CSS classes for the error messages container.
      #
      # Combines base error styles with size-specific classes and custom error_classes.
      #
      # @return [String] the merged CSS class string for the error messages container
      # @api private
      def errors_element_classes
        css_classes([
          "text-danger-600",
          "mt-1",
          "space-y-0.5",
          error_size_classes,
          @error_classes
        ].flatten.compact)
      end

      # Returns size-specific CSS classes for error message text.
      #
      # Error text sizing matches hint text sizing for consistency.
      #
      # @return [String] the text size class for the current component size
      # @api private
      def error_size_classes
        case @size
        when :xs then "text-xs"
        when :sm then "text-xs"
        when :md then "text-sm"
        when :lg then "text-sm"
        when :xl then "text-base"
        end
      end

      # Returns the complete set of HTML attributes for the input element.
      #
      # Combines standard form attributes (name, value, placeholder, etc.)
      # with state attributes (disabled, readonly, required) and any custom
      # options passed during initialization. Nil values are removed via compact.
      #
      # @return [Hash] hash of HTML attributes for the input element
      # @api private
      def input_attributes
        {
          name: @name,
          value: @value,
          placeholder: @placeholder,
          disabled: @disabled || nil,
          readonly: @readonly || nil,
          required: @required || nil,
          class: input_element_classes,
          **@options
        }.compact
      end
    end
  end
end
