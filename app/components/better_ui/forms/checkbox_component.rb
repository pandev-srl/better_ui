# frozen_string_literal: true

module BetterUi
  module Forms
    # A checkbox input component with support for labels, hints, errors, and color variants.
    #
    # This component provides a styled checkbox with customizable colors, sizes, and label positioning.
    # Unlike text inputs, the label appears inline (left or right) with the checkbox rather than above.
    #
    # @example Basic checkbox
    #   <%= render BetterUi::Forms::CheckboxComponent.new(
    #     name: "user[terms]",
    #     label: "I agree to the terms and conditions"
    #   ) %>
    #
    # @example Checkbox with different variant
    #   <%= render BetterUi::Forms::CheckboxComponent.new(
    #     name: "settings[notifications]",
    #     label: "Enable notifications",
    #     variant: :success,
    #     checked: true
    #   ) %>
    #
    # @example Checkbox with label on left
    #   <%= render BetterUi::Forms::CheckboxComponent.new(
    #     name: "user[active]",
    #     label: "Active",
    #     label_position: :left
    #   ) %>
    #
    # @example With validation errors
    #   <%= render BetterUi::Forms::CheckboxComponent.new(
    #     name: "user[terms]",
    #     label: "I agree to the terms",
    #     errors: ["You must agree to the terms"]
    #   ) %>
    #
    # @example Using with Rails form builder
    #   <%= form_with model: @user, builder: BetterUi::UiFormBuilder do |f| %>
    #     <%= f.bui_checkbox :newsletter, label: "Subscribe to newsletter" %>
    #   <% end %>
    #
    # @see BetterUi::UiFormBuilder#bui_checkbox
    class CheckboxComponent < ApplicationComponent
      # Available size variants for checkbox inputs.
      # Each size adjusts the checkbox dimensions and spacing proportionally.
      #
      # @return [Array<Symbol>] the list of valid size options (:xs, :sm, :md, :lg, :xl)
      SIZES = %i[xs sm md lg xl].freeze

      # Available label positions relative to the checkbox.
      #
      # @return [Array<Symbol>] the list of valid label positions (:left, :right)
      LABEL_POSITIONS = %i[left right].freeze

      # Initializes a new checkbox component.
      #
      # @param name [String] the name attribute for the checkbox (required for form submission)
      # @param value [String] the value submitted when checkbox is checked (defaults to "1")
      # @param checked [Boolean] whether the checkbox is initially checked
      # @param label [String, nil] the label text displayed next to the checkbox
      # @param hint [String, nil] helpful hint text displayed below the checkbox
      # @param variant [Symbol] the color variant (:primary, :secondary, :accent, :success, :danger, :warning, :info, :light, :dark)
      # @param size [Symbol] the size variant (:xs, :sm, :md, :lg, :xl), defaults to :md
      # @param label_position [Symbol] where to position the label (:left, :right), defaults to :right
      # @param disabled [Boolean] whether the checkbox should be disabled (non-interactive), defaults to false
      # @param readonly [Boolean] whether the checkbox should be readonly (viewable but not editable), defaults to false
      # @param required [Boolean] whether the field is required (shows asterisk indicator), defaults to false
      # @param errors [Array<String>, String, nil] validation error messages to display below the checkbox
      # @param container_classes [String, Array<String>, nil] additional CSS classes for the outer wrapper
      # @param label_classes [String, Array<String>, nil] additional CSS classes for the label element
      # @param checkbox_classes [String, Array<String>, nil] additional CSS classes for the checkbox element
      # @param hint_classes [String, Array<String>, nil] additional CSS classes for the hint text
      # @param error_classes [String, Array<String>, nil] additional CSS classes for error messages
      # @param options [Hash] additional HTML attributes to pass through to the checkbox element
      #
      # @raise [ArgumentError] if variant, size, or label_position is invalid
      def initialize(
        name:,
        value: "1",
        checked: false,
        label: nil,
        hint: nil,
        variant: :primary,
        size: :md,
        label_position: :right,
        disabled: false,
        readonly: false,
        required: false,
        errors: nil,
        container_classes: nil,
        label_classes: nil,
        checkbox_classes: nil,
        hint_classes: nil,
        error_classes: nil,
        **options
      )
        @name = name
        @value = value
        @checked = checked
        @label = label
        @hint = hint
        @variant = validate_variant(variant)
        @size = validate_size(size)
        @label_position = validate_label_position(label_position)
        @disabled = disabled
        @readonly = readonly
        @required = required
        @errors = Array(errors).compact.reject(&:blank?)
        @container_classes = container_classes
        @label_classes = label_classes
        @checkbox_classes = checkbox_classes
        @hint_classes = hint_classes
        @error_classes = error_classes
        @options = options
      end

      private

      # Validates that the provided variant is one of the allowed VARIANTS.
      #
      # @param variant [Symbol] the variant to validate
      # @return [Symbol] the validated variant
      # @raise [ArgumentError] if variant is not in VARIANTS
      # @api private
      def validate_variant(variant)
        unless BetterUi::ApplicationComponent::VARIANTS.key?(variant)
          raise ArgumentError, "Invalid variant: #{variant}. Must be one of: #{BetterUi::ApplicationComponent::VARIANTS.keys.join(', ')}"
        end
        variant
      end

      # Validates that the provided size is one of the allowed SIZES.
      #
      # @param size [Symbol] the size to validate
      # @return [Symbol] the validated size
      # @raise [ArgumentError] if size is not in SIZES
      # @api private
      def validate_size(size)
        unless SIZES.include?(size)
          raise ArgumentError, "Invalid size: #{size}. Must be one of: #{SIZES.join(', ')}"
        end
        size
      end

      # Validates that the provided label_position is one of the allowed LABEL_POSITIONS.
      #
      # @param label_position [Symbol] the label_position to validate
      # @return [Symbol] the validated label_position
      # @raise [ArgumentError] if label_position is not in LABEL_POSITIONS
      # @api private
      def validate_label_position(label_position)
        unless LABEL_POSITIONS.include?(label_position)
          raise ArgumentError, "Invalid label_position: #{label_position}. Must be one of: #{LABEL_POSITIONS.join(', ')}"
        end
        label_position
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
      # @return [String] the merged CSS class string
      # @api private
      def wrapper_classes
        css_classes([
          "form-field-wrapper",
          @container_classes
        ].flatten.compact)
      end

      # Returns the CSS classes for the checkbox and label wrapper.
      #
      # Handles flex direction based on label_position.
      #
      # @return [String] the merged CSS class string
      # @api private
      def checkbox_wrapper_classes
        css_classes([
          "flex",
          "items-start",
          @label_position == :left ? "flex-row-reverse" : "flex-row",
          gap_classes
        ].flatten.compact)
      end

      # Returns gap classes based on component size.
      #
      # @return [String] the gap class for the current component size
      # @api private
      def gap_classes
        case @size
        when :xs then "gap-1.5"
        when :sm then "gap-2"
        when :md then "gap-2.5"
        when :lg then "gap-3"
        when :xl then "gap-3.5"
        end
      end

      # Returns the CSS classes for the checkbox element itself.
      #
      # @return [String] the merged CSS class string for the checkbox element
      # @api private
      def checkbox_element_classes
        css_classes([
          base_checkbox_classes,
          size_checkbox_classes,
          variant_checkbox_classes,
          state_checkbox_classes,
          @checkbox_classes
        ].flatten.compact)
      end

      # Returns the base CSS classes common to all checkboxes.
      #
      # @return [Array<String>] array of base CSS class strings
      # @api private
      def base_checkbox_classes
        [
          "appearance-none",
          "shrink-0",
          "rounded",
          "border",
          "cursor-pointer",
          "transition-colors",
          "duration-200",
          "focus:outline-none",
          "focus:ring-2",
          "focus:ring-offset-2"
        ]
      end

      # Returns size-specific CSS classes for the checkbox.
      #
      # @return [Array<String>] array of size-specific CSS class strings
      # @api private
      def size_checkbox_classes
        case @size
        when :xs then [ "w-3", "h-3" ]
        when :sm then [ "w-4", "h-4" ]
        when :md then [ "w-5", "h-5" ]
        when :lg then [ "w-6", "h-6" ]
        when :xl then [ "w-7", "h-7" ]
        end
      end

      # Returns variant-specific CSS classes for the checkbox.
      # Uses literal strings for Tailwind JIT detection.
      #
      # @return [Array<String>] array of variant-specific CSS class strings
      # @api private
      def variant_checkbox_classes
        case @variant
        when :primary
          [ "border-gray-300", "checked:bg-primary-600", "checked:border-primary-600", "focus:ring-primary-500" ]
        when :secondary
          [ "border-gray-300", "checked:bg-secondary-600", "checked:border-secondary-600", "focus:ring-secondary-500" ]
        when :accent
          [ "border-gray-300", "checked:bg-accent-600", "checked:border-accent-600", "focus:ring-accent-500" ]
        when :success
          [ "border-gray-300", "checked:bg-success-600", "checked:border-success-600", "focus:ring-success-500" ]
        when :danger
          [ "border-gray-300", "checked:bg-danger-600", "checked:border-danger-600", "focus:ring-danger-500" ]
        when :warning
          [ "border-gray-300", "checked:bg-warning-600", "checked:border-warning-600", "focus:ring-warning-500" ]
        when :info
          [ "border-gray-300", "checked:bg-info-600", "checked:border-info-600", "focus:ring-info-500" ]
        when :light
          [ "border-gray-300", "checked:bg-gray-200", "checked:border-gray-400", "focus:ring-gray-400", "checked-dark" ]
        when :dark
          [ "border-gray-400", "checked:bg-gray-800", "checked:border-gray-800", "focus:ring-gray-600" ]
        end
      end

      # Returns state-specific CSS classes for the checkbox.
      #
      # @return [Array<String>] array of state-specific CSS class strings
      # @api private
      def state_checkbox_classes
        if @disabled
          [ "bg-gray-100", "cursor-not-allowed", "opacity-60" ]
        elsif @readonly
          [ "bg-gray-50", "cursor-default", "pointer-events-none" ]
        elsif has_errors?
          [ "bg-white", "border-danger-500", "focus:ring-danger-500" ]
        else
          [ "bg-white" ]
        end
      end

      # Returns the CSS classes for the label element.
      #
      # @return [String] the merged CSS class string for the label
      # @api private
      def label_element_classes
        css_classes([
          "select-none",
          "cursor-pointer",
          @disabled ? "text-gray-400 cursor-not-allowed" : "text-gray-700",
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

      # Returns the CSS classes for the hint text element.
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

      # Returns the complete set of HTML attributes for the checkbox element.
      #
      # @return [Hash] hash of HTML attributes for the checkbox element
      # @api private
      def checkbox_attributes
        attrs = {
          type: "checkbox",
          name: @name,
          value: @value,
          checked: @checked || nil,
          disabled: @disabled || nil,
          readonly: @readonly || nil,
          required: @required || nil,
          class: checkbox_element_classes,
          **@options
        }.compact

        # Handle readonly by adding aria attribute since checkboxes don't support readonly HTML attribute
        if @readonly
          attrs[:aria] ||= {}
          attrs[:aria][:readonly] = "true"
          attrs.delete(:readonly)
        end

        attrs
      end

      # Returns the input ID, either from options or generated from name.
      #
      # @return [String] the input ID
      # @api private
      def input_id
        @options[:id] || @name.to_s.gsub(/\[|\]/, "_").gsub(/_+/, "_").chomp("_")
      end
    end
  end
end
