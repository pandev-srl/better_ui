# frozen_string_literal: true

require "test_helper"

module BetterUi
  class SpinnerComponentTest < ActiveSupport::TestCase
    # Default rendering
    test "renders with default options" do
      render_inline(SpinnerComponent.new)

      assert_selector "div[role='status']"
      assert_selector "svg.animate-spin"
      assert_selector "div.text-primary-600" # default variant
      assert_selector "svg.w-8.h-8" # default size (md)
    end

    test "renders default loading label when no label provided" do
      render_inline(SpinnerComponent.new)

      assert_selector "span.sr-only", text: "Loading..."
    end

    test "renders custom label as sr-only text" do
      render_inline(SpinnerComponent.new(label: "Saving data..."))

      assert_selector "span.sr-only", text: "Saving data..."
    end

    test "renders aria-hidden on SVG" do
      render_inline(SpinnerComponent.new)

      assert_selector "svg[aria-hidden='true']"
    end

    # Variant tests
    test "renders primary variant" do
      render_inline(SpinnerComponent.new(variant: :primary))

      assert_selector "div.text-primary-600"
    end

    test "renders secondary variant" do
      render_inline(SpinnerComponent.new(variant: :secondary))

      assert_selector "div.text-secondary-500"
    end

    test "renders accent variant" do
      render_inline(SpinnerComponent.new(variant: :accent))

      assert_selector "div.text-accent-500"
    end

    test "renders success variant" do
      render_inline(SpinnerComponent.new(variant: :success))

      assert_selector "div.text-success-600"
    end

    test "renders danger variant" do
      render_inline(SpinnerComponent.new(variant: :danger))

      assert_selector "div.text-danger-600"
    end

    test "renders warning variant" do
      render_inline(SpinnerComponent.new(variant: :warning))

      assert_selector "div.text-warning-500"
    end

    test "renders info variant" do
      render_inline(SpinnerComponent.new(variant: :info))

      assert_selector "div.text-info-500"
    end

    test "renders light variant" do
      render_inline(SpinnerComponent.new(variant: :light))

      assert_selector "div.text-grayscale-400"
    end

    test "renders dark variant" do
      render_inline(SpinnerComponent.new(variant: :dark))

      assert_selector "div.text-grayscale-800"
    end

    # Size tests
    test "renders xs size" do
      render_inline(SpinnerComponent.new(size: :xs))

      assert_selector "svg.w-4.h-4"
    end

    test "renders sm size" do
      render_inline(SpinnerComponent.new(size: :sm))

      assert_selector "svg.w-5.h-5"
    end

    test "renders md size" do
      render_inline(SpinnerComponent.new(size: :md))

      assert_selector "svg.w-8.h-8"
    end

    test "renders lg size" do
      render_inline(SpinnerComponent.new(size: :lg))

      assert_selector "svg.w-12.h-12"
    end

    test "renders xl size" do
      render_inline(SpinnerComponent.new(size: :xl))

      assert_selector "svg.w-16.h-16"
    end

    # container_classes
    test "renders with custom container classes" do
      render_inline(SpinnerComponent.new(container_classes: "my-custom-class"))

      assert_selector "div.my-custom-class"
    end

    # Invalid arguments
    test "raises error for invalid variant" do
      error = assert_raises(ArgumentError) do
        SpinnerComponent.new(variant: :invalid)
      end

      assert_match(/Invalid variant/, error.message)
    end

    test "raises error for invalid size" do
      error = assert_raises(ArgumentError) do
        SpinnerComponent.new(size: :invalid)
      end

      assert_match(/Invalid size/, error.message)
    end
  end
end
