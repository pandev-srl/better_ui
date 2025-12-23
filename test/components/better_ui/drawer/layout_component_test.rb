# frozen_string_literal: true

require "test_helper"

module BetterUi
  module Drawer
    class LayoutComponentTest < ActiveSupport::TestCase
      # Default rendering tests
      test "renders with default options" do
        render_inline(LayoutComponent.new) do |layout|
          layout.with_main { "Main content" }
        end

        assert_selector "div.h-screen.overflow-hidden.flex.flex-col"
        assert_selector "main.flex-1.overflow-auto"
        assert_text "Main content"
      end

      test "renders with Stimulus controller" do
        render_inline(LayoutComponent.new) do |layout|
          layout.with_main { "Content" }
        end

        assert_selector "div[data-controller='better-ui--drawer--layout']"
      end

      # Header slot tests
      test "renders with header slot" do
        render_inline(LayoutComponent.new) do |layout|
          layout.with_header do |header|
            header.with_logo { "Logo" }
          end
          layout.with_main { "Content" }
        end

        assert_text "Logo"
        assert_selector "header"
      end

      test "renders without header" do
        render_inline(LayoutComponent.new) do |layout|
          layout.with_main { "Content" }
        end

        refute_selector "header"
        assert_text "Content"
      end

      # Sidebar slot tests
      test "renders with sidebar slot" do
        render_inline(LayoutComponent.new) do |layout|
          layout.with_sidebar do |sidebar|
            sidebar.with_navigation { "Nav" }
          end
          layout.with_main { "Content" }
        end

        assert_text "Nav"
        assert_selector "aside"
      end

      test "renders sidebar in desktop wrapper" do
        render_inline(LayoutComponent.new) do |layout|
          layout.with_sidebar do |sidebar|
            sidebar.with_navigation { "Nav" }
          end
          layout.with_main { "Content" }
        end

        # Desktop sidebar wrapper should be hidden on mobile and full height
        assert_selector "div.hidden.h-full.lg\\:flex"
      end

      test "renders sidebar in mobile wrapper" do
        render_inline(LayoutComponent.new) do |layout|
          layout.with_sidebar do |sidebar|
            sidebar.with_navigation { "Nav" }
          end
          layout.with_main { "Content" }
        end

        # Mobile sidebar wrapper should have transform classes
        assert_selector "div.fixed.inset-y-0"
        assert_selector "div.transform.transition-transform"
        assert_selector "div[data-better-ui--drawer--layout-target='sidebar']"
      end

      test "renders without sidebar" do
        render_inline(LayoutComponent.new) do |layout|
          layout.with_main { "Content" }
        end

        refute_selector "aside"
      end

      # Main slot tests
      test "renders with main slot" do
        render_inline(LayoutComponent.new) do |layout|
          layout.with_main { "Main Content" }
        end

        assert_text "Main Content"
        assert_selector "main"
      end

      test "renders default content in main when no main slot" do
        render_inline(LayoutComponent.new) { "Default Content" }

        assert_text "Default Content"
      end

      # Overlay tests
      test "renders overlay element" do
        render_inline(LayoutComponent.new) do |layout|
          layout.with_sidebar do |sidebar|
            sidebar.with_navigation { "Nav" }
          end
          layout.with_main { "Content" }
        end

        assert_selector "div[data-better-ui--drawer--layout-target='overlay']"
        assert_selector "div.fixed.inset-0.bg-black\\/50.z-40"
      end

      test "overlay has close action" do
        render_inline(LayoutComponent.new) do |layout|
          layout.with_sidebar do |sidebar|
            sidebar.with_navigation { "Nav" }
          end
          layout.with_main { "Content" }
        end

        assert_selector "div[data-action='click->better-ui--drawer--layout#close']"
      end

      # Position tests
      test "renders with left sidebar position by default" do
        render_inline(LayoutComponent.new) do |layout|
          layout.with_sidebar do |sidebar|
            sidebar.with_navigation { "Nav" }
          end
          layout.with_main { "Content" }
        end

        assert_selector "div[data-better-ui--drawer--layout-position-value='left']"
        assert_selector "div.left-0"
        assert_selector "div.-translate-x-full"
      end

      test "renders with right sidebar position" do
        render_inline(LayoutComponent.new(sidebar_position: :right)) do |layout|
          layout.with_sidebar do |sidebar|
            sidebar.with_navigation { "Nav" }
          end
          layout.with_main { "Content" }
        end

        assert_selector "div[data-better-ui--drawer--layout-position-value='right']"
        assert_selector "div.right-0"
        assert_selector "div.translate-x-full"
      end

      test "raises error for invalid sidebar position" do
        error = assert_raises(ArgumentError) do
          LayoutComponent.new(sidebar_position: :invalid)
        end

        assert_match(/Invalid sidebar_position/, error.message)
        assert_match(/left, right/, error.message)
      end

      test "exposes sidebar_position attribute" do
        component = LayoutComponent.new(sidebar_position: :right)
        assert_equal :right, component.sidebar_position
      end

      # Breakpoint tests
      test "renders with lg breakpoint by default" do
        render_inline(LayoutComponent.new) do |layout|
          layout.with_sidebar do |sidebar|
            sidebar.with_navigation { "Nav" }
          end
          layout.with_main { "Content" }
        end

        assert_selector "div[data-better-ui--drawer--layout-breakpoint-value='lg']"
        assert_selector "div.hidden.h-full.lg\\:flex"
        assert_selector "div.lg\\:hidden" # mobile drawer hidden on lg
      end

      test "renders with md breakpoint" do
        render_inline(LayoutComponent.new(sidebar_breakpoint: :md)) do |layout|
          layout.with_sidebar do |sidebar|
            sidebar.with_navigation { "Nav" }
          end
          layout.with_main { "Content" }
        end

        assert_selector "div[data-better-ui--drawer--layout-breakpoint-value='md']"
        assert_selector "div.hidden.h-full.md\\:flex"
        assert_selector "div.md\\:hidden"
      end

      test "renders with xl breakpoint" do
        render_inline(LayoutComponent.new(sidebar_breakpoint: :xl)) do |layout|
          layout.with_sidebar do |sidebar|
            sidebar.with_navigation { "Nav" }
          end
          layout.with_main { "Content" }
        end

        assert_selector "div[data-better-ui--drawer--layout-breakpoint-value='xl']"
        assert_selector "div.hidden.h-full.xl\\:flex"
        assert_selector "div.xl\\:hidden"
      end

      test "raises error for invalid sidebar breakpoint" do
        error = assert_raises(ArgumentError) do
          LayoutComponent.new(sidebar_breakpoint: :invalid)
        end

        assert_match(/Invalid sidebar_breakpoint/, error.message)
        assert_match(/md, lg, xl/, error.message)
      end

      test "exposes sidebar_breakpoint attribute" do
        component = LayoutComponent.new(sidebar_breakpoint: :xl)
        assert_equal :xl, component.sidebar_breakpoint
      end

      # Container classes tests
      test "renders with custom container classes" do
        render_inline(LayoutComponent.new(container_classes: "custom-container")) do |layout|
          layout.with_main { "Content" }
        end

        assert_selector "div.custom-container"
      end

      # Main classes tests
      test "renders with custom main classes" do
        render_inline(LayoutComponent.new(main_classes: "custom-main")) do |layout|
          layout.with_main { "Content" }
        end

        assert_selector "main.custom-main"
      end

      # HTML options tests
      test "passes through additional HTML options" do
        render_inline(LayoutComponent.new(id: "main-layout")) do |layout|
          layout.with_main { "Content" }
        end

        assert_selector "div#main-layout"
      end

      test "merges data attributes" do
        render_inline(LayoutComponent.new(data: { custom: "value" })) do |layout|
          layout.with_main { "Content" }
        end

        assert_selector "div[data-custom='value']"
        assert_selector "div[data-controller='better-ui--drawer--layout']"
      end

      # Full layout tests
      test "renders complete layout with all slots" do
        render_inline(LayoutComponent.new) do |layout|
          layout.with_header do |header|
            header.with_logo { "Logo" }
            header.with_mobile_menu_button { "Menu" }
            header.with_actions { "Actions" }
          end
          layout.with_sidebar do |sidebar|
            sidebar.with_header { "Sidebar Header" }
            sidebar.with_navigation { "Navigation" }
            sidebar.with_footer { "Sidebar Footer" }
          end
          layout.with_main { "Main Content" }
        end

        assert_text "Logo"
        assert_text "Menu"
        assert_text "Actions"
        assert_text "Sidebar Header"
        assert_text "Navigation"
        assert_text "Sidebar Footer"
        assert_text "Main Content"
      end

      # Structure tests
      test "renders body wrapper" do
        render_inline(LayoutComponent.new) do |layout|
          layout.with_main { "Content" }
        end

        assert_selector "div.flex.flex-1.overflow-hidden.relative"
      end

      test "mobile sidebar has z-50 for proper stacking" do
        render_inline(LayoutComponent.new) do |layout|
          layout.with_sidebar do |sidebar|
            sidebar.with_navigation { "Nav" }
          end
          layout.with_main { "Content" }
        end

        assert_selector "div.z-50[data-better-ui--drawer--layout-target='sidebar']"
      end

      # Animation classes tests
      test "mobile sidebar has animation classes" do
        render_inline(LayoutComponent.new) do |layout|
          layout.with_sidebar do |sidebar|
            sidebar.with_navigation { "Nav" }
          end
          layout.with_main { "Content" }
        end

        assert_selector "div.duration-300.ease-in-out"
      end
    end
  end
end
