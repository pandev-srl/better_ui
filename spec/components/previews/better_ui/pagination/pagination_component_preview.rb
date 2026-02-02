# frozen_string_literal: true

module BetterUi
  module Pagination
    class PaginationComponentPreview < ViewComponent::Preview
      # @label Default
      def default
        render_with_template
      end

      # @label All Variants
      # @display bg_color #f5f5f5
      def all_variants
        @variants = BetterUi::ApplicationComponent::VARIANTS.keys
        render_with_template
      end

      # @label All Styles
      # @display bg_color #f5f5f5
      def all_styles
        @styles = [ :solid, :outline, :ghost, :soft ]
        render_with_template
      end

      # @label All Sizes
      # @display bg_color #f5f5f5
      def all_sizes
        @sizes = [ :xs, :sm, :md, :lg, :xl ]
        render_with_template
      end

      # @label With Info
      def with_info
        render_with_template
      end

      # @label Edge Cases
      def edge_cases
        render_with_template
      end

      # @label Playground
      # @param current_page number
      # @param total_pages number
      # @param variant select { choices: [primary, secondary, accent, success, danger, warning, info, light, dark] }
      # @param style select { choices: [solid, outline, ghost, soft] }
      # @param size select { choices: [xs, sm, md, lg, xl] }
      # @param rounded select { choices: [none, sm, md, lg, full] }
      # @param window number
      # @param show_first_last toggle
      # @param show_prev_next toggle
      # @param show_page_numbers toggle
      def playground(
        current_page: 5,
        total_pages: 20,
        variant: :primary,
        style: :outline,
        size: :md,
        rounded: :md,
        window: 2,
        show_first_last: false,
        show_prev_next: true,
        show_page_numbers: true
      )
        current_page = current_page.to_i
        total_pages = total_pages.to_i
        window = window.to_i
        show_first_last = ActiveModel::Type::Boolean.new.cast(show_first_last)
        show_prev_next = ActiveModel::Type::Boolean.new.cast(show_prev_next)
        show_page_numbers = ActiveModel::Type::Boolean.new.cast(show_page_numbers)

        render BetterUi::Pagination::PaginationComponent.new(
          current_page: current_page,
          total_pages: total_pages,
          url: ->(page) { "#page-#{page}" },
          variant: variant,
          style: style,
          size: size,
          rounded: rounded,
          window: window,
          show_first_last: show_first_last,
          show_prev_next: show_prev_next,
          show_page_numbers: show_page_numbers
        )
      end
    end
  end
end
