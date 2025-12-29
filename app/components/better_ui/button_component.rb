# frozen_string_literal: true

module BetterUi
  class ButtonComponent < ApplicationComponent
    renders_one :icon_before
    renders_one :icon_after

    SIZES = {
      xs: { padding: "px-2 py-1", text: "text-xs", icon: "w-3 h-3", gap: "gap-1" },
      sm: { padding: "px-3 py-1.5", text: "text-sm", icon: "w-4 h-4", gap: "gap-1.5" },
      md: { padding: "px-4 py-2", text: "text-base", icon: "w-5 h-5", gap: "gap-2" },
      lg: { padding: "px-5 py-2.5", text: "text-lg", icon: "w-6 h-6", gap: "gap-2.5" },
      xl: { padding: "px-6 py-3", text: "text-xl", icon: "w-7 h-7", gap: "gap-3" }
    }.freeze

    STYLES = %i[solid outline ghost soft].freeze
    TYPES = %i[button submit reset].freeze

    def initialize(
      variant: :primary,
      style: :solid,
      size: :md,
      show_loader: false,
      show_loader_on_click: false,
      disabled: false,
      type: :button,
      href: nil,
      target: nil,
      rel: nil,
      method: nil,
      container_classes: nil,
      **options
    )
      @variant = validate_variant(variant)
      @style = validate_style(style)
      @size = validate_size(size)
      @show_loader = show_loader
      @show_loader_on_click = show_loader_on_click
      @disabled = disabled
      @type = validate_type(type) unless href
      @href = href
      @target = target
      @rel = compute_rel(target, rel)
      @method = method
      @container_classes = container_classes
      @options = options
    end

    def link?
      @href.present?
    end

    private

    attr_reader :variant, :style, :size, :show_loader, :show_loader_on_click, :disabled, :type,
                :href, :target, :rel, :method, :container_classes, :options

    def component_classes
      css_classes([
        base_classes,
        style_classes,
        size_classes,
        state_classes,
        @container_classes
      ].flatten.compact)
    end

    def component_attributes
      link? ? link_attributes : button_attributes
    end

    def button_attributes
      data_attrs = {
        controller: "better-ui--button",
        action: "click->better-ui--button#handleClick"
      }

      data_attrs[:"better-ui--button-show-loader-on-click-value"] = @show_loader_on_click if @show_loader_on_click

      {
        type: @type,
        disabled: @disabled || @show_loader,
        data: data_attrs,
        **@options
      }
    end

    def link_attributes
      data_attrs = {
        controller: "better-ui--button",
        action: "click->better-ui--button#handleClick"
      }

      data_attrs[:"better-ui--button-show-loader-on-click-value"] = @show_loader_on_click if @show_loader_on_click
      data_attrs[:turbo_method] = @method if @method

      attrs = {
        href: disabled_or_loading? ? nil : @href,
        target: @target,
        rel: @rel,
        data: data_attrs,
        **@options
      }

      if disabled_or_loading?
        attrs[:"aria-disabled"] = "true"
        attrs[:tabindex] = "-1"
      end

      attrs.compact
    end

    def disabled_or_loading?
      @disabled || @show_loader
    end

    def compute_rel(target, rel)
      return rel if rel.present?
      return "noopener noreferrer" if target == "_blank"
      nil
    end

    def base_classes
      ring_class = case @variant
      when :primary   then "focus:ring-primary-500"
      when :secondary then "focus:ring-secondary-500"
      when :accent    then "focus:ring-accent-500"
      when :success   then "focus:ring-success-500"
      when :danger    then "focus:ring-danger-500"
      when :warning   then "focus:ring-warning-500"
      when :info      then "focus:ring-info-500"
      when :light     then "focus:ring-grayscale-400"
      when :dark      then "focus:ring-grayscale-600"
      end

      [
        "inline-flex items-center justify-center",
        "font-medium rounded-lg",
        "transition-all duration-200",
        "focus:outline-none focus:ring-2 focus:ring-offset-2",
        ring_class
      ]
    end

    def style_classes
      case @style
      when :solid then solid_classes
      when :outline then outline_classes
      when :ghost then ghost_classes
      when :soft then soft_classes
      end
    end

    def solid_classes
      bg_classes = case @variant
      when :primary
        [ "bg-primary-600", "hover:bg-primary-700", "active:bg-primary-800" ]
      when :secondary
        [ "bg-secondary-600", "hover:bg-secondary-700", "active:bg-secondary-800" ]
      when :accent
        [ "bg-accent-600", "hover:bg-accent-700", "active:bg-accent-800" ]
      when :success
        [ "bg-success-600", "hover:bg-success-700", "active:bg-success-800" ]
      when :danger
        [ "bg-danger-600", "hover:bg-danger-700", "active:bg-danger-800" ]
      when :warning
        [ "bg-warning-600", "hover:bg-warning-700", "active:bg-warning-800" ]
      when :info
        [ "bg-info-600", "hover:bg-info-700", "active:bg-info-800" ]
      when :light
        [ "bg-grayscale-100", "hover:bg-grayscale-200", "active:bg-grayscale-300" ]
      when :dark
        [ "bg-grayscale-900", "hover:bg-grayscale-800", "active:bg-grayscale-700" ]
      end

      bg_classes + [ text_color_for_solid ]
    end

    def outline_classes
      color_classes = case @variant
      when :primary
        [ "border-primary-600", "hover:border-primary-700", "hover:bg-primary-50", "text-primary-600" ]
      when :secondary
        [ "border-secondary-600", "hover:border-secondary-700", "hover:bg-secondary-50", "text-secondary-600" ]
      when :accent
        [ "border-accent-600", "hover:border-accent-700", "hover:bg-accent-50", "text-accent-600" ]
      when :success
        [ "border-success-600", "hover:border-success-700", "hover:bg-success-50", "text-success-600" ]
      when :danger
        [ "border-danger-600", "hover:border-danger-700", "hover:bg-danger-50", "text-danger-600" ]
      when :warning
        [ "border-warning-600", "hover:border-warning-700", "hover:bg-warning-50", "text-warning-600" ]
      when :info
        [ "border-info-600", "hover:border-info-700", "hover:bg-info-50", "text-info-600" ]
      when :light
        [ "border-grayscale-400", "hover:border-grayscale-500", "hover:bg-grayscale-50", "text-grayscale-400", "hover:text-grayscale-500" ]
      when :dark
        [ "border-grayscale-700", "hover:border-grayscale-600", "hover:bg-grayscale-600", "text-grayscale-700", "hover:text-grayscale-50" ]
      end

      [ "bg-transparent", "border-2" ] + color_classes
    end

    def ghost_classes
      color_classes = case @variant
      when :primary
        [ "hover:bg-primary-50", "active:bg-primary-100", "text-primary-600" ]
      when :secondary
        [ "hover:bg-secondary-50", "active:bg-secondary-100", "text-secondary-600" ]
      when :accent
        [ "hover:bg-accent-50", "active:bg-accent-100", "text-accent-600" ]
      when :success
        [ "hover:bg-success-50", "active:bg-success-100", "text-success-600" ]
      when :danger
        [ "hover:bg-danger-50", "active:bg-danger-100", "text-danger-600" ]
      when :warning
        [ "hover:bg-warning-50", "active:bg-warning-100", "text-warning-600" ]
      when :info
        [ "hover:bg-info-50", "active:bg-info-100", "text-info-600" ]
      when :light
        [ "hover:bg-grayscale-100", "active:bg-grayscale-200", "text-grayscale-700" ]
      when :dark
        [ "hover:bg-grayscale-800", "active:bg-grayscale-700", "text-grayscale-700", "hover:text-grayscale-50" ]
      end

      [ "bg-transparent" ] + color_classes
    end

    def soft_classes
      case @variant
      when :primary
        [ "bg-primary-100", "hover:bg-primary-200", "active:bg-primary-300", "text-primary-700" ]
      when :secondary
        [ "bg-secondary-100", "hover:bg-secondary-200", "active:bg-secondary-300", "text-secondary-700" ]
      when :accent
        [ "bg-accent-100", "hover:bg-accent-200", "active:bg-accent-300", "text-accent-700" ]
      when :success
        [ "bg-success-100", "hover:bg-success-200", "active:bg-success-300", "text-success-700" ]
      when :danger
        [ "bg-danger-100", "hover:bg-danger-200", "active:bg-danger-300", "text-danger-700" ]
      when :warning
        [ "bg-warning-100", "hover:bg-warning-200", "active:bg-warning-300", "text-warning-700" ]
      when :info
        [ "bg-info-100", "hover:bg-info-200", "active:bg-info-300", "text-info-700" ]
      when :light
        [ "bg-grayscale-100", "hover:bg-grayscale-200", "active:bg-grayscale-300", "text-grayscale-700" ]
      when :dark
        [ "bg-grayscale-800", "hover:bg-grayscale-700", "active:bg-grayscale-600", "text-grayscale-100" ]
      end
    end

    def text_color_for_solid
      @variant == :light ? "text-grayscale-900" : "text-grayscale-50"
    end

    def size_classes
      size_config = SIZES[@size]
      [
        size_config[:padding],
        size_config[:text],
        size_config[:gap]
      ]
    end

    def state_classes
      classes = []
      if @disabled && !@show_loader
        classes << "opacity-50 cursor-not-allowed"
        classes << "pointer-events-none" if link?
      elsif @show_loader
        classes << "cursor-wait"
        classes << "pointer-events-none" if link?
      else
        classes << "cursor-pointer"
      end
      classes
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

    def validate_type(type)
      unless TYPES.include?(type)
        raise ArgumentError, "Invalid type: #{type}. Must be one of: #{TYPES.join(", ")}"
      end
      type
    end
  end
end
