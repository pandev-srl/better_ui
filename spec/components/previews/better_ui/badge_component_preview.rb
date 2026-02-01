# frozen_string_literal: true

module BetterUi
  class BadgeComponentPreview < ViewComponent::Preview
    # @label Default
    def default
      render BetterUi::BadgeComponent.new do
        "Badge"
      end
    end

    # @label All Variants
    # @display bg_color #f5f5f5
    def all_variants
      @variants = ApplicationComponent::VARIANTS.keys
      @styles = [ :solid, :outline, :soft, :ghost ]
      render_with_template
    end

    # @label All Styles
    # @display bg_color #f5f5f5
    def all_styles
      @styles = [ :solid, :outline, :soft, :ghost ]
      render_with_template
    end

    # @label All Sizes
    def all_sizes
      @sizes = [ :xs, :sm, :md, :lg ]
      render_with_template
    end

    # @label Dot Badges
    # @display bg_color #f5f5f5
    def dot_badges
      render_with_template
    end

    # @label Counter Badges
    # @display bg_color #f5f5f5
    def counter_badges
      render_with_template
    end

    # @label Playground
    # @param variant select { choices: [primary, secondary, accent, success, danger, warning, info, light, dark] } Matches ApplicationComponent::VARIANTS.keys
    # @param style select { choices: [solid, outline, soft, ghost] }
    # @param size select { choices: [xs, sm, md, lg] }
    # @param pill toggle
    # @param dot toggle
    # @param counter number
    def playground(variant: :primary, style: :solid, size: :md, pill: true, dot: false, counter: nil)
      pill_bool = ActiveModel::Type::Boolean.new.cast(pill)
      dot_bool = ActiveModel::Type::Boolean.new.cast(dot)
      counter_val = counter.present? ? counter.to_i : nil

      render BetterUi::BadgeComponent.new(
        variant: variant,
        style: style,
        size: size,
        pill: pill_bool,
        dot: dot_bool,
        counter: counter_val
      ) do
        "Badge"
      end
    end
  end
end
