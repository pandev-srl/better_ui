# frozen_string_literal: true

module BetterUi
  class TagComponent < ApplicationComponent
    include BetterUi::Concerns::InlineLabelStyles

    renders_one :icon_before

    SIZES = {
      xs: { padding: "px-1.5 py-0.5", text: "text-xs", icon: "w-3 h-3", gap: "gap-1", dismiss_icon: "w-2.5 h-2.5" },
      sm: { padding: "px-2 py-0.5", text: "text-xs", icon: "w-3.5 h-3.5", gap: "gap-1", dismiss_icon: "w-3 h-3" },
      md: { padding: "px-2.5 py-1", text: "text-sm", icon: "w-4 h-4", gap: "gap-1.5", dismiss_icon: "w-3.5 h-3.5" },
      lg: { padding: "px-3 py-1.5", text: "text-base", icon: "w-5 h-5", gap: "gap-2", dismiss_icon: "w-4 h-4" }
    }.freeze

    STYLES = %i[solid outline soft].freeze

    def initialize(
      variant: :primary,
      style: :solid,
      size: :md,
      dismissible: false,
      href: nil,
      container_classes: nil,
      **options
    )
      @variant = validate_variant(variant)
      @style = validate_style(style)
      @size = validate_size(size)
      @dismissible = dismissible
      @href = href
      @container_classes = container_classes
      @options = options
    end

    def link?
      @href.present?
    end

    private

    attr_reader :variant, :style, :size, :dismissible, :href, :container_classes, :options

    def component_classes
      css_classes([
        base_classes,
        style_classes,
        size_classes,
        @container_classes
      ].flatten.compact)
    end

    def component_attributes
      attrs = {}
      attrs[:href] = @href if link?

      if @dismissible
        attrs[:data] = {
          controller: "better-ui--tag"
        }
      end

      attrs.merge(@options)
    end

    def base_classes
      [
        "inline-flex items-center",
        "font-medium rounded-full",
        "transition-colors duration-200"
      ]
    end

    def style_classes
      case @style
      when :solid then solid_classes
      when :outline then outline_classes
      when :soft then soft_classes
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

    def dismiss_icon_classes
      SIZES[@size][:dismiss_icon]
    end

    # Override hook: Tag uses text-grayscale-500 for light outline variant
    def outline_light_text_class
      "text-grayscale-500"
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
