# frozen_string_literal: true

module BetterUi
  module Dialog
    # @label Dialog
    class DialogComponentPreview < ViewComponent::Preview
      # @label Default
      # @display max_height 600px
      def default
        render_with_template
      end

      # @label All Sizes
      # @display max_height 600px
      def all_sizes
        render_with_template
      end

      # @label With All Slots
      # @display max_height 600px
      def with_all_slots
        render_with_template
      end

      # @label No Close Button
      # @display max_height 600px
      def no_close_button
        render_with_template
      end

      # @label Playground
      # @display max_height 600px
      # @param size select { choices: [sm, md, lg, xl, xxl, full] }
      # @param close_on_backdrop toggle
      # @param close_on_escape toggle
      # @param show_close_button toggle
      def playground(
        size: :md,
        close_on_backdrop: true,
        close_on_escape: true,
        show_close_button: true
      )
        @size = size.presence&.to_sym || :md
        @close_on_backdrop = close_on_backdrop
        @close_on_escape = close_on_escape
        @show_close_button = show_close_button
        render_with_template
      end
    end
  end
end
