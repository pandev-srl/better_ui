# frozen_string_literal: true

module BetterUi
  class ProgressComponent < ApplicationComponent
    SIZES = {
      xs: "h-1",
      sm: "h-2",
      md: "h-3",
      lg: "h-4"
    }.freeze

    def initialize(
      value: 0,
      max: 100,
      variant: :primary,
      size: :md,
      label: nil,
      show_value: false,
      animated: false,
      container_classes: nil,
      **options
    )
      @value = value
      @max = max
      @variant = validate_variant(variant)
      @size = validate_size(size)
      @label = label
      @show_value = show_value
      @animated = animated
      @container_classes = container_classes
      @options = options
    end

    private

    attr_reader :value, :max, :variant, :size, :label, :show_value, :animated,
                :container_classes, :options

    def percentage
      (@value.to_f / @max * 100).clamp(0, 100)
    end

    def wrapper_classes
      css_classes(
        @container_classes
      )
    end

    def track_classes
      css_classes(
        "bg-grayscale-200 rounded-full overflow-hidden",
        SIZES[@size]
      )
    end

    def bar_classes
      css_classes(
        "rounded-full transition-all duration-300 ease-out h-full",
        variant_classes,
        animated_classes
      )
    end

    def variant_classes
      case @variant
      when :primary   then "bg-primary-600"
      when :secondary then "bg-secondary-500"
      when :accent    then "bg-accent-500"
      when :success   then "bg-success-600"
      when :danger    then "bg-danger-600"
      when :warning   then "bg-warning-500"
      when :info      then "bg-info-500"
      when :light     then "bg-grayscale-400"
      when :dark      then "bg-grayscale-800"
      end
    end

    def animated_classes
      return nil unless @animated

      "bg-gradient-to-r from-transparent via-white/20 to-transparent animate-pulse"
    end

    def validate_variant(variant)
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
  end
end
