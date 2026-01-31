# frozen_string_literal: true

module BetterUi
  module Dialog
    # @label Dialog Confirm
    class ConfirmComponentPreview < ViewComponent::Preview
      # @label Default (Warning)
      # @display max_height 600px
      def default
        render_with_template
      end

      # @label All Variants
      # @display max_height 800px
      def all_variants
        render_with_template
      end

      # @label Danger Confirm
      # @display max_height 600px
      def danger_confirm
        render_with_template
      end

      # @label Custom Labels
      # @display max_height 600px
      def custom_labels
        render_with_template
      end

      # @label Playground
      # @display max_height 600px
      # @param variant select { choices: [primary, secondary, accent, success, danger, warning, info, light, dark] }
      # @param title text
      # @param text text
      # @param icon toggle
      # @param confirm_label text
      # @param cancel_label text
      # @param size select { choices: [sm, md, lg] }
      def playground(
        variant: :warning,
        title: "Confirm Action",
        text: "Are you sure you want to proceed?",
        icon: true,
        confirm_label: "Confirm",
        cancel_label: "Cancel",
        size: :sm
      )
        @variant = variant.presence&.to_sym || :warning
        @title = title
        @text = text
        @icon = icon
        @confirm_label = confirm_label
        @cancel_label = cancel_label
        @size = size.presence&.to_sym || :sm
        render_with_template
      end
    end
  end
end
