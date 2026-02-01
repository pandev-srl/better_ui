# frozen_string_literal: true

module BetterUi
  class SpinnerComponentPreview < ViewComponent::Preview
    # @label Default
    def default
      render BetterUi::SpinnerComponent.new
    end

    # @label All Variants
    # @display bg_color #f5f5f5
    def all_variants
      @variants = ApplicationComponent::VARIANTS.keys
      render_with_template
    end

    # @label All Sizes
    def all_sizes
      @sizes = [ :xs, :sm, :md, :lg, :xl ]
      render_with_template
    end

    # @label With Label
    def with_label
      render BetterUi::SpinnerComponent.new(
        variant: :primary,
        size: :lg,
        label: "Loading content..."
      )
    end

    # @label Playground
    # @param variant select { choices: [primary, secondary, accent, success, danger, warning, info, light, dark] }
    # @param size select { choices: [xs, sm, md, lg, xl] }
    # @param label text
    def playground(variant: :primary, size: :md, label: nil)
      render BetterUi::SpinnerComponent.new(
        variant: variant,
        size: size,
        label: label.presence
      )
    end
  end
end
