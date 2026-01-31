# frozen_string_literal: true

module BetterUi
  module Dialog
    # @label Dialog Alert
    class AlertComponentPreview < ViewComponent::Preview
      # @label Default (Info)
      # @display max_height 600px
      def default
        render_with_template
      end

      # @label All Variants
      # @display max_height 800px
      def all_variants
        render_with_template
      end

      # @label Without Icon
      # @display max_height 600px
      def without_icon
        render_with_template
      end

      # @label Custom Button Label
      # @display max_height 600px
      def custom_button_label
        render_with_template
      end

      # @label Playground
      # @display max_height 600px
      # @param variant select { choices: [primary, secondary, accent, success, danger, warning, info, light, dark] }
      # @param title text
      # @param text text
      # @param icon toggle
      # @param button_label text
      # @param size select { choices: [sm, md, lg] }
      def playground(
        variant: :info,
        title: "Alert Title",
        text: "This is the alert message.",
        icon: true,
        button_label: "OK",
        size: :sm
      )
        @variant = variant.presence&.to_sym || :info
        @title = title
        @text = text
        @icon = icon
        @button_label = button_label
        @size = size.presence&.to_sym || :sm
        render_with_template
      end
    end
  end
end
