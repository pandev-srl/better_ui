# frozen_string_literal: true

require "test_helper"

module BetterUi
  module Dropdown
    class ItemComponentTest < ActiveSupport::TestCase
      # Default rendering (button)
      test "renders as button when no href" do
        render_inline(ItemComponent.new) { "Edit" }

        assert_selector "button[role='menuitem']", text: "Edit"
      end

      test "renders with tabindex -1" do
        render_inline(ItemComponent.new) { "Edit" }

        assert_selector "[tabindex='-1']"
      end

      test "renders with type button" do
        render_inline(ItemComponent.new) { "Edit" }

        assert_selector "button[type='button']"
      end

      # Link rendering
      test "renders as link when href provided" do
        render_inline(ItemComponent.new(href: "/edit")) { "Edit" }

        assert_selector "a[role='menuitem'][href='/edit']", text: "Edit"
      end

      test "renders link without type attribute" do
        render_inline(ItemComponent.new(href: "/edit")) { "Edit" }

        refute_selector "a[type]"
      end

      # Disabled state
      test "renders disabled button" do
        render_inline(ItemComponent.new(disabled: true)) { "Disabled" }

        assert_selector "button[disabled]"
        assert_selector "button[aria-disabled='true']"
      end

      test "renders disabled link" do
        render_inline(ItemComponent.new(href: "/edit", disabled: true)) { "Disabled" }

        assert_selector "a[aria-disabled='true']"
      end

      test "disabled item has opacity styling" do
        render_inline(ItemComponent.new(disabled: true)) { "Disabled" }

        assert_selector ".opacity-50"
        assert_selector ".cursor-not-allowed"
      end

      # Active state
      test "renders active item with background" do
        render_inline(ItemComponent.new(active: true)) { "Active" }

        assert_selector ".bg-grayscale-100"
      end

      # Variant: default
      test "renders default variant with standard text color" do
        render_inline(ItemComponent.new) { "Item" }

        assert_selector ".text-grayscale-700"
      end

      # Variant: danger
      test "renders danger variant with red text" do
        render_inline(ItemComponent.new(variant: :danger)) { "Delete" }

        assert_selector ".text-danger-600"
      end

      # Icon slot
      test "renders with icon slot" do
        render_inline(ItemComponent.new) do |item|
          item.with_icon { "<svg class='icon'></svg>".html_safe }
          "Edit"
        end

        assert_selector ".icon"
        assert_text "Edit"
      end

      # Turbo method
      test "renders link with turbo method" do
        render_inline(ItemComponent.new(href: "/destroy", method: :delete)) { "Delete" }

        assert_selector "a[data-turbo-method='delete']"
      end

      # Custom classes
      test "applies custom container_classes" do
        render_inline(ItemComponent.new(container_classes: "custom-item")) { "Item" }

        assert_selector ".custom-item"
      end

      # Stimulus target
      test "renders with item target data attribute" do
        render_inline(ItemComponent.new) { "Item" }

        assert_selector "[data-better-ui--dropdown--dropdown-target='item']"
      end

      # Base styling
      test "renders with flex layout and padding" do
        render_inline(ItemComponent.new) { "Item" }

        assert_selector ".flex"
        assert_selector ".items-center"
        assert_selector ".w-full"
        assert_selector ".text-left"
      end

      # Variant validation
      test "raises error for invalid variant" do
        error = assert_raises(ArgumentError) do
          ItemComponent.new(variant: :invalid)
        end

        assert_match(/Invalid variant/, error.message)
      end
    end
  end
end
