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
        case @variant
        when :primary then "hover:bg-primary-100 transition-colors"
        when :secondary then "hover:bg-secondary-100 transition-colors"
        when :accent then "hover:bg-accent-100 transition-colors"
        when :success then "hover:bg-success-100 transition-colors"
        when :danger then "hover:bg-danger-100 transition-colors"
        when :warning then "hover:bg-warning-100 transition-colors"
        when :info then "hover:bg-info-100 transition-colors"
        when :light then "hover:bg-grayscale-100 transition-colors"
        when :dark then "hover:bg-grayscale-600 transition-colors"
        end
      end

      def highlighted_classes
        return nil unless @highlighted
        case @variant
        when :primary then "bg-primary-100"
        when :secondary then "bg-secondary-100"
        when :accent then "bg-accent-100"
        when :success then "bg-success-100"
        when :danger then "bg-danger-100"
        when :warning then "bg-warning-100"
        when :info then "bg-info-100"
        when :light then "bg-grayscale-100"
        when :dark then "bg-grayscale-700"
        end
      end
    end
  end
end
