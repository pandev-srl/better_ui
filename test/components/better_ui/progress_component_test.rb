# frozen_string_literal: true

require "test_helper"

module BetterUi
  class ProgressComponentTest < ActiveSupport::TestCase
    # ============================================
    # Default rendering
    # ============================================

    test "renders with default options" do
      render_inline(ProgressComponent.new)

      assert_selector "div"
      assert_selector "div[role='progressbar']"
      assert_selector "div[aria-valuenow='0']"
      assert_selector "div[aria-valuemin='0']"
      assert_selector "div[aria-valuemax='100']"
    end

    test "renders primary variant by default" do
      render_inline(ProgressComponent.new)

      assert_selector "div.bg-primary-600"
    end

    test "renders md size by default" do
      render_inline(ProgressComponent.new)

      assert_selector "div.h-3"
    end

    test "renders track with background and rounded styles" do
      render_inline(ProgressComponent.new)

      assert_selector "div.bg-grayscale-200"
      assert_selector "div.rounded-full.overflow-hidden"
    end

    test "renders fill bar with transition classes" do
      render_inline(ProgressComponent.new(value: 50))

      assert_selector "div.transition-all.duration-300.ease-out"
    end

    test "renders fill bar with correct width style" do
      render_inline(ProgressComponent.new(value: 75))

      html_doc = Nokogiri::HTML.fragment(rendered_html)
      fill_bar = html_doc.css("div.rounded-full.transition-all").first
      assert_match(/width:\s*75(\.0)?%/, fill_bar["style"])
    end

    test "renders zero width for default value" do
      render_inline(ProgressComponent.new)

      html_doc = Nokogiri::HTML.fragment(rendered_html)
      fill_bar = html_doc.css("div.rounded-full.transition-all").first
      assert_match(/width:\s*0(\.0)?%/, fill_bar["style"])
    end

    # ============================================
    # Value and percentage display
    # ============================================

    test "renders correct percentage for given value" do
      render_inline(ProgressComponent.new(value: 33))

      html_doc = Nokogiri::HTML.fragment(rendered_html)
      fill_bar = html_doc.css("div.rounded-full.transition-all").first
      assert_match(/width:\s*33(\.0)?%/, fill_bar["style"])
    end

    test "does not show label or value text by default" do
      render_inline(ProgressComponent.new(value: 50))

      refute_selector "span.text-sm.font-medium"
    end

    # ============================================
    # Variant tests
    # ============================================

    test "renders primary variant" do
      render_inline(ProgressComponent.new(variant: :primary))

      assert_selector "div.bg-primary-600"
    end

    test "renders secondary variant" do
      render_inline(ProgressComponent.new(variant: :secondary))

      assert_selector "div.bg-secondary-500"
    end

    test "renders accent variant" do
      render_inline(ProgressComponent.new(variant: :accent))

      assert_selector "div.bg-accent-500"
    end

    test "renders success variant" do
      render_inline(ProgressComponent.new(variant: :success))

      assert_selector "div.bg-success-600"
    end

    test "renders danger variant" do
      render_inline(ProgressComponent.new(variant: :danger))

      assert_selector "div.bg-danger-600"
    end

    test "renders warning variant" do
      render_inline(ProgressComponent.new(variant: :warning))

      assert_selector "div.bg-warning-500"
    end

    test "renders info variant" do
      render_inline(ProgressComponent.new(variant: :info))

      assert_selector "div.bg-info-500"
    end

    test "renders light variant" do
      render_inline(ProgressComponent.new(variant: :light))

      assert_selector "div.bg-grayscale-400"
    end

    test "renders dark variant" do
      render_inline(ProgressComponent.new(variant: :dark))

      assert_selector "div.bg-grayscale-800"
    end

    # ============================================
    # Size tests
    # ============================================

    test "renders xs size" do
      render_inline(ProgressComponent.new(size: :xs))

      assert_selector "div.h-1"
    end

    test "renders sm size" do
      render_inline(ProgressComponent.new(size: :sm))

      assert_selector "div.h-2"
    end

    test "renders md size" do
      render_inline(ProgressComponent.new(size: :md))

      assert_selector "div.h-3"
    end

    test "renders lg size" do
      render_inline(ProgressComponent.new(size: :lg))

      assert_selector "div.h-4"
    end

    # ============================================
    # Label
    # ============================================

    test "renders label text" do
      render_inline(ProgressComponent.new(label: "Uploading files..."))

      assert_selector "span.text-sm.font-medium.text-grayscale-700", text: "Uploading files..."
    end

    test "renders label with flex container" do
      render_inline(ProgressComponent.new(label: "Progress"))

      assert_selector "div.flex.justify-between.items-center.mb-1"
    end

    # ============================================
    # Show value
    # ============================================

    test "renders percentage text when show_value is true" do
      render_inline(ProgressComponent.new(value: 42, show_value: true))

      assert_selector "span.text-sm.font-medium.text-grayscale-700", text: "42%"
    end

    test "renders rounded percentage when show_value is true" do
      render_inline(ProgressComponent.new(value: 33, max: 100, show_value: true))

      assert_selector "span.text-sm.font-medium.text-grayscale-700", text: "33%"
    end

    test "renders both label and value when both provided" do
      render_inline(ProgressComponent.new(label: "Progress", value: 75, show_value: true))

      assert_selector "span.text-sm.font-medium.text-grayscale-700", text: "Progress"
      assert_selector "span.text-sm.font-medium.text-grayscale-700", text: "75%"
    end

    test "renders flex container when only show_value is true" do
      render_inline(ProgressComponent.new(show_value: true))

      assert_selector "div.flex.justify-between.items-center.mb-1"
    end

    # ============================================
    # Animated
    # ============================================

    test "renders animated classes when animated is true" do
      render_inline(ProgressComponent.new(value: 50, animated: true))

      assert_selector "div.animate-pulse"
    end

    test "does not render animated classes when animated is false" do
      render_inline(ProgressComponent.new(value: 50, animated: false))

      refute_selector "div.animate-pulse"
    end

    # ============================================
    # Value clamping
    # ============================================

    test "clamps value above max to 100 percent" do
      render_inline(ProgressComponent.new(value: 150, max: 100))

      html_doc = Nokogiri::HTML.fragment(rendered_html)
      fill_bar = html_doc.css("div.rounded-full.transition-all").first
      assert_match(/width:\s*100(\.0)?%/, fill_bar["style"])
    end

    test "clamps negative value to 0 percent" do
      render_inline(ProgressComponent.new(value: -20))

      html_doc = Nokogiri::HTML.fragment(rendered_html)
      fill_bar = html_doc.css("div.rounded-full.transition-all").first
      assert_match(/width:\s*0(\.0)?%/, fill_bar["style"])
    end

    test "clamps value above max and shows 100 percent text" do
      render_inline(ProgressComponent.new(value: 200, max: 100, show_value: true))

      assert_selector "span.text-sm.font-medium.text-grayscale-700", text: "100%"
    end

    test "clamps negative value and shows 0 percent text" do
      render_inline(ProgressComponent.new(value: -50, show_value: true))

      assert_selector "span.text-sm.font-medium.text-grayscale-700", text: "0%"
    end

    # ============================================
    # Custom max value
    # ============================================

    test "calculates percentage based on custom max" do
      render_inline(ProgressComponent.new(value: 25, max: 50))

      html_doc = Nokogiri::HTML.fragment(rendered_html)
      fill_bar = html_doc.css("div.rounded-full.transition-all").first
      assert_match(/width:\s*50(\.0)?%/, fill_bar["style"])
    end

    test "renders custom max in aria-valuemax" do
      render_inline(ProgressComponent.new(value: 10, max: 200))

      assert_selector "div[aria-valuemax='200']"
    end

    test "renders value in aria-valuenow" do
      render_inline(ProgressComponent.new(value: 42))

      assert_selector "div[aria-valuenow='42']"
    end

    # ============================================
    # Aria attributes
    # ============================================

    test "renders role progressbar" do
      render_inline(ProgressComponent.new)

      assert_selector "div[role='progressbar']"
    end

    test "renders aria-valuemin" do
      render_inline(ProgressComponent.new)

      assert_selector "div[aria-valuemin='0']"
    end

    test "renders aria-valuemax with default max" do
      render_inline(ProgressComponent.new)

      assert_selector "div[aria-valuemax='100']"
    end

    test "renders aria-valuenow with value" do
      render_inline(ProgressComponent.new(value: 65))

      assert_selector "div[aria-valuenow='65']"
    end

    # ============================================
    # Container classes
    # ============================================

    test "renders with custom container classes" do
      render_inline(ProgressComponent.new(container_classes: "my-custom-class mt-4"))

      assert_selector "div.my-custom-class"
    end

    # ============================================
    # Invalid arguments
    # ============================================

    test "raises error for invalid variant" do
      error = assert_raises(ArgumentError) do
        ProgressComponent.new(variant: :invalid)
      end

      assert_match(/Invalid variant/, error.message)
    end

    test "raises error for invalid size" do
      error = assert_raises(ArgumentError) do
        ProgressComponent.new(size: :invalid)
      end

      assert_match(/Invalid size/, error.message)
    end
  end
end
