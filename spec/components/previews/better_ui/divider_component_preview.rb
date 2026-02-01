# frozen_string_literal: true

module BetterUi
  # @label Divider
  class DividerComponentPreview < ViewComponent::Preview
    # @label Default
    # @display bg_color #f5f5f5
    def default
      render BetterUi::DividerComponent.new
    end

    # @label All Styles
    # @display bg_color #f5f5f5
    def all_styles
      render_with_template
    end

    # @label With Labels
    # @display bg_color #f5f5f5
    def with_labels
      render_with_template
    end

    # @label Vertical
    # @display bg_color #f5f5f5
    def vertical
      render BetterUi::DividerComponent.new(orientation: :vertical)
    end

    # @label Playground
    # @display bg_color #f5f5f5
    # @param orientation select { choices: [horizontal, vertical] }
    # @param style select { choices: [solid, dashed, dotted] }
    # @param variant select { choices: [~, primary, secondary, accent, success, danger, warning, info, light, dark] }
    # @param size select { choices: [xs, sm, md] }
    # @param spacing select { choices: [xs, sm, md, lg, xl] }
    # @param label text
    # @param label_position select { choices: [left, center, right] }
    def playground(
      orientation: :horizontal,
      style: :solid,
      variant: nil,
      size: :md,
      spacing: :md,
      label: nil,
      label_position: :center
    )
      variant_sym = variant.present? && variant != "~" ? variant.to_sym : nil
      label_value = label.present? ? label : nil

      render BetterUi::DividerComponent.new(
        orientation: orientation.to_sym,
        style: style.to_sym,
        variant: variant_sym,
        size: size.to_sym,
        spacing: spacing.to_sym,
        label: label_value,
        label_position: label_position.to_sym
      )
    end
  end
end
