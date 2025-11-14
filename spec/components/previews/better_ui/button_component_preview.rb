# frozen_string_literal: true

module BetterUi
  class ButtonComponentPreview < ViewComponent::Preview
    # @label Default
    def default
      render BetterUi::ButtonComponent.new do
        "Click me"
      end
    end

    # @label All Variants
    # @display bg_color #f5f5f5
    def all_variants
      @variants = ApplicationComponent::VARIANTS.keys
      @styles = [ :solid, :outline, :ghost, :soft ]
      render_with_template
    end

    # @label All Sizes
    def all_sizes
      @sizes = [ :xs, :sm, :md, :lg, :xl ]
      render_with_template
    end

    # @label With Icons
    def with_icons
      @sizes = [ :xs, :sm, :md, :lg, :xl ]
      @icon_sizes = {
        xs: "w-3 h-3",
        sm: "w-4 h-4",
        md: "w-5 h-5",
        lg: "w-6 h-6",
        xl: "w-7 h-7"
      }
      render_with_template
    end

    # @label Loading States
    def loading_states
      @variants = ApplicationComponent::VARIANTS.keys
      @sizes = [ :xs, :sm, :md, :lg, :xl ]
      render_with_template
    end

    # @label Form Integration
    def form_integration
      render_with_template
    end

    # @label Interactive Demo
    def interactive
      @variants = ApplicationComponent::VARIANTS.keys.take(5)
      render_with_template
    end

    # @label Playground
    # @param variant select { choices: [primary, secondary, accent, success, danger, warning, info, light, dark] } Matches ApplicationComponent::VARIANTS.keys
    # @param style select { choices: [solid, outline, ghost, soft] }
    # @param size select { choices: [xs, sm, md, lg, xl] }
    # @param show_loader toggle
    # @param show_loader_on_click toggle
    # @param disabled toggle
    # @param icon_position select { choices: [none, before, after, both] }
    def playground(variant: :primary, style: :solid, size: :md, show_loader: false, show_loader_on_click: false, disabled: false, icon_position: :none)
      render BetterUi::ButtonComponent.new(
        variant: variant,
        style: style,
        size: size,
        show_loader: show_loader,
        show_loader_on_click: show_loader_on_click,
        disabled: disabled
      ) do |button|
        # Add icons based on selection
        if [ :before, :both ].include?(icon_position)
          button.with_icon_before do
            '<svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7"></path>
            </svg>'.html_safe
          end
        end

        if [ :after, :both ].include?(icon_position)
          button.with_icon_after do
            '<svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 7l5 5m0 0l-5 5m5-5H6"></path>
            </svg>'.html_safe
          end
        end

        "Interactive Button"
      end
    end

    # @label Auto-Loading Submit Button
    def auto_loading_submit
      render_with_template
    end
  end
end
