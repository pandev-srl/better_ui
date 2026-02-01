# frozen_string_literal: true

module BetterUi
  # @label Avatar
  class AvatarComponentPreview < ViewComponent::Preview
    # @label Default
    # @display bg_color #f5f5f5
    def default
      render BetterUi::AvatarComponent.new(
        src: "https://i.pravatar.cc/150?u=default",
        alt: "Default avatar"
      )
    end

    # @label All Variants
    # @display bg_color #f5f5f5
    def all_variants
      render_with_template
    end

    # @label All Sizes
    # @display bg_color #f5f5f5
    def all_sizes
      render_with_template
    end

    # @label All Shapes
    # @display bg_color #f5f5f5
    def all_shapes
      render_with_template
    end

    # @label With Status
    # @display bg_color #f5f5f5
    def with_status
      render_with_template
    end

    # @label With Initials
    # @display bg_color #f5f5f5
    def with_initials
      render_with_template
    end

    # @label Playground
    # @param src text
    # @param name text
    # @param variant select { choices: [primary, secondary, accent, success, danger, warning, info, light, dark] }
    # @param size select { choices: [xs, sm, md, lg, xl] }
    # @param shape select { choices: [circle, square, rounded] }
    # @param status select { choices: [~, online, offline, busy, away] }
    def playground(
      src: "",
      name: "John Doe",
      variant: :primary,
      size: :md,
      shape: :circle,
      status: nil
    )
      resolved_src = src.present? ? src : nil
      resolved_status = status.present? ? status.to_sym : nil

      render BetterUi::AvatarComponent.new(
        src: resolved_src,
        name: name,
        variant: variant.to_sym,
        size: size.to_sym,
        shape: shape.to_sym,
        status: resolved_status
      )
    end
  end
end
