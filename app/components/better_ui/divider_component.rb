# frozen_string_literal: true

module BetterUi
  # A divider component for visually separating content sections.
  #
  # Renders a horizontal or vertical divider line with optional centered label text.
  # Supports multiple border styles, color variants, sizes, and spacing options.
  #
  # @example Basic horizontal divider
  #   <%= render BetterUi::DividerComponent.new %>
  #
  # @example Dashed divider with primary color
  #   <%= render BetterUi::DividerComponent.new(style: :dashed, variant: :primary) %>
  #
  # @example Divider with centered label
  #   <%= render BetterUi::DividerComponent.new(label: "OR") %>
  #
  # @example Divider with left-aligned label
  #   <%= render BetterUi::DividerComponent.new(label: "Section", label_position: :left) %>
  #
  # @example Vertical divider
  #   <%= render BetterUi::DividerComponent.new(orientation: :vertical) %>
  #
  # @example Thick divider with large spacing
  #   <%= render BetterUi::DividerComponent.new(size: :md, spacing: :xl) %>
  class DividerComponent < ApplicationComponent
    ORIENTATIONS = %i[horizontal vertical].freeze
    STYLES = %i[solid dashed dotted].freeze
    SIZES = %i[xs sm md].freeze
    LABEL_POSITIONS = %i[left center right].freeze
    SPACINGS = %i[xs sm md lg xl].freeze

    # Initializes a new divider component.
    #
    # @param orientation [Symbol] the divider direction (:horizontal, :vertical)
    # @param style [Symbol] the border style (:solid, :dashed, :dotted)
    # @param variant [Symbol, nil] the color variant (nil for default gray)
    # @param size [Symbol] the border thickness (:xs, :sm, :md)
    # @param label [String, nil] centered text label for horizontal dividers
    # @param label_position [Symbol] label alignment (:left, :center, :right)
    # @param spacing [Symbol] outer margins (:xs, :sm, :md, :lg, :xl)
    # @param container_classes [String, nil] additional CSS classes
    # @param options [Hash] additional HTML attributes
    #
    # @raise [ArgumentError] if any parameter value is invalid
    def initialize(
      orientation: :horizontal,
      style: :solid,
      variant: nil,
      size: :md,
      label: nil,
      label_position: :center,
      spacing: :md,
      container_classes: nil,
      **options
    )
      @orientation = validate_orientation(orientation)
      @style = validate_style(style)
      @variant = validate_variant(variant) if variant
      @size = validate_size(size)
      @label = label
      @label_position = validate_label_position(label_position)
      @spacing = validate_spacing(spacing)
      @container_classes = container_classes
      @options = options
    end

    private

    attr_reader :orientation, :style, :variant, :size, :label, :label_position,
                :spacing, :container_classes, :options

    # Returns true if the divider is horizontal.
    #
    # @return [Boolean]
    # @api private
    def horizontal?
      @orientation == :horizontal
    end

    # Returns true if the divider has a label and is horizontal.
    #
    # @return [Boolean]
    # @api private
    def has_label?
      @label.present? && horizontal?
    end

    # Returns the complete CSS classes for a horizontal divider without label.
    #
    # @return [String] merged CSS class string
    # @api private
    def component_classes
      if horizontal?
        css_classes([
          border_style_class,
          horizontal_size_class,
          variant_color_class,
          horizontal_spacing_class,
          @container_classes
        ].compact)
      else
        css_classes([
          "inline-block",
          "h-full",
          "min-h-[1em]",
          border_style_class,
          vertical_size_class,
          variant_color_class,
          vertical_spacing_class,
          @container_classes
        ].compact)
      end
    end

    # Returns the CSS classes for the flex wrapper when label is present.
    #
    # @return [String] merged CSS class string
    # @api private
    def wrapper_classes
      css_classes([
        "flex",
        "items-center",
        horizontal_spacing_class,
        @container_classes
      ].compact)
    end

    # Returns the CSS classes for the line segments in a labeled divider.
    # Returns different classes based on label position and which line (first/second).
    #
    # @param position [Symbol] :first or :second to identify which line segment
    # @return [String] merged CSS class string
    # @api private
    def line_classes(position = :both)
      grow_class = case @label_position
      when :left
        position == :first ? "flex-grow-0 w-8" : "flex-grow"
      when :right
        position == :first ? "flex-grow" : "flex-grow-0 w-8"
      else
        "flex-grow"
      end

      css_classes([
        grow_class,
        "border-t",
        border_style_class,
        horizontal_label_size_class,
        variant_color_class
      ].compact)
    end

    # Returns the CSS classes for the label text.
    #
    # @return [String] merged CSS class string
    # @api private
    def label_text_classes
      "px-3 text-sm text-grayscale-500 whitespace-nowrap"
    end

    # Returns the border style class.
    #
    # @return [String] border style class
    # @api private
    def border_style_class
      case @style
      when :solid then "border-solid"
      when :dashed then "border-dashed"
      when :dotted then "border-dotted"
      end
    end

    # Returns the border thickness class for horizontal dividers.
    #
    # @return [String] border size class
    # @api private
    def horizontal_size_class
      case @size
      when :xs then "border-t"
      when :sm then "border-t-2"
      when :md then "border-t-4"
      end
    end

    # Returns the border thickness class for horizontal labeled dividers.
    # Uses border-t classes since the lines are div elements with border-top.
    #
    # @return [String] border size class
    # @api private
    def horizontal_label_size_class
      case @size
      when :xs then ""
      when :sm then "border-t-2"
      when :md then "border-t-4"
      end
    end

    # Returns the border thickness class for vertical dividers.
    #
    # @return [String] border size class
    # @api private
    def vertical_size_class
      case @size
      when :xs then "border-l"
      when :sm then "border-l-2"
      when :md then "border-l-4"
      end
    end

    # Returns the color class for the border based on variant.
    #
    # @return [String] border color class
    # @api private
    def variant_color_class
      case @variant
      when nil        then "border-grayscale-300"
      when :primary   then "border-primary-300"
      when :secondary then "border-secondary-300"
      when :accent    then "border-accent-300"
      when :success   then "border-success-300"
      when :danger    then "border-danger-300"
      when :warning   then "border-warning-300"
      when :info      then "border-info-300"
      when :light     then "border-grayscale-200"
      when :dark      then "border-grayscale-600"
      end
    end

    # Returns the spacing (margin) class for horizontal dividers.
    #
    # @return [String] margin class
    # @api private
    def horizontal_spacing_class
      case @spacing
      when :xs then "my-1"
      when :sm then "my-2"
      when :md then "my-4"
      when :lg then "my-6"
      when :xl then "my-8"
      end
    end

    # Returns the spacing (margin) class for vertical dividers.
    #
    # @return [String] margin class
    # @api private
    def vertical_spacing_class
      case @spacing
      when :xs then "mx-1"
      when :sm then "mx-2"
      when :md then "mx-4"
      when :lg then "mx-6"
      when :xl then "mx-8"
      end
    end

    # Returns HTML attributes for the component element.
    #
    # @return [Hash] HTML attributes
    # @api private
    def html_attributes
      @options
    end

    # Validates the orientation parameter.
    #
    # @param orientation [Symbol] the orientation to validate
    # @return [Symbol] the validated orientation
    # @raise [ArgumentError] if orientation is invalid
    # @api private
    def validate_orientation(orientation)
      unless ORIENTATIONS.include?(orientation)
        raise ArgumentError, "Invalid orientation: #{orientation}. Must be one of: #{ORIENTATIONS.join(', ')}"
      end
      orientation
    end

    # Validates the style parameter.
    #
    # @param style [Symbol] the style to validate
    # @return [Symbol] the validated style
    # @raise [ArgumentError] if style is invalid
    # @api private
    def validate_style(style)
      unless STYLES.include?(style)
        raise ArgumentError, "Invalid style: #{style}. Must be one of: #{STYLES.join(', ')}"
      end
      style
    end

    # Validates the variant parameter.
    #
    # @param variant [Symbol] the variant to validate
    # @return [Symbol] the validated variant
    # @raise [ArgumentError] if variant is invalid
    # @api private
    def validate_variant(variant)
      unless BetterUi::ApplicationComponent::VARIANTS.key?(variant)
        raise ArgumentError, "Invalid variant: #{variant}. Must be one of: #{BetterUi::ApplicationComponent::VARIANTS.keys.join(', ')}"
      end
      variant
    end

    # Validates the size parameter.
    #
    # @param size [Symbol] the size to validate
    # @return [Symbol] the validated size
    # @raise [ArgumentError] if size is invalid
    # @api private
    def validate_size(size)
      unless SIZES.include?(size)
        raise ArgumentError, "Invalid size: #{size}. Must be one of: #{SIZES.join(', ')}"
      end
      size
    end

    # Validates the label_position parameter.
    #
    # @param label_position [Symbol] the label position to validate
    # @return [Symbol] the validated label position
    # @raise [ArgumentError] if label_position is invalid
    # @api private
    def validate_label_position(label_position)
      unless LABEL_POSITIONS.include?(label_position)
        raise ArgumentError, "Invalid label_position: #{label_position}. Must be one of: #{LABEL_POSITIONS.join(', ')}"
      end
      label_position
    end

    # Validates the spacing parameter.
    #
    # @param spacing [Symbol] the spacing to validate
    # @return [Symbol] the validated spacing
    # @raise [ArgumentError] if spacing is invalid
    # @api private
    def validate_spacing(spacing)
      unless SPACINGS.include?(spacing)
        raise ArgumentError, "Invalid spacing: #{spacing}. Must be one of: #{SPACINGS.join(', ')}"
      end
      spacing
    end
  end
end
