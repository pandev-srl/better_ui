# frozen_string_literal: true

module BetterUi
  class FaIconComponentPreview < ViewComponent::Preview
    # @label Default
    def default
      render BetterUi::FaIconComponent.new(name: "user")
    end

    # @label All Styles
    # @display bg_color #f5f5f5
    def all_styles
      @styles = BetterUi::FaIconComponent::STYLES.keys
      render_with_template
    end

    # @label All Sizes
    # @display bg_color #f5f5f5
    def all_sizes
      @sizes = BetterUi::FaIconComponent::SIZES.keys
      render_with_template
    end

    # @label All Variants
    # @display bg_color #f5f5f5
    def all_variants
      @variants = BetterUi::ApplicationComponent::VARIANTS.keys
      render_with_template
    end

    # @label Animations
    # @display bg_color #f5f5f5
    def animations
      render_with_template
    end

    # @label Transformations
    # @display bg_color #f5f5f5
    def transformations
      render_with_template
    end

    # @label Playground
    # @param name text
    # @param style select { choices: [regular, solid, light, thin, brands] }
    # @param variant select { choices: [~, primary, secondary, accent, success, danger, warning, info, light, dark] }
    # @param size select { choices: [xs, sm, md, lg, xl, 2xl] }
    # @param spin toggle
    # @param pulse toggle
    # @param flip select { choices: [~, horizontal, vertical, both] }
    # @param rotate select { choices: [~, 90, 180, 270] }
    # @param fixed_width toggle
    def playground(
      name: "user",
      style: :regular,
      variant: nil,
      size: :md,
      spin: false,
      pulse: false,
      flip: nil,
      rotate: nil,
      fixed_width: false
    )
      spin_bool = ActiveModel::Type::Boolean.new.cast(spin)
      pulse_bool = ActiveModel::Type::Boolean.new.cast(pulse)
      fixed_width_bool = ActiveModel::Type::Boolean.new.cast(fixed_width)
      variant_val = variant.present? && variant != "~" ? variant.to_sym : nil
      flip_val = flip.present? && flip != "~" ? flip.to_sym : nil
      rotate_val = rotate.present? && rotate != "~" ? rotate.to_i : nil
      size_val = size.to_s == "2xl" ? :"2xl" : size.to_sym

      render BetterUi::FaIconComponent.new(
        name: name,
        style: style,
        variant: variant_val,
        size: size_val,
        spin: spin_bool,
        pulse: pulse_bool,
        flip: flip_val,
        rotate: rotate_val,
        fixed_width: fixed_width_bool
      )
    end
  end
end
