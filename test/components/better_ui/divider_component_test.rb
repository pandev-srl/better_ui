# frozen_string_literal: true

require "test_helper"

module BetterUi
  class DividerComponentTest < ActiveSupport::TestCase
    # Default rendering
    test "renders with default options" do
      render_inline(DividerComponent.new)

      assert_selector "hr"
      assert_selector "hr.border-solid"
      assert_selector "hr.border-grayscale-300"
      assert_selector "hr.border-t-4"
      assert_selector "hr.my-4"
    end

    # Orientation tests
    test "renders horizontal divider by default" do
      render_inline(DividerComponent.new)

      assert_selector "hr"
    end

    test "renders vertical divider" do
      render_inline(DividerComponent.new(orientation: :vertical))

      assert_selector "div[role='separator']"
      assert_selector "div.inline-block"
      assert_selector "div.h-full"
      assert_selector "div.min-h-\\[1em\\]"
      assert_selector "div.border-l-4"
      assert_selector "div.mx-4"
    end

    test "raises error for invalid orientation" do
      error = assert_raises(ArgumentError) do
        DividerComponent.new(orientation: :diagonal)
      end

      assert_match(/Invalid orientation/, error.message)
    end

    # Style tests
    test "renders solid style" do
      render_inline(DividerComponent.new(style: :solid))

      assert_selector "hr.border-solid"
    end

    test "renders dashed style" do
      render_inline(DividerComponent.new(style: :dashed))

      assert_selector "hr.border-dashed"
    end

    test "renders dotted style" do
      render_inline(DividerComponent.new(style: :dotted))

      assert_selector "hr.border-dotted"
    end

    test "raises error for invalid style" do
      error = assert_raises(ArgumentError) do
        DividerComponent.new(style: :double)
      end

      assert_match(/Invalid style/, error.message)
    end

    # Variant tests
    test "renders default gray when variant is nil" do
      render_inline(DividerComponent.new)

      assert_selector "hr.border-grayscale-300"
    end

    test "renders primary variant" do
      render_inline(DividerComponent.new(variant: :primary))

      assert_selector "hr.border-primary-300"
    end

    test "renders secondary variant" do
      render_inline(DividerComponent.new(variant: :secondary))

      assert_selector "hr.border-secondary-300"
    end

    test "renders accent variant" do
      render_inline(DividerComponent.new(variant: :accent))

      assert_selector "hr.border-accent-300"
    end

    test "renders success variant" do
      render_inline(DividerComponent.new(variant: :success))

      assert_selector "hr.border-success-300"
    end

    test "renders danger variant" do
      render_inline(DividerComponent.new(variant: :danger))

      assert_selector "hr.border-danger-300"
    end

    test "renders warning variant" do
      render_inline(DividerComponent.new(variant: :warning))

      assert_selector "hr.border-warning-300"
    end

    test "renders info variant" do
      render_inline(DividerComponent.new(variant: :info))

      assert_selector "hr.border-info-300"
    end

    test "renders light variant" do
      render_inline(DividerComponent.new(variant: :light))

      assert_selector "hr.border-grayscale-200"
    end

    test "renders dark variant" do
      render_inline(DividerComponent.new(variant: :dark))

      assert_selector "hr.border-grayscale-600"
    end

    test "raises error for invalid variant" do
      error = assert_raises(ArgumentError) do
        DividerComponent.new(variant: :neon)
      end

      assert_match(/Invalid variant/, error.message)
    end

    # Size tests
    test "renders xs size horizontal" do
      render_inline(DividerComponent.new(size: :xs))

      assert_selector "hr.border-t"
    end

    test "renders sm size horizontal" do
      render_inline(DividerComponent.new(size: :sm))

      assert_selector "hr.border-t-2"
    end

    test "renders md size horizontal" do
      render_inline(DividerComponent.new(size: :md))

      assert_selector "hr.border-t-4"
    end

    test "renders xs size vertical" do
      render_inline(DividerComponent.new(orientation: :vertical, size: :xs))

      assert_selector "div.border-l"
    end

    test "renders sm size vertical" do
      render_inline(DividerComponent.new(orientation: :vertical, size: :sm))

      assert_selector "div.border-l-2"
    end

    test "renders md size vertical" do
      render_inline(DividerComponent.new(orientation: :vertical, size: :md))

      assert_selector "div.border-l-4"
    end

    test "raises error for invalid size" do
      error = assert_raises(ArgumentError) do
        DividerComponent.new(size: :lg)
      end

      assert_match(/Invalid size/, error.message)
    end

    # Spacing tests
    test "renders xs spacing horizontal" do
      render_inline(DividerComponent.new(spacing: :xs))

      assert_selector "hr.my-1"
    end

    test "renders sm spacing horizontal" do
      render_inline(DividerComponent.new(spacing: :sm))

      assert_selector "hr.my-2"
    end

    test "renders md spacing horizontal" do
      render_inline(DividerComponent.new(spacing: :md))

      assert_selector "hr.my-4"
    end

    test "renders lg spacing horizontal" do
      render_inline(DividerComponent.new(spacing: :lg))

      assert_selector "hr.my-6"
    end

    test "renders xl spacing horizontal" do
      render_inline(DividerComponent.new(spacing: :xl))

      assert_selector "hr.my-8"
    end

    test "renders xs spacing vertical" do
      render_inline(DividerComponent.new(orientation: :vertical, spacing: :xs))

      assert_selector "div.mx-1"
    end

    test "renders sm spacing vertical" do
      render_inline(DividerComponent.new(orientation: :vertical, spacing: :sm))

      assert_selector "div.mx-2"
    end

    test "renders md spacing vertical" do
      render_inline(DividerComponent.new(orientation: :vertical, spacing: :md))

      assert_selector "div.mx-4"
    end

    test "renders lg spacing vertical" do
      render_inline(DividerComponent.new(orientation: :vertical, spacing: :lg))

      assert_selector "div.mx-6"
    end

    test "renders xl spacing vertical" do
      render_inline(DividerComponent.new(orientation: :vertical, spacing: :xl))

      assert_selector "div.mx-8"
    end

    test "raises error for invalid spacing" do
      error = assert_raises(ArgumentError) do
        DividerComponent.new(spacing: :xxl)
      end

      assert_match(/Invalid spacing/, error.message)
    end

    # Label tests
    test "renders label text" do
      render_inline(DividerComponent.new(label: "OR"))

      assert_text "OR"
      assert_selector "span.text-sm"
      assert_selector "span.text-grayscale-500"
      assert_selector "span.whitespace-nowrap"
      assert_selector "span.px-3"
    end

    test "renders label with flex wrapper" do
      render_inline(DividerComponent.new(label: "Section"))

      assert_selector "div.flex"
      assert_selector "div.items-center"
    end

    test "has role separator when label present" do
      render_inline(DividerComponent.new(label: "OR"))

      assert_selector "div[role='separator']"
    end

    test "renders hr without role separator when no label" do
      render_inline(DividerComponent.new)

      refute_selector "hr[role='separator']"
    end

    test "renders with center label position by default" do
      render_inline(DividerComponent.new(label: "OR"))

      # Both lines should have flex-grow
      assert_selector "div.flex-grow", count: 2
    end

    test "renders with left label position" do
      render_inline(DividerComponent.new(label: "Section", label_position: :left))

      # First line should be short, second should grow
      assert_selector "div.flex-grow-0.w-8"
      assert_selector "div.flex-grow"
    end

    test "renders with right label position" do
      render_inline(DividerComponent.new(label: "Section", label_position: :right))

      # First line should grow, second should be short
      assert_selector "div.flex-grow"
      assert_selector "div.flex-grow-0.w-8"
    end

    test "renders label lines with border style" do
      render_inline(DividerComponent.new(label: "OR", style: :dashed))

      assert_selector "div.border-dashed"
    end

    test "renders label lines with variant color" do
      render_inline(DividerComponent.new(label: "OR", variant: :primary))

      assert_selector "div.border-primary-300"
    end

    test "renders label with spacing" do
      render_inline(DividerComponent.new(label: "OR", spacing: :lg))

      assert_selector "div.my-6"
    end

    # Container classes
    test "renders with custom container_classes" do
      render_inline(DividerComponent.new(container_classes: "custom-divider"))

      assert_selector "hr.custom-divider"
    end

    test "renders labeled divider with custom container_classes" do
      render_inline(DividerComponent.new(label: "OR", container_classes: "custom-wrapper"))

      assert_selector "div.custom-wrapper"
    end

    test "renders vertical divider with custom container_classes" do
      render_inline(DividerComponent.new(orientation: :vertical, container_classes: "custom-vertical"))

      assert_selector "div.custom-vertical"
    end

    # HTML options pass-through
    test "passes through additional HTML options" do
      render_inline(DividerComponent.new(id: "my-divider"))

      assert_selector "hr#my-divider"
    end

    test "passes through data attributes" do
      render_inline(DividerComponent.new(data: { testid: "divider" }))

      assert_selector "hr[data-testid='divider']"
    end

    # Vertical rendering specifics
    test "vertical divider has role separator" do
      render_inline(DividerComponent.new(orientation: :vertical))

      assert_selector "div[role='separator']"
    end

    test "vertical divider renders with all styles" do
      render_inline(DividerComponent.new(orientation: :vertical, style: :dashed))
      assert_selector "div.border-dashed"

      render_inline(DividerComponent.new(orientation: :vertical, style: :dotted))
      assert_selector "div.border-dotted"

      render_inline(DividerComponent.new(orientation: :vertical, style: :solid))
      assert_selector "div.border-solid"
    end

    test "vertical divider renders with variant" do
      render_inline(DividerComponent.new(orientation: :vertical, variant: :danger))

      assert_selector "div.border-danger-300"
    end

    # Combined options test
    test "renders with combined options" do
      render_inline(DividerComponent.new(
        style: :dashed,
        variant: :success,
        size: :sm,
        spacing: :lg
      ))

      assert_selector "hr.border-dashed"
      assert_selector "hr.border-success-300"
      assert_selector "hr.border-t-2"
      assert_selector "hr.my-6"
    end

    test "renders labeled divider with combined options" do
      render_inline(DividerComponent.new(
        label: "OR",
        style: :dotted,
        variant: :info,
        size: :sm,
        spacing: :xl,
        label_position: :left
      ))

      assert_text "OR"
      assert_selector "div.flex"
      assert_selector "div.items-center"
      assert_selector "div.my-8"
      assert_selector "div.border-dotted"
      assert_selector "div.border-info-300"
      assert_selector "div.flex-grow-0.w-8"
    end
  end
end
