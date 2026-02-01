# frozen_string_literal: true

module BetterUi
  class TooltipComponentPreview < ViewComponent::Preview
    # @label Default
    def default
      render BetterUi::TooltipComponent.new(text: "This is a tooltip") do
        '<button class="px-4 py-2 bg-primary-600 text-white rounded-md">Hover me</button>'.html_safe
      end
    end

    # @label All Positions
    # @display bg_color #f5f5f5
    def all_positions
      render_with_template
    end

    # @label Variants
    # @display bg_color #f5f5f5
    def variants
      render_with_template
    end

    # @label Playground
    # @param text text
    # @param position select { choices: [top, right, bottom, left] }
    # @param variant select { choices: [dark, light] }
    # @param size select { choices: [sm, md] }
    def playground(text: "Tooltip text", position: :top, variant: :dark, size: :sm)
      render BetterUi::TooltipComponent.new(
        text: text,
        position: position,
        variant: variant,
        size: size
      ) do
        '<button class="px-4 py-2 bg-primary-600 text-white rounded-md">Hover me</button>'.html_safe
      end
    end
  end
end
