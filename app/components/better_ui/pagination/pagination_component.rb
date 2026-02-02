# frozen_string_literal: true

module BetterUi
  module Pagination
    class PaginationComponent < BetterUi::ApplicationComponent
      renders_one :info

      STYLES = %i[solid outline ghost soft].freeze

      SIZES = {
        xs: { item: "min-w-6 h-6 text-xs px-1.5", gap: "gap-0.5", icon: "w-3 h-3" },
        sm: { item: "min-w-7 h-7 text-sm px-2", gap: "gap-1", icon: "w-3.5 h-3.5" },
        md: { item: "min-w-9 h-9 text-sm px-3", gap: "gap-1.5", icon: "w-4 h-4" },
        lg: { item: "min-w-11 h-11 text-base px-3.5", gap: "gap-2", icon: "w-5 h-5" },
        xl: { item: "min-w-12 h-12 text-lg px-4", gap: "gap-2.5", icon: "w-5 h-5" }
      }.freeze

      ROUNDED = {
        none: "rounded-none",
        sm: "rounded-sm",
        md: "rounded-md",
        lg: "rounded-lg",
        full: "rounded-full"
      }.freeze

      def initialize(
        current_page:,
        total_pages:,
        url:,
        variant: :primary,
        style: :outline,
        size: :md,
        rounded: :md,
        shadow: :none,
        window: 2,
        show_first_last: false,
        show_prev_next: true,
        show_page_numbers: true,
        show_info: false,
        per_page: nil,
        total_count: nil,
        prev_label: nil,
        next_label: nil,
        first_label: nil,
        last_label: nil,
        gap_label: "\u2026",
        container_classes: nil
      )
        @current_page = current_page
        @total_pages = total_pages
        @url = url
        @variant = validate_variant(variant)
        @style = validate_style(style)
        @size = validate_size(size)
        @rounded = validate_rounded(rounded)
        @shadow = normalize_shadow(shadow)
        @window = window
        @show_first_last = show_first_last
        @show_prev_next = show_prev_next
        @show_page_numbers = show_page_numbers
        @show_info = show_info
        @per_page = per_page
        @total_count = total_count
        @prev_label = prev_label
        @next_label = next_label
        @first_label = first_label
        @last_label = last_label
        @gap_label = gap_label
        @container_classes = container_classes

        validate_pages!
        validate_url!
      end

      def render?
        @total_pages > 1
      end

      def page_items
        return [] if @total_pages <= 0
        return [1] if @total_pages == 1

        build_page_items
      end

      def page_url(page)
        @url.call(page)
      end

      def first_page?
        @current_page == 1
      end

      def last_page?
        @current_page == @total_pages
      end

      def auto_info_text
        return nil unless @show_info && @per_page && @total_count

        from = ((@current_page - 1) * @per_page) + 1
        to = [@current_page * @per_page, @total_count].min
        "Showing #{from}-#{to} of #{@total_count} results"
      end

      private

      attr_reader :current_page, :total_pages, :variant, :style, :size, :rounded,
                  :window, :show_first_last, :show_prev_next, :show_page_numbers,
                  :show_info, :per_page, :total_count,
                  :prev_label, :next_label, :first_label, :last_label, :gap_label,
                  :container_classes

      # ============================================
      # Page Algorithm
      # ============================================

      def build_page_items
        window_start = [@current_page - @window, 1].max
        window_end = [@current_page + @window, @total_pages].min

        # If everything fits without gaps, return full range
        return (1..@total_pages).to_a if @total_pages <= (2 * @window + 3)

        items = []

        # Always include first page
        items << 1

        # Gap or bridging pages between first and window
        if window_start > 2
          if window_start == 3
            items << 2
          else
            items << :gap
          end
        end

        # Window pages (skip first and last as they are always included)
        (window_start..window_end).each do |page|
          items << page unless items.include?(page)
        end

        # Gap or bridging pages between window and last
        if window_end < @total_pages - 1
          if window_end == @total_pages - 2
            items << @total_pages - 1
          else
            items << :gap
          end
        end

        # Always include last page
        items << @total_pages unless items.include?(@total_pages)

        items
      end

      # ============================================
      # CSS Classes
      # ============================================

      def nav_classes
        classes = ["flex flex-col items-center"]
        classes << SHADOWS[@shadow] if SHADOWS[@shadow]
        classes << @container_classes if @container_classes
        css_classes(*classes)
      end

      def list_classes
        css_classes("flex items-center", SIZES[@size][:gap])
      end

      def item_base_classes
        css_classes(
          "inline-flex items-center justify-center font-medium transition-colors duration-200",
          SIZES[@size][:item],
          ROUNDED[@rounded]
        )
      end

      def active_page_classes
        css_classes(item_base_classes, active_style_classes)
      end

      def inactive_page_classes
        css_classes(item_base_classes, inactive_style_classes)
      end

      def disabled_classes
        css_classes(item_base_classes, "opacity-40 cursor-not-allowed pointer-events-none", disabled_color_classes)
      end

      def gap_classes
        css_classes(
          "inline-flex items-center justify-center",
          SIZES[@size][:item],
          "text-grayscale-400 select-none"
        )
      end

      def nav_button_classes
        css_classes(item_base_classes, inactive_style_classes)
      end

      def icon_classes
        SIZES[@size][:icon]
      end

      # ============================================
      # Style-specific active/inactive classes
      # ============================================

      def active_style_classes
        case @style
        when :solid then solid_active_classes
        when :outline then outline_active_classes
        when :ghost then ghost_active_classes
        when :soft then soft_active_classes
        end
      end

      def inactive_style_classes
        case @style
        when :solid then solid_inactive_classes
        when :outline then outline_inactive_classes
        when :ghost then ghost_inactive_classes
        when :soft then soft_inactive_classes
        end
      end

      def disabled_color_classes
        case @style
        when :solid, :soft
          "bg-grayscale-100 text-grayscale-400"
        when :outline
          "border border-grayscale-200 text-grayscale-400"
        when :ghost
          "text-grayscale-400"
        end
      end

      # --- Solid ---

      def solid_active_classes
        case @variant
        when :primary   then "bg-primary-600 text-white"
        when :secondary then "bg-secondary-600 text-white"
        when :accent    then "bg-accent-600 text-white"
        when :success   then "bg-success-600 text-white"
        when :danger    then "bg-danger-600 text-white"
        when :warning   then "bg-warning-600 text-white"
        when :info      then "bg-info-600 text-white"
        when :light     then "bg-grayscale-200 text-grayscale-900"
        when :dark      then "bg-grayscale-900 text-grayscale-50"
        end
      end

      def solid_inactive_classes
        case @variant
        when :primary   then "text-grayscale-700 hover:bg-primary-50 hover:text-primary-700"
        when :secondary then "text-grayscale-700 hover:bg-secondary-50 hover:text-secondary-700"
        when :accent    then "text-grayscale-700 hover:bg-accent-50 hover:text-accent-700"
        when :success   then "text-grayscale-700 hover:bg-success-50 hover:text-success-700"
        when :danger    then "text-grayscale-700 hover:bg-danger-50 hover:text-danger-700"
        when :warning   then "text-grayscale-700 hover:bg-warning-50 hover:text-warning-700"
        when :info      then "text-grayscale-700 hover:bg-info-50 hover:text-info-700"
        when :light     then "text-grayscale-700 hover:bg-grayscale-100 hover:text-grayscale-900"
        when :dark      then "text-grayscale-700 hover:bg-grayscale-800 hover:text-grayscale-50"
        end
      end

      # --- Outline ---

      def outline_active_classes
        case @variant
        when :primary   then "border border-primary-600 bg-primary-50 text-primary-700"
        when :secondary then "border border-secondary-600 bg-secondary-50 text-secondary-700"
        when :accent    then "border border-accent-600 bg-accent-50 text-accent-700"
        when :success   then "border border-success-600 bg-success-50 text-success-700"
        when :danger    then "border border-danger-600 bg-danger-50 text-danger-700"
        when :warning   then "border border-warning-600 bg-warning-50 text-warning-700"
        when :info      then "border border-info-600 bg-info-50 text-info-700"
        when :light     then "border border-grayscale-400 bg-grayscale-50 text-grayscale-900"
        when :dark      then "border border-grayscale-700 bg-grayscale-800 text-grayscale-50"
        end
      end

      def outline_inactive_classes
        case @variant
        when :primary   then "border border-grayscale-200 text-grayscale-700 hover:border-primary-300 hover:bg-primary-50 hover:text-primary-700"
        when :secondary then "border border-grayscale-200 text-grayscale-700 hover:border-secondary-300 hover:bg-secondary-50 hover:text-secondary-700"
        when :accent    then "border border-grayscale-200 text-grayscale-700 hover:border-accent-300 hover:bg-accent-50 hover:text-accent-700"
        when :success   then "border border-grayscale-200 text-grayscale-700 hover:border-success-300 hover:bg-success-50 hover:text-success-700"
        when :danger    then "border border-grayscale-200 text-grayscale-700 hover:border-danger-300 hover:bg-danger-50 hover:text-danger-700"
        when :warning   then "border border-grayscale-200 text-grayscale-700 hover:border-warning-300 hover:bg-warning-50 hover:text-warning-700"
        when :info      then "border border-grayscale-200 text-grayscale-700 hover:border-info-300 hover:bg-info-50 hover:text-info-700"
        when :light     then "border border-grayscale-200 text-grayscale-700 hover:border-grayscale-400 hover:bg-grayscale-50 hover:text-grayscale-900"
        when :dark      then "border border-grayscale-200 text-grayscale-700 hover:border-grayscale-600 hover:bg-grayscale-800 hover:text-grayscale-50"
        end
      end

      # --- Ghost ---

      def ghost_active_classes
        case @variant
        when :primary   then "bg-primary-100 text-primary-700"
        when :secondary then "bg-secondary-100 text-secondary-700"
        when :accent    then "bg-accent-100 text-accent-700"
        when :success   then "bg-success-100 text-success-700"
        when :danger    then "bg-danger-100 text-danger-700"
        when :warning   then "bg-warning-100 text-warning-700"
        when :info      then "bg-info-100 text-info-700"
        when :light     then "bg-grayscale-200 text-grayscale-900"
        when :dark      then "bg-grayscale-800 text-grayscale-50"
        end
      end

      def ghost_inactive_classes
        case @variant
        when :primary   then "text-grayscale-700 hover:bg-primary-50 hover:text-primary-700"
        when :secondary then "text-grayscale-700 hover:bg-secondary-50 hover:text-secondary-700"
        when :accent    then "text-grayscale-700 hover:bg-accent-50 hover:text-accent-700"
        when :success   then "text-grayscale-700 hover:bg-success-50 hover:text-success-700"
        when :danger    then "text-grayscale-700 hover:bg-danger-50 hover:text-danger-700"
        when :warning   then "text-grayscale-700 hover:bg-warning-50 hover:text-warning-700"
        when :info      then "text-grayscale-700 hover:bg-info-50 hover:text-info-700"
        when :light     then "text-grayscale-700 hover:bg-grayscale-100 hover:text-grayscale-900"
        when :dark      then "text-grayscale-700 hover:bg-grayscale-800 hover:text-grayscale-50"
        end
      end

      # --- Soft ---

      def soft_active_classes
        case @variant
        when :primary   then "bg-primary-100 text-primary-700 font-semibold"
        when :secondary then "bg-secondary-100 text-secondary-700 font-semibold"
        when :accent    then "bg-accent-100 text-accent-700 font-semibold"
        when :success   then "bg-success-100 text-success-700 font-semibold"
        when :danger    then "bg-danger-100 text-danger-700 font-semibold"
        when :warning   then "bg-warning-100 text-warning-700 font-semibold"
        when :info      then "bg-info-100 text-info-700 font-semibold"
        when :light     then "bg-grayscale-200 text-grayscale-900 font-semibold"
        when :dark      then "bg-grayscale-800 text-grayscale-50 font-semibold"
        end
      end

      def soft_inactive_classes
        case @variant
        when :primary   then "bg-primary-50 text-grayscale-700 hover:bg-primary-100 hover:text-primary-700"
        when :secondary then "bg-secondary-50 text-grayscale-700 hover:bg-secondary-100 hover:text-secondary-700"
        when :accent    then "bg-accent-50 text-grayscale-700 hover:bg-accent-100 hover:text-accent-700"
        when :success   then "bg-success-50 text-grayscale-700 hover:bg-success-100 hover:text-success-700"
        when :danger    then "bg-danger-50 text-grayscale-700 hover:bg-danger-100 hover:text-danger-700"
        when :warning   then "bg-warning-50 text-grayscale-700 hover:bg-warning-100 hover:text-warning-700"
        when :info      then "bg-info-50 text-grayscale-700 hover:bg-info-100 hover:text-info-700"
        when :light     then "bg-grayscale-100 text-grayscale-700 hover:bg-grayscale-200 hover:text-grayscale-900"
        when :dark      then "bg-grayscale-700 text-grayscale-200 hover:bg-grayscale-800 hover:text-grayscale-50"
        end
      end

      # ============================================
      # Validation
      # ============================================

      def validate_pages!
        raise ArgumentError, "total_pages must be >= 0" if @total_pages.negative?
        raise ArgumentError, "current_page must be >= 1" if @total_pages > 0 && @current_page < 1
        if @total_pages > 0 && @current_page > @total_pages
          raise ArgumentError, "current_page (#{@current_page}) cannot exceed total_pages (#{@total_pages})"
        end
      end

      def validate_url!
        raise ArgumentError, "url must be a Proc" unless @url.is_a?(Proc)
      end

      def validate_variant(variant)
        unless BetterUi::ApplicationComponent::VARIANTS.key?(variant)
          raise ArgumentError, "Invalid variant: #{variant}. Must be one of: #{BetterUi::ApplicationComponent::VARIANTS.keys.join(', ')}"
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
