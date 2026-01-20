# frozen_string_literal: true

module BetterUi
  module Tabs
    # @label Tabs Container
    class ContainerComponentPreview < ViewComponent::Preview
      # @label Default (Underline)
      # @display max_height 400px
      def default
        render_with_template
      end

      # @label Pills Style
      # @display max_height 400px
      def pills_style
        render_with_template
      end

      # @label Bordered Style
      # @display max_height 400px
      def bordered_style
        render_with_template
      end

      # @label All Variants (Underline)
      # @display max_height 600px
      def all_variants
        render_with_template
      end

      # @label All Sizes
      # @display max_height 800px
      def all_sizes
        render_with_template
      end

      # @label Alignments
      # @display max_height 600px
      def alignments
        render_with_template
      end

      # @label Vertical Tabs (Left)
      # @display max_height 400px
      def vertical_left
        render_with_template
      end

      # @label Vertical Tabs (Right)
      # @display max_height 400px
      def vertical_right
        render_with_template
      end

      # @label With Icons and Badges
      # @display max_height 400px
      def with_icons_and_badges
        render_with_template
      end

      # @label Disabled Tab
      # @display max_height 400px
      def disabled_tab
        render_with_template
      end

      # @label Turbo Mode Example
      # @display max_height 400px
      def turbo_mode
        render_with_template
      end

      # @label Playground
      # @display max_height 500px
      # @param mode select { choices: [js, turbo] }
      # @param style select { choices: [underline, pills, bordered] }
      # @param variant select { choices: [primary, secondary, accent, success, danger, warning, info, light, dark] }
      # @param size select { choices: [xs, sm, md, lg, xl] }
      # @param alignment select { choices: [start, center, end, stretch] }
      # @param position select { choices: [top, bottom, left, right] }
      def playground(
        mode: :js,
        style: :underline,
        variant: :primary,
        size: :md,
        alignment: :start,
        position: :top
      )
        render BetterUi::Tabs::ContainerComponent.new(
          mode: mode.to_sym,
          style: style.to_sym,
          variant: variant.to_sym,
          size: size.to_sym,
          alignment: alignment.to_sym,
          position: position.to_sym
        ) do |tabs|
          tabs.with_tab(id: "overview", label: "Overview", active: true)
          tabs.with_tab(id: "features", label: "Features")
          tabs.with_tab(id: "pricing", label: "Pricing")

          tabs.with_panel(id: "overview", active: true) do
            "<div class='p-4'>
              <h3 class='text-lg font-semibold mb-2'>Overview</h3>
              <p class='text-grayscale-600'>This is the overview panel content. Customize the tabs using the controls above.</p>
            </div>".html_safe
          end

          tabs.with_panel(id: "features") do
            "<div class='p-4'>
              <h3 class='text-lg font-semibold mb-2'>Features</h3>
              <ul class='list-disc list-inside text-grayscale-600'>
                <li>Multiple styles: underline, pills, bordered</li>
                <li>9 color variants</li>
                <li>5 size options</li>
                <li>Vertical and horizontal layouts</li>
              </ul>
            </div>".html_safe
          end

          tabs.with_panel(id: "pricing") do
            "<div class='p-4'>
              <h3 class='text-lg font-semibold mb-2'>Pricing</h3>
              <p class='text-grayscale-600'>Contact us for pricing information.</p>
            </div>".html_safe
          end
        end
      end
    end
  end
end
