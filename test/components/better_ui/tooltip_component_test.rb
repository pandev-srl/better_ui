# frozen_string_literal: true

require "test_helper"

module BetterUi
  class TooltipComponentTest < ActiveSupport::TestCase
    # ============================================
    # Default rendering
    # ============================================

    test "renders with default options wrapping content" do
      render_inline(TooltipComponent.new(text: "Tooltip text")) { "Hover me" }

      assert_selector "div.relative"
      assert_selector "div.inline-flex"
      assert_selector "div.group"
      assert_text "Hover me"
      assert_text "Tooltip text"
    end

    test "renders tooltip text inside role=tooltip element" do
      render_inline(TooltipComponent.new(text: "Help text")) { "Trigger" }

      assert_selector "[role='tooltip']", text: "Help text"
    end

    test "has group class on wrapper for CSS-only hover" do
      render_inline(TooltipComponent.new(text: "Tip")) { "Content" }

      assert_selector "div.group"
    end

    test "tooltip is hidden by default with opacity-0" do
      render_inline(TooltipComponent.new(text: "Tip")) { "Content" }

      assert_selector "[role='tooltip'].opacity-0"
    end

    test "tooltip shows on hover with group-hover:opacity-100" do
      render_inline(TooltipComponent.new(text: "Tip")) { "Content" }

      assert_selector "[role='tooltip'].group-hover\\:opacity-100"
    end

    test "tooltip has transition classes" do
      render_inline(TooltipComponent.new(text: "Tip")) { "Content" }

      assert_selector "[role='tooltip'].transition-opacity"
      assert_selector "[role='tooltip'].duration-200"
    end

    test "tooltip has pointer-events-none" do
      render_inline(TooltipComponent.new(text: "Tip")) { "Content" }

      assert_selector "[role='tooltip'].pointer-events-none"
    end

    test "wraps block content" do
      render_inline(TooltipComponent.new(text: "Info")) { '<button class="my-btn">Click</button>'.html_safe }

      assert_selector "div.group button.my-btn", text: "Click"
    end

    # ============================================
    # Variant tests
    # ============================================

    test "renders dark variant by default" do
      render_inline(TooltipComponent.new(text: "Tip")) { "Content" }

      assert_selector "[role='tooltip'].bg-grayscale-900"
      assert_selector "[role='tooltip'].text-white"
    end

    test "renders dark variant explicitly" do
      render_inline(TooltipComponent.new(text: "Tip", variant: :dark)) { "Content" }

      assert_selector "[role='tooltip'].bg-grayscale-900"
      assert_selector "[role='tooltip'].text-white"
    end

    test "renders light variant" do
      render_inline(TooltipComponent.new(text: "Tip", variant: :light)) { "Content" }

      assert_selector "[role='tooltip'].bg-white"
      assert_selector "[role='tooltip'].text-grayscale-900"
      assert_selector "[role='tooltip'].border"
      assert_selector "[role='tooltip'].border-grayscale-200"
      assert_selector "[role='tooltip'].shadow-lg"
    end

    test "raises error for invalid variant" do
      error = assert_raises(ArgumentError) do
        TooltipComponent.new(text: "Tip", variant: :invalid)
      end

      assert_match(/Invalid variant/, error.message)
    end

    # ============================================
    # Size tests
    # ============================================

    test "renders sm size by default" do
      render_inline(TooltipComponent.new(text: "Tip")) { "Content" }

      assert_selector "[role='tooltip'].text-xs"
      assert_selector "[role='tooltip'].px-2"
      assert_selector "[role='tooltip'].py-1"
    end

    test "renders sm size explicitly" do
      render_inline(TooltipComponent.new(text: "Tip", size: :sm)) { "Content" }

      assert_selector "[role='tooltip'].text-xs"
      assert_selector "[role='tooltip'].px-2"
      assert_selector "[role='tooltip'].py-1"
    end

    test "renders md size" do
      render_inline(TooltipComponent.new(text: "Tip", size: :md)) { "Content" }

      assert_selector "[role='tooltip'].text-sm"
      assert_selector "[role='tooltip'].px-3"
      assert_selector "[role='tooltip'].py-1\\.5"
    end

    test "raises error for invalid size" do
      error = assert_raises(ArgumentError) do
        TooltipComponent.new(text: "Tip", size: :invalid)
      end

      assert_match(/Invalid size/, error.message)
    end

    # ============================================
    # Position tests
    # ============================================

    test "renders top position by default" do
      render_inline(TooltipComponent.new(text: "Tip")) { "Content" }

      assert_selector "[role='tooltip'].bottom-full"
      assert_selector "[role='tooltip'].left-1\\/2"
      assert_selector "[role='tooltip'].-translate-x-1\\/2"
      assert_selector "[role='tooltip'].mb-2"
    end

    test "renders top position explicitly" do
      render_inline(TooltipComponent.new(text: "Tip", position: :top)) { "Content" }

      assert_selector "[role='tooltip'].bottom-full"
      assert_selector "[role='tooltip'].left-1\\/2"
      assert_selector "[role='tooltip'].-translate-x-1\\/2"
      assert_selector "[role='tooltip'].mb-2"
    end

    test "renders right position" do
      render_inline(TooltipComponent.new(text: "Tip", position: :right)) { "Content" }

      assert_selector "[role='tooltip'].left-full"
      assert_selector "[role='tooltip'].top-1\\/2"
      assert_selector "[role='tooltip'].-translate-y-1\\/2"
      assert_selector "[role='tooltip'].ml-2"
    end

    test "renders bottom position" do
      render_inline(TooltipComponent.new(text: "Tip", position: :bottom)) { "Content" }

      assert_selector "[role='tooltip'].top-full"
      assert_selector "[role='tooltip'].left-1\\/2"
      assert_selector "[role='tooltip'].-translate-x-1\\/2"
      assert_selector "[role='tooltip'].mt-2"
    end

    test "renders left position" do
      render_inline(TooltipComponent.new(text: "Tip", position: :left)) { "Content" }

      assert_selector "[role='tooltip'].right-full"
      assert_selector "[role='tooltip'].top-1\\/2"
      assert_selector "[role='tooltip'].-translate-y-1\\/2"
      assert_selector "[role='tooltip'].mr-2"
    end

    test "raises error for invalid position" do
      error = assert_raises(ArgumentError) do
        TooltipComponent.new(text: "Tip", position: :invalid)
      end

      assert_match(/Invalid position/, error.message)
    end

    # ============================================
    # Container classes tests
    # ============================================

    test "renders with custom container classes" do
      render_inline(TooltipComponent.new(text: "Tip", container_classes: "custom-class")) { "Content" }

      assert_selector "div.custom-class"
    end

    test "container classes merge with wrapper classes" do
      render_inline(TooltipComponent.new(text: "Tip", container_classes: "ml-4 mt-2")) { "Content" }

      assert_selector "div.ml-4"
      assert_selector "div.mt-2"
      assert_selector "div.group"
      assert_selector "div.relative"
    end

    # ============================================
    # Additional HTML options tests
    # ============================================

    test "passes through additional HTML options" do
      render_inline(TooltipComponent.new(text: "Tip", id: "my-tooltip")) { "Content" }

      assert_selector "div#my-tooltip"
    end

    # ============================================
    # Common classes tests
    # ============================================

    test "tooltip has absolute positioning" do
      render_inline(TooltipComponent.new(text: "Tip")) { "Content" }

      assert_selector "[role='tooltip'].absolute"
    end

    test "tooltip has z-50" do
      render_inline(TooltipComponent.new(text: "Tip")) { "Content" }

      assert_selector "[role='tooltip'].z-50"
    end

    test "tooltip has rounded-md" do
      render_inline(TooltipComponent.new(text: "Tip")) { "Content" }

      assert_selector "[role='tooltip'].rounded-md"
    end

    test "tooltip has whitespace-nowrap" do
      render_inline(TooltipComponent.new(text: "Tip")) { "Content" }

      assert_selector "[role='tooltip'].whitespace-nowrap"
    end

    # ============================================
    # Combined tests
    # ============================================

    test "renders light variant with bottom position and md size" do
      render_inline(TooltipComponent.new(
        text: "Details",
        variant: :light,
        position: :bottom,
        size: :md
      )) { "Info" }

      assert_selector "[role='tooltip'].bg-white"
      assert_selector "[role='tooltip'].text-grayscale-900"
      assert_selector "[role='tooltip'].top-full"
      assert_selector "[role='tooltip'].text-sm"
      assert_selector "[role='tooltip'].px-3"
      assert_text "Details"
      assert_text "Info"
    end

    test "renders dark variant with left position and sm size" do
      render_inline(TooltipComponent.new(
        text: "Help",
        variant: :dark,
        position: :left,
        size: :sm
      )) { "?" }

      assert_selector "[role='tooltip'].bg-grayscale-900"
      assert_selector "[role='tooltip'].text-white"
      assert_selector "[role='tooltip'].right-full"
      assert_selector "[role='tooltip'].text-xs"
      assert_selector "[role='tooltip'].px-2"
      assert_text "Help"
    end
  end
end
