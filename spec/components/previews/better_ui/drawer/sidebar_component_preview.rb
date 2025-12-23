# frozen_string_literal: true

module BetterUi
  module Drawer
    # @label Sidebar
    class SidebarComponentPreview < ViewComponent::Preview
      # @label Default
      def default
        render BetterUi::Drawer::SidebarComponent.new do |sidebar|
          sidebar.with_navigation do
            "<nav class='space-y-2'>
              <a href='#' class='block px-4 py-2 rounded-md bg-primary-50 text-primary-700'>Dashboard</a>
              <a href='#' class='block px-4 py-2 rounded-md hover:bg-grayscale-100'>Projects</a>
              <a href='#' class='block px-4 py-2 rounded-md hover:bg-grayscale-100'>Team</a>
              <a href='#' class='block px-4 py-2 rounded-md hover:bg-grayscale-100'>Settings</a>
            </nav>".html_safe
          end
        end
      end

      # @label With Header
      def with_header
        render BetterUi::Drawer::SidebarComponent.new do |sidebar|
          sidebar.with_header do
            "<div class='flex items-center'>
              <div class='w-8 h-8 bg-primary-600 rounded-lg flex items-center justify-center text-white font-bold'>B</div>
              <span class='ml-2 font-semibold'>BetterUI</span>
            </div>".html_safe
          end
          sidebar.with_navigation do
            "<nav class='space-y-2'>
              <a href='#' class='block px-4 py-2 rounded-md bg-primary-50 text-primary-700'>Dashboard</a>
              <a href='#' class='block px-4 py-2 rounded-md hover:bg-grayscale-100'>Projects</a>
              <a href='#' class='block px-4 py-2 rounded-md hover:bg-grayscale-100'>Team</a>
            </nav>".html_safe
          end
        end
      end

      # @label With Footer
      def with_footer
        render BetterUi::Drawer::SidebarComponent.new do |sidebar|
          sidebar.with_navigation do
            "<nav class='space-y-2'>
              <a href='#' class='block px-4 py-2 rounded-md bg-primary-50 text-primary-700'>Dashboard</a>
              <a href='#' class='block px-4 py-2 rounded-md hover:bg-grayscale-100'>Projects</a>
            </nav>".html_safe
          end
          sidebar.with_footer do
            "<div class='flex items-center'>
              <div class='w-8 h-8 bg-grayscale-300 rounded-full'></div>
              <div class='ml-3'>
                <div class='text-sm font-medium'>John Doe</div>
                <div class='text-xs text-grayscale-500'>john@example.com</div>
              </div>
            </div>".html_safe
          end
        end
      end

      # @label Complete Sidebar
      def complete_sidebar
        render BetterUi::Drawer::SidebarComponent.new do |sidebar|
          sidebar.with_header do
            "<div class='flex items-center'>
              <div class='w-8 h-8 bg-primary-600 rounded-lg flex items-center justify-center text-white font-bold'>B</div>
              <span class='ml-2 font-semibold'>BetterUI</span>
            </div>".html_safe
          end
          sidebar.with_navigation do
            "<nav class='space-y-6'>
              <div>
                <h3 class='px-4 text-xs font-semibold text-grayscale-500 uppercase tracking-wider'>Main</h3>
                <div class='mt-2 space-y-1'>
                  <a href='#' class='flex items-center px-4 py-2 rounded-md bg-primary-50 text-primary-700'>
                    <svg class='w-5 h-5 mr-3' fill='none' stroke='currentColor' viewBox='0 0 24 24'><path stroke-linecap='round' stroke-linejoin='round' stroke-width='2' d='M3 12l2-2m0 0l7-7 7 7M5 10v10a1 1 0 001 1h3m10-11l2 2m-2-2v10a1 1 0 01-1 1h-3m-6 0a1 1 0 001-1v-4a1 1 0 011-1h2a1 1 0 011 1v4a1 1 0 001 1m-6 0h6'></path></svg>
                    Dashboard
                  </a>
                  <a href='#' class='flex items-center px-4 py-2 rounded-md hover:bg-grayscale-100'>
                    <svg class='w-5 h-5 mr-3' fill='none' stroke='currentColor' viewBox='0 0 24 24'><path stroke-linecap='round' stroke-linejoin='round' stroke-width='2' d='M19 11H5m14 0a2 2 0 012 2v6a2 2 0 01-2 2H5a2 2 0 01-2-2v-6a2 2 0 012-2m14 0V9a2 2 0 00-2-2M5 11V9a2 2 0 012-2m0 0V5a2 2 0 012-2h6a2 2 0 012 2v2M7 7h10'></path></svg>
                    Projects
                  </a>
                  <a href='#' class='flex items-center px-4 py-2 rounded-md hover:bg-grayscale-100'>
                    <svg class='w-5 h-5 mr-3' fill='none' stroke='currentColor' viewBox='0 0 24 24'><path stroke-linecap='round' stroke-linejoin='round' stroke-width='2' d='M12 4.354a4 4 0 110 5.292M15 21H3v-1a6 6 0 0112 0v1zm0 0h6v-1a6 6 0 00-9-5.197m12 5.198H9'></path></svg>
                    Team
                  </a>
                </div>
              </div>
              <div>
                <h3 class='px-4 text-xs font-semibold text-grayscale-500 uppercase tracking-wider'>Settings</h3>
                <div class='mt-2 space-y-1'>
                  <a href='#' class='flex items-center px-4 py-2 rounded-md hover:bg-grayscale-100'>
                    <svg class='w-5 h-5 mr-3' fill='none' stroke='currentColor' viewBox='0 0 24 24'><path stroke-linecap='round' stroke-linejoin='round' stroke-width='2' d='M10.325 4.317c.426-1.756 2.924-1.756 3.35 0a1.724 1.724 0 002.573 1.066c1.543-.94 3.31.826 2.37 2.37a1.724 1.724 0 001.065 2.572c1.756.426 1.756 2.924 0 3.35a1.724 1.724 0 00-1.066 2.573c.94 1.543-.826 3.31-2.37 2.37a1.724 1.724 0 00-2.572 1.065c-.426 1.756-2.924 1.756-3.35 0a1.724 1.724 0 00-2.573-1.066c-1.543.94-3.31-.826-2.37-2.37a1.724 1.724 0 00-1.065-2.572c-1.756-.426-1.756-2.924 0-3.35a1.724 1.724 0 001.066-2.573c-.94-1.543.826-3.31 2.37-2.37.996.608 2.296.07 2.572-1.065z'></path><path stroke-linecap='round' stroke-linejoin='round' stroke-width='2' d='M15 12a3 3 0 11-6 0 3 3 0 016 0z'></path></svg>
                    Settings
                  </a>
                  <a href='#' class='flex items-center px-4 py-2 rounded-md hover:bg-grayscale-100'>
                    <svg class='w-5 h-5 mr-3' fill='none' stroke='currentColor' viewBox='0 0 24 24'><path stroke-linecap='round' stroke-linejoin='round' stroke-width='2' d='M8.228 9c.549-1.165 2.03-2 3.772-2 2.21 0 4 1.343 4 3 0 1.4-1.278 2.575-3.006 2.907-.542.104-.994.54-.994 1.093m0 3h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z'></path></svg>
                    Help
                  </a>
                </div>
              </div>
            </nav>".html_safe
          end
          sidebar.with_footer do
            "<div class='flex items-center'>
              <div class='w-10 h-10 bg-grayscale-300 rounded-full'></div>
              <div class='ml-3'>
                <div class='text-sm font-medium'>John Doe</div>
                <div class='text-xs text-grayscale-500'>john@example.com</div>
              </div>
              <button class='ml-auto p-2 text-grayscale-500 hover:text-grayscale-700'>
                <svg class='w-5 h-5' fill='none' stroke='currentColor' viewBox='0 0 24 24'><path stroke-linecap='round' stroke-linejoin='round' stroke-width='2' d='M17 16l4-4m0 0l-4-4m4 4H7m6 4v1a3 3 0 01-3 3H6a3 3 0 01-3-3V7a3 3 0 013-3h4a3 3 0 013 3v1'></path></svg>
              </button>
            </div>".html_safe
          end
        end
      end

      # @label Light Variant
      def light_variant
        render BetterUi::Drawer::SidebarComponent.new(variant: :light) do |sidebar|
          sidebar.with_navigation { "Light Sidebar Navigation" }
        end
      end

      # @label Dark Variant
      # @display bg_color #374151
      def dark_variant
        render BetterUi::Drawer::SidebarComponent.new(variant: :dark) do |sidebar|
          sidebar.with_navigation do
            "<nav class='space-y-2'>
              <a href='#' class='block px-4 py-2 rounded-md bg-white/10 text-white'>Dashboard</a>
              <a href='#' class='block px-4 py-2 rounded-md hover:bg-white/5 text-grayscale-300'>Projects</a>
              <a href='#' class='block px-4 py-2 rounded-md hover:bg-white/5 text-grayscale-300'>Team</a>
            </nav>".html_safe
          end
        end
      end

      # @label Primary Variant
      def primary_variant
        render BetterUi::Drawer::SidebarComponent.new(variant: :primary) do |sidebar|
          sidebar.with_navigation do
            "<nav class='space-y-2'>
              <a href='#' class='block px-4 py-2 rounded-md bg-white/20 text-white'>Dashboard</a>
              <a href='#' class='block px-4 py-2 rounded-md hover:bg-white/10 text-primary-100'>Projects</a>
              <a href='#' class='block px-4 py-2 rounded-md hover:bg-white/10 text-primary-100'>Team</a>
            </nav>".html_safe
          end
        end
      end

      # @label Left Position
      def left_position
        render BetterUi::Drawer::SidebarComponent.new(position: :left) do |sidebar|
          sidebar.with_navigation { "Left-positioned Sidebar (border on right)" }
        end
      end

      # @label Right Position
      def right_position
        render BetterUi::Drawer::SidebarComponent.new(position: :right) do |sidebar|
          sidebar.with_navigation { "Right-positioned Sidebar (border on left)" }
        end
      end

      # @label Small Width (Icon Only)
      def small_width
        render BetterUi::Drawer::SidebarComponent.new(width: :sm) do |sidebar|
          sidebar.with_navigation do
            "<nav class='space-y-2'>
              <a href='#' class='block p-2 rounded-md bg-primary-50 text-primary-700'>
                <svg class='w-5 h-5' fill='none' stroke='currentColor' viewBox='0 0 24 24'><path stroke-linecap='round' stroke-linejoin='round' stroke-width='2' d='M3 12l2-2m0 0l7-7 7 7M5 10v10a1 1 0 001 1h3m10-11l2 2m-2-2v10a1 1 0 01-1 1h-3m-6 0a1 1 0 001-1v-4a1 1 0 011-1h2a1 1 0 011 1v4a1 1 0 001 1m-6 0h6'></path></svg>
              </a>
              <a href='#' class='block p-2 rounded-md hover:bg-grayscale-100'>
                <svg class='w-5 h-5' fill='none' stroke='currentColor' viewBox='0 0 24 24'><path stroke-linecap='round' stroke-linejoin='round' stroke-width='2' d='M19 11H5m14 0a2 2 0 012 2v6a2 2 0 01-2 2H5a2 2 0 01-2-2v-6a2 2 0 012-2m14 0V9a2 2 0 00-2-2M5 11V9a2 2 0 012-2m0 0V5a2 2 0 012-2h6a2 2 0 012 2v2M7 7h10'></path></svg>
              </a>
              <a href='#' class='block p-2 rounded-md hover:bg-grayscale-100'>
                <svg class='w-5 h-5' fill='none' stroke='currentColor' viewBox='0 0 24 24'><path stroke-linecap='round' stroke-linejoin='round' stroke-width='2' d='M10.325 4.317c.426-1.756 2.924-1.756 3.35 0a1.724 1.724 0 002.573 1.066c1.543-.94 3.31.826 2.37 2.37a1.724 1.724 0 001.065 2.572c1.756.426 1.756 2.924 0 3.35a1.724 1.724 0 00-1.066 2.573c.94 1.543-.826 3.31-2.37 2.37a1.724 1.724 0 00-2.572 1.065c-.426 1.756-2.924 1.756-3.35 0a1.724 1.724 0 00-2.573-1.066c-1.543.94-3.31-.826-2.37-2.37a1.724 1.724 0 00-1.065-2.572c-1.756-.426-1.756-2.924 0-3.35a1.724 1.724 0 001.066-2.573c-.94-1.543.826-3.31 2.37-2.37.996.608 2.296.07 2.572-1.065z'></path><path stroke-linecap='round' stroke-linejoin='round' stroke-width='2' d='M15 12a3 3 0 11-6 0 3 3 0 016 0z'></path></svg>
              </a>
            </nav>".html_safe
          end
        end
      end

      # @label Large Width
      def large_width
        render BetterUi::Drawer::SidebarComponent.new(width: :lg) do |sidebar|
          sidebar.with_navigation { "Large Width Sidebar (320px)" }
        end
      end

      # @label Playground
      # @param variant select { choices: [light, dark, primary] }
      # @param position select { choices: [left, right] }
      # @param width select { choices: [sm, md, lg] }
      # @param collapsible toggle
      def playground(variant: :light, position: :left, width: :md, collapsible: true)
        render BetterUi::Drawer::SidebarComponent.new(
          variant: variant.to_sym,
          position: position.to_sym,
          width: width.to_sym,
          collapsible: collapsible
        ) do |sidebar|
          sidebar.with_header { "Sidebar Header" }
          sidebar.with_navigation { "Sidebar Navigation" }
          sidebar.with_footer { "Sidebar Footer" }
        end
      end
    end
  end
end
