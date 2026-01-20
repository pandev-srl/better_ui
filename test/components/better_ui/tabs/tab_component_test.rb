# frozen_string_literal: true

require "test_helper"

module BetterUi
  module Tabs
    class TabComponentTest < ActiveSupport::TestCase
      # Default rendering tests
      test "renders with required options" do
        render_inline(TabComponent.new(id: "profile", label: "Profile"))

        assert_selector "button.bui-tabs__tab"
        assert_text "Profile"
      end

      test "renders with role tab" do
        render_inline(TabComponent.new(id: "profile", label: "Profile"))

        assert_selector "button[role='tab']"
      end

      test "renders as button in JS mode" do
        render_inline(TabComponent.new(id: "profile", label: "Profile", mode: :js))

        assert_selector "button[type='button']"
      end

      test "renders as anchor in Turbo mode" do
        render_inline(TabComponent.new(id: "profile", label: "Profile", mode: :turbo, href: "/profile"))

        assert_selector "a[href='/profile']"
      end

      # ID generation tests
      test "generates tab element id with container id" do
        component = TabComponent.new(id: "profile", label: "Profile", container_id: "my-tabs")
        assert_equal "my-tabs-tab-profile", component.tab_element_id
      end

      test "generates panel id with container id" do
        component = TabComponent.new(id: "profile", label: "Profile", container_id: "my-tabs")
        assert_equal "my-tabs-panel-profile", component.panel_id
      end

      # Active state tests
      test "renders inactive tab by default" do
        render_inline(TabComponent.new(id: "profile", label: "Profile", container_id: "tabs"))

        assert_selector "button[aria-selected='false']"
        assert_selector "button[tabindex='-1']"
      end

      test "renders active tab" do
        render_inline(TabComponent.new(id: "profile", label: "Profile", active: true, container_id: "tabs"))

        assert_selector "button[aria-selected='true']"
        assert_selector "button[tabindex='0']"
      end

      # Disabled state tests
      test "renders disabled tab in JS mode" do
        render_inline(TabComponent.new(id: "profile", label: "Profile", disabled: true, mode: :js))

        assert_selector "button[disabled]"
        assert_selector "button[aria-disabled='true']"
        assert_selector "button.opacity-50"
        assert_selector "button.cursor-not-allowed"
      end

      test "renders disabled tab in Turbo mode" do
        render_inline(TabComponent.new(id: "profile", label: "Profile", disabled: true, mode: :turbo, href: "/profile"))

        assert_selector "a[aria-disabled='true']"
        refute_selector "a[disabled]"
      end

      # ARIA attributes tests
      test "renders aria-controls attribute" do
        render_inline(TabComponent.new(id: "profile", label: "Profile", container_id: "my-tabs"))

        assert_selector "button[aria-controls='my-tabs-panel-profile']"
      end

      # Stimulus data attributes tests
      test "renders stimulus target attribute" do
        render_inline(TabComponent.new(id: "profile", label: "Profile"))

        assert_selector "button[data-better-ui--tabs--container-target='tab']"
      end

      test "renders tab id data attribute" do
        render_inline(TabComponent.new(id: "profile", label: "Profile"))

        assert_selector "button[data-tab-id='profile']"
      end

      test "renders action data attributes" do
        render_inline(TabComponent.new(id: "profile", label: "Profile"))

        assert_selector "button[data-action*='click->better-ui--tabs--container#selectTab']"
        assert_selector "button[data-action*='keydown->better-ui--tabs--container#handleKeydown']"
      end

      # Turbo frame tests
      test "renders turbo-frame data attribute in turbo mode" do
        render_inline(TabComponent.new(
          id: "profile",
          label: "Profile",
          mode: :turbo,
          href: "/profile",
          frame_id: "content"
        ))

        assert_selector "a[data-turbo-frame='content']"
      end

      # Size tests
      test "renders xs size" do
        render_inline(TabComponent.new(id: "profile", label: "Profile", size: :xs))

        assert_selector "button.px-2.py-1.text-xs"
      end

      test "renders sm size" do
        render_inline(TabComponent.new(id: "profile", label: "Profile", size: :sm))

        assert_selector "button.px-3.text-sm"
      end

      test "renders md size" do
        render_inline(TabComponent.new(id: "profile", label: "Profile", size: :md))

        assert_selector "button.px-4.py-2.text-sm"
      end

      test "renders lg size" do
        render_inline(TabComponent.new(id: "profile", label: "Profile", size: :lg))

        assert_selector "button.px-5.text-base"
      end

      test "renders xl size" do
        render_inline(TabComponent.new(id: "profile", label: "Profile", size: :xl))

        assert_selector "button.px-6.py-3.text-lg"
      end

      # Style tests - underline
      test "renders underline style inactive" do
        render_inline(TabComponent.new(id: "profile", label: "Profile", style: :underline, active: false))

        assert_selector "button.border-b-2.border-transparent"
      end

      test "renders underline style active with primary variant" do
        render_inline(TabComponent.new(id: "profile", label: "Profile", style: :underline, active: true, variant: :primary))

        assert_selector "button.border-b-2.border-primary-600.text-primary-600"
      end

      test "renders underline style active with success variant" do
        render_inline(TabComponent.new(id: "profile", label: "Profile", style: :underline, active: true, variant: :success))

        assert_selector "button.border-success-600.text-success-600"
      end

      # Style tests - pills
      test "renders pills style inactive" do
        render_inline(TabComponent.new(id: "profile", label: "Profile", style: :pills, active: false))

        assert_selector "button.rounded-lg"
      end

      test "renders pills style active with primary variant" do
        render_inline(TabComponent.new(id: "profile", label: "Profile", style: :pills, active: true, variant: :primary))

        assert_selector "button.rounded-lg.bg-primary-600.text-white"
      end

      test "renders pills style active with danger variant" do
        render_inline(TabComponent.new(id: "profile", label: "Profile", style: :pills, active: true, variant: :danger))

        assert_selector "button.bg-danger-600.text-white"
      end

      # Style tests - bordered
      test "renders bordered style inactive" do
        render_inline(TabComponent.new(id: "profile", label: "Profile", style: :bordered, active: false))

        assert_selector "button.border.border-transparent.rounded-t-lg"
      end

      test "renders bordered style active" do
        render_inline(TabComponent.new(id: "profile", label: "Profile", style: :bordered, active: true, variant: :primary))

        assert_selector "button.border.rounded-t-lg.bg-white.text-primary-600"
      end

      # Icon slot tests
      test "renders icon slot" do
        render_inline(TabComponent.new(id: "profile", label: "Profile")) do |tab|
          tab.with_icon { "<svg></svg>".html_safe }
        end

        assert_selector "span.bui-tabs__tab-icon svg"
      end

      test "does not render icon container when no icon" do
        render_inline(TabComponent.new(id: "profile", label: "Profile"))

        refute_selector "span.bui-tabs__tab-icon"
      end

      # Badge slot tests
      test "renders badge slot" do
        render_inline(TabComponent.new(id: "messages", label: "Messages")) do |tab|
          tab.with_badge { "5" }
        end

        assert_selector "span.bui-tabs__tab-badge"
        assert_text "5"
      end

      test "does not render badge container when no badge" do
        render_inline(TabComponent.new(id: "profile", label: "Profile"))

        refute_selector "span.bui-tabs__tab-badge"
      end

      # Label rendering tests
      test "renders label in span" do
        render_inline(TabComponent.new(id: "profile", label: "Profile"))

        assert_selector "span.bui-tabs__tab-label", text: "Profile"
      end

      # HTML attributes tests
      test "passes through additional class" do
        render_inline(TabComponent.new(id: "profile", label: "Profile", class: "custom-class"))

        assert_selector "button.bui-tabs__tab.custom-class"
      end

      test "merges data attributes" do
        render_inline(TabComponent.new(id: "profile", label: "Profile", data: { custom: "value" }))

        assert_selector "button[data-custom='value']"
        assert_selector "button[data-better-ui--tabs--container-target='tab']"
      end

      # All variants tests
      test "renders all variants for underline style" do
        BetterUi::ApplicationComponent::VARIANTS.keys.each do |variant|
          render_inline(TabComponent.new(
            id: "profile",
            label: "Profile",
            style: :underline,
            active: true,
            variant: variant
          ))

          assert_selector "button.border-b-2"
        end
      end

      test "renders all variants for pills style" do
        BetterUi::ApplicationComponent::VARIANTS.keys.each do |variant|
          render_inline(TabComponent.new(
            id: "profile",
            label: "Profile",
            style: :pills,
            active: true,
            variant: variant
          ))

          assert_selector "button.rounded-lg"
        end
      end

      # Attribute readers tests
      test "exposes id attribute" do
        component = TabComponent.new(id: "profile", label: "Profile")
        assert_equal "profile", component.id
      end

      test "exposes label attribute" do
        component = TabComponent.new(id: "profile", label: "Profile")
        assert_equal "Profile", component.label
      end

      test "exposes active attribute" do
        component = TabComponent.new(id: "profile", label: "Profile", active: true)
        assert_equal true, component.active
      end

      test "exposes disabled attribute" do
        component = TabComponent.new(id: "profile", label: "Profile", disabled: true)
        assert_equal true, component.disabled
      end

      # Data attributes for class toggling tests
      test "renders data-active-classes for underline style" do
        render_inline(TabComponent.new(id: "profile", label: "Profile", style: :underline, variant: :primary))

        assert_selector "button[data-active-classes*='border-primary-600']"
        assert_selector "button[data-active-classes*='text-primary-600']"
      end

      test "renders data-inactive-classes for underline style" do
        render_inline(TabComponent.new(id: "profile", label: "Profile", style: :underline))

        assert_selector "button[data-inactive-classes*='border-transparent']"
        assert_selector "button[data-inactive-classes*='text-grayscale-600']"
      end

      test "renders data-active-classes for pills style" do
        render_inline(TabComponent.new(id: "profile", label: "Profile", style: :pills, variant: :success))

        assert_selector "button[data-active-classes*='bg-success-600']"
        assert_selector "button[data-active-classes*='text-white']"
      end

      test "renders data-inactive-classes for pills style" do
        render_inline(TabComponent.new(id: "profile", label: "Profile", style: :pills))

        assert_selector "button[data-inactive-classes*='rounded-lg']"
        assert_selector "button[data-inactive-classes*='text-grayscale-600']"
      end
    end
  end
end
