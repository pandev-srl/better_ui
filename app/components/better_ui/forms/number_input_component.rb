# frozen_string_literal: true

module BetterUi
  module Forms
    # A number input component with support for min/max/step constraints, spinner controls,
    # and prefix/suffix icons.
    #
    # This component extends {BaseComponent} to provide a number input field with optional
    # decorative or functional icons, numeric constraints (min, max, step), and the ability
    # to hide the browser's default up/down arrow spinner buttons.
    #
    # @example Basic number input
    #   <%= render BetterUi::Forms::NumberInputComponent.new(
    #     name: "user[age]",
    #     label: "Age",
    #     min: 0,
    #     max: 120
    #   ) %>
    #
    # @example Number input with step (decimal values)
    #   <%= render BetterUi::Forms::NumberInputComponent.new(
    #     name: "product[price]",
    #     label: "Price",
    #     min: 0,
    #     step: 0.01,
    #     placeholder: "0.00"
    #   ) %>
    #
    # @example Number input without spinner controls
    #   <%= render BetterUi::Forms::NumberInputComponent.new(
    #     name: "quantity",
    #     label: "Quantity",
    #     min: 1,
    #     show_spinner: false
    #   ) %>
    #
    # @example Number input with prefix icon (currency)
    #   <%= render BetterUi::Forms::NumberInputComponent.new(
    #     name: "amount",
    #     label: "Amount",
    #     min: 0,
    #     step: 0.01
    #   ) do |component| %>
    #     <% component.with_prefix_icon do %>
    #       <span class="text-gray-500">$</span>
    #     <% end %>
    #   <% end %>
    #
    # @example Number input with suffix icon (unit)
    #   <%= render BetterUi::Forms::NumberInputComponent.new(
    #     name: "weight",
    #     label: "Weight",
    #     min: 0
    #   ) do |component| %>
    #     <% component.with_suffix_icon do %>
    #       <span class="text-gray-500">kg</span>
    #     <% end %>
    #   <% end %>
    #
    # @example With validation errors
    #   <%= render BetterUi::Forms::NumberInputComponent.new(
    #     name: "user[age]",
    #     value: "150",
    #     label: "Age",
    #     errors: ["Age must be between 0 and 120"]
    #   ) %>
    #
    # @example Using with Rails form builder
    #   <%= form_with model: @product, builder: BetterUi::UiFormBuilder do |f| %>
    #     <%= f.ui_number_input :price, min: 0, step: 0.01 do |component| %>
    #       <% component.with_prefix_icon do %>
    #         <span>$</span>
    #       <% end %>
    #     <% end %>
    #   <% end %>
    #
    # @see BaseComponent
    # @see TextInputComponent
    # @see BetterUi::UiFormBuilder#ui_number_input
    class NumberInputComponent < BaseComponent
      # @!method with_prefix_icon
      #   Slot for rendering an icon or content before (left of) the input text.
      #   The icon is positioned absolutely and input padding is adjusted automatically.
      #   @yieldreturn [String] the HTML content for the prefix icon
      renders_one :prefix_icon

      # @!method with_suffix_icon
      #   Slot for rendering an icon or content after (right of) the input text.
      #   The icon is positioned absolutely and input padding is adjusted automatically.
      #   @yieldreturn [String] the HTML content for the suffix icon
      renders_one :suffix_icon

      # Initializes a new number input component.
      #
      # Accepts all parameters from {BaseComponent#initialize} plus additional
      # number-specific parameters for constraints and spinner control.
      #
      # @param name [String] the name attribute for the input field (required for form submission)
      # @param value [String, Numeric, nil] the current value of the input field
      # @param label [String, nil] the label text to display above the input
      # @param hint [String, nil] helpful hint text displayed below the input
      # @param placeholder [String, nil] placeholder text shown when input is empty
      # @param size [Symbol] the size variant (:xs, :sm, :md, :lg, :xl), defaults to :md
      # @param disabled [Boolean] whether the input should be disabled (non-interactive), defaults to false
      # @param readonly [Boolean] whether the input should be readonly (viewable but not editable), defaults to false
      # @param required [Boolean] whether the field is required (shows asterisk indicator), defaults to false
      # @param errors [Array<String>, String, nil] validation error messages to display below the input
      # @param min [Numeric, nil] the minimum allowed value (HTML5 min attribute)
      # @param max [Numeric, nil] the maximum allowed value (HTML5 max attribute)
      # @param step [Numeric, nil] the step increment for value changes (e.g., 0.01 for currency, 1 for integers)
      # @param show_spinner [Boolean] whether to display browser's up/down arrow buttons, defaults to true
      # @param container_classes [String, Array<String>, nil] additional CSS classes for the outer wrapper
      # @param label_classes [String, Array<String>, nil] additional CSS classes for the label element
      # @param input_classes [String, Array<String>, nil] additional CSS classes for the input element
      # @param hint_classes [String, Array<String>, nil] additional CSS classes for the hint text
      # @param error_classes [String, Array<String>, nil] additional CSS classes for error messages
      # @param options [Hash] additional HTML attributes to pass through to the input element
      #
      # @raise [ArgumentError] if size is not one of the valid SIZES
      #
      # @example Basic initialization with constraints
      #   BetterUi::Forms::NumberInputComponent.new(
      #     name: "product[quantity]",
      #     label: "Quantity",
      #     min: 1,
      #     max: 100,
      #     step: 1
      #   )
      #
      # @example Currency input with decimal precision
      #   BetterUi::Forms::NumberInputComponent.new(
      #     name: "product[price]",
      #     label: "Price",
      #     min: 0,
      #     step: 0.01,
      #     show_spinner: false
      #   )
      #
      # @see BaseComponent#initialize
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
        min: nil,
        max: nil,
        step: nil,
        show_spinner: true,
        container_classes: nil,
        label_classes: nil,
        input_classes: nil,
        hint_classes: nil,
        error_classes: nil,
        **options
      )
        @min = min
        @max = max
        @step = step
        @show_spinner = show_spinner

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
      # @return [String] the input type ("number")
      # @api private
      def input_type
        "number"
      end

      # Checks if a prefix icon has been provided via the slot.
      #
      # @return [Boolean] true if prefix_icon slot is present, false otherwise
      # @api private
      def has_prefix_icon?
        prefix_icon.present?
      end

      # Checks if a suffix icon has been provided via the slot.
      #
      # @return [Boolean] true if suffix_icon slot is present, false otherwise
      # @api private
      def has_suffix_icon?
        suffix_icon.present?
      end

      # Returns the base CSS classes for icon wrapper elements.
      #
      # Icons are positioned absolutely within the input wrapper and include
      # size-specific padding to ensure proper spacing.
      #
      # @return [String] the merged CSS class string for icon wrappers
      # @api private
      def icon_wrapper_classes
        css_classes([
          "absolute",
          "inset-y-0",
          "flex",
          "items-center",
          "pointer-events-none",
          icon_size_padding
        ].flatten.compact)
      end

      # Returns the CSS classes for the prefix icon wrapper.
      #
      # Extends icon_wrapper_classes with left positioning.
      #
      # @return [String] the merged CSS class string for the prefix icon wrapper
      # @api private
      def prefix_icon_classes
        css_classes([
          icon_wrapper_classes,
          "left-0"
        ].flatten.compact)
      end

      # Returns the CSS classes for the suffix icon wrapper.
      #
      # Extends icon_wrapper_classes with right positioning.
      #
      # @return [String] the merged CSS class string for the suffix icon wrapper
      # @api private
      def suffix_icon_classes
        css_classes([
          icon_wrapper_classes,
          "right-0"
        ].flatten.compact)
      end

      # Returns size-specific horizontal padding for icon wrappers.
      #
      # Ensures icons maintain proper spacing from the input borders across all sizes.
      #
      # @return [String] the padding class for the current component size
      # @api private
      def icon_size_padding
        case @size
        when :xs then "px-2"
        when :sm then "px-3"
        when :md then "px-4"
        when :lg then "px-5"
        when :xl then "px-6"
        end
      end

      # Returns input element classes with icon-adjusted padding and optional spinner hiding.
      #
      # When prefix or suffix icons are present, this method adds extra padding to the
      # input element to prevent text from overlapping with the icons. When show_spinner
      # is false, adds the 'hide-number-spinner' class to hide browser's up/down arrows.
      # Padding amount is proportional to the component size.
      #
      # @return [String] the CSS class string with icon padding and spinner visibility adjustments
      # @api private
      def input_element_classes_with_icons
        classes = input_element_classes
        classes = "#{classes} pl-10" if has_prefix_icon? && @size == :md
        classes = "#{classes} pr-10" if has_suffix_icon? && @size == :md
        classes = "#{classes} pl-8" if has_prefix_icon? && @size == :sm
        classes = "#{classes} pr-8" if has_suffix_icon? && @size == :sm
        classes = "#{classes} pl-6" if has_prefix_icon? && @size == :xs
        classes = "#{classes} pr-6" if has_suffix_icon? && @size == :xs
        classes = "#{classes} pl-12" if has_prefix_icon? && @size == :lg
        classes = "#{classes} pr-12" if has_suffix_icon? && @size == :lg
        classes = "#{classes} pl-14" if has_prefix_icon? && @size == :xl
        classes = "#{classes} pr-14" if has_suffix_icon? && @size == :xl
        classes = "#{classes} hide-number-spinner" unless @show_spinner
        classes
      end

      # Returns the complete set of HTML attributes for the number input element.
      #
      # Extends the parent implementation to add number-specific attributes:
      # - type: "number"
      # - min: minimum allowed value (if specified)
      # - max: maximum allowed value (if specified)
      # - step: increment step for value changes (if specified)
      # - class: icon-adjusted classes when icons are present or spinner is hidden
      #
      # @return [Hash] hash of HTML attributes for the input element
      # @api private
      def input_attributes
        attrs = super
        attrs[:type] = input_type
        attrs[:min] = @min if @min
        attrs[:max] = @max if @max
        attrs[:step] = @step if @step
        attrs[:class] = input_element_classes_with_icons if has_prefix_icon? || has_suffix_icon? || !@show_spinner
        attrs
      end
    end
  end
end
