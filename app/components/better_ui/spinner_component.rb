# frozen_string_literal: true

module BetterUi
  class SpinnerComponent < ApplicationComponent
    SIZES = {
      xs: "w-4 h-4",
      sm: "w-5 h-5",
      md: "w-8 h-8",
      lg: "w-12 h-12",
      xl: "w-16 h-16"
    }.freeze

    def initialize(
      variant: :primary,
      size: :md,
      label: nil,
      container_classes: nil,
      **options
    )
      @variant = validate_variant(variant)
      @size = validate_size(size)
      @label = label
      @container_classes = container_classes
      @options = options
    end

    private

    attr_reader :variant, :size, :label, :container_classes, :options

    def component_classes
      css_classes(
        variant_classes,
        @container_classes
      )
    end

    def size_classes
      SIZES[@size]
    end

    def variant_classes
      case @variant
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
