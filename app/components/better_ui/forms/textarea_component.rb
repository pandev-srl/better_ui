# frozen_string_literal: true

module BetterUi
  module Forms
    # A textarea component with support for labels, hints, errors, and prefix/suffix icons.
    #
    # This component extends {BaseComponent} to provide a standard textarea field with
    # optional decorative or functional icons positioned before (prefix) or after (suffix)
    # the textarea. Perfect for multi-line text inputs like comments, descriptions, and messages.
    #
    # @example Basic textarea
    #   <%= render BetterUi::Forms::TextareaComponent.new(
    #     name: "post[content]",
    #     label: "Post Content",
    #     placeholder: "Write your post here..."
    #   ) %>
    #
    # @example Textarea with custom rows
    #   <%= render BetterUi::Forms::TextareaComponent.new(
    #     name: "comment[body]",
    #     label: "Comment",
    #     rows: 6,
    #     placeholder: "Enter your comment..."
    #   ) %>
    #
    # @example Textarea with prefix icon
    #   <%= render BetterUi::Forms::TextareaComponent.new(
    #     name: "description",
    #     label: "Description",
    #     placeholder: "Enter description..."
    #   ) do |component| %>
    #     <% component.with_prefix_icon do %>
    #       <svg class="h-5 w-5 text-gray-400">...</svg>
    #     <% end %>
    #   <% end %>
    #
    # @example Textarea with character limit
    #   <%= render BetterUi::Forms::TextareaComponent.new(
    #     name: "bio",
    #     label: "Bio",
    #     maxlength: 500,
    #     hint: "Maximum 500 characters"
    #   ) %>
    #
    # @example Textarea with disabled resize
    #   <%= render BetterUi::Forms::TextareaComponent.new(
    #     name: "notes",
    #     label: "Notes",
    #     resize: :none
    #   ) %>
    #
    # @example With validation errors
    #   <%= render BetterUi::Forms::TextareaComponent.new(
    #     name: "post[content]",
    #     value: "",
    #     label: "Content",
    #     errors: ["Content can't be blank", "Content is too short"]
    #   ) %>
    #
    # @example Using with Rails form builder
    #   <%= form_with model: @post, builder: BetterUi::UiFormBuilder do |f| %>
    #     <%= f.ui_textarea :content do |component| %>
    #       <% component.with_prefix_icon do %>
    #         <svg>...</svg>
    #       <% end %>
    #     <% end %>
    #   <% end %>
    #
    # @see BaseComponent
    # @see BetterUi::UiFormBuilder#ui_textarea
    class TextareaComponent < BaseComponent
      # @!method with_prefix_icon
      #   Slot for rendering an icon or content before (left of) the textarea.
      #   The icon is positioned absolutely at the top left and textarea padding is adjusted automatically.
      #   @yieldreturn [String] the HTML content for the prefix icon
      renders_one :prefix_icon

      # @!method with_suffix_icon
      #   Slot for rendering an icon or content after (right of) the textarea.
      #   The icon is positioned absolutely at the top right and textarea padding is adjusted automatically.
      #   @yieldreturn [String] the HTML content for the suffix icon
      renders_one :suffix_icon

      # Initializes a new textarea component.
      #
      # All standard parameters are passed to {BaseComponent#initialize}. See the parent class
      # for detailed parameter descriptions.
      #
      # @param name [String] the field name for form submission (required)
      # @param value [String, nil] the current value of the textarea
      # @param label [String, nil] the label text displayed above the textarea
      # @param hint [String, nil] helper text displayed below the textarea
      # @param placeholder [String, nil] placeholder text shown when textarea is empty
      # @param size [Symbol] the size variant (:xs, :sm, :md, :lg, :xl), defaults to :md
      # @param disabled [Boolean] whether the textarea is disabled, defaults to false
      # @param readonly [Boolean] whether the textarea is read-only, defaults to false
      # @param required [Boolean] whether the field is required (shows asterisk), defaults to false
      # @param errors [Array<String>, String, nil] validation error messages to display
      # @param rows [Integer] number of visible text lines, defaults to 4
      # @param cols [Integer, nil] width in characters (optional, usually controlled by CSS)
      # @param maxlength [Integer, nil] maximum number of characters allowed
      # @param resize [Symbol] CSS resize behavior (:none, :vertical, :horizontal, :both), defaults to :vertical
      # @param container_classes [String, nil] additional CSS classes for the outer wrapper
      # @param label_classes [String, nil] additional CSS classes for the label element
      # @param input_classes [String, nil] additional CSS classes for the textarea element
      # @param hint_classes [String, nil] additional CSS classes for the hint text
      # @param error_classes [String, nil] additional CSS classes for error messages
      # @param options [Hash] additional HTML attributes passed to the textarea element
      #
      # @raise [ArgumentError] if size is not one of the allowed values
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
        rows: 4,
        cols: nil,
        maxlength: nil,
        resize: :vertical,
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

        @rows = rows
        @cols = cols
        @maxlength = maxlength
        @resize = resize
      end

      private

      # Returns the HTML element type.
      #
      # @return [String] the element type ("textarea")
      # @api private
      def input_type
        "textarea"
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
      # Icons are positioned absolutely at the top of the textarea wrapper and include
      # size-specific padding to ensure proper spacing.
      #
      # @return [String] the merged CSS class string for icon wrappers
      # @api private
      def icon_wrapper_classes
        css_classes([
          "absolute",
          "top-0",
          "flex",
          "items-start",
          "pointer-events-none",
          icon_size_padding,
          icon_vertical_padding
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
      # Ensures icons maintain proper spacing from the textarea borders across all sizes.
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

      # Returns size-specific vertical padding for icon wrappers.
      #
      # Aligns icons properly with the top of the textarea text.
      #
      # @return [String] the vertical padding class for the current component size
      # @api private
      def icon_vertical_padding
        case @size
        when :xs then "pt-1"
        when :sm then "pt-1.5"
        when :md then "pt-2"
        when :lg then "pt-2.5"
        when :xl then "pt-3"
        end
      end

      # Returns textarea element classes with icon-adjusted padding.
      #
      # When prefix or suffix icons are present, this method adds extra padding to the
      # textarea element to prevent text from overlapping with the icons. Padding amount
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

      # Returns CSS classes for resize behavior.
      #
      # Maps the resize parameter to Tailwind resize classes.
      #
      # @return [String] the resize class based on @resize value
      # @api private
      def resize_classes
        case @resize
        when :none then "resize-none"
        when :vertical then "resize-y"
        when :horizontal then "resize-x"
        when :both then "resize"
        else "resize-y" # default to vertical
        end
      end

      # Returns the complete set of HTML attributes for the textarea element.
      #
      # Extends the parent implementation to add textarea-specific attributes (rows, cols, maxlength)
      # and conditionally apply icon-adjusted classes and resize classes.
      #
      # @return [Hash] hash of HTML attributes for the textarea element
      # @api private
      def input_attributes
        attrs = super
        attrs.delete(:type) # textareas don't have a type attribute
        attrs[:rows] = @rows
        attrs[:cols] = @cols if @cols.present?
        attrs[:maxlength] = @maxlength if @maxlength.present?

        # Build classes: base classes (with icon adjustments if needed) + resize classes
        if has_prefix_icon? || has_suffix_icon?
          classes = "#{input_element_classes_with_icons} #{resize_classes}".strip
        else
          classes = attrs[:class] || ""
          classes = "#{classes} #{resize_classes}".strip
        end

        attrs[:class] = classes
        attrs
      end
    end
  end
end
