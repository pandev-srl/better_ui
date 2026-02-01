# frozen_string_literal: true

require "test_helper"

module BetterUi
  class LinkComponentTest < ActiveSupport::TestCase
    # Default rendering
    test "renders with default options" do
      render_inline(LinkComponent.new(href: "/test")) { "Click me" }

      assert_selector "a[href='/test']", text: "Click me"
      assert_selector "a.text-primary-600"  # default variant
      assert_selector "a.text-base"         # default size (md)
      assert_selector "a.inline-flex"
      assert_selector "a.items-center"
      assert_selector "a.gap-1"
      assert_selector "a.transition-colors"
      assert_selector "a.cursor-pointer"
    end

    test "renders href attribute" do
      render_inline(LinkComponent.new(href: "https://example.com")) { "Example" }

      assert_selector "a[href='https://example.com']"
    end

    # Variant tests
    test "renders primary variant" do
      render_inline(LinkComponent.new(href: "/")) { "Primary" }

      assert_selector "a.text-primary-600"
      assert_selector "a.hover\\:text-primary-800"
    end

    test "renders secondary variant" do
      render_inline(LinkComponent.new(href: "/", variant: :secondary)) { "Secondary" }

      assert_selector "a.text-secondary-600"
      assert_selector "a.hover\\:text-secondary-800"
    end

    test "renders accent variant" do
      render_inline(LinkComponent.new(href: "/", variant: :accent)) { "Accent" }

      assert_selector "a.text-accent-600"
      assert_selector "a.hover\\:text-accent-800"
    end

    test "renders success variant" do
      render_inline(LinkComponent.new(href: "/", variant: :success)) { "Success" }

      assert_selector "a.text-success-600"
      assert_selector "a.hover\\:text-success-800"
    end

    test "renders danger variant" do
      render_inline(LinkComponent.new(href: "/", variant: :danger)) { "Danger" }

      assert_selector "a.text-danger-600"
      assert_selector "a.hover\\:text-danger-800"
    end

    test "renders warning variant" do
      render_inline(LinkComponent.new(href: "/", variant: :warning)) { "Warning" }

      assert_selector "a.text-warning-600"
      assert_selector "a.hover\\:text-warning-800"
    end

    test "renders info variant" do
      render_inline(LinkComponent.new(href: "/", variant: :info)) { "Info" }

      assert_selector "a.text-info-600"
      assert_selector "a.hover\\:text-info-800"
    end

    test "renders light variant" do
      render_inline(LinkComponent.new(href: "/", variant: :light)) { "Light" }

      assert_selector "a.text-grayscale-400"
      assert_selector "a.hover\\:text-grayscale-600"
    end

    test "renders dark variant" do
      render_inline(LinkComponent.new(href: "/", variant: :dark)) { "Dark" }

      assert_selector "a.text-grayscale-800"
      assert_selector "a.hover\\:text-grayscale-950"
    end

    test "raises error for invalid variant" do
      error = assert_raises(ArgumentError) do
        LinkComponent.new(href: "/", variant: :invalid)
      end

      assert_match(/Invalid variant/, error.message)
    end

    # Style tests
    test "renders default style" do
      render_inline(LinkComponent.new(href: "/", style: :default)) { "Default" }

      assert_selector "a.text-primary-600"
      assert_selector "a.hover\\:text-primary-800"
    end

    test "renders underline style" do
      render_inline(LinkComponent.new(href: "/", style: :underline)) { "Underline" }

      assert_selector "a.underline"
      assert_selector "a.underline-offset-2"
      assert_selector "a.decoration-1"
      assert_selector "a.text-primary-600"
      assert_selector "a.hover\\:text-primary-800"
    end

    test "renders ghost style" do
      render_inline(LinkComponent.new(href: "/", style: :ghost)) { "Ghost" }

      assert_selector "a.text-primary-600"
      assert_selector "a.hover\\:bg-primary-50"
      assert_selector "a.px-1"
      assert_selector "a.rounded"
    end

    test "raises error for invalid style" do
      error = assert_raises(ArgumentError) do
        LinkComponent.new(href: "/", style: :invalid)
      end

      assert_match(/Invalid style/, error.message)
    end

    # Style + variant combinations
    test "renders underline style with danger variant" do
      render_inline(LinkComponent.new(href: "/", style: :underline, variant: :danger)) { "Danger" }

      assert_selector "a.underline"
      assert_selector "a.text-danger-600"
      assert_selector "a.hover\\:text-danger-800"
    end

    test "renders ghost style with success variant" do
      render_inline(LinkComponent.new(href: "/", style: :ghost, variant: :success)) { "Success" }

      assert_selector "a.text-success-600"
      assert_selector "a.hover\\:bg-success-50"
      assert_selector "a.px-1"
      assert_selector "a.rounded"
    end

    test "renders ghost style with secondary variant" do
      render_inline(LinkComponent.new(href: "/", style: :ghost, variant: :secondary)) { "Secondary" }

      assert_selector "a.text-secondary-600"
      assert_selector "a.hover\\:bg-secondary-50"
    end

    test "renders ghost style with accent variant" do
      render_inline(LinkComponent.new(href: "/", style: :ghost, variant: :accent)) { "Accent" }

      assert_selector "a.text-accent-600"
      assert_selector "a.hover\\:bg-accent-50"
    end

    test "renders ghost style with danger variant" do
      render_inline(LinkComponent.new(href: "/", style: :ghost, variant: :danger)) { "Danger" }

      assert_selector "a.text-danger-600"
      assert_selector "a.hover\\:bg-danger-50"
    end

    test "renders ghost style with warning variant" do
      render_inline(LinkComponent.new(href: "/", style: :ghost, variant: :warning)) { "Warning" }

      assert_selector "a.text-warning-600"
      assert_selector "a.hover\\:bg-warning-50"
    end

    test "renders ghost style with info variant" do
      render_inline(LinkComponent.new(href: "/", style: :ghost, variant: :info)) { "Info" }

      assert_selector "a.text-info-600"
      assert_selector "a.hover\\:bg-info-50"
    end

    test "renders ghost style with light variant" do
      render_inline(LinkComponent.new(href: "/", style: :ghost, variant: :light)) { "Light" }

      assert_selector "a.text-grayscale-400"
      assert_selector "a.hover\\:bg-grayscale-50"
    end

    test "renders ghost style with dark variant" do
      render_inline(LinkComponent.new(href: "/", style: :ghost, variant: :dark)) { "Dark" }

      assert_selector "a.text-grayscale-800"
      assert_selector "a.hover\\:bg-grayscale-100"
    end

    test "renders underline style with secondary variant" do
      render_inline(LinkComponent.new(href: "/", style: :underline, variant: :secondary)) { "Secondary" }

      assert_selector "a.underline"
      assert_selector "a.text-secondary-600"
    end

    test "renders underline style with accent variant" do
      render_inline(LinkComponent.new(href: "/", style: :underline, variant: :accent)) { "Accent" }

      assert_selector "a.underline"
      assert_selector "a.text-accent-600"
    end

    test "renders underline style with success variant" do
      render_inline(LinkComponent.new(href: "/", style: :underline, variant: :success)) { "Success" }

      assert_selector "a.underline"
      assert_selector "a.text-success-600"
    end

    test "renders underline style with warning variant" do
      render_inline(LinkComponent.new(href: "/", style: :underline, variant: :warning)) { "Warning" }

      assert_selector "a.underline"
      assert_selector "a.text-warning-600"
    end

    test "renders underline style with info variant" do
      render_inline(LinkComponent.new(href: "/", style: :underline, variant: :info)) { "Info" }

      assert_selector "a.underline"
      assert_selector "a.text-info-600"
    end

    test "renders underline style with light variant" do
      render_inline(LinkComponent.new(href: "/", style: :underline, variant: :light)) { "Light" }

      assert_selector "a.underline"
      assert_selector "a.text-grayscale-400"
    end

    test "renders underline style with dark variant" do
      render_inline(LinkComponent.new(href: "/", style: :underline, variant: :dark)) { "Dark" }

      assert_selector "a.underline"
      assert_selector "a.text-grayscale-800"
    end

    # Size tests
    test "renders xs size" do
      render_inline(LinkComponent.new(href: "/", size: :xs)) { "XS" }

      assert_selector "a.text-xs"
    end

    test "renders sm size" do
      render_inline(LinkComponent.new(href: "/", size: :sm)) { "SM" }

      assert_selector "a.text-sm"
    end

    test "renders md size" do
      render_inline(LinkComponent.new(href: "/", size: :md)) { "MD" }

      assert_selector "a.text-base"
    end

    test "renders lg size" do
      render_inline(LinkComponent.new(href: "/", size: :lg)) { "LG" }

      assert_selector "a.text-lg"
    end

    test "renders xl size" do
      render_inline(LinkComponent.new(href: "/", size: :xl)) { "XL" }

      assert_selector "a.text-xl"
    end

    test "raises error for invalid size" do
      error = assert_raises(ArgumentError) do
        LinkComponent.new(href: "/", size: :invalid)
      end

      assert_match(/Invalid size/, error.message)
    end

    # Target attribute
    test "renders with target attribute" do
      render_inline(LinkComponent.new(href: "https://example.com", target: "_blank")) { "External" }

      assert_selector "a[target='_blank']"
    end

    # Auto rel for _blank
    test "automatically adds rel noopener noreferrer for target blank" do
      render_inline(LinkComponent.new(href: "https://example.com", target: "_blank")) { "External" }

      assert_selector "a[rel='noopener noreferrer']"
    end

    test "does not add rel when target is not blank" do
      render_inline(LinkComponent.new(href: "/", target: "_self")) { "Self" }

      refute_selector "a[rel]"
    end

    # Custom rel
    test "allows custom rel attribute" do
      render_inline(LinkComponent.new(href: "/", target: "_blank", rel: "nofollow")) { "Link" }

      assert_selector "a[rel='nofollow']"
    end

    # Disabled state
    test "renders disabled state with opacity" do
      render_inline(LinkComponent.new(href: "/", disabled: true)) { "Disabled" }

      assert_selector "a.opacity-50"
    end

    test "renders disabled state with pointer-events-none" do
      render_inline(LinkComponent.new(href: "/", disabled: true)) { "Disabled" }

      assert_selector "a.pointer-events-none"
    end

    test "renders disabled state with cursor-not-allowed" do
      render_inline(LinkComponent.new(href: "/", disabled: true)) { "Disabled" }

      assert_selector "a.cursor-not-allowed"
    end

    test "disabled link has aria-disabled" do
      render_inline(LinkComponent.new(href: "/", disabled: true)) { "Disabled" }

      assert_selector "a[aria-disabled='true']"
    end

    test "disabled link has tabindex -1" do
      render_inline(LinkComponent.new(href: "/", disabled: true)) { "Disabled" }

      assert_selector "a[tabindex='-1']"
    end

    test "disabled link has no href" do
      render_inline(LinkComponent.new(href: "/test", disabled: true)) { "Disabled" }

      refute_selector "a[href='/test']"
    end

    # Icon slots
    test "renders icon_before slot" do
      render_inline(LinkComponent.new(href: "/")) do |component|
        component.with_icon_before { '<svg class="icon-before"></svg>'.html_safe }
        "Link"
      end

      assert_selector "a svg.icon-before"
    end

    test "renders icon_after slot" do
      render_inline(LinkComponent.new(href: "/")) do |component|
        component.with_icon_after { '<svg class="icon-after"></svg>'.html_safe }
        "Link"
      end

      assert_selector "a svg.icon-after"
    end

    test "renders both icon slots" do
      render_inline(LinkComponent.new(href: "/")) do |component|
        component.with_icon_before { '<svg class="icon-before"></svg>'.html_safe }
        component.with_icon_after { '<svg class="icon-after"></svg>'.html_safe }
        "Link"
      end

      assert_selector "a svg.icon-before"
      assert_selector "a svg.icon-after"
    end

    # Container classes
    test "renders with container_classes" do
      render_inline(LinkComponent.new(href: "/", container_classes: "custom-class")) { "Custom" }

      assert_selector "a.custom-class"
    end

    # Additional HTML options
    test "passes through additional HTML options" do
      render_inline(LinkComponent.new(href: "/", id: "my-link", class: "extra-class")) { "Link" }

      assert_selector "a#my-link"
      assert_selector "a.extra-class"
    end

    # All variants render as links
    test "renders all variants" do
      BetterUi::ApplicationComponent::VARIANTS.keys.each do |variant|
        render_inline(LinkComponent.new(href: "/", variant: variant)) { variant.to_s }
        assert_selector "a"
      end
    end
  end
end
