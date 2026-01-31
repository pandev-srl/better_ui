# frozen_string_literal: true

module BetterUi
  module Table
    class TableComponentPreview < ViewComponent::Preview
      # @label Default
      # @display bg_color "#f5f5f5"
      def default
        render_with_template
      end

      # @label Bordered
      # @display bg_color "#f5f5f5"
      def bordered
        render_with_template
      end

      # @label Striped
      # @display bg_color "#f5f5f5"
      def striped
        render_with_template
      end

      # @label Hoverable
      # @display bg_color "#f5f5f5"
      def hoverable
        render_with_template
      end

      # @label All Variants
      # @display bg_color "#f5f5f5"
      def all_variants
        render_with_template
      end

      # @label All Sizes
      # @display bg_color "#f5f5f5"
      def all_sizes
        render_with_template
      end

      # @label Collection Mode
      # @display bg_color "#f5f5f5"
      def collection_mode
        render_with_template
      end

      # @label Empty State
      # @display bg_color "#f5f5f5"
      def empty_state
        render_with_template
      end

      # @label With Footer
      # @display bg_color "#f5f5f5"
      def with_footer
        render_with_template
      end

      # @label Inside Card
      # @display bg_color "#f5f5f5"
      def inside_card
        render_with_template
      end
    end
  end
end
