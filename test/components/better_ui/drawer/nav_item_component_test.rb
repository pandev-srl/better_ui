# frozen_string_literal: true

require "test_helper"

module BetterUi
  module Drawer
    class NavItemComponentTest < ActiveSupport::TestCase
      # Basic rendering tests
      test "renders with required parameters" do
        render_inline(NavItemComponent.new(label: "Dashboard", href: "/dashboard"))

        assert_selector "a[href='/dashboard']"
        assert_text "Dashboard"
      end

      test "renders with default variant classes" do
        render_inline(NavItemComponent.new(label: "Dashboard", href: "/dashboard"))

        assert_selector "a.flex.items-center.px-4.py-2.rounded-md"
        assert_selector "a.hover\\:bg-grayscale-100"
      end

      # Active state tests
      test "renders active state" do
        render_inline(NavItemComponent.new(label: "Dashboard", href: "/dashboard", active: true))

        assert_selector "a.bg-primary-50.text-primary-700"
      end

      test "renders inactive state" do
        render_inline(NavItemComponent.new(label: "Dashboard", href: "/dashboard", active: false))

        assert_selector "a.hover\\:bg-grayscale-100"
        refute_selector "a.bg-primary-50"
      end

      # Icon slot tests
      test "renders with icon slot" do
        render_inline(NavItemComponent.new(label: "Dashboard", href: "/dashboard")) do |item|
          item.with_icon { "<svg class='test-icon'></svg>".html_safe }
        end

        assert_selector "span.w-5.h-5.mr-3.shrink-0"
        assert_selector "svg.test-icon"
      end

      test "renders without icon" do
        render_inline(NavItemComponent.new(label: "Dashboard", href: "/dashboard"))

        refute_selector "span.w-5"
      end

      # Badge slot tests
      test "renders with badge slot" do
        render_inline(NavItemComponent.new(label: "Messages", href: "/messages")) do |item|
          item.with_badge { "5" }
        end

        assert_selector "span.ml-auto.text-xs.rounded-full"
        assert_text "5"
      end

      test "renders without badge" do
        render_inline(NavItemComponent.new(label: "Dashboard", href: "/dashboard"))

        refute_selector "span.ml-auto"
      end

      test "badge has correct variant classes" do
        render_inline(NavItemComponent.new(label: "Messages", href: "/messages", variant: :light)) do |item|
          item.with_badge { "5" }
        end

        assert_selector "span.bg-primary-100.text-primary-700"
      end

      # HTTP method tests
      test "renders with turbo method for delete" do
        render_inline(NavItemComponent.new(label: "Logout", href: "/logout", method: :delete))

        assert_selector "a[data-turbo-method='delete']"
      end

      test "renders with turbo method for post" do
        render_inline(NavItemComponent.new(label: "Submit", href: "/submit", method: :post))

        assert_selector "a[data-turbo-method='post']"
      end

      test "does not add turbo method for get" do
        render_inline(NavItemComponent.new(label: "Link", href: "/link", method: :get))

        refute_selector "a[data-turbo-method]"
      end

      test "does not add turbo method when nil" do
        render_inline(NavItemComponent.new(label: "Link", href: "/link"))

        refute_selector "a[data-turbo-method]"
      end

      test "raises error for invalid method" do
        error = assert_raises(ArgumentError) do
          NavItemComponent.new(label: "Link", href: "/link", method: :invalid)
        end

        assert_match(/Invalid method/, error.message)
      end

      # Variant tests
      test "renders light variant" do
        render_inline(NavItemComponent.new(label: "Link", href: "/", variant: :light, active: true))

        assert_selector "a.bg-primary-50.text-primary-700"
      end

      test "renders dark variant active" do
        render_inline(NavItemComponent.new(label: "Link", href: "/", variant: :dark, active: true))

        assert_selector "a.bg-white\\/10.text-white"
      end

      test "renders dark variant inactive" do
        render_inline(NavItemComponent.new(label: "Link", href: "/", variant: :dark, active: false))

        assert_selector "a.text-grayscale-300.hover\\:bg-white\\/5"
      end

      test "renders primary variant active" do
        render_inline(NavItemComponent.new(label: "Link", href: "/", variant: :primary, active: true))

        assert_selector "a.bg-white\\/20.text-white"
      end

      test "renders primary variant inactive" do
        render_inline(NavItemComponent.new(label: "Link", href: "/", variant: :primary, active: false))

        assert_selector "a.text-primary-100.hover\\:bg-white\\/10"
      end

      test "raises error for invalid variant" do
        error = assert_raises(ArgumentError) do
          NavItemComponent.new(label: "Link", href: "/", variant: :invalid)
        end

        assert_match(/Invalid variant/, error.message)
      end

      # Custom classes tests
      test "renders with custom container classes" do
        render_inline(NavItemComponent.new(label: "Link", href: "/", container_classes: "custom-class"))

        assert_selector "a.custom-class"
      end

      # HTML options tests
      test "passes through additional HTML options" do
        render_inline(NavItemComponent.new(label: "Link", href: "/", id: "nav-link", target: "_blank"))

        assert_selector "a#nav-link[target='_blank']"
      end

      # Complete rendering test
      test "renders complete item with all features" do
        render_inline(NavItemComponent.new(
          label: "Messages",
          href: "/messages",
          active: true,
          variant: :light
        )) do |item|
          item.with_icon { "<svg></svg>".html_safe }
          item.with_badge { "99+" }
        end

        assert_selector "a.bg-primary-50.text-primary-700"
        assert_selector "span.w-5.h-5.mr-3"
        assert_text "Messages"
        assert_selector "span.ml-auto.rounded-full"
        assert_text "99+"
      end
    end
  end
end
