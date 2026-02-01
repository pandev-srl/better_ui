# frozen_string_literal: true

module BetterUi
  class LinkComponent < ApplicationComponent
    renders_one :icon_before
    renders_one :icon_after

    SIZES = {
      xs: "text-xs",
      sm: "text-sm",
      md: "text-base",
      lg: "text-lg",
      xl: "text-xl"
    }.freeze

    STYLES = %i[default underline ghost].freeze

    def initialize(
      href:,
      variant: :primary,
      style: :default,
      size: :md,
      target: nil,
      rel: nil,
      disabled: false,
      container_classes: nil,
      **options
    )
      @href = href
      @variant = validate_variant(variant)
      @style = validate_style(style)
      @size = validate_size(size)
      @target = target
      @rel = compute_rel(target, rel)
      @disabled = disabled
      @container_classes = container_classes
      @options = options
    end

    private

    attr_reader :variant, :style, :size, :href, :target, :rel, :disabled,
                :container_classes, :options

    def component_classes
      css_classes([
        base_classes,
        size_classes,
        style_classes,
        state_classes,
        @container_classes
      ].flatten.compact)
    end

    def component_attributes
      attrs = {
        target: @target,
        rel: @rel,
        **@options
      }

      if @disabled
        attrs[:"aria-disabled"] = "true"
        attrs[:tabindex] = "-1"
      end

      attrs.compact
    end

    def base_classes
      "inline-flex items-center gap-1 transition-colors duration-200 cursor-pointer"
    end

    def size_classes
      SIZES[@size]
    end

    def style_classes
      case @style
      when :default then default_style_classes
      when :underline then underline_style_classes
      when :ghost then ghost_style_classes
      end
    end

    def default_style_classes
      case @variant
      when :primary   then "text-primary-600 hover:text-primary-800"
      when :secondary then "text-secondary-600 hover:text-secondary-800"
      when :accent    then "text-accent-600 hover:text-accent-800"
      when :success   then "text-success-600 hover:text-success-800"
      when :danger    then "text-danger-600 hover:text-danger-800"
      when :warning   then "text-warning-600 hover:text-warning-800"
      when :info      then "text-info-600 hover:text-info-800"
      when :light     then "text-grayscale-400 hover:text-grayscale-600"
      when :dark      then "text-grayscale-800 hover:text-grayscale-950"
      end
    end

    def underline_style_classes
      decoration = "underline underline-offset-2 decoration-1"

      color_classes = case @variant
      when :primary   then "text-primary-600 hover:text-primary-800"
      when :secondary then "text-secondary-600 hover:text-secondary-800"
      when :accent    then "text-accent-600 hover:text-accent-800"
      when :success   then "text-success-600 hover:text-success-800"
      when :danger    then "text-danger-600 hover:text-danger-800"
      when :warning   then "text-warning-600 hover:text-warning-800"
      when :info      then "text-info-600 hover:text-info-800"
      when :light     then "text-grayscale-400 hover:text-grayscale-600"
      when :dark      then "text-grayscale-800 hover:text-grayscale-950"
      end

      "#{decoration} #{color_classes}"
    end

    def ghost_style_classes
      case @variant
      when :primary   then "text-primary-600 hover:bg-primary-50 px-1 py-0.5 rounded"
      when :secondary then "text-secondary-600 hover:bg-secondary-50 px-1 py-0.5 rounded"
      when :accent    then "text-accent-600 hover:bg-accent-50 px-1 py-0.5 rounded"
      when :success   then "text-success-600 hover:bg-success-50 px-1 py-0.5 rounded"
      when :danger    then "text-danger-600 hover:bg-danger-50 px-1 py-0.5 rounded"
      when :warning   then "text-warning-600 hover:bg-warning-50 px-1 py-0.5 rounded"
      when :info      then "text-info-600 hover:bg-info-50 px-1 py-0.5 rounded"
      when :light     then "text-grayscale-400 hover:bg-grayscale-50 px-1 py-0.5 rounded"
      when :dark      then "text-grayscale-800 hover:bg-grayscale-100 px-1 py-0.5 rounded"
      end
    end

    def state_classes
      return "opacity-50 cursor-not-allowed pointer-events-none" if @disabled

      nil
    end

    def compute_rel(target, rel)
      return rel if rel.present?
      return "noopener noreferrer" if target == "_blank"

      nil
    end

    def validate_variant(variant)
      unless BetterUi::ApplicationComponent::VARIANTS.key?(variant)
        raise ArgumentError, "Invalid variant: #{variant}. Must be one of: #{BetterUi::ApplicationComponent::VARIANTS.keys.join(", ")}"
      end

      variant
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
