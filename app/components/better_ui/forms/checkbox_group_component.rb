# frozen_string_literal: true

module BetterUi
  module Forms
    # A checkbox group component for selecting multiple options from a collection.
    #
    # This component renders a group of checkboxes within a fieldset, allowing users
    # to select multiple values. It supports both vertical and horizontal orientations,
    # and integrates seamlessly with Rails form builders for array attribute submission.
    #
    # @example Basic checkbox group
    #   <%= render BetterUi::Forms::CheckboxGroupComponent.new(
    #     name: "user[roles]",
    #     collection: ["Admin", "Editor", "Viewer"],
    #     legend: "User Roles"
    #   ) %>
    #
    # @example With label/value pairs
    #   <%= render BetterUi::Forms::CheckboxGroupComponent.new(
    #     name: "user[permissions]",
    #     collection: [["Read", "read"], ["Write", "write"], ["Delete", "delete"]],
    #     selected: ["read", "write"],
    #     legend: "Permissions"
    #   ) %>
    #
    # @example Horizontal orientation
    #   <%= render BetterUi::Forms::CheckboxGroupComponent.new(
    #     name: "options",
    #     collection: ["Option A", "Option B", "Option C"],
    #     orientation: :horizontal
    #   ) %>
    #
    # @example With validation errors
    #   <%= render BetterUi::Forms::CheckboxGroupComponent.new(
    #     name: "user[interests]",
    #     collection: ["Sports", "Music", "Art"],
    #     errors: ["Please select at least one interest"]
    #   ) %>
    #
    # @example Using with Rails form builder
    #   <%= form_with model: @user, builder: BetterUi::UiFormBuilder do |f| %>
    #     <%= f.bui_checkbox_group :roles, [["Admin", "admin"], ["Editor", "editor"]] %>
    #   <% end %>
    #
    # @see CheckboxComponent
    # @see BetterUi::UiFormBuilder#bui_checkbox_group
    class CheckboxGroupComponent < ApplicationComponent
      # Available size variants for checkbox groups.
      # Each size adjusts checkbox dimensions and spacing proportionally.
      #
      # @return [Array<Symbol>] the list of valid size options (:xs, :sm, :md, :lg, :xl)
      SIZES = %i[xs sm md lg xl].freeze

      # Available orientation options for checkbox group layout.
      #
      # @return [Array<Symbol>] the list of valid orientations (:vertical, :horizontal)
      ORIENTATIONS = %i[vertical horizontal].freeze

      # Initializes a new checkbox group component.
      #
      # @param name [String] the base name attribute for the checkboxes (required for form submission)
      # @param collection [Array] the collection of options, can be:
      #   - Array of values (e.g., ["Admin", "Editor"])
      #   - Array of [label, value] pairs (e.g., [["Admin", "admin"], ["Editor", "editor"]])
      # @param selected [Array, String, nil] the currently selected value(s)
      # @param legend [String, nil] the legend text for the fieldset
      # @param hint [String, nil] helpful hint text displayed below the checkboxes
      # @param variant [Symbol] the color variant for all checkboxes (:primary, :secondary, etc.)
      # @param size [Symbol] the size variant (:xs, :sm, :md, :lg, :xl), defaults to :md
      # @param orientation [Symbol] the layout orientation (:vertical, :horizontal), defaults to :vertical
      # @param disabled [Boolean] whether all checkboxes should be disabled, defaults to false
      # @param required [Boolean] whether the field is required (shows asterisk indicator), defaults to false
      # @param errors [Array<String>, String, nil] validation error messages to display
      # @param container_classes [String, Array<String>, nil] additional CSS classes for the outer wrapper
      # @param legend_classes [String, Array<String>, nil] additional CSS classes for the legend element
      # @param items_classes [String, Array<String>, nil] additional CSS classes for the items container
      # @param hint_classes [String, Array<String>, nil] additional CSS classes for the hint text
      # @param error_classes [String, Array<String>, nil] additional CSS classes for error messages
      # @param options [Hash] additional HTML attributes to pass through to the fieldset element
      #
      # @raise [ArgumentError] if variant, size, or orientation is invalid
      def initialize(
        name:,
        collection: [],
        selected: [],
        legend: nil,
        hint: nil,
        variant: :primary,
        size: :md,
        orientation: :vertical,
        disabled: false,
        required: false,
        errors: nil,
        container_classes: nil,
        legend_classes: nil,
        items_classes: nil,
        hint_classes: nil,
        error_classes: nil,
        **options
      )
        @name = name
        @collection = collection
        @selected = Array(selected).map(&:to_s)
        @legend = legend
        @hint = hint
        @variant = validate_variant(variant)
        @size = validate_size(size)
        @orientation = validate_orientation(orientation)
        @disabled = disabled
        @required = required
        @errors = Array(errors).compact.reject(&:blank?)
        @container_classes = container_classes
        @legend_classes = legend_classes
        @items_classes = items_classes
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

      # Validates that the provided orientation is one of the allowed ORIENTATIONS.
      #
      # @param orientation [Symbol] the orientation to validate
      # @return [Symbol] the validated orientation
      # @raise [ArgumentError] if orientation is not in ORIENTATIONS
      # @api private
      def validate_orientation(orientation)
        unless ORIENTATIONS.include?(orientation)
          raise ArgumentError, "Invalid orientation: #{orientation}. Must be one of: #{ORIENTATIONS.join(', ')}"
        end
        orientation
      end

      # Checks if the component has any validation errors to display.
      #
      # @return [Boolean] true if errors are present, false otherwise
      # @api private
      def has_errors?
        @errors.present?
      end

      # Returns the field name for checkbox inputs (with array notation).
      #
      # @return [String] the field name with [] suffix for array submission
      # @api private
      def field_name
        "#{@name}[]"
      end

      # Checks if a specific value is currently selected.
      #
      # @param value [String, Integer] the value to check
      # @return [Boolean] true if the value is selected, false otherwise
      # @api private
      def item_checked?(value)
        @selected.include?(value.to_s)
      end

      # Extracts the label from a collection item.
      #
      # @param item [String, Array] the collection item
      # @return [String] the label text
      # @api private
      def item_label(item)
        item.is_a?(Array) ? item.first.to_s : item.to_s.humanize
      end

      # Extracts the value from a collection item.
      #
      # @param item [String, Array] the collection item
      # @return [String] the value
      # @api private
      def item_value(item)
        item.is_a?(Array) ? item.last.to_s : item.to_s
      end

      # Generates a unique ID for each checkbox item.
      #
      # @param index [Integer] the item index
      # @return [String] the generated ID
      # @api private
      def item_id(index)
        base_id = @name.to_s.gsub(/\[|\]/, "_").gsub(/_+/, "_").chomp("_")
        "#{base_id}_#{index}"
      end

      # Returns the CSS classes for the fieldset wrapper.
      #
      # @return [String] the merged CSS class string
      # @api private
      def wrapper_classes
        css_classes([
          "form-field-wrapper",
          @container_classes
        ].flatten.compact)
      end

      # Returns the CSS classes for the legend element.
      #
      # @return [String] the merged CSS class string for the legend
      # @api private
      def legend_element_classes
        css_classes([
          "block",
          "font-medium",
          "text-gray-700",
          "mb-2",
          legend_size_classes,
          @legend_classes
        ].flatten.compact)
      end

      # Returns size-specific CSS classes for the legend text.
      #
      # @return [String] the text size class for the current component size
      # @api private
      def legend_size_classes
        case @size
        when :xs then "text-xs"
        when :sm then "text-sm"
        when :md then "text-sm"
        when :lg then "text-base"
        when :xl then "text-lg"
        end
      end

      # Returns the CSS classes for the items container.
      #
      # @return [String] the merged CSS class string
      # @api private
      def items_wrapper_classes
        css_classes([
          "flex",
          orientation_classes,
          items_gap_classes,
          @items_classes
        ].flatten.compact)
      end

      # Returns CSS classes for orientation layout.
      #
      # @return [Array<String>] array of orientation CSS class strings
      # @api private
      def orientation_classes
        case @orientation
        when :vertical
          [ "flex-col" ]
        when :horizontal
          [ "flex-row", "flex-wrap" ]
        end
      end

      # Returns gap classes based on component size and orientation.
      #
      # @return [String] the gap class for the current component size
      # @api private
      def items_gap_classes
        case @size
        when :xs then @orientation == :horizontal ? "gap-x-4 gap-y-1.5" : "gap-1.5"
        when :sm then @orientation == :horizontal ? "gap-x-5 gap-y-2" : "gap-2"
        when :md then @orientation == :horizontal ? "gap-x-6 gap-y-2.5" : "gap-2.5"
        when :lg then @orientation == :horizontal ? "gap-x-7 gap-y-3" : "gap-3"
        when :xl then @orientation == :horizontal ? "gap-x-8 gap-y-3.5" : "gap-3.5"
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
          "mt-2",
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
          "mt-2",
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

      # Returns the HTML attributes for the fieldset element.
      #
      # @return [Hash] hash of HTML attributes for the fieldset
      # @api private
      def fieldset_attributes
        {
          class: wrapper_classes,
          disabled: @disabled || nil,
          **@options
        }.compact
      end
    end
  end
end
