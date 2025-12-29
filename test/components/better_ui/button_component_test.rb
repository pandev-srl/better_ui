# frozen_string_literal: true

require "test_helper"

module BetterUi
  class ButtonComponentTest < ActiveSupport::TestCase
    test "renders with default options" do
      render_inline(ButtonComponent.new) { "Click me" }

      assert_selector "button[type='button']", text: "Click me"
      assert_selector "button[data-controller='better-ui--button']"
      assert_selector "button.bg-primary-600" # default variant
      assert_selector "button.px-4.py-2" # default size (md)
    end

    test "renders with custom content" do
      render_inline(ButtonComponent.new) { "Custom Button Text" }

      assert_text "Custom Button Text"
    end

    # Variant tests
    test "renders primary variant" do
      render_inline(ButtonComponent.new(variant: :primary)) { "Primary" }

      assert_selector "button.bg-primary-600"
      assert_selector "button.hover\\:bg-primary-700"
    end

    test "renders secondary variant" do
      render_inline(ButtonComponent.new(variant: :secondary)) { "Secondary" }

      assert_selector "button.bg-secondary-600"
    end

    test "renders accent variant" do
      render_inline(ButtonComponent.new(variant: :accent)) { "Accent" }

      assert_selector "button.bg-accent-600"
    end

    test "renders success variant" do
      render_inline(ButtonComponent.new(variant: :success)) { "Success" }

      assert_selector "button.bg-success-600"
    end

    test "renders danger variant" do
      render_inline(ButtonComponent.new(variant: :danger)) { "Danger" }

      assert_selector "button.bg-danger-600"
    end

    test "renders warning variant" do
      render_inline(ButtonComponent.new(variant: :warning)) { "Warning" }

      assert_selector "button.bg-warning-600"
    end

    test "renders info variant" do
      render_inline(ButtonComponent.new(variant: :info)) { "Info" }

      assert_selector "button.bg-info-600"
    end

    test "renders light variant" do
      render_inline(ButtonComponent.new(variant: :light)) { "Light" }

      assert_selector "button.bg-grayscale-100"
      assert_selector "button.text-grayscale-900"
    end

    test "renders dark variant" do
      render_inline(ButtonComponent.new(variant: :dark)) { "Dark" }

      assert_selector "button.bg-grayscale-900"
    end

    test "raises error for invalid variant" do
      error = assert_raises(ArgumentError) do
        ButtonComponent.new(variant: :invalid)
      end

      assert_match(/Invalid variant/, error.message)
    end

    # Style tests
    test "renders solid style" do
      render_inline(ButtonComponent.new(style: :solid)) { "Solid" }

      assert_selector "button.bg-primary-600"
      assert_selector "button.text-grayscale-50"
    end

    test "renders outline style" do
      render_inline(ButtonComponent.new(style: :outline)) { "Outline" }

      assert_selector "button.bg-transparent"
      assert_selector "button.border-2"
      assert_selector "button.border-primary-600"
    end

    test "renders ghost style" do
      render_inline(ButtonComponent.new(style: :ghost)) { "Ghost" }

      assert_selector "button.bg-transparent"
      assert_selector "button.hover\\:bg-primary-50"
    end

    test "renders soft style" do
      render_inline(ButtonComponent.new(style: :soft)) { "Soft" }

      assert_selector "button.bg-primary-100"
      assert_selector "button.text-primary-700"
    end

    test "raises error for invalid style" do
      error = assert_raises(ArgumentError) do
        ButtonComponent.new(style: :invalid)
      end

      assert_match(/Invalid style/, error.message)
    end

    # Size tests
    test "renders xs size" do
      render_inline(ButtonComponent.new(size: :xs)) { "XS" }

      assert_selector "button.px-2.py-1"
      assert_selector "button.text-xs"
    end

    test "renders sm size" do
      render_inline(ButtonComponent.new(size: :sm)) { "SM" }

      assert_selector "button.px-3"
      assert_selector "button.text-sm"
    end

    test "renders md size" do
      render_inline(ButtonComponent.new(size: :md)) { "MD" }

      assert_selector "button.px-4.py-2"
      assert_selector "button.text-base"
    end

    test "renders lg size" do
      render_inline(ButtonComponent.new(size: :lg)) { "LG" }

      assert_selector "button.px-5"
      assert_selector "button.text-lg"
    end

    test "renders xl size" do
      render_inline(ButtonComponent.new(size: :xl)) { "XL" }

      assert_selector "button.px-6.py-3"
      assert_selector "button.text-xl"
    end

    test "raises error for invalid size" do
      error = assert_raises(ArgumentError) do
        ButtonComponent.new(size: :invalid)
      end

      assert_match(/Invalid size/, error.message)
    end

    # State tests
    test "renders disabled state" do
      render_inline(ButtonComponent.new(disabled: true)) { "Disabled" }

      assert_selector "button[disabled]"
      assert_selector "button.opacity-50"
      assert_selector "button.cursor-not-allowed"
    end

    test "renders loading state" do
      render_inline(ButtonComponent.new(show_loader: true)) { "Loading" }

      assert_selector "button[disabled]"
      assert_selector "button.cursor-wait"
    end

    test "renders show_loader_on_click data attribute" do
      render_inline(ButtonComponent.new(show_loader_on_click: true)) { "Click" }

      assert_selector "button[data-better-ui--button-show-loader-on-click-value='true']"
    end

    test "renders with custom container classes" do
      render_inline(ButtonComponent.new(container_classes: "custom-class")) { "Custom" }

      assert_selector "button.custom-class"
    end

    # Type tests
    test "renders button type" do
      render_inline(ButtonComponent.new(type: :button)) { "Button" }

      assert_selector "button[type='button']"
    end

    test "renders submit type" do
      render_inline(ButtonComponent.new(type: :submit)) { "Submit" }

      assert_selector "button[type='submit']"
    end

    test "renders reset type" do
      render_inline(ButtonComponent.new(type: :reset)) { "Reset" }

      assert_selector "button[type='reset']"
    end

    test "raises error for invalid type" do
      error = assert_raises(ArgumentError) do
        ButtonComponent.new(type: :invalid)
      end

      assert_match(/Invalid type/, error.message)
    end

    # Icon slot tests
    test "renders icon_before slot" do
      render_inline(ButtonComponent.new) do |component|
        component.with_icon_before { '<svg class="icon-before"></svg>'.html_safe }
        "Button"
      end

      assert_selector "button svg.icon-before"
    end

    test "renders icon_after slot" do
      render_inline(ButtonComponent.new) do |component|
        component.with_icon_after { '<svg class="icon-after"></svg>'.html_safe }
        "Button"
      end

      assert_selector "button svg.icon-after"
    end

    test "renders both icon slots" do
      render_inline(ButtonComponent.new) do |component|
        component.with_icon_before { '<svg class="icon-before"></svg>'.html_safe }
        component.with_icon_after { '<svg class="icon-after"></svg>'.html_safe }
        "Button"
      end

      assert_selector "button svg.icon-before"
      assert_selector "button svg.icon-after"
    end

    # Stimulus controller tests
    test "includes Stimulus controller data attributes" do
      render_inline(ButtonComponent.new) { "Click" }

      assert_selector "button[data-controller='better-ui--button']"
      assert_selector "button[data-action='click->better-ui--button#handleClick']"
    end

    # Additional HTML options tests
    test "passes through additional HTML options" do
      render_inline(ButtonComponent.new(id: "my-button", class: "extra-class")) { "Button" }

      assert_selector "button#my-button"
      assert_selector "button.extra-class"
    end

    test "applies focus ring classes" do
      render_inline(ButtonComponent.new(variant: :primary)) { "Focus" }

      assert_selector "button.focus\\:ring-primary-500"
      assert_selector "button.focus\\:ring-2"
    end

    # Combined variant and style tests
    test "renders danger outline button" do
      render_inline(ButtonComponent.new(variant: :danger, style: :outline)) { "Delete" }

      assert_selector "button.border-danger-600"
      assert_selector "button.text-danger-600"
      assert_selector "button.hover\\:bg-danger-50"
    end

    test "renders success ghost button" do
      render_inline(ButtonComponent.new(variant: :success, style: :ghost)) { "Save" }

      assert_selector "button.text-success-600"
      assert_selector "button.hover\\:bg-success-50"
    end

    # Comprehensive variant+style combination tests for 100% coverage
    test "renders secondary solid button" do
      render_inline(ButtonComponent.new(variant: :secondary, style: :solid)) { "Secondary" }
      assert_selector "button.bg-secondary-600"
      assert_selector "button.hover\\:bg-secondary-700"
    end

    test "renders secondary outline button" do
      render_inline(ButtonComponent.new(variant: :secondary, style: :outline)) { "Secondary" }
      assert_selector "button.border-secondary-600"
      assert_selector "button.text-secondary-600"
    end

    test "renders secondary ghost button" do
      render_inline(ButtonComponent.new(variant: :secondary, style: :ghost)) { "Secondary" }
      assert_selector "button.text-secondary-600"
      assert_selector "button.hover\\:bg-secondary-50"
    end

    test "renders secondary soft button" do
      render_inline(ButtonComponent.new(variant: :secondary, style: :soft)) { "Secondary" }
      assert_selector "button.bg-secondary-100"
      assert_selector "button.text-secondary-700"
    end

    test "renders info solid button" do
      render_inline(ButtonComponent.new(variant: :info, style: :solid)) { "Info" }
      assert_selector "button.bg-info-600"
      assert_selector "button.hover\\:bg-info-700"
    end

    test "renders info outline button" do
      render_inline(ButtonComponent.new(variant: :info, style: :outline)) { "Info" }
      assert_selector "button.border-info-600"
      assert_selector "button.text-info-600"
    end

    test "renders info ghost button" do
      render_inline(ButtonComponent.new(variant: :info, style: :ghost)) { "Info" }
      assert_selector "button.text-info-600"
      assert_selector "button.hover\\:bg-info-50"
    end

    test "renders info soft button" do
      render_inline(ButtonComponent.new(variant: :info, style: :soft)) { "Info" }
      assert_selector "button.bg-info-100"
      assert_selector "button.text-info-700"
    end

    test "renders warning outline button" do
      render_inline(ButtonComponent.new(variant: :warning, style: :outline)) { "Warning" }
      assert_selector "button.border-warning-600"
      assert_selector "button.text-warning-600"
    end

    test "renders warning ghost button" do
      render_inline(ButtonComponent.new(variant: :warning, style: :ghost)) { "Warning" }
      assert_selector "button.text-warning-600"
      assert_selector "button.hover\\:bg-warning-50"
    end

    test "renders warning soft button" do
      render_inline(ButtonComponent.new(variant: :warning, style: :soft)) { "Warning" }
      assert_selector "button.bg-warning-100"
      assert_selector "button.text-warning-700"
    end

    test "renders accent outline button" do
      render_inline(ButtonComponent.new(variant: :accent, style: :outline)) { "Accent" }
      assert_selector "button.border-accent-600"
      assert_selector "button.text-accent-600"
    end

    test "renders accent ghost button" do
      render_inline(ButtonComponent.new(variant: :accent, style: :ghost)) { "Accent" }
      assert_selector "button.text-accent-600"
      assert_selector "button.hover\\:bg-accent-50"
    end

    test "renders accent soft button" do
      render_inline(ButtonComponent.new(variant: :accent, style: :soft)) { "Accent" }
      assert_selector "button.bg-accent-100"
      assert_selector "button.text-accent-700"
    end

    test "renders light outline button" do
      render_inline(ButtonComponent.new(variant: :light, style: :outline)) { "Light" }
      assert_selector "button.border-grayscale-400"
      assert_selector "button.text-grayscale-400"
    end

    test "renders light ghost button" do
      render_inline(ButtonComponent.new(variant: :light, style: :ghost)) { "Light" }
      assert_selector "button.text-grayscale-700"
      assert_selector "button.hover\\:bg-grayscale-100"
    end

    test "renders light soft button" do
      render_inline(ButtonComponent.new(variant: :light, style: :soft)) { "Light" }
      assert_selector "button.bg-grayscale-100"
      assert_selector "button.text-grayscale-700"
    end

    test "renders dark outline button" do
      render_inline(ButtonComponent.new(variant: :dark, style: :outline)) { "Dark" }
      assert_selector "button.border-grayscale-700"
      assert_selector "button.text-grayscale-700"
    end

    test "renders dark ghost button" do
      render_inline(ButtonComponent.new(variant: :dark, style: :ghost)) { "Dark" }
      assert_selector "button.text-grayscale-700"
      assert_selector "button.hover\\:bg-grayscale-800"
    end

    test "renders dark soft button" do
      render_inline(ButtonComponent.new(variant: :dark, style: :soft)) { "Dark" }
      assert_selector "button.bg-grayscale-800"
      assert_selector "button.text-grayscale-100"
    end

    # Additional tests to reach 100% coverage
    test "renders success outline button" do
      render_inline(ButtonComponent.new(variant: :success, style: :outline)) { "Success" }
      assert_selector "button.border-success-600"
      assert_selector "button.hover\\:border-success-700"
    end

    test "renders danger ghost button additional" do
      render_inline(ButtonComponent.new(variant: :danger, style: :ghost)) { "Danger" }
      assert_selector "button.hover\\:bg-danger-50"
      assert_selector "button.active\\:bg-danger-100"
    end

    test "renders success soft button" do
      render_inline(ButtonComponent.new(variant: :success, style: :soft)) { "Success" }
      assert_selector "button.bg-success-100"
      assert_selector "button.hover\\:bg-success-200"
    end

    test "renders danger soft button" do
      render_inline(ButtonComponent.new(variant: :danger, style: :soft)) { "Danger" }
      assert_selector "button.bg-danger-100"
      assert_selector "button.hover\\:bg-danger-200"
    end

    # Link rendering tests
    test "renders as anchor tag when href is provided" do
      render_inline(ButtonComponent.new(href: "/users")) { "View Users" }

      assert_selector "a[href='/users']", text: "View Users"
      refute_selector "button"
    end

    test "renders as button when href is not provided" do
      render_inline(ButtonComponent.new) { "Click me" }

      assert_selector "button"
      refute_selector "a"
    end

    test "applies all styles to link" do
      render_inline(ButtonComponent.new(href: "/", variant: :success, style: :outline, size: :lg)) { "Link" }

      assert_selector "a.border-success-600"
      assert_selector "a.px-5"
    end

    test "renders link with target attribute" do
      render_inline(ButtonComponent.new(href: "https://example.com", target: "_blank")) { "External" }

      assert_selector "a[target='_blank']"
    end

    test "automatically adds rel noopener noreferrer for target blank" do
      render_inline(ButtonComponent.new(href: "https://example.com", target: "_blank")) { "External" }

      assert_selector "a[rel='noopener noreferrer']"
    end

    test "allows custom rel attribute" do
      render_inline(ButtonComponent.new(href: "/", target: "_blank", rel: "nofollow")) { "Link" }

      assert_selector "a[rel='nofollow']"
    end

    test "renders link with turbo method data attribute" do
      render_inline(ButtonComponent.new(href: "/users/1", method: :delete)) { "Delete" }

      assert_selector "a[data-turbo-method='delete']"
    end

    test "disabled link has aria-disabled and no href" do
      render_inline(ButtonComponent.new(href: "/", disabled: true)) { "Disabled Link" }

      assert_selector "a[aria-disabled='true']"
      refute_selector "a[href]"
      assert_selector "a.pointer-events-none"
      assert_selector "a.opacity-50"
    end

    test "disabled link has tabindex -1" do
      render_inline(ButtonComponent.new(href: "/", disabled: true)) { "Disabled Link" }

      assert_selector "a[tabindex='-1']"
    end

    test "link with show_loader shows spinner and is disabled" do
      render_inline(ButtonComponent.new(href: "/", show_loader: true)) { "Loading Link" }

      assert_selector "a.pointer-events-none"
      assert_selector "a[aria-disabled='true']"
      assert_selector "svg.animate-spin"
    end

    test "link with show_loader_on_click has data attribute" do
      render_inline(ButtonComponent.new(href: "/", show_loader_on_click: true)) { "Click Link" }

      assert_selector "a[data-better-ui--button-show-loader-on-click-value='true']"
    end

    test "link includes Stimulus controller data attributes" do
      render_inline(ButtonComponent.new(href: "/")) { "Link" }

      assert_selector "a[data-controller='better-ui--button']"
      assert_selector "a[data-action='click->better-ui--button#handleClick']"
    end

    test "link renders icon_before slot" do
      render_inline(ButtonComponent.new(href: "/")) do |component|
        component.with_icon_before { '<svg class="icon-before"></svg>'.html_safe }
        "Link"
      end

      assert_selector "a svg.icon-before"
    end

    test "link renders icon_after slot" do
      render_inline(ButtonComponent.new(href: "/")) do |component|
        component.with_icon_after { '<svg class="icon-after"></svg>'.html_safe }
        "Link"
      end

      assert_selector "a svg.icon-after"
    end

    test "type parameter is ignored when href is provided" do
      render_inline(ButtonComponent.new(href: "/", type: :submit)) { "Link" }

      assert_selector "a[href='/']"
      refute_selector "a[type]"
    end

    test "renders all variants as links" do
      BetterUi::ApplicationComponent::VARIANTS.keys.each do |variant|
        render_inline(ButtonComponent.new(href: "/", variant: variant)) { variant.to_s }
        assert_selector "a"
      end
    end

    test "passes through additional HTML options to links" do
      render_inline(ButtonComponent.new(href: "/", id: "my-link", class: "extra-class")) { "Link" }

      assert_selector "a#my-link"
      assert_selector "a.extra-class"
    end

    test "link applies focus ring classes" do
      render_inline(ButtonComponent.new(href: "/", variant: :primary)) { "Link" }

      assert_selector "a.focus\\:ring-primary-500"
      assert_selector "a.focus\\:ring-2"
    end

    test "link renders danger outline style" do
      render_inline(ButtonComponent.new(href: "/", variant: :danger, style: :outline)) { "Delete" }

      assert_selector "a.border-danger-600"
      assert_selector "a.text-danger-600"
    end
  end
end
