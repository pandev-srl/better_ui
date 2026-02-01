# frozen_string_literal: true

module BetterUi
  class BadgeComponent < ApplicationComponent
    include BetterUi::Concerns::InlineLabelStyles

    renders_one :icon_before

    SIZES = {
      xs: { padding: "px-1.5 py-0.5", text: "text-xs", icon: "w-3 h-3", gap: "gap-1" },
      sm: { padding: "px-2 py-0.5", text: "text-xs", icon: "w-3.5 h-3.5", gap: "gap-1" },
      md: { padding: "px-2.5 py-1", text: "text-sm", icon: "w-4 h-4", gap: "gap-1.5" },
      lg: { padding: "px-3 py-1.5", text: "text-base", icon: "w-5 h-5", gap: "gap-2" }
    }.freeze

    STYLES = %i[solid outline soft ghost].freeze

    def initialize(
      variant: :primary,
      style: :solid,
      size: :md,
      pill: true,
      dot: false,
      counter: nil,
      container_classes: nil,
      **options
    )
      @variant = validate_variant(variant)
      @style = validate_style(style)
      @size = validate_size(size)
      @pill = pill
      @dot = dot
      @counter = counter
      @container_classes = container_classes
      @options = options
    end

    private

    attr_reader :variant, :style, :size, :pill, :dot, :counter, :container_classes, :options

    def component_classes
      css_classes([
        base_classes,
        style_classes,
        size_classes,
        shape_classes,
        @container_classes
      ].flatten.compact)
    end

    def component_attributes
      @options
    end

    def base_classes
      [
        "inline-flex items-center",
        "font-medium",
        "transition-colors duration-200"
      ]
    end

    def shape_classes
      @pill ? "rounded-full" : "rounded-md"
    end

    def style_classes
      case @style
      when :solid then solid_classes
      when :outline then outline_classes
      when :soft then soft_classes
      when :ghost then ghost_classes
      end
    end

    def size_classes
      size_config = SIZES[@size]
      [
        size_config[:padding],
        size_config[:text],
        size_config[:gap]
      ]
    end

    def dot_classes
      case @variant
      when :primary   then "bg-primary-600"
      when :secondary then "bg-secondary-600"
      when :accent    then "bg-accent-600"
      when :success   then "bg-success-600"
      when :danger    then "bg-danger-600"
      when :warning   then "bg-warning-600"
      when :info      then "bg-info-600"
      when :light     then "bg-grayscale-400"
      when :dark      then "bg-grayscale-900"
      end
    end

    def validate_style(style)
      unless STYLES.include?(style)
        raise ArgumentError, "Invalid style: #{style}. Must be one of: #{STYLES.join(", ")}"
      end
      style
    end

    def validate_size(size)
      unless SIZES.key?(size)
        raise ArgumentError, "Invalid size: #{size}. Must be one of: #{SIZES.keys.join(", ")}"
      end
      size
    end
  end
end
