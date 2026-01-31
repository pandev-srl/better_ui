# frozen_string_literal: true

require "test_helper"

module BetterUi
  module Dialog
    class ConfirmComponentTest < ActiveSupport::TestCase
      # Default rendering
      test "renders with default options" do
        render_inline(ConfirmComponent.new(title: "Confirm", text: "Are you sure?"))

        assert_selector "[role='dialog']"
        assert_text "Confirm"
        assert_text "Are you sure?"
        assert_text "Confirm"
        assert_text "Cancel"
      end

      test "renders without title" do
        render_inline(ConfirmComponent.new(text: "Are you sure?"))

        assert_text "Are you sure?"
      end

      test "renders without text" do
        render_inline(ConfirmComponent.new(title: "Confirm Action"))

        assert_text "Confirm Action"
      end

      # Card wrapper
      test "renders content inside a card component" do
        render_inline(ConfirmComponent.new(title: "Confirm"))

        assert_selector ".bg-white.border.border-gray-300"
        assert_selector ".shadow-md"
      end

      # Variant tests
      test "renders warning variant by default" do
        render_inline(ConfirmComponent.new(title: "Confirm"))

        assert_selector ".text-warning-600"
        assert_selector ".bg-warning-100"
      end

      test "renders danger variant" do
        render_inline(ConfirmComponent.new(variant: :danger, title: "Delete?"))

        assert_selector ".text-danger-600"
        assert_selector ".bg-danger-100"
      end

      test "renders success variant" do
        render_inline(ConfirmComponent.new(variant: :success, title: "Save?"))

        assert_selector ".text-success-600"
        assert_selector ".bg-success-100"
      end

      test "renders info variant" do
        render_inline(ConfirmComponent.new(variant: :info, title: "Info"))

        assert_selector ".text-info-600"
        assert_selector ".bg-info-100"
      end

      test "renders primary variant" do
        render_inline(ConfirmComponent.new(variant: :primary, title: "Primary"))

        assert_selector ".text-primary-600"
        assert_selector ".bg-primary-100"
      end

      test "renders secondary variant" do
        render_inline(ConfirmComponent.new(variant: :secondary, title: "Secondary"))

        assert_selector ".text-secondary-600"
        assert_selector ".bg-secondary-100"
      end

      test "renders accent variant" do
        render_inline(ConfirmComponent.new(variant: :accent, title: "Accent"))

        assert_selector ".text-accent-600"
        assert_selector ".bg-accent-100"
      end

      test "renders light variant" do
        render_inline(ConfirmComponent.new(variant: :light, title: "Light"))

        assert_selector ".text-grayscale-600"
        assert_selector ".bg-grayscale-100"
      end

      test "renders dark variant" do
        render_inline(ConfirmComponent.new(variant: :dark, title: "Dark"))

        assert_selector ".text-grayscale-800"
        assert_selector ".bg-grayscale-200"
      end

      test "raises error for invalid variant" do
        error = assert_raises(ArgumentError) do
          ConfirmComponent.new(variant: :invalid)
        end

        assert_match(/Invalid variant/, error.message)
      end

      # Icon tests
      test "renders icon by default" do
        render_inline(ConfirmComponent.new(title: "Confirm"))

        assert_selector "svg"
      end

      test "hides icon when icon is false" do
        render_inline(ConfirmComponent.new(title: "Confirm", icon: false))

        refute_selector ".rounded-full svg"
      end

      test "renders check-circle icon for success" do
        render_inline(ConfirmComponent.new(variant: :success, title: "Save?"))

        assert_selector ".rounded-full svg"
      end

      test "renders exclamation-triangle icon for warning" do
        render_inline(ConfirmComponent.new(variant: :warning, title: "Warning"))

        assert_selector ".rounded-full svg"
      end

      # Button tests
      test "renders confirm button with default label" do
        render_inline(ConfirmComponent.new(title: "Confirm"))

        assert_text "Confirm"
      end

      test "renders cancel button with default label" do
        render_inline(ConfirmComponent.new(title: "Confirm"))

        assert_text "Cancel"
      end

      test "renders confirm button with custom label" do
        render_inline(ConfirmComponent.new(title: "Delete?", confirm_label: "Yes, delete"))

        assert_text "Yes, delete"
      end

      test "renders cancel button with custom label" do
        render_inline(ConfirmComponent.new(title: "Delete?", cancel_label: "No, keep it"))

        assert_text "No, keep it"
      end

      test "confirm button has confirm action" do
        render_inline(ConfirmComponent.new(title: "Confirm"))

        assert_selector "[data-action*='click->better-ui--dialog--dialog#confirm']"
      end

      test "cancel button has cancel action" do
        render_inline(ConfirmComponent.new(title: "Confirm"))

        assert_selector "[data-action*='click->better-ui--dialog--dialog#cancel']"
      end

      # Trigger slot
      test "renders trigger slot" do
        render_inline(ConfirmComponent.new(title: "Confirm")) do |c|
          c.with_trigger { "<button>Delete Item</button>".html_safe }
        end

        assert_selector "button", text: "Delete Item"
      end

      # Dialog configuration defaults
      test "uses sm size by default" do
        render_inline(ConfirmComponent.new(title: "Confirm"))

        assert_selector ".sm\\:max-w-sm"
      end

      test "close_on_backdrop defaults to false" do
        render_inline(ConfirmComponent.new(title: "Confirm"))

        assert_selector "[data-better-ui--dialog--dialog-close-on-backdrop-value='false']"
      end

      test "close_on_escape defaults to false" do
        render_inline(ConfirmComponent.new(title: "Confirm"))

        assert_selector "[data-better-ui--dialog--dialog-close-on-escape-value='false']"
      end

      test "renders without close button" do
        render_inline(ConfirmComponent.new(title: "Confirm"))

        refute_selector "button[aria-label='Close']"
      end

      # Layout structure
      test "renders centered text layout" do
        render_inline(ConfirmComponent.new(title: "Confirm", text: "Message"))

        assert_selector ".text-center"
      end

      test "renders title with correct styling" do
        render_inline(ConfirmComponent.new(title: "My Title"))

        assert_selector "h3.text-lg.font-semibold", text: "My Title"
      end

      test "renders text with correct styling" do
        render_inline(ConfirmComponent.new(text: "My message"))

        assert_selector "p.text-sm.text-grayscale-500", text: "My message"
      end

      # Footer button layout
      test "renders two buttons in card footer" do
        render_inline(ConfirmComponent.new(title: "Confirm"))

        assert_selector ".border-t .flex.flex-col-reverse"
      end

      # Custom options passthrough
      test "passes custom id to dialog" do
        render_inline(ConfirmComponent.new(title: "Confirm", id: "my-confirm"))

        assert_selector "#my-confirm"
      end

      test "allows custom size" do
        render_inline(ConfirmComponent.new(title: "Confirm", size: :lg))

        assert_selector ".sm\\:max-w-lg"
      end

      test "allows close_on_backdrop override" do
        render_inline(ConfirmComponent.new(title: "Confirm", close_on_backdrop: true))

        assert_selector "[data-better-ui--dialog--dialog-close-on-backdrop-value='true']"
      end

      test "allows close_on_escape override" do
        render_inline(ConfirmComponent.new(title: "Confirm", close_on_escape: true))

        assert_selector "[data-better-ui--dialog--dialog-close-on-escape-value='true']"
      end
    end
  end
end
