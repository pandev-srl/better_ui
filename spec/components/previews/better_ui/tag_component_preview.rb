# frozen_string_literal: true

module BetterUi
  class TagComponentPreview < ViewComponent::Preview
    # @label Default
    def default
      render BetterUi::TagComponent.new do
        "Tag"
      end
    end

    # @label All Variants
    # @display bg_color #f5f5f5
    def all_variants
      render_with_template
    end

    # @label All Styles
    # @display bg_color #f5f5f5
    def all_styles
      render_with_template
    end

    # @label Dismissible
    def dismissible
      render_with_template
    end

    # @label As Links
    # @display bg_color #f5f5f5
    def as_links
      render_with_template
    end

    # @label Playground
    # @param variant select { choices: [primary, secondary, accent, success, danger, warning, info, light, dark] }
    # @param style select { choices: [solid, outline, soft] }
    # @param size select { choices: [xs, sm, md, lg] }
    # @param dismissible toggle
    # @param as_link toggle
    def playground(variant: :primary, style: :solid, size: :md, dismissible: false, as_link: false)
      dismissible_bool = ActiveModel::Type::Boolean.new.cast(dismissible)
      as_link_bool = ActiveModel::Type::Boolean.new.cast(as_link)

      render BetterUi::TagComponent.new(
        variant: variant,
        style: style,
        size: size,
        dismissible: dismissible_bool,
        href: as_link_bool ? "#" : nil
      ) do
        "Interactive Tag"
      end
    end
  end
end
