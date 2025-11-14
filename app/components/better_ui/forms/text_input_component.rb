# frozen_string_literal: true

module BetterUi
  module Forms
    # A text input component with support for labels, hints, errors, and prefix/suffix icons.
    #
    # This component extends {BaseComponent} to provide a standard text input field with
    # optional decorative or functional icons positioned before (prefix) or after (suffix)
    # the input text. Perfect for search fields, email inputs, URL fields, and more.
    #
    # @example Basic text input
    #   <%= render BetterUi::Forms::TextInputComponent.new(
    #     name: "user[email]",
    #     label: "Email Address",
    #     placeholder: "you@example.com"
    #   ) %>
    #
    # @example Text input with prefix icon (search)
    #   <%= render BetterUi::Forms::TextInputComponent.new(
    #     name: "search",
    #     label: "Search",
    #     placeholder: "Search..."
    #   ) do |component| %>
    #     <% component.with_prefix_icon do %>
    #       <svg class="h-5 w-5 text-gray-400">...</svg>
    #     <% end %>
    #   <% end %>
    #
    # @example Text input with suffix icon (verified checkmark)
    #   <%= render BetterUi::Forms::TextInputComponent.new(
    #     name: "user[email]",
    #     value: "user@example.com",
    #     label: "Verified Email"
    #   ) do |component| %>
    #     <% component.with_suffix_icon do %>
    #       <svg class="h-5 w-5 text-success-600">...</svg>
    #     <% end %>
    #   <% end %>
    #
    # @example Text input with both icons
    #   <%= render BetterUi::Forms::TextInputComponent.new(
    #     name: "website",
    #     label: "Website URL",
    #     placeholder: "example.com"
    #   ) do |component| %>
    #     <% component.with_prefix_icon do %>
    #       <span class="text-gray-500">https://</span>
    #     <% end %>
    #     <% component.with_suffix_icon do %>
    #       <svg class="h-5 w-5 text-gray-400">...</svg>
    #     <% end %>
    #   <% end %>
    #
    # @example With validation errors
    #   <%= render BetterUi::Forms::TextInputComponent.new(
    #     name: "user[email]",
    #     value: "invalid",
    #     label: "Email",
    #     errors: ["Email is invalid", "Email can't be blank"]
    #   ) %>
    #
    # @example Using with Rails form builder
    #   <%= form_with model: @user, builder: BetterUi::UiFormBuilder do |f| %>
    #     <%= f.ui_text_input :email do |component| %>
    #       <% component.with_prefix_icon do %>
    #         <svg>...</svg>
    #       <% end %>
    #     <% end %>
    #   <% end %>
    #
    # @see BaseComponent
    # @see BetterUi::UiFormBuilder#ui_text_input
    class TextInputComponent < BaseComponent
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

      # Initializes a new text input component.
      #
      # All parameters are passed to {BaseComponent#initialize}. See the parent class
      # for detailed parameter descriptions.
      #
      # @param (see BaseComponent#initialize)
      # @option (see BaseComponent#initialize)
      # @raise (see BaseComponent#initialize)
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
      # @return [String] the input type ("text")
      # @api private
      def input_type
        "text"
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

      # Returns input element classes with icon-adjusted padding.
      #
      # When prefix or suffix icons are present, this method adds extra padding to the
      # input element to prevent text from overlapping with the icons. Padding amount
      # is proportional to the component size.
      #
      # @return [String] the CSS class string with icon padding adjustments
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
        classes
      end

      # Returns the complete set of HTML attributes for the input element.
      #
      # Extends the parent implementation to add the input type and conditionally
      # apply icon-adjusted classes when icons are present.
      #
      # @return [Hash] hash of HTML attributes for the input element
      # @api private
      def input_attributes
        attrs = super
        attrs[:type] = input_type
        attrs[:class] = input_element_classes_with_icons if has_prefix_icon? || has_suffix_icon?
        attrs
      end
    end
  end
end
