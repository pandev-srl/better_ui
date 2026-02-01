# frozen_string_literal: true

require "test_helper"

module BetterUi
  module Dropdown
    class DropdownComponentTest < ActiveSupport::TestCase
      # Default rendering
      test "renders with default options" do
        render_inline(DropdownComponent.new) do |d|
          d.with_trigger { "<button>Open</button>".html_safe }
          d.with_item { "Item 1" }
        end

        assert_selector "div[data-controller='better-ui--dropdown--dropdown']"
      end

      test "renders trigger slot" do
        render_inline(DropdownComponent.new) do |d|
          d.with_trigger { "<button>Toggle</button>".html_safe }
          d.with_item { "Item" }
        end

        assert_selector "button", text: "Toggle"
      end

      test "trigger has aria-haspopup" do
        render_inline(DropdownComponent.new) do |d|
          d.with_trigger { "<button>Open</button>".html_safe }
          d.with_item { "Item" }
        end

        assert_selector "[aria-haspopup='true']"
      end

      test "trigger has aria-expanded false by default" do
        render_inline(DropdownComponent.new) do |d|
          d.with_trigger { "<button>Open</button>".html_safe }
          d.with_item { "Item" }
        end

        assert_selector "[aria-expanded='false']"
      end

      test "trigger has toggle action" do
        render_inline(DropdownComponent.new) do |d|
          d.with_trigger { "<button>Open</button>".html_safe }
          d.with_item { "Item" }
        end

        assert_selector "[data-action='click->better-ui--dropdown--dropdown#toggle']"
      end

      # Menu panel
      test "renders menu with role menu" do
        render_inline(DropdownComponent.new) do |d|
          d.with_trigger { "Trigger" }
          d.with_item { "Item" }
        end

        assert_selector "[role='menu']"
      end

      test "menu is hidden by default" do
        render_inline(DropdownComponent.new) do |d|
          d.with_trigger { "Trigger" }
          d.with_item { "Item" }
        end

        assert_selector "[role='menu'][hidden]"
      end

      test "menu has target attribute" do
        render_inline(DropdownComponent.new) do |d|
          d.with_trigger { "Trigger" }
          d.with_item { "Item" }
        end

        assert_selector "[data-better-ui--dropdown--dropdown-target='menu']"
      end

      # Items rendering
      test "renders items" do
        render_inline(DropdownComponent.new) do |d|
          d.with_trigger { "Trigger" }
          d.with_item { "Edit" }
          d.with_item { "Delete" }
        end

        assert_selector "[role='menuitem']", count: 2
        assert_text "Edit"
        assert_text "Delete"
      end

      # Polymorphic items
      test "renders divider items" do
        render_inline(DropdownComponent.new) do |d|
          d.with_trigger { "Trigger" }
          d.with_item { "Item 1" }
          d.with_divider
          d.with_item { "Item 2" }
        end

        assert_selector "[role='menuitem']", count: 2
        assert_selector "[role='separator']", count: 1
      end

      test "renders header items" do
        render_inline(DropdownComponent.new) do |d|
          d.with_trigger { "Trigger" }
          d.with_header(text: "Section")
          d.with_item { "Item" }
        end

        assert_selector "[role='presentation']", text: "Section"
        assert_selector "[role='menuitem']", count: 1
      end

      test "renders mixed polymorphic items in order" do
        render_inline(DropdownComponent.new) do |d|
          d.with_trigger { "Trigger" }
          d.with_header(text: "Actions")
          d.with_item { "Edit" }
          d.with_item { "Duplicate" }
          d.with_divider
          d.with_item(variant: :danger) { "Delete" }
        end

        assert_selector "[role='presentation']", count: 1
        assert_selector "[role='menuitem']", count: 3
        assert_selector "[role='separator']", count: 1
      end

      # Placement
      test "renders with bottom_start placement by default" do
        render_inline(DropdownComponent.new) do |d|
          d.with_trigger { "Trigger" }
          d.with_item { "Item" }
        end

        assert_selector ".top-full"
        assert_selector ".left-0"
      end

      test "renders with bottom_end placement" do
        render_inline(DropdownComponent.new(placement: :bottom_end)) do |d|
          d.with_trigger { "Trigger" }
          d.with_item { "Item" }
        end

        assert_selector ".top-full"
        assert_selector ".right-0"
      end

      test "renders with top_start placement" do
        render_inline(DropdownComponent.new(placement: :top_start)) do |d|
          d.with_trigger { "Trigger" }
          d.with_item { "Item" }
        end

        assert_selector ".bottom-full"
        assert_selector ".left-0"
      end

      test "renders with top_end placement" do
        render_inline(DropdownComponent.new(placement: :top_end)) do |d|
          d.with_trigger { "Trigger" }
          d.with_item { "Item" }
        end

        assert_selector ".bottom-full"
        assert_selector ".right-0"
      end

      test "raises error for invalid placement" do
        error = assert_raises(ArgumentError) do
          DropdownComponent.new(placement: :invalid)
        end

        assert_match(/Invalid placement/, error.message)
      end

      # Size variants
      test "renders sm size" do
        render_inline(DropdownComponent.new(size: :sm)) do |d|
          d.with_trigger { "Trigger" }
          d.with_item { "Item" }
        end

        assert_selector ".w-40"
      end

      test "renders md size (default)" do
        render_inline(DropdownComponent.new(size: :md)) do |d|
          d.with_trigger { "Trigger" }
          d.with_item { "Item" }
        end

        assert_selector ".w-56"
      end

      test "renders lg size" do
        render_inline(DropdownComponent.new(size: :lg)) do |d|
          d.with_trigger { "Trigger" }
          d.with_item { "Item" }
        end

        assert_selector ".w-72"
      end

      test "raises error for invalid size" do
        error = assert_raises(ArgumentError) do
          DropdownComponent.new(size: :invalid)
        end

        assert_match(/Invalid size/, error.message)
      end

      # Shadow
      test "renders with shadow by default" do
        render_inline(DropdownComponent.new) do |d|
          d.with_trigger { "Trigger" }
          d.with_item { "Item" }
        end

        assert_selector ".shadow-lg"
      end

      test "renders without shadow when disabled" do
        render_inline(DropdownComponent.new(shadow: false)) do |d|
          d.with_trigger { "Trigger" }
          d.with_item { "Item" }
        end

        refute_selector ".shadow-lg"
        refute_selector ".shadow-md"
        refute_selector ".shadow-sm"
      end

      test "renders with specific shadow size" do
        render_inline(DropdownComponent.new(shadow: :xl)) do |d|
          d.with_trigger { "Trigger" }
          d.with_item { "Item" }
        end

        assert_selector ".shadow-xl"
      end

      # Stimulus data attributes
      test "passes auto_close value to stimulus" do
        render_inline(DropdownComponent.new(auto_close: false)) do |d|
          d.with_trigger { "Trigger" }
          d.with_item { "Item" }
        end

        assert_selector "[data-better-ui--dropdown--dropdown-auto-close-value='false']"
      end

      test "passes close_on_item_click value to stimulus" do
        render_inline(DropdownComponent.new(close_on_item_click: false)) do |d|
          d.with_trigger { "Trigger" }
          d.with_item { "Item" }
        end

        assert_selector "[data-better-ui--dropdown--dropdown-close-on-item-click-value='false']"
      end

      # Custom classes
      test "applies custom container_classes to root" do
        render_inline(DropdownComponent.new(container_classes: "my-dropdown")) do |d|
          d.with_trigger { "Trigger" }
          d.with_item { "Item" }
        end

        assert_selector "div.my-dropdown"
      end

      test "applies custom menu_classes to menu panel" do
        render_inline(DropdownComponent.new(menu_classes: "custom-menu")) do |d|
          d.with_trigger { "Trigger" }
          d.with_item { "Item" }
        end

        assert_selector "[role='menu'].custom-menu"
      end

      # Menu styling
      test "menu has white background and rounded corners" do
        render_inline(DropdownComponent.new) do |d|
          d.with_trigger { "Trigger" }
          d.with_item { "Item" }
        end

        assert_selector "[role='menu'].bg-white"
        assert_selector "[role='menu'].rounded-md"
      end

      test "menu has ring border" do
        render_inline(DropdownComponent.new) do |d|
          d.with_trigger { "Trigger" }
          d.with_item { "Item" }
        end

        assert_selector "[role='menu'].ring-1"
      end

      # Relative container
      test "root element has relative positioning" do
        render_inline(DropdownComponent.new) do |d|
          d.with_trigger { "Trigger" }
          d.with_item { "Item" }
        end

        assert_selector "div.relative.inline-block"
      end
    end
  end
end
