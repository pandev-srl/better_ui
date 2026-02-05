# frozen_string_literal: true

module BetterUi
  module Table
    # A flexible table component supporting two data modes.
    #
    # **Slot-based mode**: Manually define header, rows, and cells using slots.
    # **Collection-based mode**: Pass a collection and column definitions for automatic rendering.
    #
    # Mode is implicitly detected: if `collection:` is provided, collection mode activates.
    #
    # @example Slot-based usage
    #   <%= render BetterUi::Table::TableComponent.new(variant: :primary, striped: true) do |t| %>
    #     <% t.with_header do |h| %>
    #       <% h.with_cell(label: "Name") %>
    #       <% h.with_cell(label: "Email") %>
    #     <% end %>
    #     <% @users.each do |user| %>
    #       <% t.with_row do |r| %>
    #         <% r.with_cell { user.name } %>
    #         <% r.with_cell { user.email } %>
    #       <% end %>
    #     <% end %>
    #   <% end %>
    #
    # @example Collection-based usage
    #   <%= render BetterUi::Table::TableComponent.new(collection: @users, variant: :primary) do |t| %>
    #     <% t.with_column(key: :name, label: "Name") %>
    #     <% t.with_column(key: :email, label: "Email") %>
    #     <% t.with_column(key: :role, label: "Role") { |user| user.role.humanize } %>
    #   <% end %>
    class TableComponent < ApplicationComponent
      include Concerns::SortIcons
      SIZES = {
        xs: { th_padding: "px-2 py-1.5", td_padding: "px-2 py-2", text: "text-xs" },
        sm: { th_padding: "px-3 py-2", td_padding: "px-3 py-2.5", text: "text-sm" },
        md: { th_padding: "px-3 py-3.5", td_padding: "px-3 py-4", text: "text-sm" },
        lg: { th_padding: "px-4 py-4", td_padding: "px-4 py-5", text: "text-base" },
        xl: { th_padding: "px-6 py-5", td_padding: "px-6 py-6", text: "text-lg" }
      }.freeze

      ROUNDED = {
        none: nil,
        sm: "sm:rounded-sm",
        md: "sm:rounded-lg",
        lg: "sm:rounded-xl",
        xl: "sm:rounded-2xl",
        full: "sm:rounded-full"
      }.freeze

      STYLES = %i[default bordered].freeze

      # Slot-mode slots
      renders_one :header, lambda { |**args|
        HeaderComponent.new(size: @size, variant: @variant, style: @style, **args)
      }

      renders_many :rows, lambda { |**args|
        RowComponent.new(
          size: @size,
          striped: @striped,
          variant: @variant,
          hoverable: @hoverable,
          style: @style,
          **args
        )
      }

      renders_one :footer_row, lambda { |**args|
        RowComponent.new(size: @size, style: @style, **args)
      }

      # Collection-mode slots
      renders_many :columns, lambda { |**args, &block|
        ColumnComponent.new(**args, &block)
      }

      # Shared slot
      renders_one :empty_state

      def initialize(
        variant: :primary,
        style: :default,
        size: :md,
        rounded: :md,
        striped: false,
        hoverable: false,
        responsive: true,
        shadow: :sm,
        caption: nil,
        collection: nil,
        row_highlighted: nil,
        row_html: nil,
        body_row_partial: nil,
        header_partial: nil,
        footer_partial: nil,
        sort_column: nil,
        sort_direction: nil,
        sort_url: nil,
        sort_html: {},
        container_classes: nil,
        table_classes: nil,
        header_classes: nil,
        body_classes: nil,
        footer_classes: nil,
        **options
      )
        @variant = validate_variant(variant)
        @style = validate_style(style)
        @size = validate_size(size)
        @rounded = validate_rounded(rounded)
        @striped = striped
        @hoverable = hoverable
        @responsive = responsive
        @shadow = normalize_shadow(shadow)
        @caption = caption
        @collection = collection
        @row_highlighted = row_highlighted
        @row_html = row_html
        @body_row_partial = body_row_partial
        @header_partial = header_partial
        @footer_partial = footer_partial
        @sort_column = sort_column&.to_sym
        @table_sort_direction = sort_direction&.to_sym
        @sort_url = sort_url
        @sort_html = sort_html || {}
        @container_classes = container_classes
        @table_classes = table_classes
        @header_classes = header_classes
        @body_classes = body_classes
        @footer_classes = footer_classes
        @options = options
      end

      def collection_mode?
        !@collection.nil?
      end

      private

      # Wrapper div classes (card container)
      def wrapper_classes
        css_classes([
          SHADOWS[@shadow],
          "ring-1",
          wrapper_ring_color,
          ROUNDED[@rounded],
          @responsive ? "overflow-x-auto" : "overflow-hidden",
          @container_classes
        ].compact)
      end

      def wrapper_ring_color
        return "ring-black/5" unless @style == :bordered
        variant_ring_color
      end

      # Variant ring color for bordered style
      def variant_ring_color
        VARIANT_RING[@variant]
      end

      # <table> element classes
      def table_element_classes
        css_classes([
          "min-w-full",
          table_divide_classes,
          table_border_classes,
          @table_classes
        ].compact)
      end

      def table_border_classes
        nil
      end

      # <thead> classes
      def thead_classes
        css_classes([
          variant_header_bg,
          variant_header_text,
          @header_classes
        ].compact)
      end

      # <tbody> classes
      def tbody_classes
        css_classes([
          body_divide_classes,
          @body_classes
        ].compact)
      end

      def body_divide_classes
        css_classes([
          "divide-y",
          variant_body_divide_color,
          "bg-white"
        ])
      end

      # Variant body divide color
      def variant_body_divide_color
        VARIANT_BODY_DIVIDE[@variant]
      end

      # <tfoot> classes
      def tfoot_classes
        css_classes([
          "border-t border-grayscale-200",
          @footer_classes
        ].compact)
      end

      # Caption classes
      def caption_classes
        size_config = SIZES[@size]
        css_classes([
          size_config[:td_padding],
          size_config[:text],
          "text-grayscale-500",
          "caption-bottom",
          "text-left"
        ])
      end

      # Variant header background
      def variant_header_bg
        VARIANT_HEADER_BG[@variant]
      end

      # Variant header text color
      def variant_header_text
        VARIANT_HEADER_TEXT[@variant]
      end

      # Collection mode: header cell classes
      def collection_header_cell_classes(column)
        size_config = SIZES[@size]
        css_classes([
          size_config[:th_padding],
          size_config[:text],
          "font-semibold",
          "align-middle",
          align_class(column.align),
          first_last_cell_classes,
          bordered_cell_classes,
          collection_header_sortable_classes(column),
          column.header_classes
        ].compact)
      end

      # Collection mode: row classes
      def collection_row_classes(item = nil)
        css_classes([
          collection_striped_classes,
          collection_hoverable_classes,
          collection_highlighted_classes(item)
        ].compact)
      end

      # Collection mode: full row attributes (classes + custom HTML attrs from row_html proc)
      def collection_row_attributes(item, index)
        base_classes = collection_row_classes(item)
        custom_attrs = resolve_row_html(item, index)
        custom_class = custom_attrs.delete(:class)
        merged_class = custom_class ? css_classes(base_classes, custom_class) : base_classes
        { class: merged_class, **custom_attrs }
      end

      # Resolve row_html proc to a hash of HTML attributes
      def resolve_row_html(item, index)
        return {} if @row_html.nil?

        result = if @row_html.arity == 1
                   @row_html.call(item)
        else
                   @row_html.call(item, index)
        end

        return {} if result.nil?

        unless result.is_a?(Hash)
          raise ArgumentError, "row_html proc must return a Hash or nil, got #{result.class}"
        end

        result.symbolize_keys
      end

      def collection_striped_classes
        @striped ? VARIANT_STRIPED[@variant] : nil
      end

      def collection_hoverable_classes
        @hoverable ? VARIANT_HOVERABLE[@variant] : nil
      end

      def collection_highlighted_classes(item)
        return nil unless @row_highlighted && item && @row_highlighted.call(item)
        VARIANT_HIGHLIGHTED[@variant]
      end

      # Collection mode: cell classes
      def collection_cell_classes(column)
        size_config = SIZES[@size]
        css_classes([
          size_config[:td_padding],
          size_config[:text],
          "text-black",
          "align-middle",
          align_class(column.align),
          first_last_cell_classes,
          bordered_cell_classes,
          column.cell_classes
        ].compact)
      end

      # Shared bordered cell classes (bordered now uses dividers like default)
      def bordered_cell_classes
        nil
      end

      # Table element divide classes
      def table_divide_classes
        VARIANT_DIVIDE[@variant]
      end

      # First/last cell extra padding for card indentation
      def first_last_cell_classes
        "first:ps-4 first:pe-3 sm:first:ps-6 last:ps-3 last:pe-4 sm:last:pe-6"
      end

      def align_class(align)
        case align
        when :left then "text-left"
        when :center then "text-center"
        when :right then "text-right"
        end
      end

      # Collection mode: sortable header classes
      def collection_header_sortable_classes(column)
        return nil unless column.sortable
        "cursor-pointer select-none"
      end

      # Collection mode: whether this column is currently sorted
      # Table-level sort_column overrides column-level sorted
      def effective_sorted?(column)
        if @sort_column
          column.key && column.key.to_sym == @sort_column
        else
          column.sorted
        end
      end

      # Collection mode: effective sort direction for a column
      # Table-level overrides column-level when the column is the sorted one
      def effective_sort_direction(column)
        if @sort_column && effective_sorted?(column) && @table_sort_direction
          @table_sort_direction
        else
          column.sort_direction
        end
      end

      # Collection mode: next sort direction (toggles asc↔desc)
      def next_sort_direction(column)
        effective_sorted?(column) && effective_sort_direction(column) == :asc ? :desc : :asc
      end

      # Collection mode: sort icon SVG
      def collection_sort_icon(column)
        return nil unless column.sortable

        sort_icon_svg(sorted: effective_sorted?(column), direction: effective_sort_direction(column))
      end

      # Collection mode: sort icon classes
      def collection_sort_icon_classes(column)
        effective_sorted?(column) ? VARIANT_SORT_ICON[@variant] : "text-grayscale-400"
      end

      # Collection mode: whether a column should render a sort link
      def collection_sort_link?(column)
        return false unless column.sortable
        column.sort_url.present? || @sort_url.present?
      end

      # Collection mode: resolved sort URL for a column
      def collection_sort_url(column)
        if column.sort_url.present?
          column.sort_url
        elsif @sort_url.present?
          @sort_url.call(column.key, next_sort_direction(column))
        end
      end

      # Collection mode: merged sort link HTML attributes
      def collection_sort_link_html(column)
        base = @sort_html.dup
        override = column.sort_html
        base.merge(override)
      end

      # Partial helpers
      def body_row_partial?
        @body_row_partial.present?
      end

      def header_partial?
        @header_partial.present?
      end

      def footer_partial?
        @footer_partial.present?
      end

      # Slot-mode empty state colspan
      def slot_mode_colspan
        return 1 unless header?
        header.cells.size
      end

      # Validation methods
      def validate_variant(variant)
        unless VARIANTS.key?(variant)
          raise ArgumentError, "Invalid variant: #{variant}. Must be one of: #{VARIANTS.keys.join(', ')}"
        end
        variant
      end

      def validate_style(style)
        unless STYLES.include?(style)
          raise ArgumentError, "Invalid style: #{style}. Must be one of: #{STYLES.join(', ')}"
        end
        style
      end

      def validate_size(size)
        unless SIZES.key?(size)
          raise ArgumentError, "Invalid size: #{size}. Must be one of: #{SIZES.keys.join(', ')}"
        end
        size
      end

      def validate_rounded(rounded)
        unless ROUNDED.key?(rounded)
          raise ArgumentError, "Invalid rounded: #{rounded}. Must be one of: #{ROUNDED.keys.join(', ')}"
        end
        rounded
      end
    end
  end
end
