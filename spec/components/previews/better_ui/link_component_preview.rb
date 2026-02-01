# frozen_string_literal: true

module BetterUi
  class LinkComponentPreview < ViewComponent::Preview
    # @label Default
    def default
      render BetterUi::LinkComponent.new(href: "#") do
        "Click me"
      end
    end

    # @label All Variants
    # @display bg_color #f5f5f5
    def all_variants
      @variants = ApplicationComponent::VARIANTS.keys
      @styles = [ :default, :underline, :ghost ]
      render_with_template
    end

    # @label All Styles
    # @display bg_color #f5f5f5
    def all_styles
      @styles = [ :default, :underline, :ghost ]
      @variants = ApplicationComponent::VARIANTS.keys
      render_with_template
    end

    # @label All Sizes
    def all_sizes
      @sizes = [ :xs, :sm, :md, :lg, :xl ]
      render_with_template
    end

    # @label With Icons
    def with_icons
      render_with_template
    end

    # @label Playground
    # @param variant select { choices: [primary, secondary, accent, success, danger, warning, info, light, dark] }
    # @param style select { choices: [default, underline, ghost] }
    # @param size select { choices: [xs, sm, md, lg, xl] }
    # @param disabled toggle
    # @param target select { choices: [none, blank, self] }
    def playground(variant: :primary, style: :default, size: :md, disabled: false, target: :none)
      target_val = case target
      when :blank then "_blank"
      when :self then "_self"
      else nil
      end

      disabled_bool = ActiveModel::Type::Boolean.new.cast(disabled)

      render BetterUi::LinkComponent.new(
        href: "#",
        variant: variant,
        style: style,
        size: size,
        target: target_val,
        disabled: disabled_bool
      ) do
        "Interactive Link"
      end
    end
  end
end
