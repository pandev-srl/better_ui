# frozen_string_literal: true

require "test_helper"

module BetterUi
  module Tabs
    class PanelComponentTest < ActiveSupport::TestCase
      # Default rendering tests
      test "renders with required options" do
        render_inline(PanelComponent.new(id: "profile")) { "Profile content" }

        assert_selector "div.bui-tabs__panel"
        assert_text "Profile content"
      end

      test "renders with role tabpanel" do
        render_inline(PanelComponent.new(id: "profile")) { "Content" }

        assert_selector "div[role='tabpanel']"
      end

      test "renders with tabindex for keyboard navigation" do
        render_inline(PanelComponent.new(id: "profile")) { "Content" }

        assert_selector "div[tabindex='0']"
      end

      # ID generation tests
      test "generates panel element id with container id" do
        component = PanelComponent.new(id: "profile", container_id: "my-tabs")
        assert_equal "my-tabs-panel-profile", component.panel_element_id
      end

      test "generates tab element id with container id" do
        component = PanelComponent.new(id: "profile", container_id: "my-tabs")
        assert_equal "my-tabs-tab-profile", component.tab_element_id
      end

      # Active state tests
      test "renders hidden by default" do
        render_inline(PanelComponent.new(id: "profile")) { "Content" }

        assert_selector "div.bui-tabs__panel.hidden"
      end

      test "renders visible when active" do
        render_inline(PanelComponent.new(id: "profile", active: true)) { "Content" }

        refute_selector "div.hidden"
      end

      # ARIA attributes tests
      test "renders aria-labelledby attribute" do
        render_inline(PanelComponent.new(id: "profile", container_id: "my-tabs")) { "Content" }

        assert_selector "div[aria-labelledby='my-tabs-tab-profile']"
      end

      # Stimulus data attributes tests
      test "renders stimulus target attribute" do
        render_inline(PanelComponent.new(id: "profile")) { "Content" }

        assert_selector "div[data-better-ui--tabs--container-target='panel']"
      end

      test "renders panel id data attribute" do
        render_inline(PanelComponent.new(id: "profile")) { "Content" }

        assert_selector "div[data-panel-id='profile']"
      end

      # Content tests
      test "renders block content" do
        render_inline(PanelComponent.new(id: "profile")) do
          "<p>Complex content</p>".html_safe
        end

        assert_selector "div.bui-tabs__panel p"
        assert_text "Complex content"
      end

      # HTML attributes tests
      test "passes through additional class" do
        render_inline(PanelComponent.new(id: "profile", class: "custom-class")) { "Content" }

        assert_selector "div.bui-tabs__panel.custom-class"
      end

      test "merges data attributes" do
        render_inline(PanelComponent.new(id: "profile", data: { custom: "value" })) { "Content" }

        assert_selector "div[data-custom='value']"
        assert_selector "div[data-better-ui--tabs--container-target='panel']"
      end

      test "passes through id attribute from options" do
        # When container_id is set, it generates the id
        render_inline(PanelComponent.new(id: "profile", container_id: "tabs")) { "Content" }

        assert_selector "div#tabs-panel-profile"
      end

      # Attribute readers tests
      test "exposes id attribute" do
        component = PanelComponent.new(id: "profile")
        assert_equal "profile", component.id
      end

      test "exposes active attribute" do
        component = PanelComponent.new(id: "profile", active: true)
        assert_equal true, component.active
      end

      test "active is false by default" do
        component = PanelComponent.new(id: "profile")
        assert_equal false, component.active
      end
    end
  end
end
