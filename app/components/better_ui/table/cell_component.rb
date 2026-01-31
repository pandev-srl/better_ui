# frozen_string_literal: true

module BetterUi
  module Table
    # A table cell component that renders a <td> element.
    #
    # Used within RowComponent to render individual data cells.
    # Supports text alignment and size-based padding.
    #
    # @example Basic cell
    #   <%= render BetterUi::Table::CellComponent.new { "Cell content" } %>
    #
    # @example Right-aligned cell
    #   <%= render BetterUi::Table::CellComponent.new(align: :right) { "$100.00" } %>
    class CellComponent < ApplicationComponent
      SIZES = {
        xs: { padding: "px-2 py-2", text: "text-xs" },
        sm: { padding: "px-3 py-2.5", text: "text-sm" },
        md: { padding: "px-3 py-4", text: "text-sm" },
        lg: { padding: "px-4 py-5", text: "text-base" },
        xl: { padding: "px-6 py-6", text: "text-lg" }
      }.freeze

      ALIGNMENTS = %i[left center right].freeze

      def initialize(align: :left, size: :md, style: :default, container_classes: nil, **options)
        @align = validate_align(align)
        @size = validate_size(size)
        @style = style
        @container_classes = container_classes
        @options = options
      end

      private

      def component_classes
        css_classes([
          size_config[:padding],
          size_config[:text],
          "text-black",
          "align-middle",
          align_class,
          first_last_cell_classes,
          border_classes,
          @container_classes
        ].compact)
      end

      def first_last_cell_classes
        "first:ps-4 first:pe-3 sm:first:ps-6 last:ps-3 last:pe-4 sm:last:pe-6"
      end

      def size_config
        SIZES[@size]
      end

      def align_class
        case @align
        when :left then "text-left"
        when :center then "text-center"
        when :right then "text-right"
        end
      end

      def border_classes
        nil
      end

      def validate_align(align)
        unless ALIGNMENTS.include?(align)
          raise ArgumentError, "Invalid align: #{align}. Must be one of: #{ALIGNMENTS.join(', ')}"
        end
        align
      end

      def validate_size(size)
        unless SIZES.key?(size)
          raise ArgumentError, "Invalid size: #{size}. Must be one of: #{SIZES.keys.join(', ')}"
        end
        size
      end
    end
  end
end
