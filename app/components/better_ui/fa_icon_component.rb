# frozen_string_literal: true

module BetterUi
  class FaIconComponent < ApplicationComponent
    STYLES = {
      regular: "fa-regular",
      solid: "fa-solid",
      light: "fa-light",
      thin: "fa-thin",
      brands: "fa-brands"
    }.freeze

    SIZES = {
      xs: "fa-xs",
      sm: "fa-sm",
      md: nil,
      lg: "fa-lg",
      xl: "fa-xl",
      "2xl": "fa-2xl"
    }.freeze

    FLIPS = {
      horizontal: "fa-flip-horizontal",
      vertical: "fa-flip-vertical",
      both: "fa-flip-both"
    }.freeze

    ROTATIONS = {
      90 => "fa-rotate-90",
      180 => "fa-rotate-180",
      270 => "fa-rotate-270"
    }.freeze

    def initialize(
      name:,
      style: :regular,
      variant: nil,
      size: :md,
      spin: false,
      pulse: false,
      flip: nil,
      rotate: nil,
      fixed_width: false,
      container_classes: nil,
      **options
    )
      @name = name
      @style = validate_style(style)
      @variant = validate_variant(variant)
      @size = validate_size(size)
      @spin = spin
      @pulse = pulse
      @flip = validate_flip(flip)
      @rotate = validate_rotate(rotate)
      @fixed_width = fixed_width
      @container_classes = container_classes
      @options = options
    end

    private

    attr_reader :name, :style, :variant, :size, :spin, :pulse, :flip, :rotate,
                :fixed_width, :container_classes, :options

    def component_classes
      css_classes([
        style_class,
        icon_class,
        size_class,
        variant_class,
        animation_classes,
        flip_class,
        rotate_class,
        fixed_width_class,
        @container_classes
      ].flatten.compact)
    end

    def style_class
      STYLES[@style]
    end

    def icon_class
      "fa-#{@name}"
    end

    def size_class
      SIZES[@size]
    end

    def variant_class
      case @variant
      when nil       then nil
      when :primary   then "text-primary-600"
      when :secondary then "text-secondary-500"
      when :accent    then "text-accent-500"
      when :success   then "text-success-600"
      when :danger    then "text-danger-600"
      when :warning   then "text-warning-500"
      when :info      then "text-info-500"
      when :light     then "text-grayscale-400"
      when :dark      then "text-grayscale-800"
      end
    end

    def animation_classes
      classes = []
      classes << "fa-spin" if @spin
      classes << "fa-pulse" if @pulse
      classes
    end

    def flip_class
      return nil unless @flip
      FLIPS[@flip]
    end

    def rotate_class
      return nil unless @rotate
      ROTATIONS[@rotate]
    end

    def fixed_width_class
      @fixed_width ? "fa-fw" : nil
    end

    def validate_style(style)
      unless STYLES.key?(style)
        raise ArgumentError, "Invalid style: #{style}. Must be one of: #{STYLES.keys.join(", ")}"
      end
      style
    end

    def validate_variant(variant)
      return nil if variant.nil?
      unless BetterUi::ApplicationComponent::VARIANTS.key?(variant)
        raise ArgumentError, "Invalid variant: #{variant}. Must be one of: #{BetterUi::ApplicationComponent::VARIANTS.keys.join(", ")}"
      end
      variant
    end

    def validate_size(size)
      unless SIZES.key?(size)
        raise ArgumentError, "Invalid size: #{size}. Must be one of: #{SIZES.keys.join(", ")}"
      end
      size
    end

    def validate_flip(flip)
      return nil if flip.nil?
      unless FLIPS.key?(flip)
        raise ArgumentError, "Invalid flip: #{flip}. Must be one of: #{FLIPS.keys.join(", ")}"
      end
      flip
    end

    def validate_rotate(rotate)
      return nil if rotate.nil?
      unless ROTATIONS.key?(rotate)
        raise ArgumentError, "Invalid rotate: #{rotate}. Must be one of: #{ROTATIONS.keys.join(", ")}"
      end
      rotate
    end
  end
end
