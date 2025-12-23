# frozen_string_literal: true

require "test_helper"

module BetterUi
  module Drawer
    class NavGroupComponentTest < ActiveSupport::TestCase
      # Basic rendering tests
      test "renders with title" do
        render_inline(NavGroupComponent.new(title: "Main")) do |group|
          group.with_item(label: "Dashboard", href: "/dashboard")
        end

        assert_selector "h3", text: "Main"
        assert_selector "h3.px-4.text-xs.font-semibold.uppercase.tracking-wider"
      end

      test "renders without title" do
        render_inline(NavGroupComponent.new) do |group|
          group.with_item(label: "Dashboard", href: "/dashboard")
        end

        refute_selector "h3"
      end

      # Items rendering tests
      test "renders items" do
        render_inline(NavGroupComponent.new(title: "Main")) do |group|
          group.with_item(label: "Dashboard", href: "/dashboard")
          group.with_item(label: "Settings", href: "/settings")
        end

        assert_selector "a", count: 2
        assert_text "Dashboard"
        assert_text "Settings"
      end

      test "renders items with active state" do
        render_inline(NavGroupComponent.new(title: "Main")) do |group|
          group.with_item(label: "Dashboard", href: "/dashboard", active: true)
          group.with_item(label: "Settings", href: "/settings", active: false)
        end

        assert_selector "a.bg-primary-50", count: 1
        assert_selector "a.hover\\:bg-grayscale-100", count: 1
      end

      test "renders items with icons" do
        render_inline(NavGroupComponent.new(title: "Main")) do |group|
          group.with_item(label: "Dashboard", href: "/dashboard") do |item|
            item.with_icon { "<svg class='test-icon'></svg>".html_safe }
          end
        end

        assert_selector "svg.test-icon"
      end

      test "renders items with badges" do
        render_inline(NavGroupComponent.new(title: "Main")) do |group|
          group.with_item(label: "Messages", href: "/messages") do |item|
            item.with_badge { "5" }
          end
        end

        assert_selector "span.ml-auto.rounded-full"
        assert_text "5"
      end

      # Items wrapper classes tests
      test "items wrapper has margin when title present" do
        render_inline(NavGroupComponent.new(title: "Main")) do |group|
          group.with_item(label: "Dashboard", href: "/dashboard")
        end

        assert_selector "div.mt-2.space-y-1"
      end

      test "items wrapper has no margin when no title" do
        render_inline(NavGroupComponent.new) do |group|
          group.with_item(label: "Dashboard", href: "/dashboard")
        end

        assert_selector "div.space-y-1"
        refute_selector "div.mt-2.space-y-1"
      end

      # Variant tests
      test "renders light variant title" do
        render_inline(NavGroupComponent.new(title: "Main", variant: :light)) do |group|
          group.with_item(label: "Dashboard", href: "/dashboard")
        end

        assert_selector "h3.text-grayscale-500"
      end

      test "renders dark variant title" do
        render_inline(NavGroupComponent.new(title: "Main", variant: :dark)) do |group|
          group.with_item(label: "Dashboard", href: "/dashboard")
        end

        assert_selector "h3.text-grayscale-400"
      end

      test "renders primary variant title" do
        render_inline(NavGroupComponent.new(title: "Main", variant: :primary)) do |group|
          group.with_item(label: "Dashboard", href: "/dashboard")
        end

        assert_selector "h3.text-primary-200"
      end

      test "passes variant to items" do
        render_inline(NavGroupComponent.new(title: "Main", variant: :dark)) do |group|
          group.with_item(label: "Dashboard", href: "/dashboard", active: true)
        end

        assert_selector "a.bg-white\\/10.text-white"
      end

      test "raises error for invalid variant" do
        error = assert_raises(ArgumentError) do
          NavGroupComponent.new(title: "Main", variant: :invalid)
        end

        assert_match(/Invalid variant/, error.message)
      end

      # Custom classes tests
      test "renders with custom container classes" do
        render_inline(NavGroupComponent.new(title: "Main", container_classes: "custom-class")) do |group|
          group.with_item(label: "Dashboard", href: "/dashboard")
        end

        assert_selector "div.custom-class"
      end

      # HTML options tests
      test "passes through additional HTML options" do
        render_inline(NavGroupComponent.new(title: "Main", id: "nav-group")) do |group|
          group.with_item(label: "Dashboard", href: "/dashboard")
        end

        assert_selector "div#nav-group"
      end

      # HTTP method tests
      test "passes method to items" do
        render_inline(NavGroupComponent.new(title: "Account")) do |group|
          group.with_item(label: "Logout", href: "/logout", method: :delete)
        end

        assert_selector "a[data-turbo-method='delete']"
      end

      # Complete rendering test
      test "renders complete group with all features" do
        render_inline(NavGroupComponent.new(title: "Main", variant: :light)) do |group|
          group.with_item(label: "Dashboard", href: "/dashboard", active: true) do |item|
            item.with_icon { "<svg></svg>".html_safe }
          end
          group.with_item(label: "Messages", href: "/messages") do |item|
            item.with_icon { "<svg></svg>".html_safe }
            item.with_badge { "5" }
          end
          group.with_item(label: "Logout", href: "/logout", method: :delete) do |item|
            item.with_icon { "<svg></svg>".html_safe }
          end
        end

        assert_selector "h3.text-grayscale-500", text: "Main"
        assert_selector "a", count: 3
        assert_selector "a.bg-primary-50", count: 1
        assert_selector "span.ml-auto.rounded-full", count: 1
        assert_selector "a[data-turbo-method='delete']", count: 1
      end
    end
  end
end
