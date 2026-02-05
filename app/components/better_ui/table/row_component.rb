# frozen_string_literal: true

module BetterUi
  module Table
    # A table row component that renders a <tr> element with cell slots.
    #
    # Used within TableComponent for slot-based table construction.
    # Supports striped row backgrounds and hover effects.
    #
    # @example Row with cells
    #   <% t.with_row do |r| %>
    #     <% r.with_cell { "John" } %>
    #     <% r.with_cell { "john@example.com" } %>
    #   <% end %>
    class RowComponent < ApplicationComponent
      renders_many :cells, lambda { |**args|
        CellComponent.new(size: @size, style: @style, **args)
      }

      def initialize(size: :md, striped: false, variant: :primary, hoverable: false, highlighted: false,
                     style: :default, container_classes: nil)
        @size = size
        @striped = striped
        @variant = variant
        @hoverable = hoverable
        @highlighted = highlighted
        @style = style
        @container_classes = container_classes
      end

      private

      def component_classes
        css_classes([
          striped_classes,
          hoverable_classes,
          highlighted_classes,
          @container_classes
        ].compact)
      end

      def striped_classes
        @striped ? VARIANT_STRIPED[@variant] : nil
      end

      def hoverable_classes
        @hoverable ? VARIANT_HOVERABLE[@variant] : nil
      end

      def highlighted_classes
        @highlighted ? VARIANT_HIGHLIGHTED[@variant] : nil
      end
    end
  end
end
