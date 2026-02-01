# frozen_string_literal: true

require "test_helper"

module BetterUi
  class HeadingComponentTest < ActiveSupport::TestCase
    # Default rendering
    test "renders with default options" do
      render_inline(HeadingComponent.new) { "Page Title" }

      assert_selector "h2", text: "Page Title"
      assert_selector "h2.text-3xl"
      assert_selector "h2.font-semibold"
      assert_selector "div.text-left"
    end

    test "renders heading text content" do
      render_inline(HeadingComponent.new) { "Custom Heading Text" }

      assert_text "Custom Heading Text"
    end

    # Level tests - all 6 levels
    test "renders h1 level" do
      render_inline(HeadingComponent.new(level: :h1)) { "Heading 1" }

      assert_selector "h1", text: "Heading 1"
      assert_selector "h1.text-4xl"
      assert_selector "h1.font-bold"
    end

    test "renders h2 level" do
      render_inline(HeadingComponent.new(level: :h2)) { "Heading 2" }

      assert_selector "h2", text: "Heading 2"
      assert_selector "h2.text-3xl"
      assert_selector "h2.font-semibold"
    end

    test "renders h3 level" do
      render_inline(HeadingComponent.new(level: :h3)) { "Heading 3" }

      assert_selector "h3", text: "Heading 3"
      assert_selector "h3.text-2xl"
      assert_selector "h3.font-semibold"
    end

    test "renders h4 level" do
      render_inline(HeadingComponent.new(level: :h4)) { "Heading 4" }

      assert_selector "h4", text: "Heading 4"
      assert_selector "h4.text-xl"
      assert_selector "h4.font-medium"
    end

    test "renders h5 level" do
      render_inline(HeadingComponent.new(level: :h5)) { "Heading 5" }

      assert_selector "h5", text: "Heading 5"
      assert_selector "h5.text-lg"
      assert_selector "h5.font-medium"
    end

    test "renders h6 level" do
      render_inline(HeadingComponent.new(level: :h6)) { "Heading 6" }

      assert_selector "h6", text: "Heading 6"
      assert_selector "h6.text-base"
      assert_selector "h6.font-medium"
    end

    test "raises error for invalid level" do
      error = assert_raises(ArgumentError) do
        HeadingComponent.new(level: :h7)
      end

      assert_match(/Invalid level/, error.message)
    end

    # Alignment tests
    test "renders with left alignment by default" do
      render_inline(HeadingComponent.new) { "Left" }

      assert_selector "div.text-left"
    end

    test "renders with center alignment" do
      render_inline(HeadingComponent.new(align: :center)) { "Center" }

      assert_selector "div.text-center"
    end

    test "renders with right alignment" do
      render_inline(HeadingComponent.new(align: :right)) { "Right" }

      assert_selector "div.text-right"
    end

    test "raises error for invalid align" do
      error = assert_raises(ArgumentError) do
        HeadingComponent.new(align: :justify)
      end

      assert_match(/Invalid align/, error.message)
    end

    # Variant tests - all 9 variants
    test "renders without color class when variant is nil" do
      render_inline(HeadingComponent.new(variant: nil)) { "No Color" }

      assert_selector "h2"
      refute_selector "h2.text-primary-600"
      refute_selector "h2.text-secondary-600"
      refute_selector "h2.text-accent-600"
      refute_selector "h2.text-success-600"
      refute_selector "h2.text-danger-600"
      refute_selector "h2.text-warning-600"
      refute_selector "h2.text-info-600"
      refute_selector "h2.text-grayscale-400"
      refute_selector "h2.text-grayscale-900"
    end

    test "renders primary variant" do
      render_inline(HeadingComponent.new(variant: :primary)) { "Primary" }

      assert_selector "h2.text-primary-600"
    end

    test "renders secondary variant" do
      render_inline(HeadingComponent.new(variant: :secondary)) { "Secondary" }

      assert_selector "h2.text-secondary-600"
    end

    test "renders accent variant" do
      render_inline(HeadingComponent.new(variant: :accent)) { "Accent" }

      assert_selector "h2.text-accent-600"
    end

    test "renders success variant" do
      render_inline(HeadingComponent.new(variant: :success)) { "Success" }

      assert_selector "h2.text-success-600"
    end

    test "renders danger variant" do
      render_inline(HeadingComponent.new(variant: :danger)) { "Danger" }

      assert_selector "h2.text-danger-600"
    end

    test "renders warning variant" do
      render_inline(HeadingComponent.new(variant: :warning)) { "Warning" }

      assert_selector "h2.text-warning-600"
    end

    test "renders info variant" do
      render_inline(HeadingComponent.new(variant: :info)) { "Info" }

      assert_selector "h2.text-info-600"
    end

    test "renders light variant" do
      render_inline(HeadingComponent.new(variant: :light)) { "Light" }

      assert_selector "h2.text-grayscale-400"
    end

    test "renders dark variant" do
      render_inline(HeadingComponent.new(variant: :dark)) { "Dark" }

      assert_selector "h2.text-grayscale-900"
    end

    test "raises error for invalid variant" do
      error = assert_raises(ArgumentError) do
        HeadingComponent.new(variant: :invalid)
      end

      assert_match(/Invalid variant/, error.message)
    end

    # Subtitle as string parameter
    test "renders subtitle from string parameter" do
      render_inline(HeadingComponent.new(subtitle: "A brief description")) { "Title" }

      assert_selector "p.text-grayscale-500", text: "A brief description"
      assert_selector "p.mt-1"
    end

    test "does not render subtitle paragraph when subtitle is nil and slot is empty" do
      render_inline(HeadingComponent.new) { "Title" }

      refute_selector "p"
    end

    # Subtitle as slot
    test "renders subtitle from slot" do
      render_inline(HeadingComponent.new) do |heading|
        heading.with_subtitle { "Slot subtitle content" }
        "Title"
      end

      assert_selector "p.text-grayscale-500", text: "Slot subtitle content"
    end

    test "subtitle slot takes precedence over string parameter" do
      render_inline(HeadingComponent.new(subtitle: "String subtitle")) do |heading|
        heading.with_subtitle { "Slot subtitle" }
        "Title"
      end

      assert_selector "p", text: "Slot subtitle"
    end

    # Subtitle size varies by heading level
    test "h1 subtitle has text-lg size" do
      render_inline(HeadingComponent.new(level: :h1, subtitle: "Sub")) { "Title" }

      assert_selector "p.text-lg"
    end

    test "h2 subtitle has text-base size" do
      render_inline(HeadingComponent.new(level: :h2, subtitle: "Sub")) { "Title" }

      assert_selector "p.text-base"
    end

    test "h3 subtitle has text-sm size" do
      render_inline(HeadingComponent.new(level: :h3, subtitle: "Sub")) { "Title" }

      assert_selector "p.text-sm"
    end

    test "h4 subtitle has text-sm size" do
      render_inline(HeadingComponent.new(level: :h4, subtitle: "Sub")) { "Title" }

      assert_selector "p.text-sm"
    end

    test "h5 subtitle has text-xs size" do
      render_inline(HeadingComponent.new(level: :h5, subtitle: "Sub")) { "Title" }

      assert_selector "p.text-xs"
    end

    test "h6 subtitle has text-xs size" do
      render_inline(HeadingComponent.new(level: :h6, subtitle: "Sub")) { "Title" }

      assert_selector "p.text-xs"
    end

    # Actions slot
    test "renders actions slot" do
      render_inline(HeadingComponent.new) do |heading|
        heading.with_actions { '<button class="action-btn">Add</button>'.html_safe }
        "Title"
      end

      assert_selector "div.flex.items-center.gap-2"
      assert_selector "button.action-btn", text: "Add"
    end

    test "does not render actions container when actions slot is empty" do
      render_inline(HeadingComponent.new) { "Title" }

      # The flex justify-between wrapper is always there, but the actions div should not be
      refute_selector "div.flex.items-center.gap-2"
    end

    # Divider
    test "renders divider when divider is true" do
      render_inline(HeadingComponent.new(divider: true)) { "Title" }

      assert_selector "div.border-b"
      assert_selector "div.border-grayscale-200"
      assert_selector "div.pb-3"
    end

    test "does not render divider when divider is false" do
      render_inline(HeadingComponent.new(divider: false)) { "Title" }

      refute_selector "div.border-b"
      refute_selector "div.pb-3"
    end

    # Container classes
    test "renders with custom container classes" do
      render_inline(HeadingComponent.new(container_classes: "mb-8 custom-heading")) { "Title" }

      assert_selector "div.mb-8"
      assert_selector "div.custom-heading"
    end

    # Additional HTML options
    test "passes through additional HTML options to the heading element" do
      render_inline(HeadingComponent.new(id: "main-heading", data: { testid: "heading" })) { "Title" }

      assert_selector "h2#main-heading"
      assert_selector "h2[data-testid='heading']"
    end

    # Correct HTML heading tag rendering
    test "renders correct HTML heading tag for each level" do
      BetterUi::HeadingComponent::LEVELS.each do |level|
        render_inline(HeadingComponent.new(level: level)) { "Test" }

        assert_selector level.to_s, text: "Test"
      end
    end

    # Combined options
    test "renders with all options combined" do
      render_inline(HeadingComponent.new(
        level: :h1,
        variant: :primary,
        align: :center,
        divider: true,
        subtitle: "A great subtitle",
        container_classes: "mb-6"
      )) { "Full Featured Heading" }

      assert_selector "h1.text-4xl.font-bold.text-primary-600", text: "Full Featured Heading"
      assert_selector "div.text-center"
      assert_selector "div.border-b"
      assert_selector "div.mb-6"
      assert_selector "p.text-grayscale-500", text: "A great subtitle"
    end

    test "renders heading with both actions and subtitle" do
      render_inline(HeadingComponent.new(subtitle: "Description text")) do |heading|
        heading.with_actions { "<button>Action</button>".html_safe }
        "Title"
      end

      assert_selector "h2", text: "Title"
      assert_selector "div.flex.items-center.gap-2"
      assert_selector "button", text: "Action"
      assert_selector "p.text-grayscale-500", text: "Description text"
    end
  end
end
