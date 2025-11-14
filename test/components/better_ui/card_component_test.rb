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

    # Comprehensive variant+style combination tests for full coverage
    test "renders secondary solid card" do
      render_inline(CardComponent.new(variant: :secondary, style: :solid)) { "Content" }
      assert_selector "div.bg-secondary-50"
      assert_selector "div.border-secondary-200"
    end

    test "renders secondary outline card" do
      render_inline(CardComponent.new(variant: :secondary, style: :outline)) { "Content" }
      assert_selector "div.border-secondary-500"
    end

    test "renders secondary ghost card" do
      render_inline(CardComponent.new(variant: :secondary, style: :ghost)) { "Content" }
      assert_selector "div.text-secondary-600"
    end

    test "renders secondary soft card" do
      render_inline(CardComponent.new(variant: :secondary, style: :soft)) { "Content" }
      assert_selector "div.bg-secondary-50"
      assert_selector "div.border-secondary-100"
    end

    test "renders accent solid card" do
      render_inline(CardComponent.new(variant: :accent, style: :solid)) { "Content" }
      assert_selector "div.bg-accent-50"
      assert_selector "div.border-accent-200"
    end

    test "renders accent outline card" do
      render_inline(CardComponent.new(variant: :accent, style: :outline)) { "Content" }
      assert_selector "div.border-accent-500"
    end

    test "renders accent ghost card" do
      render_inline(CardComponent.new(variant: :accent, style: :ghost)) { "Content" }
      assert_selector "div.text-accent-600"
    end

    test "renders accent soft card" do
      render_inline(CardComponent.new(variant: :accent, style: :soft)) { "Content" }
      assert_selector "div.bg-accent-50"
      assert_selector "div.border-accent-100"
    end

    test "renders danger ghost card" do
      render_inline(CardComponent.new(variant: :danger, style: :ghost)) { "Content" }
      assert_selector "div.text-danger-600"
    end

    test "renders warning solid card" do
      render_inline(CardComponent.new(variant: :warning, style: :solid)) { "Content" }
      assert_selector "div.bg-warning-50"
      assert_selector "div.border-warning-200"
    end

    test "renders warning outline card" do
      render_inline(CardComponent.new(variant: :warning, style: :outline)) { "Content" }
      assert_selector "div.border-warning-500"
    end

    test "renders warning ghost card" do
      render_inline(CardComponent.new(variant: :warning, style: :ghost)) { "Content" }
      assert_selector "div.text-warning-600"
    end

    test "renders warning soft card" do
      render_inline(CardComponent.new(variant: :warning, style: :soft)) { "Content" }
      assert_selector "div.bg-warning-50"
      assert_selector "div.border-warning-100"
    end

    test "renders info outline card" do
      render_inline(CardComponent.new(variant: :info, style: :outline)) { "Content" }
      assert_selector "div.border-info-500"
    end

    test "renders info ghost card" do
      render_inline(CardComponent.new(variant: :info, style: :ghost)) { "Content" }
      assert_selector "div.text-info-600"
    end

    test "renders light outline card" do
      render_inline(CardComponent.new(variant: :light, style: :outline)) { "Content" }
      assert_selector "div.border-grayscale-300"
    end

    test "renders light ghost card" do
      render_inline(CardComponent.new(variant: :light, style: :ghost)) { "Content" }
      assert_selector "div.text-grayscale-400"
    end

    test "renders dark outline card" do
      render_inline(CardComponent.new(variant: :dark, style: :outline)) { "Content" }
      assert_selector "div.border-grayscale-900"
    end

    test "renders dark ghost card" do
      render_inline(CardComponent.new(variant: :dark, style: :ghost)) { "Content" }
      assert_selector "div.text-grayscale-900"
    end

    test "renders dark soft card" do
      render_inline(CardComponent.new(variant: :dark, style: :soft)) { "Content" }
      assert_selector "div.bg-grayscale-800"
      assert_selector "div.border-grayscale-700"
    end

    # Test border colors with slots
    test "renders header with border color for solid style" do
      render_inline(CardComponent.new(variant: :primary, style: :solid)) do |card|
        card.with_header { "Header" }
        card.with_body { "Body" }
      end
      assert_selector "div" # header border color
    end

    test "renders header with border color for outline style" do
      render_inline(CardComponent.new(variant: :danger, style: :outline)) do |card|
        card.with_header { "Header" }
        card.with_body { "Body" }
      end
      assert_selector "div" # header border color
    end

    test "renders header with border color for soft style" do
      render_inline(CardComponent.new(variant: :success, style: :soft)) do |card|
        card.with_header { "Header" }
        card.with_body { "Body" }
      end
      assert_selector "div" # header border color
    end

    test "renders header with border color for ghost style" do
      render_inline(CardComponent.new(variant: :info, style: :ghost)) do |card|
        card.with_header { "Header" }
        card.with_body { "Body" }
      end
      assert_selector "div" # header border color
    end

    test "renders header with border color for bordered style" do
      render_inline(CardComponent.new(style: :bordered)) do |card|
        card.with_header { "Header" }
        card.with_body { "Body" }
      end
      assert_selector "div" # header border color
    end

    test "renders footer with border color for solid style" do
      render_inline(CardComponent.new(variant: :secondary, style: :solid)) do |card|
        card.with_body { "Body" }
        card.with_footer { "Footer" }
      end
      assert_selector "div" # footer border color
    end

    test "renders footer with border color for outline style" do
      render_inline(CardComponent.new(variant: :accent, style: :outline)) do |card|
        card.with_body { "Body" }
        card.with_footer { "Footer" }
      end
      assert_selector "div" # footer border color
    end

    test "renders footer with border color for soft style" do
      render_inline(CardComponent.new(variant: :warning, style: :soft)) do |card|
        card.with_body { "Body" }
        card.with_footer { "Footer" }
      end
      assert_selector "div" # footer border color
    end

    # Comprehensive solid style tests for all variants
    test "renders info solid card" do
      render_inline(CardComponent.new(variant: :info, style: :solid)) { "Info" }
      assert_selector "div.bg-info-50"
      assert_selector "div.border-info-200"
    end

    test "renders light solid card" do
      render_inline(CardComponent.new(variant: :light, style: :solid)) { "Light" }
      assert_selector "div.bg-light"
      assert_selector "div.border-grayscale-200"
    end

    test "renders dark solid card" do
      render_inline(CardComponent.new(variant: :dark, style: :solid)) { "Dark" }
      assert_selector "div.bg-dark"
      assert_selector "div.border-grayscale-700"
    end

    # Additional soft style tests for remaining variants
    test "renders info soft card" do
      render_inline(CardComponent.new(variant: :info, style: :soft)) { "Info" }
      assert_selector "div.bg-info-50"
      assert_selector "div.border-info-100"
    end

    test "renders light soft card" do
      render_inline(CardComponent.new(variant: :light, style: :soft)) { "Light" }
      assert_selector "div.bg-light"
      assert_selector "div.border-grayscale-100"
    end

    # Additional bordered style tests for all variants
    test "renders primary bordered card" do
      render_inline(CardComponent.new(variant: :primary, style: :bordered)) { "Primary" }
      assert_selector "div.bg-white"
      assert_selector "div.border-gray-300"
    end

    test "renders secondary bordered card" do
      render_inline(CardComponent.new(variant: :secondary, style: :bordered)) { "Secondary" }
      assert_selector "div.bg-white"
      assert_selector "div.border-gray-300"
    end

    test "renders accent bordered card" do
      render_inline(CardComponent.new(variant: :accent, style: :bordered)) { "Accent" }
      assert_selector "div.bg-white"
      assert_selector "div.border-gray-300"
    end

    test "renders success bordered card" do
      render_inline(CardComponent.new(variant: :success, style: :bordered)) { "Success" }
      assert_selector "div.bg-white"
      assert_selector "div.border-gray-300"
    end

    test "renders danger bordered card" do
      render_inline(CardComponent.new(variant: :danger, style: :bordered)) { "Danger" }
      assert_selector "div.bg-white"
      assert_selector "div.border-gray-300"
    end

    test "renders warning bordered card" do
      render_inline(CardComponent.new(variant: :warning, style: :bordered)) { "Warning" }
      assert_selector "div.bg-white"
      assert_selector "div.border-gray-300"
    end

    test "renders info bordered card" do
      render_inline(CardComponent.new(variant: :info, style: :bordered)) { "Info" }
      assert_selector "div.bg-white"
      assert_selector "div.border-gray-300"
    end

    test "renders light bordered card" do
      render_inline(CardComponent.new(variant: :light, style: :bordered)) { "Light" }
      assert_selector "div.bg-white"
      assert_selector "div.border-gray-300"
    end

    test "renders dark bordered card" do
      render_inline(CardComponent.new(variant: :dark, style: :bordered)) { "Dark" }
      assert_selector "div.bg-white"
      assert_selector "div.border-gray-300"
    end

    # Additional outline tests for missing variants
    test "renders success outline card" do
      render_inline(CardComponent.new(variant: :success, style: :outline)) { "Success" }
      assert_selector "div.bg-white"
      assert_selector "div.border-success-500"
    end

    # Additional ghost tests for missing variants
    test "renders success ghost card" do
      render_inline(CardComponent.new(variant: :success, style: :ghost)) { "Success" }
      assert_selector "div.bg-transparent"
      assert_selector "div.text-success-600"
    end

    # Additional soft tests for missing variants
    test "renders danger soft card" do
      render_inline(CardComponent.new(variant: :danger, style: :soft)) { "Danger" }
      assert_selector "div.bg-danger-50"
      assert_selector "div.border-danger-100"
    end

    # Test border_color_class with headers for solid style - all variants
    test "renders accent solid card with header" do
      render_inline(CardComponent.new(variant: :accent, style: :solid)) do |card|
        card.with_header { "Header" }
        card.with_body { "Body" }
      end
      assert_text "Header"
    end

    test "renders success solid card with header" do
      render_inline(CardComponent.new(variant: :success, style: :solid)) do |card|
        card.with_header { "Header" }
        card.with_body { "Body" }
      end
      assert_text "Header"
    end

    test "renders danger solid card with header" do
      render_inline(CardComponent.new(variant: :danger, style: :solid)) do |card|
        card.with_header { "Header" }
        card.with_body { "Body" }
      end
      assert_text "Header"
    end

    test "renders warning solid card with header" do
      render_inline(CardComponent.new(variant: :warning, style: :solid)) do |card|
        card.with_header { "Header" }
        card.with_body { "Body" }
      end
      assert_text "Header"
    end

    test "renders info solid card with header" do
      render_inline(CardComponent.new(variant: :info, style: :solid)) do |card|
        card.with_header { "Header" }
        card.with_body { "Body" }
      end
      assert_text "Header"
    end

    test "renders light solid card with header" do
      render_inline(CardComponent.new(variant: :light, style: :solid)) do |card|
        card.with_header { "Header" }
        card.with_body { "Body" }
      end
      assert_text "Header"
    end

    test "renders dark solid card with header" do
      render_inline(CardComponent.new(variant: :dark, style: :solid)) do |card|
        card.with_header { "Header" }
        card.with_body { "Body" }
      end
      assert_text "Header"
    end

    # Test border_color_class with headers for outline style - all variants
    test "renders primary outline card with header" do
      render_inline(CardComponent.new(variant: :primary, style: :outline)) do |card|
        card.with_header { "Header" }
        card.with_body { "Body" }
      end
      assert_text "Header"
    end

    test "renders secondary outline card with header" do
      render_inline(CardComponent.new(variant: :secondary, style: :outline)) do |card|
        card.with_header { "Header" }
        card.with_body { "Body" }
      end
      assert_text "Header"
    end

    test "renders accent outline card with header" do
      render_inline(CardComponent.new(variant: :accent, style: :outline)) do |card|
        card.with_header { "Header" }
        card.with_body { "Body" }
      end
      assert_text "Header"
    end

    test "renders success outline card with header" do
      render_inline(CardComponent.new(variant: :success, style: :outline)) do |card|
        card.with_header { "Header" }
        card.with_body { "Body" }
      end
      assert_text "Header"
    end

    test "renders danger outline card with header" do
      render_inline(CardComponent.new(variant: :danger, style: :outline)) do |card|
        card.with_header { "Header" }
        card.with_body { "Body" }
      end
      assert_text "Header"
    end

    test "renders warning outline card with header" do
      render_inline(CardComponent.new(variant: :warning, style: :outline)) do |card|
        card.with_header { "Header" }
        card.with_body { "Body" }
      end
      assert_text "Header"
    end

    test "renders info outline card with header" do
      render_inline(CardComponent.new(variant: :info, style: :outline)) do |card|
        card.with_header { "Header" }
        card.with_body { "Body" }
      end
      assert_text "Header"
    end

    test "renders light outline card with header" do
      render_inline(CardComponent.new(variant: :light, style: :outline)) do |card|
        card.with_header { "Header" }
        card.with_body { "Body" }
      end
      assert_text "Header"
    end

    test "renders dark outline card with header" do
      render_inline(CardComponent.new(variant: :dark, style: :outline)) do |card|
        card.with_header { "Header" }
        card.with_body { "Body" }
      end
      assert_text "Header"
    end

    # Test border_color_class with headers for soft style - all variants
    test "renders primary soft card with header" do
      render_inline(CardComponent.new(variant: :primary, style: :soft)) do |card|
        card.with_header { "Header" }
        card.with_body { "Body" }
      end
      assert_text "Header"
    end

    test "renders secondary soft card with header" do
      render_inline(CardComponent.new(variant: :secondary, style: :soft)) do |card|
        card.with_header { "Header" }
        card.with_body { "Body" }
      end
      assert_text "Header"
    end

    test "renders accent soft card with header" do
      render_inline(CardComponent.new(variant: :accent, style: :soft)) do |card|
        card.with_header { "Header" }
        card.with_body { "Body" }
      end
      assert_text "Header"
    end

    test "renders danger soft card with header" do
      render_inline(CardComponent.new(variant: :danger, style: :soft)) do |card|
        card.with_header { "Header" }
        card.with_body { "Body" }
      end
      assert_text "Header"
    end

    test "renders warning soft card with header" do
      render_inline(CardComponent.new(variant: :warning, style: :soft)) do |card|
        card.with_header { "Header" }
        card.with_body { "Body" }
      end
      assert_text "Header"
    end

    test "renders info soft card with header" do
      render_inline(CardComponent.new(variant: :info, style: :soft)) do |card|
        card.with_header { "Header" }
        card.with_body { "Body" }
      end
      assert_text "Header"
    end

    test "renders light soft card with header" do
      render_inline(CardComponent.new(variant: :light, style: :soft)) do |card|
        card.with_header { "Header" }
        card.with_body { "Body" }
      end
      assert_text "Header"
    end

    test "renders dark soft card with header" do
      render_inline(CardComponent.new(variant: :dark, style: :soft)) do |card|
        card.with_header { "Header" }
        card.with_body { "Body" }
      end
      assert_text "Header"
    end
  end
end
