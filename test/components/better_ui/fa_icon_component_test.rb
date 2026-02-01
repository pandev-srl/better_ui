# frozen_string_literal: true

require "test_helper"

module BetterUi
  class FaIconComponentTest < ActiveSupport::TestCase
    # ============================================
    # Default rendering
    # ============================================

    test "renders an i element" do
      render_inline(FaIconComponent.new(name: "user"))

      assert_selector "i"
      refute_selector "span"
      refute_selector "svg"
    end

    test "renders with default options" do
      render_inline(FaIconComponent.new(name: "user"))

      assert_selector "i.fa-regular"          # default style
      assert_selector "i.fa-user"              # icon name class
    end

    test "renders aria-hidden attribute for accessibility" do
      render_inline(FaIconComponent.new(name: "user"))

      assert_selector "i[aria-hidden='true']"
    end

    # ============================================
    # Name parameter
    # ============================================

    test "renders correct class for simple icon name" do
      render_inline(FaIconComponent.new(name: "check"))

      assert_selector "i.fa-check"
    end

    test "renders correct class for hyphenated icon name" do
      render_inline(FaIconComponent.new(name: "arrow-right"))

      assert_selector "i.fa-arrow-right"
    end

    test "renders correct class for multi-word icon name" do
      render_inline(FaIconComponent.new(name: "circle-exclamation"))

      assert_selector "i.fa-circle-exclamation"
    end

    # ============================================
    # Style tests
    # ============================================

    test "renders regular style" do
      render_inline(FaIconComponent.new(name: "user", style: :regular))

      assert_selector "i.fa-regular"
    end

    test "renders solid style" do
      render_inline(FaIconComponent.new(name: "user", style: :solid))

      assert_selector "i.fa-solid"
    end

    test "renders light style" do
      render_inline(FaIconComponent.new(name: "user", style: :light))

      assert_selector "i.fa-light"
    end

    test "renders thin style" do
      render_inline(FaIconComponent.new(name: "user", style: :thin))

      assert_selector "i.fa-thin"
    end

    test "renders brands style" do
      render_inline(FaIconComponent.new(name: "github", style: :brands))

      assert_selector "i.fa-brands"
    end

    test "raises error for invalid style" do
      error = assert_raises(ArgumentError) do
        FaIconComponent.new(name: "user", style: :invalid)
      end

      assert_match(/Invalid style/, error.message)
    end

    # ============================================
    # Size tests
    # ============================================

    test "renders xs size" do
      render_inline(FaIconComponent.new(name: "user", size: :xs))

      assert_selector "i.fa-xs"
    end

    test "renders sm size" do
      render_inline(FaIconComponent.new(name: "user", size: :sm))

      assert_selector "i.fa-sm"
    end

    test "renders md size with no size class" do
      render_inline(FaIconComponent.new(name: "user", size: :md))

      refute_selector "i.fa-xs"
      refute_selector "i.fa-sm"
      refute_selector "i.fa-lg"
      refute_selector "i.fa-xl"
      refute_selector "i.fa-2xl"
    end

    test "renders lg size" do
      render_inline(FaIconComponent.new(name: "user", size: :lg))

      assert_selector "i.fa-lg"
    end

    test "renders xl size" do
      render_inline(FaIconComponent.new(name: "user", size: :xl))

      assert_selector "i.fa-xl"
    end

    test "renders 2xl size" do
      render_inline(FaIconComponent.new(name: "user", size: :"2xl"))

      assert_selector "i.fa-2xl"
    end

    test "raises error for invalid size" do
      error = assert_raises(ArgumentError) do
        FaIconComponent.new(name: "user", size: :invalid)
      end

      assert_match(/Invalid size/, error.message)
    end

    # ============================================
    # Variant tests
    # ============================================

    test "renders with no color class when variant is nil" do
      render_inline(FaIconComponent.new(name: "user", variant: nil))

      refute_selector "i.text-primary-600"
      refute_selector "i.text-secondary-500"
      refute_selector "i.text-accent-500"
      refute_selector "i.text-success-600"
      refute_selector "i.text-danger-600"
      refute_selector "i.text-warning-500"
      refute_selector "i.text-info-500"
      refute_selector "i.text-grayscale-400"
      refute_selector "i.text-grayscale-800"
    end

    test "renders primary variant" do
      render_inline(FaIconComponent.new(name: "user", variant: :primary))

      assert_selector "i.text-primary-600"
    end

    test "renders secondary variant" do
      render_inline(FaIconComponent.new(name: "user", variant: :secondary))

      assert_selector "i.text-secondary-500"
    end

    test "renders accent variant" do
      render_inline(FaIconComponent.new(name: "user", variant: :accent))

      assert_selector "i.text-accent-500"
    end

    test "renders success variant" do
      render_inline(FaIconComponent.new(name: "user", variant: :success))

      assert_selector "i.text-success-600"
    end

    test "renders danger variant" do
      render_inline(FaIconComponent.new(name: "user", variant: :danger))

      assert_selector "i.text-danger-600"
    end

    test "renders warning variant" do
      render_inline(FaIconComponent.new(name: "user", variant: :warning))

      assert_selector "i.text-warning-500"
    end

    test "renders info variant" do
      render_inline(FaIconComponent.new(name: "user", variant: :info))

      assert_selector "i.text-info-500"
    end

    test "renders light variant" do
      render_inline(FaIconComponent.new(name: "user", variant: :light))

      assert_selector "i.text-grayscale-400"
    end

    test "renders dark variant" do
      render_inline(FaIconComponent.new(name: "user", variant: :dark))

      assert_selector "i.text-grayscale-800"
    end

    test "raises error for invalid variant" do
      error = assert_raises(ArgumentError) do
        FaIconComponent.new(name: "user", variant: :invalid)
      end

      assert_match(/Invalid variant/, error.message)
    end

    # ============================================
    # Animation tests
    # ============================================

    test "renders spin animation" do
      render_inline(FaIconComponent.new(name: "spinner", spin: true))

      assert_selector "i.fa-spin"
    end

    test "does not render spin class when spin is false" do
      render_inline(FaIconComponent.new(name: "spinner", spin: false))

      refute_selector "i.fa-spin"
    end

    test "renders pulse animation" do
      render_inline(FaIconComponent.new(name: "spinner", pulse: true))

      assert_selector "i.fa-pulse"
    end

    test "does not render pulse class when pulse is false" do
      render_inline(FaIconComponent.new(name: "spinner", pulse: false))

      refute_selector "i.fa-pulse"
    end

    test "renders both spin and pulse together" do
      render_inline(FaIconComponent.new(name: "spinner", spin: true, pulse: true))

      assert_selector "i.fa-spin"
      assert_selector "i.fa-pulse"
    end

    # ============================================
    # Flip tests
    # ============================================

    test "renders horizontal flip" do
      render_inline(FaIconComponent.new(name: "user", flip: :horizontal))

      assert_selector "i.fa-flip-horizontal"
    end

    test "renders vertical flip" do
      render_inline(FaIconComponent.new(name: "user", flip: :vertical))

      assert_selector "i.fa-flip-vertical"
    end

    test "renders both flip" do
      render_inline(FaIconComponent.new(name: "user", flip: :both))

      assert_selector "i.fa-flip-both"
    end

    test "does not render flip class when flip is nil" do
      render_inline(FaIconComponent.new(name: "user", flip: nil))

      refute_selector "i.fa-flip-horizontal"
      refute_selector "i.fa-flip-vertical"
      refute_selector "i.fa-flip-both"
    end

    test "raises error for invalid flip" do
      error = assert_raises(ArgumentError) do
        FaIconComponent.new(name: "user", flip: :invalid)
      end

      assert_match(/Invalid flip/, error.message)
    end

    # ============================================
    # Rotate tests
    # ============================================

    test "renders rotate 90" do
      render_inline(FaIconComponent.new(name: "user", rotate: 90))

      assert_selector "i.fa-rotate-90"
    end

    test "renders rotate 180" do
      render_inline(FaIconComponent.new(name: "user", rotate: 180))

      assert_selector "i.fa-rotate-180"
    end

    test "renders rotate 270" do
      render_inline(FaIconComponent.new(name: "user", rotate: 270))

      assert_selector "i.fa-rotate-270"
    end

    test "does not render rotate class when rotate is nil" do
      render_inline(FaIconComponent.new(name: "user", rotate: nil))

      refute_selector "i.fa-rotate-90"
      refute_selector "i.fa-rotate-180"
      refute_selector "i.fa-rotate-270"
    end

    test "raises error for invalid rotate" do
      error = assert_raises(ArgumentError) do
        FaIconComponent.new(name: "user", rotate: 45)
      end

      assert_match(/Invalid rotate/, error.message)
    end

    # ============================================
    # Fixed width tests
    # ============================================

    test "renders fixed width class when fixed_width is true" do
      render_inline(FaIconComponent.new(name: "user", fixed_width: true))

      assert_selector "i.fa-fw"
    end

    test "does not render fixed width class when fixed_width is false" do
      render_inline(FaIconComponent.new(name: "user", fixed_width: false))

      refute_selector "i.fa-fw"
    end

    # ============================================
    # Container classes tests
    # ============================================

    test "renders with custom container classes" do
      render_inline(FaIconComponent.new(name: "user", container_classes: "custom-class"))

      assert_selector "i.custom-class"
    end

    test "container classes merge with component classes" do
      render_inline(FaIconComponent.new(name: "user", container_classes: "ml-2 mt-1"))

      assert_selector "i.ml-2"
      assert_selector "i.mt-1"
      assert_selector "i.fa-regular"
    end

    # ============================================
    # Combined feature tests
    # ============================================

    test "renders with all options combined" do
      render_inline(FaIconComponent.new(
        name: "star",
        style: :solid,
        variant: :warning,
        size: :lg,
        spin: true,
        fixed_width: true,
        container_classes: "extra"
      ))

      assert_selector "i.fa-solid"
      assert_selector "i.fa-star"
      assert_selector "i.text-warning-500"
      assert_selector "i.fa-lg"
      assert_selector "i.fa-spin"
      assert_selector "i.fa-fw"
      assert_selector "i.extra"
      assert_selector "i[aria-hidden='true']"
    end

    test "renders brands icon with size and variant" do
      render_inline(FaIconComponent.new(
        name: "github",
        style: :brands,
        variant: :dark,
        size: :xl
      ))

      assert_selector "i.fa-brands"
      assert_selector "i.fa-github"
      assert_selector "i.text-grayscale-800"
      assert_selector "i.fa-xl"
    end

    test "renders with flip and rotate together" do
      render_inline(FaIconComponent.new(
        name: "arrow-right",
        flip: :horizontal,
        rotate: 90
      ))

      assert_selector "i.fa-flip-horizontal"
      assert_selector "i.fa-rotate-90"
    end
  end
end
