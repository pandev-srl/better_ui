# frozen_string_literal: true

require "test_helper"

module BetterUi
  module Breadcrumb
    class BreadcrumbComponentTest < ActiveSupport::TestCase
      # ============================================
      # Default rendering
      # ============================================

      test "renders nav element with aria-label" do
        render_inline(BreadcrumbComponent.new) do |breadcrumb|
          breadcrumb.with_item(label: "Home", href: "/")
        end

        assert_selector "nav[aria-label='Breadcrumb']"
      end

      test "renders ol element" do
        render_inline(BreadcrumbComponent.new) do |breadcrumb|
          breadcrumb.with_item(label: "Home", href: "/")
        end

        assert_selector "ol"
      end

      test "renders with default size classes" do
        render_inline(BreadcrumbComponent.new) do |breadcrumb|
          breadcrumb.with_item(label: "Home", href: "/")
        end

        assert_selector "ol.flex.items-center.flex-wrap.gap-1.text-base"
      end

      # ============================================
      # Single item (no separator)
      # ============================================

      test "renders single item without separator" do
        render_inline(BreadcrumbComponent.new) do |breadcrumb|
          breadcrumb.with_item(label: "Home", href: "/")
        end

        assert_selector "li", count: 1
        refute_selector "span[aria-hidden='true']"
      end

      # ============================================
      # Multiple items with separators
      # ============================================

      test "renders multiple items with separators between them" do
        render_inline(BreadcrumbComponent.new) do |breadcrumb|
          breadcrumb.with_item(label: "Home", href: "/")
          breadcrumb.with_item(label: "Products", href: "/products")
          breadcrumb.with_item(label: "Widget")
        end

        assert_selector "li", count: 3
        assert_selector "span[aria-hidden='true']", count: 2
      end

      test "does not render separator before first item" do
        render_inline(BreadcrumbComponent.new) do |breadcrumb|
          breadcrumb.with_item(label: "Home", href: "/")
          breadcrumb.with_item(label: "Products", href: "/products")
        end

        # First li should not contain a separator span
        html_doc = Nokogiri::HTML.fragment(rendered_html)
        first_li = html_doc.css("li").first
        assert first_li.css("span[aria-hidden]").empty?, "First item should not have a separator"
      end

      # ============================================
      # Separator types
      # ============================================

      test "renders slash separator by default" do
        render_inline(BreadcrumbComponent.new(separator: :slash)) do |breadcrumb|
          breadcrumb.with_item(label: "Home", href: "/")
          breadcrumb.with_item(label: "Page")
        end

        assert_selector "span[aria-hidden='true']", text: "/"
      end

      test "renders chevron separator as SVG" do
        render_inline(BreadcrumbComponent.new(separator: :chevron)) do |breadcrumb|
          breadcrumb.with_item(label: "Home", href: "/")
          breadcrumb.with_item(label: "Page")
        end

        assert_selector "span[aria-hidden='true'] svg"
      end

      test "renders dot separator" do
        render_inline(BreadcrumbComponent.new(separator: :dot)) do |breadcrumb|
          breadcrumb.with_item(label: "Home", href: "/")
          breadcrumb.with_item(label: "Page")
        end

        assert_selector "span[aria-hidden='true']", text: "\u00B7"
      end

      test "separator has correct classes" do
        render_inline(BreadcrumbComponent.new) do |breadcrumb|
          breadcrumb.with_item(label: "Home", href: "/")
          breadcrumb.with_item(label: "Page")
        end

        assert_selector "span.mx-2.text-grayscale-400"
      end

      # ============================================
      # Sizes
      # ============================================

      test "renders small size" do
        render_inline(BreadcrumbComponent.new(size: :sm)) do |breadcrumb|
          breadcrumb.with_item(label: "Home", href: "/")
        end

        assert_selector "ol.text-sm"
      end

      test "renders medium size" do
        render_inline(BreadcrumbComponent.new(size: :md)) do |breadcrumb|
          breadcrumb.with_item(label: "Home", href: "/")
        end

        assert_selector "ol.text-base"
      end

      test "renders large size" do
        render_inline(BreadcrumbComponent.new(size: :lg)) do |breadcrumb|
          breadcrumb.with_item(label: "Home", href: "/")
        end

        assert_selector "ol.text-lg"
      end

      # ============================================
      # Item rendering: current page vs link
      # ============================================

      test "item without href renders as span with aria-current" do
        render_inline(BreadcrumbComponent.new) do |breadcrumb|
          breadcrumb.with_item(label: "Current Page")
        end

        assert_selector "span[aria-current='page']", text: "Current Page"
        refute_selector "a"
      end

      test "current item has correct classes" do
        render_inline(BreadcrumbComponent.new) do |breadcrumb|
          breadcrumb.with_item(label: "Current")
        end

        assert_selector "span.text-grayscale-500.font-medium.inline-flex.items-center.gap-1"
      end

      test "item with href renders as link" do
        render_inline(BreadcrumbComponent.new) do |breadcrumb|
          breadcrumb.with_item(label: "Home", href: "/")
        end

        assert_selector "a[href='/']", text: "Home"
        refute_selector "span[aria-current]"
      end

      test "link item has correct classes" do
        render_inline(BreadcrumbComponent.new) do |breadcrumb|
          breadcrumb.with_item(label: "Home", href: "/")
        end

        assert_selector "a.text-grayscale-600.inline-flex.items-center.gap-1.transition-colors"
      end

      # ============================================
      # icon_before slot on items
      # ============================================

      test "item renders with icon_before slot" do
        render_inline(BreadcrumbComponent.new) do |breadcrumb|
          breadcrumb.with_item(label: "Home", href: "/") do |item|
            item.with_icon_before { "<svg class='test-icon'></svg>".html_safe }
          end
        end

        assert_selector "a svg.test-icon"
      end

      test "current item renders with icon_before slot" do
        render_inline(BreadcrumbComponent.new) do |breadcrumb|
          breadcrumb.with_item(label: "Current") do |item|
            item.with_icon_before { "<svg class='current-icon'></svg>".html_safe }
          end
        end

        assert_selector "span[aria-current='page'] svg.current-icon"
      end

      test "item renders without icon when slot not used" do
        render_inline(BreadcrumbComponent.new) do |breadcrumb|
          breadcrumb.with_item(label: "Home", href: "/")
        end

        refute_selector "svg"
      end

      # ============================================
      # container_classes
      # ============================================

      test "renders with container_classes on nav element" do
        render_inline(BreadcrumbComponent.new(container_classes: "my-4 custom-nav")) do |breadcrumb|
          breadcrumb.with_item(label: "Home", href: "/")
        end

        assert_selector "nav.my-4.custom-nav"
      end

      test "renders without container_classes when not provided" do
        render_inline(BreadcrumbComponent.new) do |breadcrumb|
          breadcrumb.with_item(label: "Home", href: "/")
        end

        assert_selector "nav[aria-label='Breadcrumb']"
      end

      # ============================================
      # Validation errors
      # ============================================

      test "raises ArgumentError for invalid separator" do
        error = assert_raises(ArgumentError) do
          BreadcrumbComponent.new(separator: :arrow)
        end

        assert_match(/Invalid separator/, error.message)
      end

      test "raises ArgumentError for invalid size" do
        error = assert_raises(ArgumentError) do
          BreadcrumbComponent.new(size: :xl)
        end

        assert_match(/Invalid size/, error.message)
      end

      # ============================================
      # Complete rendering
      # ============================================

      test "renders complete breadcrumb with all features" do
        render_inline(BreadcrumbComponent.new(separator: :chevron, size: :lg, container_classes: "mb-6")) do |breadcrumb|
          breadcrumb.with_item(label: "Home", href: "/") do |item|
            item.with_icon_before { "<svg class='home-icon'></svg>".html_safe }
          end
          breadcrumb.with_item(label: "Products", href: "/products")
          breadcrumb.with_item(label: "Widget")
        end

        assert_selector "nav.mb-6[aria-label='Breadcrumb']"
        assert_selector "ol.text-lg"
        assert_selector "li", count: 3
        assert_selector "span[aria-hidden='true'] svg", count: 2
        assert_selector "a[href='/']", text: "Home"
        assert_selector "svg.home-icon"
        assert_selector "a[href='/products']", text: "Products"
        assert_selector "span[aria-current='page']", text: "Widget"
      end

      # ============================================
      # Li element classes
      # ============================================

      test "li elements have inline-flex items-center classes" do
        render_inline(BreadcrumbComponent.new) do |breadcrumb|
          breadcrumb.with_item(label: "Home", href: "/")
        end

        assert_selector "li.inline-flex.items-center"
      end
    end
  end
end
