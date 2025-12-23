# frozen_string_literal: true

module BetterUi
  module Drawer
    # @label Layout
    class LayoutComponentPreview < ViewComponent::Preview
      # @label Default
      # @display max_height 600px
      def default
        render_with_template
      end

      # @label With Header Only
      # @display max_height 400px
      def with_header_only
        render_with_template
      end

      # @label With Sidebar Only
      # @display max_height 400px
      def with_sidebar_only
        render_with_template
      end

      # @label Complete Layout
      # @display max_height 600px
      def complete_layout
        render_with_template
      end

      # @label Right Sidebar
      # @display max_height 600px
      def right_sidebar
        render_with_template
      end

      # @label Dark Theme
      # @display max_height 600px
      # @display bg_color #111827
      def dark_theme
        render_with_template
      end

      # @label Primary Theme
      # @display max_height 600px
      def primary_theme
        render_with_template
      end

      # @label Dashboard Example
      # @display max_height 700px
      def dashboard_example
        render_with_template
      end

      # @label Playground
      # @display max_height 600px
      # @param sidebar_position select { choices: [left, right] }
      # @param sidebar_breakpoint select { choices: [md, lg, xl] }
      # @param header_variant select { choices: [light, dark, transparent, primary] }
      # @param sidebar_variant select { choices: [light, dark, primary] }
      def playground(sidebar_position: :left, sidebar_breakpoint: :lg, header_variant: :light, sidebar_variant: :light)
        render BetterUi::Drawer::LayoutComponent.new(
          sidebar_position: sidebar_position.to_sym,
          sidebar_breakpoint: sidebar_breakpoint.to_sym
        ) do |layout|
          layout.with_header(variant: header_variant.to_sym) do |header|
            header.with_mobile_menu_button do
              "<button class='p-2 rounded-md lg:hidden' data-action='click->better-ui--drawer--layout#toggle'>
                <svg class='w-6 h-6' fill='none' stroke='currentColor' viewBox='0 0 24 24'><path stroke-linecap='round' stroke-linejoin='round' stroke-width='2' d='M4 6h16M4 12h16M4 18h16'></path></svg>
              </button>".html_safe
            end
            header.with_logo { "Playground" }
            header.with_actions { "Actions" }
          end

          layout.with_sidebar(variant: sidebar_variant.to_sym, position: sidebar_position.to_sym) do |sidebar|
            sidebar.with_navigation { "Navigation" }
          end

          layout.with_main do
            "<div class='p-6'>
              <h1 class='text-2xl font-bold mb-4'>Main Content</h1>
              <p>This is the main content area.</p>
            </div>".html_safe
          end
        end
      end
    end
  end
end
