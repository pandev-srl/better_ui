# frozen_string_literal: true

module BetterUi
  module Forms
    # A custom dropdown select component for choosing a single option from a collection.
    #
    # This component extends {BaseComponent} to provide a custom select dropdown with
    # keyboard navigation, type-ahead search, and full ARIA support. It uses a hidden
    # input for form submission and a Stimulus controller for interactivity.
    #
    # @example Basic select
    #   <%= render BetterUi::Forms::SelectComponent.new(
    #     name: "user[country]",
    #     collection: [["Italy", "it"], ["France", "fr"], ["Germany", "de"]],
    #     label: "Country"
    #   ) %>
    #
    # @example With prefix icon
    #   <%= render BetterUi::Forms::SelectComponent.new(
    #     name: "country",
    #     collection: [["Italy", "it"], ["France", "fr"]],
    #     label: "Country",
    #     clearable: true
    #   ) do |component| %>
    #     <% component.with_prefix_icon do %>
    #       <svg class="h-5 w-5 text-gray-400">...</svg>
    #     <% end %>
    #   <% end %>
    #
    # @example Simple array collection
    #   <%= render BetterUi::Forms::SelectComponent.new(
    #     name: "color",
    #     collection: ["Red", "Blue", "Green"],
    #     placeholder: "Pick a color"
    #   ) %>
    #
    # @see BaseComponent
    # @see BetterUi::UiFormBuilder#bui_select
    class SelectComponent < BaseComponent
      renders_one :prefix_icon

      # @param name [String] the name attribute for the hidden input field
      # @param collection [Array] array of values or [label, value] pairs
      # @param clearable [Boolean] whether to show a clear button
      # @param dropdown_classes [String, nil] custom CSS classes for the dropdown
      # @param (see BaseComponent#initialize)
      def initialize(
        name:,
        collection: [],
        clearable: false,
        dropdown_classes: nil,
        value: nil,
        label: nil,
        hint: nil,
        placeholder: nil,
        size: :md,
        disabled: false,
        readonly: false,
        required: false,
        errors: nil,
        shadow: :sm,
        container_classes: nil,
        label_classes: nil,
        input_classes: nil,
        hint_classes: nil,
        error_classes: nil,
        **options
      )
        @collection = collection
        @clearable = clearable
        @dropdown_classes = dropdown_classes
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
          shadow: shadow,
          container_classes: container_classes,
          label_classes: label_classes,
          input_classes: input_classes,
          hint_classes: hint_classes,
          error_classes: error_classes,
          **options
        )
      end

      private

      # Extracts the label from a collection item.
      #
      # @param item [String, Array] the collection item
      # @return [String] the label text
      def item_label(item)
        item.is_a?(Array) ? item.first.to_s : item.to_s
      end

      # Extracts the value from a collection item.
      #
      # @param item [String, Array] the collection item
      # @return [String] the value
      def item_value(item)
        item.is_a?(Array) ? item.last.to_s : item.to_s
      end

      # Finds the label for the currently selected value.
      #
      # @return [String, nil] the label of the selected option, or nil
      def selected_label
        return nil unless has_selection?

        selected_item = @collection.find { |item| item_value(item) == @value.to_s }
        selected_item ? item_label(selected_item) : @value.to_s
      end

      # Checks if there is a current selection.
      #
      # @return [Boolean] true if a value is present
      def has_selection?
        @value.present?
      end

      # Generates a unique ID based on the input name.
      #
      # @return [String] the generated ID
      def input_id
        @name.to_s.gsub(/\[|\]/, "_").gsub(/_+/, "_").chomp("_")
      end

      # Generates a unique ID for the listbox element.
      #
      # @return [String] the listbox element ID
      def listbox_id
        "#{input_id}_listbox"
      end

      # Returns CSS classes for the trigger button element.
      #
      # @return [String] merged CSS classes
      def trigger_element_classes
        css_classes([
          trigger_base_classes,
          size_input_classes,
          trigger_state_classes,
          @input_classes
        ].flatten.compact)
      end

      # Returns the base CSS classes for the trigger element.
      # Uses flex instead of block (unlike text inputs) for icon layout.
      #
      # @return [Array<String>] base trigger CSS classes
      def trigger_base_classes
        [
          "block",
          "w-full",
          "rounded-md",
          "border",
          SHADOWS[@shadow],
          "transition-colors",
          "duration-200",
          "flex",
          "items-center",
          "text-left"
        ]
      end

      # Returns state-specific trigger classes with correct cursor.
      # Cursor-pointer is only applied in normal and error states.
      #
      # @return [Array<String>] state CSS classes
      def trigger_state_classes
        if @disabled
          disabled_classes
        elsif @readonly
          readonly_classes
        elsif has_errors?
          error_state_classes + [ "cursor-pointer" ]
        else
          normal_state_classes + [ "cursor-pointer" ]
        end
      end

      # Returns CSS classes for the trigger display text.
      #
      # @return [String] merged CSS classes
      def trigger_text_classes
        if has_selection?
          css_classes([ "flex-1", "truncate", "text-gray-900" ])
        else
          css_classes([ "flex-1", "truncate", "text-gray-400" ])
        end
      end

      # Returns CSS classes for the dropdown listbox.
      #
      # @return [String] merged CSS classes
      def dropdown_element_classes
        css_classes([
          "absolute",
          "z-50",
          "w-full",
          "mt-1",
          "bg-white",
          "border",
          "border-gray-300",
          "rounded-md",
          "shadow-lg",
          "max-h-60",
          "overflow-auto",
          "py-1",
          "hidden",
          @dropdown_classes
        ].flatten.compact)
      end

      # Returns CSS classes for an option element.
      #
      # @param selected [Boolean] whether this option is currently selected
      # @return [String] merged CSS classes
      def option_element_classes(selected)
        css_classes([
          "px-3",
          "py-2",
          "cursor-pointer",
          "truncate",
          option_size_classes,
          selected ? "bg-primary-50 text-primary-700 font-medium" : "text-gray-900",
          "hover:bg-gray-100"
        ].flatten.compact)
      end

      # Returns size-specific classes for option text.
      #
      # @return [String] the text size class
      def option_size_classes
        case @size
        when :xs then "text-xs"
        when :sm then "text-sm"
        when :md then "text-base"
        when :lg then "text-lg"
        when :xl then "text-xl"
        end
      end

      # Returns SVG size classes for the caret icon.
      #
      # @return [String] the size classes
      def caret_icon_size
        case @size
        when :xs, :sm then "w-4 h-4"
        when :md, :lg then "w-5 h-5"
        when :xl then "w-6 h-6"
        end
      end

      # Returns the placeholder text with a default fallback.
      #
      # @return [String] the placeholder text
      def placeholder_text
        @placeholder || "Select..."
      end

      # Overrides disabled_classes to use cursor-not-allowed without focus styles.
      #
      # @return [Array<String>] CSS classes for disabled state
      def disabled_classes
        [
          "border-gray-300",
          "bg-gray-100",
          "text-gray-500",
          "cursor-not-allowed",
          "opacity-60"
        ]
      end

      # Overrides readonly_classes for the trigger.
      #
      # @return [Array<String>] CSS classes for readonly state
      def readonly_classes
        [
          "border-gray-300",
          "bg-gray-50",
          "text-gray-700",
          "cursor-default"
        ]
      end

      # Returns the Stimulus controller wrapper data attributes.
      #
      # @return [Hash] data attributes hash
      def controller_wrapper_attributes
        attrs = {
          controller: "better-ui--forms--select",
          "better-ui--forms--select-clearable-value": @clearable,
          "better-ui--forms--select-placeholder-value": placeholder_text,
          "better-ui--forms--select-disabled-value": @disabled,
          "better-ui--forms--select-readonly-value": @readonly
        }
        attrs
      end

      # Returns the complete set of HTML attributes for the trigger button.
      #
      # @return [Hash] trigger button attributes
      def trigger_attributes
        attrs = {
          type: "button",
          role: "combobox",
          "aria-expanded": "false",
          "aria-haspopup": "listbox",
          "aria-controls": listbox_id,
          class: trigger_element_classes,
          disabled: @disabled || nil,
          "aria-readonly": @readonly ? "true" : nil,
          "data-better-ui--forms--select-target": "trigger",
          "data-action": "click->better-ui--forms--select#toggle keydown->better-ui--forms--select#handleTriggerKeydown"
        }.compact
        attrs
      end

      # Returns the HTML attributes for the hidden input.
      #
      # @return [Hash] hidden input attributes
      def hidden_input_attributes
        attrs = {
          type: "hidden",
          name: @name,
          value: @value,
          "data-better-ui--forms--select-target": "hiddenInput"
        }
        attrs[:id] = @options[:id] if @options[:id]
        attrs[:required] = true if @required
        @options.each do |key, val|
          next if key == :id
          attrs[key] = val
        end
        attrs.compact
      end
    end
  end
end
