# frozen_string_literal: true

module BetterUi
  module Drawer
    # @label Nav Item
    class NavItemComponentPreview < ViewComponent::Preview
      # @label Default
      def default
        render BetterUi::Drawer::NavItemComponent.new(label: "Dashboard", href: "#")
      end

      # @label With Icon
      def with_icon
        render BetterUi::Drawer::NavItemComponent.new(label: "Dashboard", href: "#") do |item|
          item.with_icon do
            "<svg class='w-5 h-5' fill='none' stroke='currentColor' viewBox='0 0 24 24'><path stroke-linecap='round' stroke-linejoin='round' stroke-width='2' d='M3 12l2-2m0 0l7-7 7 7M5 10v10a1 1 0 001 1h3m10-11l2 2m-2-2v10a1 1 0 01-1 1h-3m-6 0a1 1 0 001-1v-4a1 1 0 011-1h2a1 1 0 011 1v4a1 1 0 001 1m-6 0h6'></path></svg>".html_safe
          end
        end
      end

      # @label Active State
      def active_state
        render BetterUi::Drawer::NavItemComponent.new(label: "Dashboard", href: "#", active: true) do |item|
          item.with_icon do
            "<svg class='w-5 h-5' fill='none' stroke='currentColor' viewBox='0 0 24 24'><path stroke-linecap='round' stroke-linejoin='round' stroke-width='2' d='M3 12l2-2m0 0l7-7 7 7M5 10v10a1 1 0 001 1h3m10-11l2 2m-2-2v10a1 1 0 01-1 1h-3m-6 0a1 1 0 001-1v-4a1 1 0 011-1h2a1 1 0 011 1v4a1 1 0 001 1m-6 0h6'></path></svg>".html_safe
          end
        end
      end

      # @label With Badge
      def with_badge
        render BetterUi::Drawer::NavItemComponent.new(label: "Messages", href: "#") do |item|
          item.with_icon do
            "<svg class='w-5 h-5' fill='none' stroke='currentColor' viewBox='0 0 24 24'><path stroke-linecap='round' stroke-linejoin='round' stroke-width='2' d='M3 8l7.89 5.26a2 2 0 002.22 0L21 8M5 19h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v10a2 2 0 002 2z'></path></svg>".html_safe
          end
          item.with_badge { "5" }
        end
      end

      # @label With HTTP Method (Delete)
      def with_http_method
        render BetterUi::Drawer::NavItemComponent.new(label: "Logout", href: "#", method: :delete) do |item|
          item.with_icon do
            "<svg class='w-5 h-5' fill='none' stroke='currentColor' viewBox='0 0 24 24'><path stroke-linecap='round' stroke-linejoin='round' stroke-width='2' d='M17 16l4-4m0 0l-4-4m4 4H7m6 4v1a3 3 0 01-3 3H6a3 3 0 01-3-3V7a3 3 0 013-3h4a3 3 0 013 3v1'></path></svg>".html_safe
          end
        end
      end

      # @label Dark Variant
      # @display bg_color #1f2937
      def dark_variant
        render BetterUi::Drawer::NavItemComponent.new(label: "Dashboard", href: "#", variant: :dark, active: true) do |item|
          item.with_icon do
            "<svg class='w-5 h-5' fill='none' stroke='currentColor' viewBox='0 0 24 24'><path stroke-linecap='round' stroke-linejoin='round' stroke-width='2' d='M3 12l2-2m0 0l7-7 7 7M5 10v10a1 1 0 001 1h3m10-11l2 2m-2-2v10a1 1 0 01-1 1h-3m-6 0a1 1 0 001-1v-4a1 1 0 011-1h2a1 1 0 011 1v4a1 1 0 001 1m-6 0h6'></path></svg>".html_safe
          end
        end
      end

      # @label Primary Variant
      # @display bg_color #1d4ed8
      def primary_variant
        render BetterUi::Drawer::NavItemComponent.new(label: "Dashboard", href: "#", variant: :primary, active: true) do |item|
          item.with_icon do
            "<svg class='w-5 h-5' fill='none' stroke='currentColor' viewBox='0 0 24 24'><path stroke-linecap='round' stroke-linejoin='round' stroke-width='2' d='M3 12l2-2m0 0l7-7 7 7M5 10v10a1 1 0 001 1h3m10-11l2 2m-2-2v10a1 1 0 01-1 1h-3m-6 0a1 1 0 001-1v-4a1 1 0 011-1h2a1 1 0 011 1v4a1 1 0 001 1m-6 0h6'></path></svg>".html_safe
          end
        end
      end

      # @label All Features
      def all_features
        render BetterUi::Drawer::NavItemComponent.new(
          label: "Notifications",
          href: "#",
          active: true
        ) do |item|
          item.with_icon do
            "<svg class='w-5 h-5' fill='none' stroke='currentColor' viewBox='0 0 24 24'><path stroke-linecap='round' stroke-linejoin='round' stroke-width='2' d='M15 17h5l-1.405-1.405A2.032 2.032 0 0118 14.158V11a6.002 6.002 0 00-4-5.659V5a2 2 0 10-4 0v.341C7.67 6.165 6 8.388 6 11v3.159c0 .538-.214 1.055-.595 1.436L4 17h5m6 0v1a3 3 0 11-6 0v-1m6 0H9'></path></svg>".html_safe
          end
          item.with_badge { "99+" }
        end
      end

      # @label Playground
      # @param label text
      # @param href text
      # @param active toggle
      # @param variant select { choices: [light, dark, primary] }
      # @param method select { choices: [~, get, post, put, patch, delete] }
      def playground(label: "Dashboard", href: "#", active: false, variant: :light, method: nil)
        render BetterUi::Drawer::NavItemComponent.new(
          label: label,
          href: href,
          active: active,
          variant: variant.to_sym,
          method: method.present? && method != "~" ? method.to_sym : nil
        ) do |item|
          item.with_icon do
            "<svg class='w-5 h-5' fill='none' stroke='currentColor' viewBox='0 0 24 24'><path stroke-linecap='round' stroke-linejoin='round' stroke-width='2' d='M3 12l2-2m0 0l7-7 7 7M5 10v10a1 1 0 001 1h3m10-11l2 2m-2-2v10a1 1 0 01-1 1h-3m-6 0a1 1 0 001-1v-4a1 1 0 011-1h2a1 1 0 011 1v4a1 1 0 001 1m-6 0h6'></path></svg>".html_safe
          end
        end
      end
    end
  end
end
