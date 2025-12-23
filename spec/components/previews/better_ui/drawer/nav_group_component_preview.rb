# frozen_string_literal: true

module BetterUi
  module Drawer
    # @label Nav Group
    class NavGroupComponentPreview < ViewComponent::Preview
      # @label Default
      def default
        render BetterUi::Drawer::NavGroupComponent.new(title: "Main") do |group|
          group.with_item(label: "Dashboard", href: "#", active: true) do |item|
            item.with_icon { dashboard_icon }
          end
          group.with_item(label: "Projects", href: "#") do |item|
            item.with_icon { projects_icon }
          end
          group.with_item(label: "Team", href: "#") do |item|
            item.with_icon { team_icon }
          end
        end
      end

      # @label Without Title
      def without_title
        render BetterUi::Drawer::NavGroupComponent.new do |group|
          group.with_item(label: "Dashboard", href: "#", active: true) do |item|
            item.with_icon { dashboard_icon }
          end
          group.with_item(label: "Settings", href: "#") do |item|
            item.with_icon { settings_icon }
          end
        end
      end

      # @label With Badges
      def with_badges
        render BetterUi::Drawer::NavGroupComponent.new(title: "Messages") do |group|
          group.with_item(label: "Inbox", href: "#", active: true) do |item|
            item.with_icon { inbox_icon }
            item.with_badge { "12" }
          end
          group.with_item(label: "Sent", href: "#") do |item|
            item.with_icon { sent_icon }
          end
          group.with_item(label: "Drafts", href: "#") do |item|
            item.with_icon { drafts_icon }
            item.with_badge { "3" }
          end
        end
      end

      # @label Dark Variant
      # @display bg_color #1f2937
      def dark_variant
        render BetterUi::Drawer::NavGroupComponent.new(title: "Main", variant: :dark) do |group|
          group.with_item(label: "Dashboard", href: "#", active: true) do |item|
            item.with_icon { dashboard_icon }
          end
          group.with_item(label: "Projects", href: "#") do |item|
            item.with_icon { projects_icon }
          end
          group.with_item(label: "Team", href: "#") do |item|
            item.with_icon { team_icon }
          end
        end
      end

      # @label Primary Variant
      # @display bg_color #1d4ed8
      def primary_variant
        render BetterUi::Drawer::NavGroupComponent.new(title: "Main", variant: :primary) do |group|
          group.with_item(label: "Dashboard", href: "#", active: true) do |item|
            item.with_icon { dashboard_icon }
          end
          group.with_item(label: "Projects", href: "#") do |item|
            item.with_icon { projects_icon }
          end
          group.with_item(label: "Team", href: "#") do |item|
            item.with_icon { team_icon }
          end
        end
      end

      # @label With HTTP Method
      def with_http_method
        render BetterUi::Drawer::NavGroupComponent.new(title: "Account") do |group|
          group.with_item(label: "Settings", href: "#") do |item|
            item.with_icon { settings_icon }
          end
          group.with_item(label: "Help", href: "#") do |item|
            item.with_icon { help_icon }
          end
          group.with_item(label: "Logout", href: "#", method: :delete) do |item|
            item.with_icon { logout_icon }
          end
        end
      end

      # @label Complete Sidebar Navigation
      def complete_navigation
        render_with_template
      end

      # @label Playground
      # @param title text
      # @param variant select { choices: [light, dark, primary] }
      def playground(title: "Navigation", variant: :light)
        render BetterUi::Drawer::NavGroupComponent.new(
          title: title.present? ? title : nil,
          variant: variant.to_sym
        ) do |group|
          group.with_item(label: "Dashboard", href: "#", active: true) do |item|
            item.with_icon { dashboard_icon }
          end
          group.with_item(label: "Projects", href: "#") do |item|
            item.with_icon { projects_icon }
          end
          group.with_item(label: "Messages", href: "#") do |item|
            item.with_icon { inbox_icon }
            item.with_badge { "5" }
          end
        end
      end

      private

      def dashboard_icon
        "<svg class='w-5 h-5' fill='none' stroke='currentColor' viewBox='0 0 24 24'><path stroke-linecap='round' stroke-linejoin='round' stroke-width='2' d='M3 12l2-2m0 0l7-7 7 7M5 10v10a1 1 0 001 1h3m10-11l2 2m-2-2v10a1 1 0 01-1 1h-3m-6 0a1 1 0 001-1v-4a1 1 0 011-1h2a1 1 0 011 1v4a1 1 0 001 1m-6 0h6'></path></svg>".html_safe
      end

      def projects_icon
        "<svg class='w-5 h-5' fill='none' stroke='currentColor' viewBox='0 0 24 24'><path stroke-linecap='round' stroke-linejoin='round' stroke-width='2' d='M19 11H5m14 0a2 2 0 012 2v6a2 2 0 01-2 2H5a2 2 0 01-2-2v-6a2 2 0 012-2m14 0V9a2 2 0 00-2-2M5 11V9a2 2 0 012-2m0 0V5a2 2 0 012-2h6a2 2 0 012 2v2M7 7h10'></path></svg>".html_safe
      end

      def team_icon
        "<svg class='w-5 h-5' fill='none' stroke='currentColor' viewBox='0 0 24 24'><path stroke-linecap='round' stroke-linejoin='round' stroke-width='2' d='M17 20h5v-2a3 3 0 00-5.356-1.857M17 20H7m10 0v-2c0-.656-.126-1.283-.356-1.857M7 20H2v-2a3 3 0 015.356-1.857M7 20v-2c0-.656.126-1.283.356-1.857m0 0a5.002 5.002 0 019.288 0M15 7a3 3 0 11-6 0 3 3 0 016 0zm6 3a2 2 0 11-4 0 2 2 0 014 0zM7 10a2 2 0 11-4 0 2 2 0 014 0z'></path></svg>".html_safe
      end

      def settings_icon
        "<svg class='w-5 h-5' fill='none' stroke='currentColor' viewBox='0 0 24 24'><path stroke-linecap='round' stroke-linejoin='round' stroke-width='2' d='M10.325 4.317c.426-1.756 2.924-1.756 3.35 0a1.724 1.724 0 002.573 1.066c1.543-.94 3.31.826 2.37 2.37a1.724 1.724 0 001.065 2.572c1.756.426 1.756 2.924 0 3.35a1.724 1.724 0 00-1.066 2.573c.94 1.543-.826 3.31-2.37 2.37a1.724 1.724 0 00-2.572 1.065c-.426 1.756-2.924 1.756-3.35 0a1.724 1.724 0 00-2.573-1.066c-1.543.94-3.31-.826-2.37-2.37a1.724 1.724 0 00-1.065-2.572c-1.756-.426-1.756-2.924 0-3.35a1.724 1.724 0 001.066-2.573c-.94-1.543.826-3.31 2.37-2.37.996.608 2.296.07 2.572-1.065z'></path><path stroke-linecap='round' stroke-linejoin='round' stroke-width='2' d='M15 12a3 3 0 11-6 0 3 3 0 016 0z'></path></svg>".html_safe
      end

      def help_icon
        "<svg class='w-5 h-5' fill='none' stroke='currentColor' viewBox='0 0 24 24'><path stroke-linecap='round' stroke-linejoin='round' stroke-width='2' d='M8.228 9c.549-1.165 2.03-2 3.772-2 2.21 0 4 1.343 4 3 0 1.4-1.278 2.575-3.006 2.907-.542.104-.994.54-.994 1.093m0 3h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z'></path></svg>".html_safe
      end

      def logout_icon
        "<svg class='w-5 h-5' fill='none' stroke='currentColor' viewBox='0 0 24 24'><path stroke-linecap='round' stroke-linejoin='round' stroke-width='2' d='M17 16l4-4m0 0l-4-4m4 4H7m6 4v1a3 3 0 01-3 3H6a3 3 0 01-3-3V7a3 3 0 013-3h4a3 3 0 013 3v1'></path></svg>".html_safe
      end

      def inbox_icon
        "<svg class='w-5 h-5' fill='none' stroke='currentColor' viewBox='0 0 24 24'><path stroke-linecap='round' stroke-linejoin='round' stroke-width='2' d='M20 13V6a2 2 0 00-2-2H6a2 2 0 00-2 2v7m16 0v5a2 2 0 01-2 2H6a2 2 0 01-2-2v-5m16 0h-2.586a1 1 0 00-.707.293l-2.414 2.414a1 1 0 01-.707.293h-3.172a1 1 0 01-.707-.293l-2.414-2.414A1 1 0 006.586 13H4'></path></svg>".html_safe
      end

      def sent_icon
        "<svg class='w-5 h-5' fill='none' stroke='currentColor' viewBox='0 0 24 24'><path stroke-linecap='round' stroke-linejoin='round' stroke-width='2' d='M12 19l9 2-9-18-9 18 9-2zm0 0v-8'></path></svg>".html_safe
      end

      def drafts_icon
        "<svg class='w-5 h-5' fill='none' stroke='currentColor' viewBox='0 0 24 24'><path stroke-linecap='round' stroke-linejoin='round' stroke-width='2' d='M11 5H6a2 2 0 00-2 2v11a2 2 0 002 2h11a2 2 0 002-2v-5m-1.414-9.414a2 2 0 112.828 2.828L11.828 15H9v-2.828l8.586-8.586z'></path></svg>".html_safe
      end
    end
  end
end
