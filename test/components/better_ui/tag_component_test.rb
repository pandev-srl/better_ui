# frozen_string_literal: true

require "test_helper"

module BetterUi
  class TagComponentTest < ActiveSupport::TestCase
    # Default rendering tests
    test "renders with default options" do
      render_inline(TagComponent.new) { "Tag" }

      assert_selector "span", text: "Tag"
      assert_selector "span.bg-primary-600"
      assert_selector "span.text-grayscale-50"
      assert_selector "span.rounded-full"
      assert_selector "span.px-2\\.5"
      assert_selector "span.py-1"
      assert_selector "span.text-sm"
    end

    test "renders as span by default" do
      render_inline(TagComponent.new) { "Tag" }

      assert_selector "span"
      refute_selector "a"
      refute_selector "button"
    end

    # Variant tests - solid style (default)
    test "renders primary variant" do
      render_inline(TagComponent.new(variant: :primary)) { "Primary" }

      assert_selector "span.bg-primary-600"
      assert_selector "span.text-grayscale-50"
    end

    test "renders secondary variant" do
      render_inline(TagComponent.new(variant: :secondary)) { "Secondary" }

      assert_selector "span.bg-secondary-600"
      assert_selector "span.text-grayscale-50"
    end

    test "renders accent variant" do
      render_inline(TagComponent.new(variant: :accent)) { "Accent" }

      assert_selector "span.bg-accent-600"
      assert_selector "span.text-grayscale-50"
    end

    test "renders success variant" do
      render_inline(TagComponent.new(variant: :success)) { "Success" }

      assert_selector "span.bg-success-600"
      assert_selector "span.text-grayscale-50"
    end

    test "renders danger variant" do
      render_inline(TagComponent.new(variant: :danger)) { "Danger" }

      assert_selector "span.bg-danger-600"
      assert_selector "span.text-grayscale-50"
    end

    test "renders warning variant" do
      render_inline(TagComponent.new(variant: :warning)) { "Warning" }

      assert_selector "span.bg-warning-600"
      assert_selector "span.text-grayscale-50"
    end

    test "renders info variant" do
      render_inline(TagComponent.new(variant: :info)) { "Info" }

      assert_selector "span.bg-info-600"
      assert_selector "span.text-grayscale-50"
    end

    test "renders light variant" do
      render_inline(TagComponent.new(variant: :light)) { "Light" }

      assert_selector "span.bg-grayscale-100"
      assert_selector "span.text-grayscale-900"
    end

    test "renders dark variant" do
      render_inline(TagComponent.new(variant: :dark)) { "Dark" }

      assert_selector "span.bg-grayscale-900"
      assert_selector "span.text-grayscale-50"
    end

    test "raises error for invalid variant" do
      error = assert_raises(ArgumentError) do
        TagComponent.new(variant: :invalid)
      end

      assert_match(/Invalid variant/, error.message)
    end

    # Style tests
    test "renders solid style" do
      render_inline(TagComponent.new(style: :solid)) { "Solid" }

      assert_selector "span.bg-primary-600"
      assert_selector "span.text-grayscale-50"
    end

    test "renders outline style" do
      render_inline(TagComponent.new(style: :outline)) { "Outline" }

      assert_selector "span.bg-transparent"
      assert_selector "span.border"
      assert_selector "span.border-primary-600"
      assert_selector "span.text-primary-600"
    end

    test "renders soft style" do
      render_inline(TagComponent.new(style: :soft)) { "Soft" }

      assert_selector "span.bg-primary-100"
      assert_selector "span.text-primary-700"
    end

    test "raises error for invalid style" do
      error = assert_raises(ArgumentError) do
        TagComponent.new(style: :invalid)
      end

      assert_match(/Invalid style/, error.message)
    end

    # Size tests
    test "renders sm size" do
      render_inline(TagComponent.new(size: :sm)) { "SM" }

      assert_selector "span.px-2"
      assert_selector "span.py-0\\.5"
      assert_selector "span.text-xs"
      assert_selector "span.gap-1"
    end

    test "renders md size" do
      render_inline(TagComponent.new(size: :md)) { "MD" }

      assert_selector "span.px-2\\.5"
      assert_selector "span.py-1"
      assert_selector "span.text-sm"
      assert_selector "span.gap-1\\.5"
    end

    test "renders lg size" do
      render_inline(TagComponent.new(size: :lg)) { "LG" }

      assert_selector "span.px-3"
      assert_selector "span.py-1\\.5"
      assert_selector "span.text-base"
      assert_selector "span.gap-2"
    end

    test "renders xs size" do
      render_inline(TagComponent.new(size: :xs)) { "XS" }

      assert_selector "span.px-1\\.5"
      assert_selector "span.py-0\\.5"
      assert_selector "span.text-xs"
      assert_selector "span.gap-1"
    end

    test "raises error for invalid size" do
      error = assert_raises(ArgumentError) do
        TagComponent.new(size: :invalid)
      end

      assert_match(/Invalid size/, error.message)
    end

    # Dismissible tests
    test "renders dismiss button when dismissible is true" do
      render_inline(TagComponent.new(dismissible: true)) { "Dismissible" }

      assert_selector "button[aria-label='Dismiss']"
      assert_selector "button svg"
      assert_selector "button[data-action='click->better-ui--tag#dismiss']"
    end

    test "renders Stimulus controller when dismissible is true" do
      render_inline(TagComponent.new(dismissible: true)) { "Dismissible" }

      assert_selector "span[data-controller='better-ui--tag']"
    end

    test "does not render dismiss button when dismissible is false" do
      render_inline(TagComponent.new(dismissible: false)) { "Not Dismissible" }

      refute_selector "button[aria-label='Dismiss']"
    end

    test "does not render Stimulus controller when dismissible is false" do
      render_inline(TagComponent.new(dismissible: false)) { "Not Dismissible" }

      refute_selector "[data-controller='better-ui--tag']"
    end

    # Href / link tests
    test "renders as anchor tag when href is provided" do
      render_inline(TagComponent.new(href: "/tags")) { "Link Tag" }

      assert_selector "a[href='/tags']", text: "Link Tag"
      refute_selector "span"
    end

    test "renders as span when href is not provided" do
      render_inline(TagComponent.new) { "Span Tag" }

      assert_selector "span"
      refute_selector "a"
    end

    test "applies all styles to link" do
      render_inline(TagComponent.new(href: "/", variant: :success, style: :outline, size: :lg)) { "Link" }

      assert_selector "a.border-success-600"
      assert_selector "a.px-3"
    end

    test "renders dismissible link" do
      render_inline(TagComponent.new(href: "/tags", dismissible: true)) { "Dismissible Link" }

      assert_selector "a[data-controller='better-ui--tag']"
      assert_selector "a button[data-action='click->better-ui--tag#dismiss']"
    end

    # Icon slot tests
    test "renders icon_before slot" do
      render_inline(TagComponent.new) do |component|
        component.with_icon_before { '<svg class="icon-before"></svg>'.html_safe }
        "Tag"
      end

      assert_selector "span svg.icon-before"
    end

    test "renders icon_before slot in link" do
      render_inline(TagComponent.new(href: "/")) do |component|
        component.with_icon_before { '<svg class="icon-before"></svg>'.html_safe }
        "Tag"
      end

      assert_selector "a svg.icon-before"
    end

    test "renders icon_before in sizing wrapper span" do
      render_inline(TagComponent.new) do |component|
        component.with_icon_before { '<svg class="icon-test"></svg>'.html_safe }
        "Tag"
      end

      assert_selector "span span.inline-flex.items-center svg.icon-test"
    end

    test "renders icon_before sizing wrapper in link" do
      render_inline(TagComponent.new(href: "/")) do |component|
        component.with_icon_before { '<svg class="icon-test"></svg>'.html_safe }
        "Tag"
      end

      assert_selector "a span.inline-flex.items-center svg.icon-test"
    end

    # Container classes tests
    test "renders with custom container classes" do
      render_inline(TagComponent.new(container_classes: "custom-class")) { "Custom" }

      assert_selector "span.custom-class"
    end

    # Additional HTML options tests
    test "passes through additional HTML options" do
      render_inline(TagComponent.new(id: "my-tag")) { "Tag" }

      assert_selector "span#my-tag"
    end

    # Combined variant + style tests for coverage
    test "renders secondary outline tag" do
      render_inline(TagComponent.new(variant: :secondary, style: :outline)) { "Secondary" }
      assert_selector "span.border-secondary-600"
      assert_selector "span.text-secondary-600"
    end

    test "renders accent outline tag" do
      render_inline(TagComponent.new(variant: :accent, style: :outline)) { "Accent" }
      assert_selector "span.border-accent-600"
      assert_selector "span.text-accent-600"
    end

    test "renders success outline tag" do
      render_inline(TagComponent.new(variant: :success, style: :outline)) { "Success" }
      assert_selector "span.border-success-600"
      assert_selector "span.text-success-600"
    end

    test "renders danger outline tag" do
      render_inline(TagComponent.new(variant: :danger, style: :outline)) { "Danger" }
      assert_selector "span.border-danger-600"
      assert_selector "span.text-danger-600"
    end

    test "renders warning outline tag" do
      render_inline(TagComponent.new(variant: :warning, style: :outline)) { "Warning" }
      assert_selector "span.border-warning-600"
      assert_selector "span.text-warning-600"
    end

    test "renders info outline tag" do
      render_inline(TagComponent.new(variant: :info, style: :outline)) { "Info" }
      assert_selector "span.border-info-600"
      assert_selector "span.text-info-600"
    end

    test "renders light outline tag" do
      render_inline(TagComponent.new(variant: :light, style: :outline)) { "Light" }
      assert_selector "span.border-grayscale-400"
      assert_selector "span.text-grayscale-500"
    end

    test "renders dark outline tag" do
      render_inline(TagComponent.new(variant: :dark, style: :outline)) { "Dark" }
      assert_selector "span.border-grayscale-700"
      assert_selector "span.text-grayscale-700"
    end

    test "renders secondary soft tag" do
      render_inline(TagComponent.new(variant: :secondary, style: :soft)) { "Secondary" }
      assert_selector "span.bg-secondary-100"
      assert_selector "span.text-secondary-700"
    end

    test "renders accent soft tag" do
      render_inline(TagComponent.new(variant: :accent, style: :soft)) { "Accent" }
      assert_selector "span.bg-accent-100"
      assert_selector "span.text-accent-700"
    end

    test "renders success soft tag" do
      render_inline(TagComponent.new(variant: :success, style: :soft)) { "Success" }
      assert_selector "span.bg-success-100"
      assert_selector "span.text-success-700"
    end

    test "renders danger soft tag" do
      render_inline(TagComponent.new(variant: :danger, style: :soft)) { "Danger" }
      assert_selector "span.bg-danger-100"
      assert_selector "span.text-danger-700"
    end

    test "renders warning soft tag" do
      render_inline(TagComponent.new(variant: :warning, style: :soft)) { "Warning" }
      assert_selector "span.bg-warning-100"
      assert_selector "span.text-warning-700"
    end

    test "renders info soft tag" do
      render_inline(TagComponent.new(variant: :info, style: :soft)) { "Info" }
      assert_selector "span.bg-info-100"
      assert_selector "span.text-info-700"
    end

    test "renders light soft tag" do
      render_inline(TagComponent.new(variant: :light, style: :soft)) { "Light" }
      assert_selector "span.bg-grayscale-100"
      assert_selector "span.text-grayscale-700"
    end

    test "renders dark soft tag" do
      render_inline(TagComponent.new(variant: :dark, style: :soft)) { "Dark" }
      assert_selector "span.bg-grayscale-800"
      assert_selector "span.text-grayscale-100"
    end

    # All variants as links
    test "renders all variants as links" do
      BetterUi::ApplicationComponent::VARIANTS.keys.each do |variant|
        render_inline(TagComponent.new(href: "/", variant: variant)) { variant.to_s }
        assert_selector "a"
      end
    end
  end
end
