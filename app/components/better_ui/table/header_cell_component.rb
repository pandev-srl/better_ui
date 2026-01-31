# frozen_string_literal: true

module BetterUi
  module Table
    # A table header cell component that renders a <th> element.
    #
    # Used within HeaderComponent to render column headers.
    # Supports text alignment, size-based padding, and label text.
    #
    # @example Header cell with label
    #   <%= render BetterUi::Table::HeaderCellComponent.new(label: "Name") %>
    #
    # @example Header cell with block content
    #   <%= render BetterUi::Table::HeaderCellComponent.new(align: :right) { "Actions" } %>
    class HeaderCellComponent < ApplicationComponent
      SIZES = {
        xs: { padding: "px-2 py-1.5", text: "text-xs" },
        sm: { padding: "px-3 py-2", text: "text-sm" },
        md: { padding: "px-3 py-3.5", text: "text-sm" },
        lg: { padding: "px-4 py-4", text: "text-base" },
        xl: { padding: "px-6 py-5", text: "text-lg" }
      }.freeze

      ALIGNMENTS = %i[left center right].freeze

      def initialize(label: nil, align: :left, size: :md, style: :default, container_classes: nil, **options)
        @label = label
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
          "font-semibold",
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
        "border border-grayscale-200" if @style == :bordered
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
