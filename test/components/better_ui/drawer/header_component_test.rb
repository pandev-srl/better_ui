# frozen_string_literal: true

require "test_helper"

module BetterUi
  module Drawer
    class HeaderComponentTest < ActiveSupport::TestCase
      # Default rendering tests
      test "renders with default options" do
        render_inline(HeaderComponent.new) do |header|
          header.with_logo { "Logo" }
        end

        assert_selector "header.w-full"
        assert_selector "header.h-16" # default height (md)
        assert_selector "header.bg-white" # default variant (light)
        assert_selector "header.sticky.top-0" # default sticky
        assert_text "Logo"
      end

      test "renders as header element" do
        render_inline(HeaderComponent.new) do |header|
          header.with_logo { "Logo" }
        end

        assert_selector "header"
      end

      # Logo slot tests
      test "renders with logo slot" do
        render_inline(HeaderComponent.new) do |header|
          header.with_logo { "Brand Logo" }
        end

        assert_text "Brand Logo"
        assert_selector "header div.flex.items-center.shrink-0"
      end

      test "renders without logo" do
        render_inline(HeaderComponent.new) do |header|
          header.with_actions { "Actions" }
        end

        assert_text "Actions"
      end

      # Navigation slot tests
      test "renders with navigation slot" do
        render_inline(HeaderComponent.new) do |header|
          header.with_logo { "Logo" }
          header.with_navigation { "Navigation links" }
        end

        assert_text "Navigation links"
        assert_selector "div.hidden.lg\\:flex" # hidden on mobile
      end

      test "renders navigation centered" do
        render_inline(HeaderComponent.new) do |header|
          header.with_navigation { "Nav" }
        end

        assert_selector "div.justify-center"
      end

      # Actions slot tests
      test "renders with actions slot" do
        render_inline(HeaderComponent.new) do |header|
          header.with_actions { "User Menu" }
        end

        assert_text "User Menu"
        assert_selector "div.flex.items-center.gap-2"
      end

      # Mobile menu button slot tests
      test "renders with mobile menu button slot" do
        render_inline(HeaderComponent.new) do |header|
          header.with_mobile_menu_button { "☰" }
          header.with_logo { "Logo" }
        end

        assert_text "☰"
        assert_selector "div.lg\\:hidden" # only visible on mobile
      end

      test "mobile menu button appears before logo" do
        render_inline(HeaderComponent.new) do |header|
          header.with_mobile_menu_button { "Menu" }
          header.with_logo { "Logo" }
        end

        # Both should be present
        assert_text "Menu"
        assert_text "Logo"
      end

      # All slots together test
      test "renders with all slots" do
        render_inline(HeaderComponent.new) do |header|
          header.with_logo { "Logo" }
          header.with_navigation { "Navigation" }
          header.with_actions { "Actions" }
          header.with_mobile_menu_button { "Menu" }
        end

        assert_text "Logo"
        assert_text "Navigation"
        assert_text "Actions"
        assert_text "Menu"
      end

      # Variant tests
      test "renders light variant" do
        render_inline(HeaderComponent.new(variant: :light)) do |header|
          header.with_logo { "Logo" }
        end

        assert_selector "header.bg-white"
        assert_selector "header.border-b.border-grayscale-200"
        assert_selector "header.text-grayscale-900"
      end

      test "renders dark variant" do
        render_inline(HeaderComponent.new(variant: :dark)) do |header|
          header.with_logo { "Logo" }
        end

        assert_selector "header.bg-grayscale-900"
        assert_selector "header.border-b.border-grayscale-700"
        assert_selector "header.text-white"
      end

      test "renders transparent variant" do
        render_inline(HeaderComponent.new(variant: :transparent)) do |header|
          header.with_logo { "Logo" }
        end

        assert_selector "header.bg-transparent"
        assert_selector "header.text-grayscale-900"
        refute_selector "header.border-b"
      end

      test "renders primary variant" do
        render_inline(HeaderComponent.new(variant: :primary)) do |header|
          header.with_logo { "Logo" }
        end

        assert_selector "header.bg-primary-600"
        assert_selector "header.border-b.border-primary-700"
        assert_selector "header.text-white"
      end

      test "raises error for invalid variant" do
        error = assert_raises(ArgumentError) do
          HeaderComponent.new(variant: :invalid)
        end

        assert_match(/Invalid variant/, error.message)
        assert_match(/light, dark, transparent, primary/, error.message)
      end

      # Sticky tests
      test "renders sticky by default" do
        render_inline(HeaderComponent.new) do |header|
          header.with_logo { "Logo" }
        end

        assert_selector "header.sticky.top-0"
      end

      test "renders non-sticky when disabled" do
        render_inline(HeaderComponent.new(sticky: false)) do |header|
          header.with_logo { "Logo" }
        end

        refute_selector "header.sticky"
        refute_selector "header.top-0"
      end

      # Height tests
      test "renders sm height" do
        render_inline(HeaderComponent.new(height: :sm)) do |header|
          header.with_logo { "Logo" }
        end

        assert_selector "header.h-12"
      end

      test "renders md height by default" do
        render_inline(HeaderComponent.new) do |header|
          header.with_logo { "Logo" }
        end

        assert_selector "header.h-16"
      end

      test "renders lg height" do
        render_inline(HeaderComponent.new(height: :lg)) do |header|
          header.with_logo { "Logo" }
        end

        assert_selector "header.h-20"
      end

      test "raises error for invalid height" do
        error = assert_raises(ArgumentError) do
          HeaderComponent.new(height: :invalid)
        end

        assert_match(/Invalid height/, error.message)
        assert_match(/sm, md, lg/, error.message)
      end

      # Container classes tests
      test "renders with custom container classes" do
        render_inline(HeaderComponent.new(container_classes: "custom-class")) do |header|
          header.with_logo { "Logo" }
        end

        assert_selector "header.custom-class"
      end

      # HTML options tests
      test "passes through additional HTML options" do
        render_inline(HeaderComponent.new(id: "main-header", data: { controller: "header" })) do |header|
          header.with_logo { "Logo" }
        end

        assert_selector "header#main-header"
        assert_selector "header[data-controller='header']"
      end

      # Layout structure tests
      test "renders with flex layout" do
        render_inline(HeaderComponent.new) do |header|
          header.with_logo { "Logo" }
        end

        assert_selector "header.flex.items-center.justify-between"
      end

      test "renders with z-index" do
        render_inline(HeaderComponent.new) do |header|
          header.with_logo { "Logo" }
        end

        assert_selector "header.z-40"
      end

      test "renders with horizontal padding" do
        render_inline(HeaderComponent.new) do |header|
          header.with_logo { "Logo" }
        end

        assert_selector "header.px-4"
      end
    end
  end
end
