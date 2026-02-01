# frozen_string_literal: true

require "test_helper"

module BetterUi
  class BadgeComponentTest < ActiveSupport::TestCase
    # ============================================
    # Default rendering
    # ============================================

    test "renders with default options" do
      render_inline(BadgeComponent.new) { "New" }

      assert_selector "span", text: "New"
      assert_selector "span.bg-primary-600"       # default variant (solid)
      assert_selector "span.text-grayscale-50"     # solid text color
      assert_selector "span.px-2\\.5"              # default size (md)
      assert_selector "span.py-1"                  # default size (md)
      assert_selector "span.text-sm"               # default size (md)
      assert_selector "span.rounded-full"          # default pill: true
    end

    test "renders as a span element" do
      render_inline(BadgeComponent.new) { "Badge" }

      assert_selector "span", text: "Badge"
      refute_selector "button"
      refute_selector "a"
      refute_selector "div"
    end

    # ============================================
    # Variant tests (solid style)
    # ============================================

    test "renders primary variant" do
      render_inline(BadgeComponent.new(variant: :primary)) { "Primary" }

      assert_selector "span.bg-primary-600"
      assert_selector "span.text-grayscale-50"
    end

    test "renders secondary variant" do
      render_inline(BadgeComponent.new(variant: :secondary)) { "Secondary" }

      assert_selector "span.bg-secondary-600"
      assert_selector "span.text-grayscale-50"
    end

    test "renders accent variant" do
      render_inline(BadgeComponent.new(variant: :accent)) { "Accent" }

      assert_selector "span.bg-accent-600"
      assert_selector "span.text-grayscale-50"
    end

    test "renders success variant" do
      render_inline(BadgeComponent.new(variant: :success)) { "Success" }

      assert_selector "span.bg-success-600"
      assert_selector "span.text-grayscale-50"
    end

    test "renders danger variant" do
      render_inline(BadgeComponent.new(variant: :danger)) { "Danger" }

      assert_selector "span.bg-danger-600"
      assert_selector "span.text-grayscale-50"
    end

    test "renders warning variant" do
      render_inline(BadgeComponent.new(variant: :warning)) { "Warning" }

      assert_selector "span.bg-warning-600"
      assert_selector "span.text-grayscale-50"
    end

    test "renders info variant" do
      render_inline(BadgeComponent.new(variant: :info)) { "Info" }

      assert_selector "span.bg-info-600"
      assert_selector "span.text-grayscale-50"
    end

    test "renders light variant" do
      render_inline(BadgeComponent.new(variant: :light)) { "Light" }

      assert_selector "span.bg-grayscale-100"
      assert_selector "span.text-grayscale-900"
    end

    test "renders dark variant" do
      render_inline(BadgeComponent.new(variant: :dark)) { "Dark" }

      assert_selector "span.bg-grayscale-900"
      assert_selector "span.text-grayscale-50"
    end

    test "raises error for invalid variant" do
      error = assert_raises(ArgumentError) do
        BadgeComponent.new(variant: :invalid)
      end

      assert_match(/Invalid variant/, error.message)
    end

    # ============================================
    # Style tests (primary variant)
    # ============================================

    test "renders solid style" do
      render_inline(BadgeComponent.new(style: :solid)) { "Solid" }

      assert_selector "span.bg-primary-600"
      assert_selector "span.text-grayscale-50"
    end

    test "renders outline style" do
      render_inline(BadgeComponent.new(style: :outline)) { "Outline" }

      assert_selector "span.bg-transparent"
      assert_selector "span.border"
      assert_selector "span.border-primary-600"
      assert_selector "span.text-primary-600"
    end

    test "renders soft style" do
      render_inline(BadgeComponent.new(style: :soft)) { "Soft" }

      assert_selector "span.bg-primary-100"
      assert_selector "span.text-primary-700"
    end

    test "renders ghost style" do
      render_inline(BadgeComponent.new(style: :ghost)) { "Ghost" }

      assert_selector "span.bg-transparent"
      assert_selector "span.text-primary-600"
    end

    test "raises error for invalid style" do
      error = assert_raises(ArgumentError) do
        BadgeComponent.new(style: :invalid)
      end

      assert_match(/Invalid style/, error.message)
    end

    # ============================================
    # Size tests
    # ============================================

    test "renders xs size" do
      render_inline(BadgeComponent.new(size: :xs)) { "XS" }

      assert_selector "span.px-1\\.5"
      assert_selector "span.py-0\\.5"
      assert_selector "span.text-xs"
    end

    test "renders sm size" do
      render_inline(BadgeComponent.new(size: :sm)) { "SM" }

      assert_selector "span.px-2"
      assert_selector "span.py-0\\.5"
      assert_selector "span.text-xs"
    end

    test "renders md size" do
      render_inline(BadgeComponent.new(size: :md)) { "MD" }

      assert_selector "span.px-2\\.5"
      assert_selector "span.py-1"
      assert_selector "span.text-sm"
    end

    test "renders lg size" do
      render_inline(BadgeComponent.new(size: :lg)) { "LG" }

      assert_selector "span.px-3"
      assert_selector "span.py-1\\.5"
      assert_selector "span.text-base"
    end

    test "raises error for invalid size" do
      error = assert_raises(ArgumentError) do
        BadgeComponent.new(size: :invalid)
      end

      assert_match(/Invalid size/, error.message)
    end

    # ============================================
    # Pill / shape tests
    # ============================================

    test "renders pill shape by default" do
      render_inline(BadgeComponent.new) { "Pill" }

      assert_selector "span.rounded-full"
    end

    test "renders pill shape when pill is true" do
      render_inline(BadgeComponent.new(pill: true)) { "Pill" }

      assert_selector "span.rounded-full"
    end

    test "renders rounded-md shape when pill is false" do
      render_inline(BadgeComponent.new(pill: false)) { "Square" }

      assert_selector "span.rounded-md"
    end

    # ============================================
    # Dot tests
    # ============================================

    test "renders dot indicator when dot is true" do
      render_inline(BadgeComponent.new(dot: true)) { "Ignored" }

      assert_selector "span span.w-2.h-2.rounded-full"
    end

    test "dot uses variant color" do
      render_inline(BadgeComponent.new(dot: true, variant: :success)) { "Dot" }

      assert_selector "span span.bg-success-600"
    end

    test "dot does not render content text" do
      render_inline(BadgeComponent.new(dot: true)) { "Should not show" }

      assert_selector "span span.w-2"
      # The rendered HTML should not contain the content text
      html_doc = Nokogiri::HTML.fragment(rendered_html)
      refute html_doc.text.include?("Should not show"), "Expected dot badge not to render content text"
    end

    test "dot with light variant uses grayscale color" do
      render_inline(BadgeComponent.new(dot: true, variant: :light))

      assert_selector "span span.bg-grayscale-400"
    end

    test "dot with dark variant uses grayscale color" do
      render_inline(BadgeComponent.new(dot: true, variant: :dark))

      assert_selector "span span.bg-grayscale-900"
    end

    # ============================================
    # Counter tests
    # ============================================

    test "renders counter value" do
      render_inline(BadgeComponent.new(counter: 5))

      assert_text "5"
    end

    test "renders counter with large number" do
      render_inline(BadgeComponent.new(counter: 99))

      assert_text "99"
    end

    test "counter takes precedence over content" do
      render_inline(BadgeComponent.new(counter: 42)) { "Ignored content" }

      assert_text "42"
    end

    # ============================================
    # Icon slot tests
    # ============================================

    test "renders icon_before slot" do
      render_inline(BadgeComponent.new) do |component|
        component.with_icon_before { '<svg class="icon-before"></svg>'.html_safe }
        "Badge"
      end

      assert_selector "span svg.icon-before"
    end

    test "renders icon_before with text content" do
      render_inline(BadgeComponent.new) do |component|
        component.with_icon_before { '<svg class="test-icon"></svg>'.html_safe }
        "Label"
      end

      assert_selector "span svg.test-icon"
      assert_text "Label"
    end

    # ============================================
    # Container classes tests
    # ============================================

    test "renders with custom container classes" do
      render_inline(BadgeComponent.new(container_classes: "custom-class")) { "Custom" }

      assert_selector "span.custom-class"
    end

    test "container classes merge with component classes" do
      render_inline(BadgeComponent.new(container_classes: "ml-2 mt-1")) { "Spaced" }

      assert_selector "span.ml-2"
      assert_selector "span.mt-1"
      assert_selector "span.bg-primary-600"
    end

    # ============================================
    # Additional HTML options tests
    # ============================================

    test "passes through additional HTML options" do
      render_inline(BadgeComponent.new(id: "my-badge", class: "extra-class")) { "Badge" }

      assert_selector "span#my-badge"
      assert_selector "span.extra-class"
    end

    # ============================================
    # Combined variant + style tests
    # ============================================

    test "renders secondary outline badge" do
      render_inline(BadgeComponent.new(variant: :secondary, style: :outline)) { "Sec" }

      assert_selector "span.border-secondary-600"
      assert_selector "span.text-secondary-600"
    end

    test "renders success soft badge" do
      render_inline(BadgeComponent.new(variant: :success, style: :soft)) { "OK" }

      assert_selector "span.bg-success-100"
      assert_selector "span.text-success-700"
    end

    test "renders danger ghost badge" do
      render_inline(BadgeComponent.new(variant: :danger, style: :ghost)) { "Error" }

      assert_selector "span.bg-transparent"
      assert_selector "span.text-danger-600"
    end

    test "renders warning outline badge" do
      render_inline(BadgeComponent.new(variant: :warning, style: :outline)) { "Warn" }

      assert_selector "span.border-warning-600"
      assert_selector "span.text-warning-600"
    end

    test "renders info soft badge" do
      render_inline(BadgeComponent.new(variant: :info, style: :soft)) { "Tip" }

      assert_selector "span.bg-info-100"
      assert_selector "span.text-info-700"
    end

    test "renders accent ghost badge" do
      render_inline(BadgeComponent.new(variant: :accent, style: :ghost)) { "New" }

      assert_selector "span.bg-transparent"
      assert_selector "span.text-accent-600"
    end

    test "renders light outline badge" do
      render_inline(BadgeComponent.new(variant: :light, style: :outline)) { "Light" }

      assert_selector "span.border-grayscale-400"
      assert_selector "span.text-grayscale-400"
    end

    test "renders dark soft badge" do
      render_inline(BadgeComponent.new(variant: :dark, style: :soft)) { "Dark" }

      assert_selector "span.bg-grayscale-800"
      assert_selector "span.text-grayscale-100"
    end

    test "renders light ghost badge" do
      render_inline(BadgeComponent.new(variant: :light, style: :ghost)) { "Light" }

      assert_selector "span.bg-transparent"
      assert_selector "span.text-grayscale-700"
    end

    test "renders dark ghost badge" do
      render_inline(BadgeComponent.new(variant: :dark, style: :ghost)) { "Dark" }

      assert_selector "span.bg-transparent"
      assert_selector "span.text-grayscale-700"
    end

    test "renders dark outline badge" do
      render_inline(BadgeComponent.new(variant: :dark, style: :outline)) { "Dark" }

      assert_selector "span.border-grayscale-700"
      assert_selector "span.text-grayscale-700"
    end

    test "renders light soft badge" do
      render_inline(BadgeComponent.new(variant: :light, style: :soft)) { "Light" }

      assert_selector "span.bg-grayscale-100"
      assert_selector "span.text-grayscale-700"
    end

    # ============================================
    # Dot variant coverage (all remaining variants)
    # ============================================

    test "dot with primary variant" do
      render_inline(BadgeComponent.new(dot: true, variant: :primary))

      assert_selector "span span.bg-primary-600"
    end

    test "dot with secondary variant" do
      render_inline(BadgeComponent.new(dot: true, variant: :secondary))

      assert_selector "span span.bg-secondary-600"
    end

    test "dot with accent variant" do
      render_inline(BadgeComponent.new(dot: true, variant: :accent))

      assert_selector "span span.bg-accent-600"
    end

    test "dot with danger variant" do
      render_inline(BadgeComponent.new(dot: true, variant: :danger))

      assert_selector "span span.bg-danger-600"
    end

    test "dot with warning variant" do
      render_inline(BadgeComponent.new(dot: true, variant: :warning))

      assert_selector "span span.bg-warning-600"
    end

    test "dot with info variant" do
      render_inline(BadgeComponent.new(dot: true, variant: :info))

      assert_selector "span span.bg-info-600"
    end

    # ============================================
    # Combined feature tests
    # ============================================

    test "renders pill badge with counter and success variant" do
      render_inline(BadgeComponent.new(variant: :success, pill: true, counter: 12))

      assert_selector "span.rounded-full"
      assert_selector "span.bg-success-600"
      assert_text "12"
    end

    test "renders non-pill badge with outline style and lg size" do
      render_inline(BadgeComponent.new(style: :outline, pill: false, size: :lg)) { "Large" }

      assert_selector "span.rounded-md"
      assert_selector "span.border"
      assert_selector "span.px-3"
      assert_selector "span.text-base"
    end
  end
end
