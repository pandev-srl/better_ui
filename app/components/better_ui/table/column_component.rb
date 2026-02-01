# frozen_string_literal: true

module BetterUi
  module Table
    # A data-holder component for defining table columns in collection mode.
    #
    # ColumnComponent stores column configuration (key, label, alignment, formatter)
    # and produces no rendered output. The parent TableComponent reads these
    # configurations to build the table structure.
    #
    # @example Column with key (auto-extracts value from collection items)
    #   <% t.with_column(key: :name, label: "Name") %>
    #
    # @example Column with custom formatter
    #   <% t.with_column(key: :role, label: "Role") { |user| user.role.humanize } %>
    #
    # @example Column with no key (header-only, relies on formatter block)
    #   <% t.with_column(label: "Actions", align: :right) { |user| link_to("Edit", user) } %>
    class ColumnComponent < ApplicationComponent
      ALIGNMENTS = %i[left center right].freeze
      SORT_DIRECTIONS = %i[asc desc].freeze

      attr_reader :key, :label, :align, :header_classes, :cell_classes, :formatter,
                  :sortable, :sorted, :sort_direction

      def initialize(key: nil, label: nil, align: :left, header_classes: nil, cell_classes: nil,
                     sortable: false, sorted: false, sort_direction: :asc, &formatter)
        @key = key
        @label = label
        @align = validate_align(align)
        @header_classes = header_classes
        @cell_classes = cell_classes
        @sortable = sortable
        @sorted = sorted
        @sort_direction = validate_sort_direction(sort_direction)
        @formatter = formatter
      end

      def call
        ""
      end

      def display_label
        @label || @key&.to_s&.humanize || ""
      end

      def value_for(item)
        if @formatter
          @formatter.call(item)
        elsif @key
          item.respond_to?(@key) ? item.public_send(@key) : item[@key]
        else
          ""
        end
      end

      private

      def validate_align(align)
        unless ALIGNMENTS.include?(align)
          raise ArgumentError, "Invalid align: #{align}. Must be one of: #{ALIGNMENTS.join(', ')}"
        end
        align
      end

      def validate_sort_direction(direction)
        unless SORT_DIRECTIONS.include?(direction)
          raise ArgumentError,
                "Invalid sort_direction: #{direction}. Must be one of: #{SORT_DIRECTIONS.join(', ')}"
        end
        direction
      end
    end
  end
end
