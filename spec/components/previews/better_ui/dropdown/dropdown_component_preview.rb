# frozen_string_literal: true

module BetterUi
  module Dropdown
    # @label Dropdown
    class DropdownComponentPreview < ViewComponent::Preview
      # @label Default
      def default
        render_with_template
      end

      # @label All Sizes
      def all_sizes
        render_with_template
      end

      # @label With Icons
      def with_icons
        render_with_template
      end

      # @label With Dividers and Headers
      def with_dividers_and_headers
        render_with_template
      end

      # @label Placement Options
      def placement_options
        render_with_template
      end

      # @label Disabled Items
      def disabled_items
        render_with_template
      end

      # @label Playground
      # @param size select { choices: [sm, md, lg] }
      # @param placement select { choices: [bottom_start, bottom_end, top_start, top_end] }
      # @param shadow select { choices: [none, sm, md, lg, xl] }
      # @param auto_close toggle
      # @param close_on_item_click toggle
      def playground(
        size: :md,
        placement: :bottom_start,
        shadow: :lg,
        auto_close: true,
        close_on_item_click: true
      )
        @size = size.presence&.to_sym || :md
        @placement = placement.presence&.to_sym || :bottom_start
        @shadow = shadow.presence&.to_sym || :lg
        @auto_close = auto_close
        @close_on_item_click = close_on_item_click
        render_with_template
      end
    end
  end
end
