# frozen_string_literal: true

require "test_helper"

module BetterUi
  module Tabs
    class ContainerComponentTest < ActiveSupport::TestCase
      # Default rendering tests
      test "renders with default options" do
        render_inline(ContainerComponent.new) do |tabs|
          tabs.with_tab(id: "tab1", label: "Tab 1", active: true)
          tabs.with_panel(id: "tab1", active: true) { "Content 1" }
        end

        assert_selector "div.bui-tabs"
        assert_selector "div[role='tablist']"
        assert_selector "button[role='tab']"
        assert_text "Tab 1"
        assert_text "Content 1"
      end

      test "renders with Stimulus controller" do
        render_inline(ContainerComponent.new) do |tabs|
          tabs.with_tab(id: "tab1", label: "Tab 1")
        end

        assert_selector "div[data-controller='better-ui--tabs--container']"
      end

      test "generates unique container id" do
        component = ContainerComponent.new
        assert_match(/^tabs-[a-f0-9]{8}$/, component.container_id)
      end

      test "uses explicit id when provided" do
        component = ContainerComponent.new(id: "my-tabs")
        assert_equal "my-tabs", component.container_id
      end

      # Mode tests
      test "renders in JS mode by default" do
        render_inline(ContainerComponent.new) do |tabs|
          tabs.with_tab(id: "tab1", label: "Tab 1")
        end

        assert_selector "div[data-better-ui--tabs--container-mode-value='js']"
      end

      test "renders in Turbo mode" do
        render_inline(ContainerComponent.new(mode: :turbo, frame_id: "content")) do |tabs|
          tabs.with_tab(id: "tab1", label: "Tab 1", href: "/profile")
        end

        assert_selector "div[data-better-ui--tabs--container-mode-value='turbo']"
        assert_selector "div[data-better-ui--tabs--container-frame-id-value='content']"
      end

      test "raises error for invalid mode" do
        error = assert_raises(ArgumentError) do
          ContainerComponent.new(mode: :invalid)
        end

        assert_match(/Invalid mode/, error.message)
        assert_match(/js, turbo/, error.message)
      end

      test "raises error when turbo mode without frame_id" do
        error = assert_raises(ArgumentError) do
          ContainerComponent.new(mode: :turbo)
        end

        assert_match(/frame_id is required/, error.message)
      end

      # Style tests
      test "renders underline style by default" do
        render_inline(ContainerComponent.new) do |tabs|
          tabs.with_tab(id: "tab1", label: "Tab 1")
        end

        assert_selector "div[role='tablist'].border-b"
      end

      test "renders pills style" do
        render_inline(ContainerComponent.new(style: :pills)) do |tabs|
          tabs.with_tab(id: "tab1", label: "Tab 1")
        end

        assert_selector "div[role='tablist'].gap-1"
      end

      test "renders bordered style" do
        render_inline(ContainerComponent.new(style: :bordered)) do |tabs|
          tabs.with_tab(id: "tab1", label: "Tab 1")
        end

        assert_selector "div[role='tablist'].gap-0"
      end

      test "raises error for invalid style" do
        error = assert_raises(ArgumentError) do
          ContainerComponent.new(style: :invalid)
        end

        assert_match(/Invalid style/, error.message)
        assert_match(/underline, pills, bordered/, error.message)
      end

      # Variant tests
      test "accepts valid variants" do
        BetterUi::ApplicationComponent::VARIANTS.keys.each do |variant|
          component = ContainerComponent.new(variant: variant)
          assert_equal variant, component.variant
        end
      end

      test "raises error for invalid variant" do
        error = assert_raises(ArgumentError) do
          ContainerComponent.new(variant: :invalid)
        end

        assert_match(/Invalid variant/, error.message)
      end

      # Size tests
      test "accepts valid sizes" do
        %i[xs sm md lg xl].each do |size|
          component = ContainerComponent.new(size: size)
          assert_equal size, component.size
        end
      end

      test "raises error for invalid size" do
        error = assert_raises(ArgumentError) do
          ContainerComponent.new(size: :invalid)
        end

        assert_match(/Invalid size/, error.message)
      end

      # Alignment tests
      test "renders with start alignment by default" do
        render_inline(ContainerComponent.new) do |tabs|
          tabs.with_tab(id: "tab1", label: "Tab 1")
        end

        assert_selector "div[role='tablist'].justify-start"
      end

      test "renders with center alignment" do
        render_inline(ContainerComponent.new(alignment: :center)) do |tabs|
          tabs.with_tab(id: "tab1", label: "Tab 1")
        end

        assert_selector "div[role='tablist'].justify-center"
      end

      test "renders with end alignment" do
        render_inline(ContainerComponent.new(alignment: :end)) do |tabs|
          tabs.with_tab(id: "tab1", label: "Tab 1")
        end

        assert_selector "div[role='tablist'].justify-end"
      end

      test "raises error for invalid alignment" do
        error = assert_raises(ArgumentError) do
          ContainerComponent.new(alignment: :invalid)
        end

        assert_match(/Invalid alignment/, error.message)
      end

      # Position tests
      test "renders with top position by default" do
        render_inline(ContainerComponent.new) do |tabs|
          tabs.with_tab(id: "tab1", label: "Tab 1")
        end

        assert_selector "div[role='tablist'].flex-row"
      end

      test "renders with left position" do
        render_inline(ContainerComponent.new(position: :left)) do |tabs|
          tabs.with_tab(id: "tab1", label: "Tab 1")
        end

        assert_selector "div.bui-tabs.flex"
        assert_selector "div[role='tablist'].flex-col"
      end

      test "renders with right position" do
        render_inline(ContainerComponent.new(position: :right)) do |tabs|
          tabs.with_tab(id: "tab1", label: "Tab 1")
        end

        assert_selector "div.bui-tabs.flex"
        assert_selector "div[role='tablist'].flex-col"
      end

      test "raises error for invalid position" do
        error = assert_raises(ArgumentError) do
          ContainerComponent.new(position: :invalid)
        end

        assert_match(/Invalid position/, error.message)
      end

      # Persistence tests
      test "renders with persist data attribute" do
        render_inline(ContainerComponent.new(persist: true)) do |tabs|
          tabs.with_tab(id: "tab1", label: "Tab 1")
        end

        assert_selector "div[data-better-ui--tabs--container-persist-value='true']"
      end

      test "renders with persist key data attribute" do
        render_inline(ContainerComponent.new(persist: true, persist_key: "my-tabs")) do |tabs|
          tabs.with_tab(id: "tab1", label: "Tab 1")
        end

        assert_selector "div[data-better-ui--tabs--container-persist-key-value='my-tabs']"
      end

      # Default tab tests
      test "renders with default tab data attribute" do
        render_inline(ContainerComponent.new(default_tab: "tab2")) do |tabs|
          tabs.with_tab(id: "tab1", label: "Tab 1")
          tabs.with_tab(id: "tab2", label: "Tab 2")
        end

        assert_selector "div[data-better-ui--tabs--container-default-tab-value='tab2']"
      end

      # Tab slot tests
      test "renders multiple tabs" do
        render_inline(ContainerComponent.new) do |tabs|
          tabs.with_tab(id: "tab1", label: "Tab 1")
          tabs.with_tab(id: "tab2", label: "Tab 2")
          tabs.with_tab(id: "tab3", label: "Tab 3")
        end

        assert_selector "button[role='tab']", count: 3
        assert_text "Tab 1"
        assert_text "Tab 2"
        assert_text "Tab 3"
      end

      # Panel slot tests
      test "renders panels in JS mode" do
        render_inline(ContainerComponent.new(mode: :js)) do |tabs|
          tabs.with_tab(id: "tab1", label: "Tab 1", active: true)
          tabs.with_tab(id: "tab2", label: "Tab 2")
          tabs.with_panel(id: "tab1", active: true) { "Content 1" }
          tabs.with_panel(id: "tab2") { "Content 2" }
        end

        assert_selector "div[role='tabpanel']", count: 2
        assert_text "Content 1"
        assert_text "Content 2"
      end

      test "does not render panels container when no panels" do
        render_inline(ContainerComponent.new(mode: :js)) do |tabs|
          tabs.with_tab(id: "tab1", label: "Tab 1")
        end

        refute_selector "div.bui-tabs__panels"
      end

      # HTML attributes tests
      test "passes through additional HTML options" do
        render_inline(ContainerComponent.new(class: "custom-class")) do |tabs|
          tabs.with_tab(id: "tab1", label: "Tab 1")
        end

        assert_selector "div.bui-tabs.custom-class"
      end

      test "merges data attributes" do
        render_inline(ContainerComponent.new(data: { custom: "value" })) do |tabs|
          tabs.with_tab(id: "tab1", label: "Tab 1")
        end

        assert_selector "div[data-custom='value']"
        assert_selector "div[data-controller='better-ui--tabs--container']"
      end

      # ARIA tests
      test "renders tablist role" do
        render_inline(ContainerComponent.new) do |tabs|
          tabs.with_tab(id: "tab1", label: "Tab 1")
        end

        assert_selector "div[role='tablist']"
        assert_selector "div[aria-label='Tabs']"
      end

      # Attribute readers tests
      test "exposes mode attribute" do
        component = ContainerComponent.new(mode: :turbo, frame_id: "content")
        assert_equal :turbo, component.mode
      end

      test "exposes style attribute" do
        component = ContainerComponent.new(style: :pills)
        assert_equal :pills, component.style
      end

      test "exposes variant attribute" do
        component = ContainerComponent.new(variant: :success)
        assert_equal :success, component.variant
      end

      test "exposes size attribute" do
        component = ContainerComponent.new(size: :lg)
        assert_equal :lg, component.size
      end

      test "exposes alignment attribute" do
        component = ContainerComponent.new(alignment: :center)
        assert_equal :center, component.alignment
      end

      test "exposes position attribute" do
        component = ContainerComponent.new(position: :left)
        assert_equal :left, component.position
      end

      test "exposes frame_id attribute" do
        component = ContainerComponent.new(mode: :turbo, frame_id: "my-frame")
        assert_equal "my-frame", component.frame_id
      end

      test "exposes default_tab attribute" do
        component = ContainerComponent.new(default_tab: "tab2")
        assert_equal "tab2", component.default_tab
      end

      test "exposes persist attribute" do
        component = ContainerComponent.new(persist: true)
        assert_equal true, component.persist
      end

      test "exposes persist_key attribute" do
        component = ContainerComponent.new(persist_key: "my-key")
        assert_equal "my-key", component.persist_key
      end
    end
  end
end
