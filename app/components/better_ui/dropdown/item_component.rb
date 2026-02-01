# frozen_string_literal: true

module BetterUi
  module Dropdown
    class ItemComponent < ApplicationComponent
      ITEM_VARIANTS = {
        default: "text-grayscale-700",
        danger: "text-danger-600"
      }.freeze

      renders_one :icon

      def initialize(
        href: nil,
        disabled: false,
        method: nil,
        active: false,
        variant: :default,
        container_classes: nil
      )
        @href = href
        @disabled = disabled
        @method = method
        @active = active
        @variant = validate_variant(variant)
        @container_classes = container_classes
      end

      private

      attr_reader :href, :disabled, :method, :active, :variant, :container_classes

      def link?
        @href.present?
      end

      def component_classes
        css_classes(
          "flex items-center gap-2 w-full text-left px-3 py-2 text-sm",
          "transition-colors duration-150",
          ITEM_VARIANTS[@variant],
          hover_classes,
          active_classes,
          disabled_classes,
          @container_classes
        )
      end

      def hover_classes
        return nil if @disabled

        case @variant
        when :danger then "hover:bg-danger-50 hover:text-danger-700"
        else "hover:bg-grayscale-100 hover:text-grayscale-900"
        end
      end

      def active_classes
        @active ? "bg-grayscale-100" : nil
      end

      def disabled_classes
        @disabled ? "opacity-50 cursor-not-allowed pointer-events-none" : "cursor-pointer"
      end

      def component_attributes
        base = {
          role: "menuitem",
          tabindex: "-1",
          class: component_classes,
          data: {
            "better-ui--dropdown--dropdown-target": "item"
          }
        }

        if link?
          base[:href] = @href
          base[:data]["turbo-method"] = @method if @method
          base[:"aria-disabled"] = "true" if @disabled
        else
          base[:type] = "button"
          base[:disabled] = true if @disabled
          base[:"aria-disabled"] = "true" if @disabled
        end

        base
      end

      def validate_variant(variant)
        unless ITEM_VARIANTS.key?(variant)
          raise ArgumentError, "Invalid variant: #{variant}. Must be one of: #{ITEM_VARIANTS.keys.join(', ')}"
        end
        variant
      end
    end
  end
end
