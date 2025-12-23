# frozen_string_literal: true

require "test_helper"

module BetterUi
  module Drawer
    class SidebarComponentTest < ActiveSupport::TestCase
      # Default rendering tests
      test "renders with default options" do
        render_inline(SidebarComponent.new) do |sidebar|
          sidebar.with_navigation { "Navigation" }
        end

        assert_selector "aside.flex.flex-col"
        assert_selector "aside.w-64" # default width (md)
        assert_selector "aside.bg-white" # default variant (light)
        assert_selector "aside.h-full"
        assert_text "Navigation"
      end

      test "renders as aside element" do
        render_inline(SidebarComponent.new) do |sidebar|
          sidebar.with_navigation { "Nav" }
        end

        assert_selector "aside"
      end

      # Header slot tests
      test "renders with header slot" do
        render_inline(SidebarComponent.new) do |sidebar|
          sidebar.with_header { "Logo" }
          sidebar.with_navigation { "Nav" }
        end

        assert_text "Logo"
        assert_selector "div.shrink-0.p-4.border-b"
      end

      test "renders without header" do
        render_inline(SidebarComponent.new) do |sidebar|
          sidebar.with_navigation { "Nav" }
        end

        assert_text "Nav"
        # Only one border element (from navigation wrapper, not header)
        refute_selector "div.shrink-0.p-4.border-b"
      end

      # Navigation slot tests
      test "renders with navigation slot" do
        render_inline(SidebarComponent.new) do |sidebar|
          sidebar.with_navigation { "Navigation links" }
        end

        assert_text "Navigation links"
        assert_selector "div.flex-1.overflow-y-auto"
      end

      test "renders default content in navigation area when no navigation slot" do
        render_inline(SidebarComponent.new) { "Default content" }

        assert_text "Default content"
      end

      # Footer slot tests
      test "renders with footer slot" do
        render_inline(SidebarComponent.new) do |sidebar|
          sidebar.with_navigation { "Nav" }
          sidebar.with_footer { "User Info" }
        end

        assert_text "User Info"
        assert_selector "div.shrink-0.p-4.border-t"
      end

      test "renders without footer" do
        render_inline(SidebarComponent.new) do |sidebar|
          sidebar.with_navigation { "Nav" }
        end

        refute_selector "div.border-t"
      end

      # All slots together test
      test "renders with all slots" do
        render_inline(SidebarComponent.new) do |sidebar|
          sidebar.with_header { "Header" }
          sidebar.with_navigation { "Navigation" }
          sidebar.with_footer { "Footer" }
        end

        assert_text "Header"
        assert_text "Navigation"
        assert_text "Footer"
      end

      # Variant tests
      test "renders light variant" do
        render_inline(SidebarComponent.new(variant: :light)) do |sidebar|
          sidebar.with_navigation { "Nav" }
        end

        assert_selector "aside.bg-white"
        assert_selector "aside.text-grayscale-900"
        assert_selector "aside.border-grayscale-200"
      end

      test "renders dark variant" do
        render_inline(SidebarComponent.new(variant: :dark)) do |sidebar|
          sidebar.with_navigation { "Nav" }
        end

        assert_selector "aside.bg-grayscale-900"
        assert_selector "aside.text-white"
        assert_selector "aside.border-grayscale-700"
      end

      test "renders primary variant" do
        render_inline(SidebarComponent.new(variant: :primary)) do |sidebar|
          sidebar.with_navigation { "Nav" }
        end

        assert_selector "aside.bg-primary-800"
        assert_selector "aside.text-white"
        assert_selector "aside.border-primary-900"
      end

      test "raises error for invalid variant" do
        error = assert_raises(ArgumentError) do
          SidebarComponent.new(variant: :invalid)
        end

        assert_match(/Invalid variant/, error.message)
        assert_match(/light, dark, primary/, error.message)
      end

      # Position tests
      test "renders with left position by default" do
        render_inline(SidebarComponent.new) do |sidebar|
          sidebar.with_navigation { "Nav" }
        end

        assert_selector "aside.border-r"
        assert_selector "aside[data-position='left']"
      end

      test "renders with right position" do
        render_inline(SidebarComponent.new(position: :right)) do |sidebar|
          sidebar.with_navigation { "Nav" }
        end

        assert_selector "aside.border-l"
        assert_selector "aside[data-position='right']"
      end

      test "raises error for invalid position" do
        error = assert_raises(ArgumentError) do
          SidebarComponent.new(position: :invalid)
        end

        assert_match(/Invalid position/, error.message)
        assert_match(/left, right/, error.message)
      end

      test "exposes position attribute" do
        component = SidebarComponent.new(position: :right)
        assert_equal :right, component.position
      end

      # Width tests
      test "renders sm width" do
        render_inline(SidebarComponent.new(width: :sm)) do |sidebar|
          sidebar.with_navigation { "Nav" }
        end

        assert_selector "aside.w-16"
      end

      test "renders md width by default" do
        render_inline(SidebarComponent.new) do |sidebar|
          sidebar.with_navigation { "Nav" }
        end

        assert_selector "aside.w-64"
      end

      test "renders lg width" do
        render_inline(SidebarComponent.new(width: :lg)) do |sidebar|
          sidebar.with_navigation { "Nav" }
        end

        assert_selector "aside.w-80"
      end

      test "raises error for invalid width" do
        error = assert_raises(ArgumentError) do
          SidebarComponent.new(width: :invalid)
        end

        assert_match(/Invalid width/, error.message)
        assert_match(/sm, md, lg/, error.message)
      end

      # Collapsible tests
      test "renders with collapsible true by default" do
        render_inline(SidebarComponent.new) do |sidebar|
          sidebar.with_navigation { "Nav" }
        end

        assert_selector "aside[data-collapsible='true']"
      end

      test "renders with collapsible false" do
        render_inline(SidebarComponent.new(collapsible: false)) do |sidebar|
          sidebar.with_navigation { "Nav" }
        end

        assert_selector "aside[data-collapsible='false']"
      end

      # Container classes tests
      test "renders with custom container classes" do
        render_inline(SidebarComponent.new(container_classes: "custom-sidebar")) do |sidebar|
          sidebar.with_navigation { "Nav" }
        end

        assert_selector "aside.custom-sidebar"
      end

      # Section classes tests
      test "renders with custom header classes" do
        render_inline(SidebarComponent.new(header_classes: "custom-header")) do |sidebar|
          sidebar.with_header { "Header" }
          sidebar.with_navigation { "Nav" }
        end

        assert_selector "div.custom-header"
      end

      test "renders with custom navigation classes" do
        render_inline(SidebarComponent.new(navigation_classes: "custom-nav")) do |sidebar|
          sidebar.with_navigation { "Nav" }
        end

        assert_selector "div.custom-nav"
      end

      test "renders with custom footer classes" do
        render_inline(SidebarComponent.new(footer_classes: "custom-footer")) do |sidebar|
          sidebar.with_navigation { "Nav" }
          sidebar.with_footer { "Footer" }
        end

        assert_selector "div.custom-footer"
      end

      # HTML options tests
      test "passes through additional HTML options" do
        render_inline(SidebarComponent.new(id: "main-sidebar", class: "extra-class")) do |sidebar|
          sidebar.with_navigation { "Nav" }
        end

        assert_selector "aside#main-sidebar"
      end

      test "merges data attributes" do
        render_inline(SidebarComponent.new(data: { controller: "sidebar" })) do |sidebar|
          sidebar.with_navigation { "Nav" }
        end

        assert_selector "aside[data-controller='sidebar']"
        assert_selector "aside[data-position='left']"
      end

      # Layout structure tests
      test "renders with shrink-0 class" do
        render_inline(SidebarComponent.new) do |sidebar|
          sidebar.with_navigation { "Nav" }
        end

        assert_selector "aside.shrink-0"
      end

      test "navigation section has overflow-y-auto" do
        render_inline(SidebarComponent.new) do |sidebar|
          sidebar.with_navigation { "Nav" }
        end

        assert_selector "div.overflow-y-auto"
      end

      # Combined variant and position tests
      test "renders dark variant with right position" do
        render_inline(SidebarComponent.new(variant: :dark, position: :right)) do |sidebar|
          sidebar.with_navigation { "Nav" }
        end

        assert_selector "aside.bg-grayscale-900"
        assert_selector "aside.border-l"
        assert_selector "aside.border-grayscale-700"
      end

      test "renders primary variant with left position" do
        render_inline(SidebarComponent.new(variant: :primary, position: :left)) do |sidebar|
          sidebar.with_navigation { "Nav" }
        end

        assert_selector "aside.bg-primary-800"
        assert_selector "aside.border-r"
        assert_selector "aside.border-primary-900"
      end

      # Variant-specific border colors in sections
      test "renders light variant with header having correct border color" do
        render_inline(SidebarComponent.new(variant: :light)) do |sidebar|
          sidebar.with_header { "Header" }
          sidebar.with_navigation { "Nav" }
        end

        assert_selector "div.border-b.border-grayscale-200"
      end

      test "renders dark variant with footer having correct border color" do
        render_inline(SidebarComponent.new(variant: :dark)) do |sidebar|
          sidebar.with_navigation { "Nav" }
          sidebar.with_footer { "Footer" }
        end

        assert_selector "div.border-t.border-grayscale-700"
      end

      test "renders primary variant with header having correct border color" do
        render_inline(SidebarComponent.new(variant: :primary)) do |sidebar|
          sidebar.with_header { "Header" }
          sidebar.with_navigation { "Nav" }
        end

        assert_selector "div.border-b.border-primary-900"
      end
    end
  end
end
