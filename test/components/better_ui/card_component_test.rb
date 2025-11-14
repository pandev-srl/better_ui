# frozen_string_literal: true

require "test_helper"

module BetterUi
  class CardComponentTest < ActiveSupport::TestCase
    test "renders with default options" do
      render_inline(CardComponent.new) { "Card content" }

      assert_selector "div.flex.flex-col"
      assert_selector "div.rounded-lg" # default size (md)
      assert_selector "div.bg-primary-50" # default variant (primary) with solid style
      assert_selector "div.shadow-md" # default shadow
      assert_text "Card content"
    end

    test "renders with custom content" do
      render_inline(CardComponent.new) { "Custom content here" }

      assert_text "Custom content here"
    end

    # Slot tests
    test "renders with header slot" do
      render_inline(CardComponent.new) do |card|
        card.with_header { "Card Header" }
        "Body content"
      end

      assert_text "Card Header"
      assert_text "Body content"
      assert_selector "div.border-b" # header divider
    end

    test "renders with body slot" do
      render_inline(CardComponent.new) do |card|
        card.with_body { "Card Body" }
      end

      assert_text "Card Body"
    end

    test "renders with footer slot" do
      render_inline(CardComponent.new) do |card|
        card.with_footer { "Card Footer" }
        "Body content"
      end

      assert_text "Card Footer"
      assert_text "Body content"
      assert_selector "div.border-t" # footer divider
    end

    test "renders with all slots" do
      render_inline(CardComponent.new) do |card|
        card.with_header { "Header" }
        card.with_body { "Body" }
        card.with_footer { "Footer" }
      end

      assert_text "Header"
      assert_text "Body"
      assert_text "Footer"
    end

    # Variant tests
    test "renders primary variant with solid style" do
      render_inline(CardComponent.new(variant: :primary, style: :solid)) { "Content" }

      assert_selector "div.bg-primary-50"
      assert_selector "div.border-primary-200"
    end

    test "renders secondary variant with solid style" do
      render_inline(CardComponent.new(variant: :secondary, style: :solid)) { "Content" }

      assert_selector "div.bg-secondary-50"
    end

    test "renders success variant with solid style" do
      render_inline(CardComponent.new(variant: :success, style: :solid)) { "Content" }

      assert_selector "div.bg-success-50"
    end

    test "renders danger variant with solid style" do
      render_inline(CardComponent.new(variant: :danger, style: :solid)) { "Content" }

      assert_selector "div.bg-danger-50"
    end

    test "renders warning variant with solid style" do
      render_inline(CardComponent.new(variant: :warning, style: :solid)) { "Content" }

      assert_selector "div.bg-warning-50"
    end

    test "renders info variant with solid style" do
      render_inline(CardComponent.new(variant: :info, style: :solid)) { "Content" }

      assert_selector "div.bg-info-50"
    end

    test "renders light variant with solid style" do
      render_inline(CardComponent.new(variant: :light, style: :solid)) { "Content" }

      assert_selector "div.bg-light"
    end

    test "renders dark variant with solid style" do
      render_inline(CardComponent.new(variant: :dark, style: :solid)) { "Content" }

      assert_selector "div.bg-dark"
      assert_selector "div.text-grayscale-50"
    end

    test "raises error for invalid variant" do
      error = assert_raises(ArgumentError) do
        CardComponent.new(variant: :invalid)
      end

      assert_match(/Invalid variant/, error.message)
    end

    # Style tests
    test "renders solid style" do
      render_inline(CardComponent.new(style: :solid)) { "Content" }

      assert_selector "div.bg-primary-50"
      assert_selector "div.border"
    end

    test "renders outline style" do
      render_inline(CardComponent.new(style: :outline)) { "Content" }

      assert_selector "div.bg-white"
      assert_selector "div.border-2"
      assert_selector "div.border-primary-500"
    end

    test "renders ghost style" do
      render_inline(CardComponent.new(style: :ghost)) { "Content" }

      assert_selector "div.bg-transparent"
    end

    test "renders soft style" do
      render_inline(CardComponent.new(style: :soft)) { "Content" }

      assert_selector "div.bg-primary-50"
      assert_selector "div.border-primary-100"
    end

    test "renders bordered style" do
      render_inline(CardComponent.new(style: :bordered)) { "Content" }

      assert_selector "div.bg-white"
      assert_selector "div.border-gray-300"
    end

    test "raises error for invalid style" do
      error = assert_raises(ArgumentError) do
        CardComponent.new(style: :invalid)
      end

      assert_match(/Invalid style/, error.message)
    end

    # Size tests
    test "renders xs size" do
      render_inline(CardComponent.new(size: :xs)) { "Content" }

      assert_selector "div.p-3"
      assert_selector "div.text-xs"
      assert_selector "div.rounded"
    end

    test "renders sm size" do
      render_inline(CardComponent.new(size: :sm)) { "Content" }

      assert_selector "div.p-4"
      assert_selector "div.text-sm"
      assert_selector "div.rounded-md"
    end

    test "renders md size" do
      render_inline(CardComponent.new(size: :md)) { "Content" }

      assert_selector "div.p-6"
      assert_selector "div.text-base"
      assert_selector "div.rounded-lg"
    end

    test "renders lg size" do
      render_inline(CardComponent.new(size: :lg)) { "Content" }

      assert_selector "div.p-8"
      assert_selector "div.text-lg"
    end

    test "renders xl size" do
      render_inline(CardComponent.new(size: :xl)) { "Content" }

      assert_selector "div.p-10"
      assert_selector "div.text-xl"
      assert_selector "div.rounded-xl"
    end

    test "raises error for invalid size" do
      error = assert_raises(ArgumentError) do
        CardComponent.new(size: :invalid)
      end

      assert_match(/Invalid size/, error.message)
    end

    # Shadow tests
    test "renders with shadow by default" do
      render_inline(CardComponent.new) { "Content" }

      assert_selector "div.shadow-md"
    end

    test "renders without shadow when disabled" do
      render_inline(CardComponent.new(shadow: false)) { "Content" }

      refute_selector "div.shadow-md"
    end

    # Padding tests
    test "renders with header padding by default" do
      render_inline(CardComponent.new) do |card|
        card.with_header { "Header" }
        "Content"
      end

      # Header should have padding
      assert_selector "div.border-b.p-6"
    end

    test "renders without header padding when disabled" do
      render_inline(CardComponent.new(header_padding: false)) do |card|
        card.with_header { "Header" }
        "Content"
      end

      assert_selector "div.border-b"
    end

    test "renders with body padding by default" do
      render_inline(CardComponent.new) do |card|
        card.with_body { "Body" }
      end

      # Body should have padding
      assert_selector "div.p-6"
    end

    test "renders without body padding when disabled" do
      render_inline(CardComponent.new(body_padding: false)) do |card|
        card.with_body { "Body" }
      end

      # Body should not have padding
      refute_selector "div.p-6 > div.p-6"
    end

    test "renders with footer padding by default" do
      render_inline(CardComponent.new) do |card|
        card.with_footer { "Footer" }
        "Content"
      end

      # Footer should have padding
      assert_selector "div.border-t.p-6"
    end

    test "renders without footer padding when disabled" do
      render_inline(CardComponent.new(footer_padding: false)) do |card|
        card.with_footer { "Footer" }
        "Content"
      end

      assert_selector "div.border-t"
    end

    # Custom class tests
    test "renders with custom container classes" do
      render_inline(CardComponent.new(container_classes: "custom-class")) { "Content" }

      assert_selector "div.custom-class"
    end

    test "renders with custom header classes" do
      render_inline(CardComponent.new(header_classes: "custom-header")) do |card|
        card.with_header { "Header" }
        "Content"
      end

      assert_selector "div.custom-header"
    end

    test "renders with custom body classes" do
      render_inline(CardComponent.new(body_classes: "custom-body")) do |card|
        card.with_body { "Body" }
      end

      assert_selector "div.custom-body"
    end

    test "renders with custom footer classes" do
      render_inline(CardComponent.new(footer_classes: "custom-footer")) do |card|
        card.with_footer { "Footer" }
        "Content"
      end

      assert_selector "div.custom-footer"
    end

    # Additional HTML options tests
    test "passes through additional HTML options" do
      render_inline(CardComponent.new(id: "my-card", data: { controller: "custom" })) { "Content" }

      assert_selector "div#my-card"
      assert_selector "div[data-controller='custom']"
    end

    # Combined style and variant tests
    test "renders danger outline card" do
      render_inline(CardComponent.new(variant: :danger, style: :outline)) { "Danger" }

      assert_selector "div.bg-white"
      assert_selector "div.border-2.border-danger-500"
      assert_selector "div.text-danger-700"
    end

    test "renders success soft card" do
      render_inline(CardComponent.new(variant: :success, style: :soft)) { "Success" }

      assert_selector "div.bg-success-50"
      assert_selector "div.border-success-100"
      assert_selector "div.text-success-800"
    end

    test "renders ghost card with no background" do
      render_inline(CardComponent.new(style: :ghost)) { "Ghost" }

      assert_selector "div.bg-transparent"
    end
  end
end
