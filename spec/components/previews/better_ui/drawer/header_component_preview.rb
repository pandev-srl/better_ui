# frozen_string_literal: true

module BetterUi
  module Drawer
    # @label Header
    class HeaderComponentPreview < ViewComponent::Preview
      # @label Default
      def default
        render BetterUi::Drawer::HeaderComponent.new do |header|
          header.with_logo { "BetterUI" }
        end
      end

      # @label With Navigation
      def with_navigation
        render BetterUi::Drawer::HeaderComponent.new do |header|
          header.with_logo { "Brand" }
          header.with_navigation do
            "<nav class='flex gap-6'>
              <a href='#' class='text-grayscale-600 hover:text-grayscale-900'>Home</a>
              <a href='#' class='text-grayscale-600 hover:text-grayscale-900'>Products</a>
              <a href='#' class='text-grayscale-600 hover:text-grayscale-900'>About</a>
              <a href='#' class='text-grayscale-600 hover:text-grayscale-900'>Contact</a>
            </nav>".html_safe
          end
        end
      end

      # @label With Actions
      def with_actions
        render BetterUi::Drawer::HeaderComponent.new do |header|
          header.with_logo { "Brand" }
          header.with_actions do
            "<div class='flex items-center gap-4'>
              <button class='text-grayscale-600 hover:text-grayscale-900'>
                <svg class='w-6 h-6' fill='none' stroke='currentColor' viewBox='0 0 24 24'><path stroke-linecap='round' stroke-linejoin='round' stroke-width='2' d='M15 17h5l-1.405-1.405A2.032 2.032 0 0118 14.158V11a6.002 6.002 0 00-4-5.659V5a2 2 0 10-4 0v.341C7.67 6.165 6 8.388 6 11v3.159c0 .538-.214 1.055-.595 1.436L4 17h5m6 0v1a3 3 0 11-6 0v-1m6 0H9'></path></svg>
              </button>
              <div class='w-8 h-8 bg-primary-500 rounded-full'></div>
            </div>".html_safe
          end
        end
      end

      # @label With Mobile Menu Button
      def with_mobile_menu_button
        render BetterUi::Drawer::HeaderComponent.new do |header|
          header.with_mobile_menu_button do
            "<button class='p-2 text-grayscale-600 hover:text-grayscale-900 hover:bg-grayscale-100 rounded-md'>
              <svg class='w-6 h-6' fill='none' stroke='currentColor' viewBox='0 0 24 24'><path stroke-linecap='round' stroke-linejoin='round' stroke-width='2' d='M4 6h16M4 12h16M4 18h16'></path></svg>
            </button>".html_safe
          end
          header.with_logo { "Brand" }
          header.with_actions do
            "<div class='w-8 h-8 bg-primary-500 rounded-full'></div>".html_safe
          end
        end
      end

      # @label Complete Header
      def complete_header
        render BetterUi::Drawer::HeaderComponent.new do |header|
          header.with_mobile_menu_button do
            "<button class='p-2 text-grayscale-600 hover:text-grayscale-900 hover:bg-grayscale-100 rounded-md lg:hidden'>
              <svg class='w-6 h-6' fill='none' stroke='currentColor' viewBox='0 0 24 24'><path stroke-linecap='round' stroke-linejoin='round' stroke-width='2' d='M4 6h16M4 12h16M4 18h16'></path></svg>
            </button>".html_safe
          end
          header.with_logo do
            "<div class='flex items-center'>
              <div class='w-8 h-8 bg-primary-600 rounded-lg flex items-center justify-center text-white font-bold'>B</div>
              <span class='ml-2 font-semibold text-lg'>BetterUI</span>
            </div>".html_safe
          end
          header.with_navigation do
            "<nav class='flex gap-6'>
              <a href='#' class='text-primary-600 font-medium'>Dashboard</a>
              <a href='#' class='text-grayscale-600 hover:text-grayscale-900'>Projects</a>
              <a href='#' class='text-grayscale-600 hover:text-grayscale-900'>Team</a>
              <a href='#' class='text-grayscale-600 hover:text-grayscale-900'>Settings</a>
            </nav>".html_safe
          end
          header.with_actions do
            "<div class='flex items-center gap-4'>
              <button class='text-grayscale-600 hover:text-grayscale-900'>
                <svg class='w-6 h-6' fill='none' stroke='currentColor' viewBox='0 0 24 24'><path stroke-linecap='round' stroke-linejoin='round' stroke-width='2' d='M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z'></path></svg>
              </button>
              <button class='text-grayscale-600 hover:text-grayscale-900 relative'>
                <svg class='w-6 h-6' fill='none' stroke='currentColor' viewBox='0 0 24 24'><path stroke-linecap='round' stroke-linejoin='round' stroke-width='2' d='M15 17h5l-1.405-1.405A2.032 2.032 0 0118 14.158V11a6.002 6.002 0 00-4-5.659V5a2 2 0 10-4 0v.341C7.67 6.165 6 8.388 6 11v3.159c0 .538-.214 1.055-.595 1.436L4 17h5m6 0v1a3 3 0 11-6 0v-1m6 0H9'></path></svg>
                <span class='absolute -top-1 -right-1 w-2 h-2 bg-danger-500 rounded-full'></span>
              </button>
              <div class='w-8 h-8 bg-primary-500 rounded-full'></div>
            </div>".html_safe
          end
        end
      end

      # @label Light Variant
      def light_variant
        render BetterUi::Drawer::HeaderComponent.new(variant: :light) do |header|
          header.with_logo { "Light Header" }
        end
      end

      # @label Dark Variant
      # @display bg_color #1f2937
      def dark_variant
        render BetterUi::Drawer::HeaderComponent.new(variant: :dark) do |header|
          header.with_logo { "Dark Header" }
        end
      end

      # @label Primary Variant
      def primary_variant
        render BetterUi::Drawer::HeaderComponent.new(variant: :primary) do |header|
          header.with_logo { "Primary Header" }
        end
      end

      # @label Transparent Variant
      # @display bg_color #e0e7ff
      def transparent_variant
        render BetterUi::Drawer::HeaderComponent.new(variant: :transparent) do |header|
          header.with_logo { "Transparent Header" }
        end
      end

      # @label Small Height
      def small_height
        render BetterUi::Drawer::HeaderComponent.new(height: :sm) do |header|
          header.with_logo { "Small Header" }
        end
      end

      # @label Large Height
      def large_height
        render BetterUi::Drawer::HeaderComponent.new(height: :lg) do |header|
          header.with_logo { "Large Header" }
        end
      end

      # @label Non-Sticky
      def non_sticky
        render BetterUi::Drawer::HeaderComponent.new(sticky: false) do |header|
          header.with_logo { "Non-Sticky Header" }
        end
      end

      # @label Playground
      # @param variant select { choices: [light, dark, transparent, primary] }
      # @param height select { choices: [sm, md, lg] }
      # @param sticky toggle
      def playground(variant: :light, height: :md, sticky: true)
        render BetterUi::Drawer::HeaderComponent.new(
          variant: variant.to_sym,
          height: height.to_sym,
          sticky: sticky
        ) do |header|
          header.with_mobile_menu_button do
            "<button class='p-2 rounded-md'>Menu</button>".html_safe
          end
          header.with_logo { "Playground Header" }
          header.with_navigation do
            "<nav>Navigation</nav>".html_safe
          end
          header.with_actions { "Actions" }
        end
      end
    end
  end
end
