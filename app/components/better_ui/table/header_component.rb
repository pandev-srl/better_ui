# frozen_string_literal: true

module BetterUi
  module Table
    # A table header row component that renders a <tr> element with header cell slots.
    #
    # Used within TableComponent's <thead> section for slot-based table construction.
    # Header cells are rendered as <th> elements with appropriate styling.
    #
    # @example Header with cells
    #   <% t.with_header do |h| %>
    #     <% h.with_cell(label: "Name") %>
    #     <% h.with_cell(label: "Email") %>
    #     <% h.with_cell(label: "Actions", align: :right) %>
    #   <% end %>
    class HeaderComponent < ApplicationComponent
      renders_many :cells, lambda { |**args|
        HeaderCellComponent.new(size: @size, style: @style, **args)
      }

      def initialize(size: :md, variant: :primary, style: :default, container_classes: nil)
        @size = size
        @variant = variant
        @style = style
        @container_classes = container_classes
      end

      private

      def component_classes
        css_classes([
          @container_classes
        ].compact)
      end
    end
  end
end
