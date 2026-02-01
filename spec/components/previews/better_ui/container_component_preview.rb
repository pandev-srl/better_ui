# frozen_string_literal: true

module BetterUi
  # @label Container
  class ContainerComponentPreview < ViewComponent::Preview
    # @label Default
    # @display bg_color #f5f5f5
    def default
      render BetterUi::ContainerComponent.new do
        "<div class='bg-white p-6 rounded-lg shadow-sm'>This is a default container with lg max-width, horizontal padding, and centered alignment.</div>".html_safe
      end
    end

    # @label All Sizes
    # @display bg_color #f5f5f5
    def all_sizes
      render_with_template
    end

    # @label Without Padding
    # @display bg_color #f5f5f5
    def without_padding
      render BetterUi::ContainerComponent.new(padding: false) do
        "<div class='bg-white p-6 shadow-sm'>This container has no horizontal padding. Content goes edge-to-edge within the max-width constraint.</div>".html_safe
      end
    end

    # @label Without Centering
    # @display bg_color #f5f5f5
    def without_centering
      render BetterUi::ContainerComponent.new(centered: false) do
        "<div class='bg-white p-6 rounded-lg shadow-sm'>This container is not centered. It aligns to the left by default.</div>".html_safe
      end
    end

    # @label Full Width
    # @display bg_color #f5f5f5
    def full_width
      render BetterUi::ContainerComponent.new(size: :full) do
        "<div class='bg-white p-6 rounded-lg shadow-sm'>This container uses full width with no max-width constraint (other than max-w-full).</div>".html_safe
      end
    end

    # @label Playground
    # @param size select { choices: [sm, md, lg, xl, full] }
    # @param padding toggle
    # @param centered toggle
    def playground(size: :lg, padding: true, centered: true)
      render BetterUi::ContainerComponent.new(
        size: size.to_sym,
        padding: padding,
        centered: centered,
        container_classes: "bg-blue-50 border border-blue-200 rounded-lg"
      ) do
        "<div class='bg-white p-6 rounded shadow-sm'>Interactive container playground. Adjust the parameters to see how the container changes. Current size: <strong>#{size}</strong>, padding: <strong>#{padding}</strong>, centered: <strong>#{centered}</strong>.</div>".html_safe
      end
    end
  end
end
