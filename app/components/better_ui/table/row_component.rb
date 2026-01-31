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

      def initialize(size: :md, striped: false, variant: :primary, hoverable: false, style: :default, container_classes: nil)
        @size = size
        @striped = striped
        @variant = variant
        @hoverable = hoverable
        @style = style
        @container_classes = container_classes
      end

      private

      def component_classes
        css_classes([
          striped_classes,
          hoverable_classes,
          @container_classes
        ].compact)
      end

      def striped_classes
        return nil unless @striped
        case @variant
        when :primary then "even:bg-primary-50"
        when :secondary then "even:bg-secondary-50"
        when :accent then "even:bg-accent-50"
        when :success then "even:bg-success-50"
        when :danger then "even:bg-danger-50"
        when :warning then "even:bg-warning-50"
        when :info then "even:bg-info-50"
        when :light then "even:bg-grayscale-50"
        when :dark then "even:bg-grayscale-700"
        end
      end

      def hoverable_classes
        return nil unless @hoverable
        "hover:bg-grayscale-100 transition-colors"
      end
    end
  end
end
