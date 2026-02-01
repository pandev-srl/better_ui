# frozen_string_literal: true

module BetterUi
  module Dropdown
    class DropdownComponent < ApplicationComponent
      SIZES = {
        sm: "w-40",
        md: "w-56",
        lg: "w-72"
      }.freeze

      PLACEMENTS = {
        bottom_start: "top-full left-0 mt-1",
        bottom_end: "top-full right-0 mt-1",
        top_start: "bottom-full left-0 mb-1",
        top_end: "bottom-full right-0 mb-1"
      }.freeze

      renders_one :trigger
      renders_many :items, types: {
        item: {
          renders: lambda { |**args, &block|
            ItemComponent.new(**args, &block)
          },
          as: :item
        },
        divider: {
          renders: lambda { |**args|
            DividerComponent.new(**args)
          },
          as: :divider
        },
        header: {
          renders: lambda { |**args|
            HeaderComponent.new(**args)
          },
          as: :header
        }
      }

      def initialize(
        variant: :default,
        size: :md,
        placement: :bottom_start,
        shadow: :lg,
        auto_close: true,
        close_on_item_click: true,
        container_classes: nil,
        menu_classes: nil
      )
        @variant = variant
        @size = validate_size(size || :md)
        @placement = validate_placement(placement || :bottom_start)
        @shadow = normalize_shadow(shadow, default: :lg)
        @auto_close = auto_close
        @close_on_item_click = close_on_item_click
        @container_classes = container_classes
        @menu_classes = menu_classes
      end

      private

      def controller_data
        {
          controller: "better-ui--dropdown--dropdown",
          "better-ui--dropdown--dropdown-auto-close-value": @auto_close,
          "better-ui--dropdown--dropdown-close-on-item-click-value": @close_on_item_click
        }
      end

      def root_classes
        css_classes(
          "relative inline-block",
          @container_classes
        )
      end

      def menu_classes
        css_classes(
          "absolute z-50",
          "bg-white rounded-md ring-1 ring-grayscale-200 ring-opacity-5",
          "py-1 overflow-hidden",
          "focus:outline-none",
          "transition-all duration-150 ease-out",
          "opacity-0 scale-95",
          SIZES[@size],
          PLACEMENTS[@placement],
          SHADOWS[@shadow],
          @menu_classes
        )
      end

      def validate_size(size)
        unless SIZES.key?(size)
          raise ArgumentError, "Invalid size: #{size}. Must be one of: #{SIZES.keys.join(', ')}"
        end
        size
      end

      def validate_placement(placement)
        unless PLACEMENTS.key?(placement)
          raise ArgumentError, "Invalid placement: #{placement}. Must be one of: #{PLACEMENTS.keys.join(', ')}"
        end
        placement
      end
    end
  end
end
