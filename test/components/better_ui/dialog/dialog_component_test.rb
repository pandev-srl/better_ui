# frozen_string_literal: true

require "test_helper"

module BetterUi
  module Dialog
    class DialogComponentTest < ActiveSupport::TestCase
      # Default rendering
      test "renders with default options" do
        render_inline(DialogComponent.new) { "Dialog content" }

        assert_selector "div[data-controller='better-ui--dialog--dialog']"
        assert_selector "[role='dialog'][aria-modal='true']"
        assert_selector "[hidden]" # closed by default
        assert_text "Dialog content"
      end

      test "renders with open state" do
        render_inline(DialogComponent.new(open: true)) { "Open dialog" }

        assert_selector "[data-better-ui--dialog--dialog-open-value='true']"
        refute_selector "[hidden]"
      end

      # Size tests
      test "renders sm size" do
        render_inline(DialogComponent.new(size: :sm)) { "Small" }

        assert_selector ".sm\\:max-w-sm"
      end

      test "renders md size (default)" do
        render_inline(DialogComponent.new(size: :md)) { "Medium" }

        assert_selector ".sm\\:max-w-md"
      end

      test "renders lg size" do
        render_inline(DialogComponent.new(size: :lg)) { "Large" }

        assert_selector ".sm\\:max-w-lg"
      end

      test "renders xl size" do
        render_inline(DialogComponent.new(size: :xl)) { "XL" }

        assert_selector ".sm\\:max-w-xl"
      end

      test "renders xxl size" do
        render_inline(DialogComponent.new(size: :xxl)) { "XXL" }

        assert_selector ".sm\\:max-w-2xl"
      end

      test "renders full size" do
        render_inline(DialogComponent.new(size: :full)) { "Full" }

        assert_selector ".sm\\:max-w-full"
      end

      test "raises error for invalid size" do
        error = assert_raises(ArgumentError) do
          DialogComponent.new(size: :invalid)
        end

        assert_match(/Invalid size/, error.message)
      end

      # Slot tests
      test "renders trigger slot" do
        render_inline(DialogComponent.new) do |d|
          d.with_trigger { "<button>Open</button>".html_safe }
          "Content"
        end

        assert_selector "button", text: "Open"
        assert_selector "[data-action='click->better-ui--dialog--dialog#open']"
      end

      test "renders block content" do
        render_inline(DialogComponent.new) { "My custom content" }

        assert_text "My custom content"
      end

      test "renders complex block content" do
        render_inline(DialogComponent.new) do
          "<div class=\"my-card\"><p>Rich content</p></div>".html_safe
        end

        assert_selector ".my-card p", text: "Rich content"
      end

      # Close button tests
      test "renders close button by default" do
        render_inline(DialogComponent.new) { "Content" }

        assert_selector "button[aria-label='Close']"
        assert_selector "[data-action='click->better-ui--dialog--dialog#close']"
      end

      test "hides close button when show_close_button is false" do
        render_inline(DialogComponent.new(show_close_button: false)) { "Content" }

        refute_selector "button[aria-label='Close']"
      end

      # Configuration values
      test "sets close_on_backdrop value" do
        render_inline(DialogComponent.new(close_on_backdrop: false)) { "Content" }

        assert_selector "[data-better-ui--dialog--dialog-close-on-backdrop-value='false']"
      end

      test "sets close_on_escape value" do
        render_inline(DialogComponent.new(close_on_escape: false)) { "Content" }

        assert_selector "[data-better-ui--dialog--dialog-close-on-escape-value='false']"
      end

      # Custom options
      test "passes through custom id" do
        render_inline(DialogComponent.new(id: "my-dialog")) { "Content" }

        assert_selector "#my-dialog"
      end

      test "applies container classes" do
        render_inline(DialogComponent.new(container_classes: "custom-panel")) { "Content" }

        assert_selector ".custom-panel"
      end

      # Backdrop
      test "renders backdrop with click action" do
        render_inline(DialogComponent.new) { "Content" }

        assert_selector "[data-better-ui--dialog--dialog-target='backdrop']"
        assert_selector ".bg-black\\/50"
      end

      # Panel target
      test "renders panel target without card styling" do
        render_inline(DialogComponent.new) { "Content" }

        assert_selector "[data-better-ui--dialog--dialog-target='panel']"
        refute_selector ".rounded-lg.bg-white.shadow-xl"
      end

      # Structure
      test "renders fixed overlay structure" do
        render_inline(DialogComponent.new) { "Content" }

        assert_selector ".fixed.inset-0.z-\\[1000\\]"
      end

      test "renders centering wrapper" do
        render_inline(DialogComponent.new) { "Content" }

        assert_selector ".flex.min-h-full.items-center.justify-center"
      end
    end
  end
end
