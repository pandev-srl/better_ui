# frozen_string_literal: true

require "test_helper"

module BetterUi
  module Dialog
    class AlertComponentTest < ActiveSupport::TestCase
      # Default rendering
      test "renders with default options" do
        render_inline(AlertComponent.new(title: "Alert", text: "Something happened"))

        assert_selector "[role='dialog']"
        assert_text "Alert"
        assert_text "Something happened"
        assert_text "OK"
      end

      test "renders without title" do
        render_inline(AlertComponent.new(text: "Just a message"))

        assert_text "Just a message"
      end

      test "renders without text" do
        render_inline(AlertComponent.new(title: "Title Only"))

        assert_text "Title Only"
      end

      # Card wrapper
      test "renders content inside a card component" do
        render_inline(AlertComponent.new(title: "Alert"))

        assert_selector ".bg-white.border.border-grayscale-300"
        assert_selector ".shadow-sm"
      end

      # Variant tests
      test "renders info variant by default" do
        render_inline(AlertComponent.new(title: "Info"))

        assert_selector ".text-info-600"
        assert_selector ".bg-info-100"
      end

      test "renders success variant" do
        render_inline(AlertComponent.new(variant: :success, title: "Success"))

        assert_selector ".text-success-600"
        assert_selector ".bg-success-100"
      end

      test "renders danger variant" do
        render_inline(AlertComponent.new(variant: :danger, title: "Error"))

        assert_selector ".text-danger-600"
        assert_selector ".bg-danger-100"
      end

      test "renders warning variant" do
        render_inline(AlertComponent.new(variant: :warning, title: "Warning"))

        assert_selector ".text-warning-600"
        assert_selector ".bg-warning-100"
      end

      test "renders primary variant" do
        render_inline(AlertComponent.new(variant: :primary, title: "Primary"))

        assert_selector ".text-primary-600"
        assert_selector ".bg-primary-100"
      end

      test "renders secondary variant" do
        render_inline(AlertComponent.new(variant: :secondary, title: "Secondary"))

        assert_selector ".text-secondary-600"
        assert_selector ".bg-secondary-100"
      end

      test "renders accent variant" do
        render_inline(AlertComponent.new(variant: :accent, title: "Accent"))

        assert_selector ".text-accent-600"
        assert_selector ".bg-accent-100"
      end

      test "renders light variant" do
        render_inline(AlertComponent.new(variant: :light, title: "Light"))

        assert_selector ".text-grayscale-600"
        assert_selector ".bg-grayscale-100"
      end

      test "renders dark variant" do
        render_inline(AlertComponent.new(variant: :dark, title: "Dark"))

        assert_selector ".text-grayscale-800"
        assert_selector ".bg-grayscale-200"
      end

      test "raises error for invalid variant" do
        error = assert_raises(ArgumentError) do
          AlertComponent.new(variant: :invalid)
        end

        assert_match(/Invalid variant/, error.message)
      end

      # Icon tests
      test "renders icon by default" do
        render_inline(AlertComponent.new(title: "With Icon"))

        assert_selector "svg"
      end

      test "hides icon when icon is false" do
        render_inline(AlertComponent.new(title: "No Icon", icon: false))

        refute_selector ".rounded-full svg"
      end

      test "renders check-circle icon for success" do
        render_inline(AlertComponent.new(variant: :success, title: "Success"))

        assert_selector ".rounded-full svg"
      end

      test "renders exclamation-circle icon for danger" do
        render_inline(AlertComponent.new(variant: :danger, title: "Danger"))

        assert_selector ".rounded-full svg"
      end

      test "renders exclamation-triangle icon for warning" do
        render_inline(AlertComponent.new(variant: :warning, title: "Warning"))

        assert_selector ".rounded-full svg"
      end

      test "renders information-circle icon for info" do
        render_inline(AlertComponent.new(variant: :info, title: "Info"))

        assert_selector ".rounded-full svg"
      end

      # Button tests
      test "renders OK button with default label" do
        render_inline(AlertComponent.new(title: "Alert"))

        assert_text "OK"
      end

      test "renders OK button with custom label" do
        render_inline(AlertComponent.new(title: "Alert", button_label: "Got it"))

        assert_text "Got it"
      end

      test "OK button has close action" do
        render_inline(AlertComponent.new(title: "Alert"))

        assert_selector "[data-action*='click->better-ui--dialog--dialog#close']"
      end

      # Trigger slot
      test "renders trigger slot" do
        render_inline(AlertComponent.new(title: "Alert")) do |a|
          a.with_trigger { "<button>Show Alert</button>".html_safe }
        end

        assert_selector "button", text: "Show Alert"
      end

      # Dialog configuration
      test "uses sm size by default" do
        render_inline(AlertComponent.new(title: "Alert"))

        assert_selector ".sm\\:max-w-sm"
      end

      test "renders without close button" do
        render_inline(AlertComponent.new(title: "Alert"))

        refute_selector "button[aria-label='Close']"
      end

      test "passes close_on_backdrop option" do
        render_inline(AlertComponent.new(title: "Alert", close_on_backdrop: false))

        assert_selector "[data-better-ui--dialog--dialog-close-on-backdrop-value='false']"
      end

      test "passes close_on_escape option" do
        render_inline(AlertComponent.new(title: "Alert", close_on_escape: false))

        assert_selector "[data-better-ui--dialog--dialog-close-on-escape-value='false']"
      end

      # Layout structure
      test "renders centered text layout" do
        render_inline(AlertComponent.new(title: "Alert", text: "Message"))

        assert_selector ".text-center"
      end

      test "renders title with correct styling" do
        render_inline(AlertComponent.new(title: "My Title"))

        assert_selector "h3.text-lg.font-semibold", text: "My Title"
      end

      test "renders text with correct styling" do
        render_inline(AlertComponent.new(text: "My message"))

        assert_selector "p.text-sm.text-grayscale-500", text: "My message"
      end

      # Footer button layout
      test "renders button in card footer" do
        render_inline(AlertComponent.new(title: "Alert"))

        assert_selector ".border-t .flex.flex-col-reverse"
      end

      # Custom options passthrough
      test "passes custom id to dialog" do
        render_inline(AlertComponent.new(title: "Alert", id: "my-alert"))

        assert_selector "#my-alert"
      end
    end
  end
end
