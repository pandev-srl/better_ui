# frozen_string_literal: true

require "test_helper"

module BetterUi
  module Breadcrumb
    class ItemComponentTest < ActiveSupport::TestCase
      # ============================================
      # Rendering as link (with href)
      # ============================================

      test "renders as anchor tag when href is provided" do
        render_inline(ItemComponent.new(label: "Home", href: "/"))

        assert_selector "a[href='/']", text: "Home"
        refute_selector "span"
      end

      test "link has correct CSS classes" do
        render_inline(ItemComponent.new(label: "Home", href: "/"))

        assert_selector "a.text-grayscale-600"
        assert_selector "a.inline-flex"
        assert_selector "a.items-center"
        assert_selector "a.gap-1"
        assert_selector "a.transition-colors"
      end

      test "link does not have aria-current attribute" do
        render_inline(ItemComponent.new(label: "Products", href: "/products"))

        refute_selector "[aria-current]"
      end

      # ============================================
      # Rendering as current page (without href)
      # ============================================

      test "renders as span when href is nil" do
        render_inline(ItemComponent.new(label: "Current Page"))

        assert_selector "span", text: "Current Page"
        refute_selector "a"
      end

      test "current page has aria-current attribute" do
        render_inline(ItemComponent.new(label: "Settings"))

        assert_selector "span[aria-current='page']", text: "Settings"
      end

      test "current page has correct CSS classes" do
        render_inline(ItemComponent.new(label: "Settings"))

        assert_selector "span.text-grayscale-500"
        assert_selector "span.font-medium"
        assert_selector "span.inline-flex"
        assert_selector "span.items-center"
        assert_selector "span.gap-1"
      end

      # ============================================
      # current? method
      # ============================================

      test "current? returns true when href is nil" do
        component = ItemComponent.new(label: "Page")
        assert component.current?
      end

      test "current? returns false when href is provided" do
        component = ItemComponent.new(label: "Page", href: "/page")
        refute component.current?
      end

      # ============================================
      # icon_before slot
      # ============================================

      test "renders icon_before slot in link item" do
        render_inline(ItemComponent.new(label: "Home", href: "/")) do |item|
          item.with_icon_before { '<svg class="home-icon"></svg>'.html_safe }
        end

        assert_selector "a svg.home-icon"
        assert_selector "a", text: "Home"
      end

      test "renders icon_before slot in current page item" do
        render_inline(ItemComponent.new(label: "Settings")) do |item|
          item.with_icon_before { '<svg class="settings-icon"></svg>'.html_safe }
        end

        assert_selector "span[aria-current='page'] svg.settings-icon"
        assert_selector "span", text: "Settings"
      end

      test "does not render icon when slot is not used" do
        render_inline(ItemComponent.new(label: "Home", href: "/"))

        refute_selector "svg"
      end

      # ============================================
      # Label rendering
      # ============================================

      test "renders the label text" do
        render_inline(ItemComponent.new(label: "Products", href: "/products"))

        assert_text "Products"
      end

      test "renders label in current page span" do
        render_inline(ItemComponent.new(label: "Dashboard"))

        assert_selector "span[aria-current='page']", text: "Dashboard"
      end
    end
  end
end
