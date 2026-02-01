# frozen_string_literal: true

module BetterUi
  class ProgressComponentPreview < ViewComponent::Preview
    # @label Default
    def default
      render BetterUi::ProgressComponent.new(value: 50)
    end

    # @label All Variants
    # @display bg_color #f5f5f5
    def all_variants
      @variants = ApplicationComponent::VARIANTS.keys
      render_with_template
    end

    # @label All Sizes
    def all_sizes
      @sizes = [ :xs, :sm, :md, :lg ]
      render_with_template
    end

    # @label With Labels
    def with_labels
      render BetterUi::ProgressComponent.new(
        value: 68,
        variant: :primary,
        size: :md,
        label: "Uploading files...",
        show_value: true
      )
    end

    # @label Animated
    def animated
      render BetterUi::ProgressComponent.new(
        value: 45,
        variant: :info,
        size: :md,
        label: "Processing...",
        show_value: true,
        animated: true
      )
    end

    # @label Playground
    # @param value range { min: 0, max: 100, step: 1 }
    # @param variant select { choices: [primary, secondary, accent, success, danger, warning, info, light, dark] }
    # @param size select { choices: [xs, sm, md, lg] }
    # @param label text
    # @param show_value toggle
    # @param animated toggle
    def playground(value: 50, variant: :primary, size: :md, label: nil, show_value: false, animated: false)
      render BetterUi::ProgressComponent.new(
        value: value.to_i,
        variant: variant,
        size: size,
        label: label.presence,
        show_value: show_value,
        animated: animated
      )
    end
  end
end
