# frozen_string_literal: true

module BetterUi
  # A CSS-only tooltip component that shows a tooltip on hover.
  #
  # The component wraps any content passed in a block and displays
  # a tooltip on hover using CSS group-hover utilities.
  #
  # @example Basic tooltip
  #   <%= render BetterUi::TooltipComponent.new(text: "Save changes") do %>
  #     <button>Save</button>
  #   <% end %>
  #
  # @example Tooltip with position and variant
  #   <%= render BetterUi::TooltipComponent.new(text: "Delete item", position: :bottom, variant: :light) do %>
  #     <button>Delete</button>
  #   <% end %>
  #
  # @example Tooltip with larger size
  #   <%= render BetterUi::TooltipComponent.new(text: "More information here", size: :md) do %>
  #     <span>Hover me</span>
  #   <% end %>
  class TooltipComponent < ApplicationComponent
    POSITIONS = %i[top right bottom left].freeze

    TOOLTIP_VARIANTS = %i[dark light].freeze

    SIZES = %i[sm md].freeze

    # Initializes a new tooltip component.
    #
    # @param text [String] the tooltip content (required)
    # @param position [Symbol] tooltip position (:top, :right, :bottom, :left), defaults to :top
    # @param variant [Symbol] tooltip style variant (:dark, :light), defaults to :dark
    # @param size [Symbol] tooltip text size (:sm, :md), defaults to :sm
    # @param container_classes [String, nil] additional CSS classes for the outer wrapper
    # @param options [Hash] additional HTML attributes
    #
    # @raise [ArgumentError] if position is not one of the allowed values
    # @raise [ArgumentError] if variant is not one of the allowed values
    # @raise [ArgumentError] if size is not one of the allowed values
    def initialize(
      text:,
      position: :top,
      variant: :dark,
      size: :sm,
      container_classes: nil,
      **options
    )
      @text = text
      @position = validate_position(position)
      @variant = validate_tooltip_variant(variant)
      @size = validate_size(size)
      @container_classes = container_classes
      @options = options
    end

    private

    attr_reader :text, :position, :variant, :size, :container_classes, :options

    # Returns the complete CSS classes for the tooltip element.
    #
    # @return [String] the merged CSS class string
    # @api private
    def tooltip_classes
      css_classes([
        base_classes,
        position_classes,
        variant_classes,
        size_classes
      ].flatten.compact)
    end

    # Returns base classes common to all tooltips.
    #
    # @return [Array<String>] base CSS classes
    # @api private
    def base_classes
      [
        "absolute",
        "z-50",
        "rounded-md",
        "whitespace-nowrap",
        "pointer-events-none",
        "opacity-0",
        "group-hover:opacity-100",
        "transition-opacity",
        "duration-200"
      ]
    end

    # Returns position-specific CSS classes.
    #
    # @return [String] position CSS classes
    # @api private
    def position_classes
      case @position
      when :top    then "bottom-full left-1/2 -translate-x-1/2 mb-2"
      when :right  then "left-full top-1/2 -translate-y-1/2 ml-2"
      when :bottom then "top-full left-1/2 -translate-x-1/2 mt-2"
      when :left   then "right-full top-1/2 -translate-y-1/2 mr-2"
      end
    end

    # Returns variant-specific CSS classes.
    #
    # @return [String] variant CSS classes
    # @api private
    def variant_classes
      case @variant
      when :dark  then "bg-grayscale-900 text-white"
      when :light then "bg-white text-grayscale-900 border border-grayscale-200 shadow-lg"
      end
    end

    # Returns size-specific CSS classes.
    #
    # @return [String] size CSS classes
    # @api private
    def size_classes
      case @size
      when :sm then "text-xs px-2 py-1"
      when :md then "text-sm px-3 py-1.5"
      end
    end

    # Validates the position parameter.
    #
    # @param position [Symbol] the position to validate
    # @return [Symbol] the validated position
    # @raise [ArgumentError] if position is invalid
    # @api private
    def validate_position(position)
      unless POSITIONS.include?(position)
        raise ArgumentError, "Invalid position: #{position}. Must be one of: #{POSITIONS.join(', ')}"
      end
      position
    end

    # Validates the variant parameter for tooltip.
    #
    # @param variant [Symbol] the variant to validate
    # @return [Symbol] the validated variant
    # @raise [ArgumentError] if variant is invalid
    # @api private
    def validate_tooltip_variant(variant)
      unless TOOLTIP_VARIANTS.include?(variant)
        raise ArgumentError, "Invalid variant: #{variant}. Must be one of: #{TOOLTIP_VARIANTS.join(', ')}"
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
  end
end
