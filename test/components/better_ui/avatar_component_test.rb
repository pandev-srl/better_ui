# frozen_string_literal: true

require "test_helper"

module BetterUi
  class AvatarComponentTest < ActiveSupport::TestCase
    # ============================================
    # Default rendering with image
    # ============================================

    test "renders with image src" do
      render_inline(AvatarComponent.new(src: "https://example.com/avatar.jpg", alt: "John Doe"))

      assert_selector "img[src='https://example.com/avatar.jpg']"
      assert_selector "img[alt='John Doe']"
    end

    test "renders img tag when src is provided" do
      render_inline(AvatarComponent.new(src: "https://example.com/avatar.jpg"))

      assert_selector "img"
      refute_selector "div.flex.items-center"
    end

    test "renders default size and shape with image" do
      render_inline(AvatarComponent.new(src: "https://example.com/avatar.jpg"))

      assert_selector "img.w-10.h-10"       # default md size
      assert_selector "img.rounded-full"     # default circle shape
      assert_selector "img.object-cover"
    end

    # ============================================
    # Initials rendering (no image)
    # ============================================

    test "renders initials div when no src is provided" do
      render_inline(AvatarComponent.new(name: "John Doe"))

      refute_selector "img"
      assert_selector "div.flex.items-center.justify-center.font-medium"
      assert_text "JD"
    end

    test "renders initials from single word name" do
      render_inline(AvatarComponent.new(name: "Alice"))

      assert_text "A"
    end

    test "renders initials from two word name" do
      render_inline(AvatarComponent.new(name: "John Doe"))

      assert_text "JD"
    end

    test "renders initials from multi-word name taking first two words" do
      render_inline(AvatarComponent.new(name: "John Michael Doe"))

      assert_text "JM"
    end

    test "renders uppercase initials" do
      render_inline(AvatarComponent.new(name: "john doe"))

      assert_text "JD"
    end

    test "renders empty initials when name is nil" do
      render_inline(AvatarComponent.new)

      assert_selector "div.flex.items-center.justify-center"
    end

    # ============================================
    # Alt attribute
    # ============================================

    test "uses alt parameter for image alt text" do
      render_inline(AvatarComponent.new(src: "https://example.com/avatar.jpg", alt: "Custom Alt"))

      assert_selector "img[alt='Custom Alt']"
    end

    test "falls back to name for image alt text when alt is nil" do
      render_inline(AvatarComponent.new(src: "https://example.com/avatar.jpg", name: "Jane Smith"))

      assert_selector "img[alt='Jane Smith']"
    end

    # ============================================
    # Variant tests (all 9 variants)
    # ============================================

    test "renders primary variant initials" do
      render_inline(AvatarComponent.new(name: "Test", variant: :primary))

      assert_selector "div.bg-primary-100.text-primary-700"
    end

    test "renders secondary variant initials" do
      render_inline(AvatarComponent.new(name: "Test", variant: :secondary))

      assert_selector "div.bg-secondary-100.text-secondary-700"
    end

    test "renders accent variant initials" do
      render_inline(AvatarComponent.new(name: "Test", variant: :accent))

      assert_selector "div.bg-accent-100.text-accent-700"
    end

    test "renders success variant initials" do
      render_inline(AvatarComponent.new(name: "Test", variant: :success))

      assert_selector "div.bg-success-100.text-success-700"
    end

    test "renders danger variant initials" do
      render_inline(AvatarComponent.new(name: "Test", variant: :danger))

      assert_selector "div.bg-danger-100.text-danger-700"
    end

    test "renders warning variant initials" do
      render_inline(AvatarComponent.new(name: "Test", variant: :warning))

      assert_selector "div.bg-warning-100.text-warning-700"
    end

    test "renders info variant initials" do
      render_inline(AvatarComponent.new(name: "Test", variant: :info))

      assert_selector "div.bg-info-100.text-info-700"
    end

    test "renders light variant initials" do
      render_inline(AvatarComponent.new(name: "Test", variant: :light))

      assert_selector "div.bg-grayscale-100.text-grayscale-700"
    end

    test "renders dark variant initials" do
      render_inline(AvatarComponent.new(name: "Test", variant: :dark))

      assert_selector "div.bg-grayscale-800.text-grayscale-100"
    end

    test "does not apply variant background classes when src is present" do
      render_inline(AvatarComponent.new(src: "https://example.com/avatar.jpg", variant: :primary))

      refute_selector "img.bg-primary-100"
    end

    test "raises error for invalid variant" do
      error = assert_raises(ArgumentError) do
        AvatarComponent.new(variant: :invalid)
      end

      assert_match(/Invalid variant/, error.message)
    end

    # ============================================
    # Size tests (all 5 sizes)
    # ============================================

    test "renders xs size" do
      render_inline(AvatarComponent.new(name: "Test", size: :xs))

      assert_selector "div.w-6.h-6.text-xs"
    end

    test "renders sm size" do
      render_inline(AvatarComponent.new(name: "Test", size: :sm))

      assert_selector "div.w-8.h-8.text-sm"
    end

    test "renders md size" do
      render_inline(AvatarComponent.new(name: "Test", size: :md))

      assert_selector "div.w-10.h-10.text-base"
    end

    test "renders lg size" do
      render_inline(AvatarComponent.new(name: "Test", size: :lg))

      assert_selector "div.w-14.h-14.text-lg"
    end

    test "renders xl size" do
      render_inline(AvatarComponent.new(name: "Test", size: :xl))

      assert_selector "div.w-20.h-20.text-xl"
    end

    test "raises error for invalid size" do
      error = assert_raises(ArgumentError) do
        AvatarComponent.new(size: :invalid)
      end

      assert_match(/Invalid size/, error.message)
    end

    # ============================================
    # Shape tests (all 3 shapes)
    # ============================================

    test "renders circle shape" do
      render_inline(AvatarComponent.new(name: "Test", shape: :circle))

      assert_selector "div.rounded-full"
    end

    test "renders square shape" do
      render_inline(AvatarComponent.new(name: "Test", shape: :square))

      assert_selector "div.rounded-none"
    end

    test "renders rounded shape" do
      render_inline(AvatarComponent.new(name: "Test", shape: :rounded))

      assert_selector "div.rounded-lg"
    end

    test "raises error for invalid shape" do
      error = assert_raises(ArgumentError) do
        AvatarComponent.new(shape: :invalid)
      end

      assert_match(/Invalid shape/, error.message)
    end

    # ============================================
    # Status indicator tests
    # ============================================

    test "renders online status indicator" do
      render_inline(AvatarComponent.new(name: "Test", status: :online))

      assert_selector "span.bg-success-500.rounded-full.ring-2.ring-white"
    end

    test "renders offline status indicator" do
      render_inline(AvatarComponent.new(name: "Test", status: :offline))

      assert_selector "span.bg-grayscale-400.rounded-full.ring-2.ring-white"
    end

    test "renders busy status indicator" do
      render_inline(AvatarComponent.new(name: "Test", status: :busy))

      assert_selector "span.bg-danger-500.rounded-full.ring-2.ring-white"
    end

    test "renders away status indicator" do
      render_inline(AvatarComponent.new(name: "Test", status: :away))

      assert_selector "span.bg-warning-500.rounded-full.ring-2.ring-white"
    end

    test "does not render status dot when status is nil" do
      render_inline(AvatarComponent.new(name: "Test"))

      refute_selector "span.rounded-full.ring-2"
    end

    test "raises error for invalid status" do
      error = assert_raises(ArgumentError) do
        AvatarComponent.new(status: :invalid)
      end

      assert_match(/Invalid status/, error.message)
    end

    # Status dot size scales with avatar size
    test "renders xs status dot size" do
      render_inline(AvatarComponent.new(name: "Test", status: :online, size: :xs))

      assert_selector "span.w-2.h-2"
    end

    test "renders sm status dot size" do
      render_inline(AvatarComponent.new(name: "Test", status: :online, size: :sm))

      assert_selector "span.w-2.h-2"
    end

    test "renders md status dot size" do
      render_inline(AvatarComponent.new(name: "Test", status: :online, size: :md))

      assert_selector "span.w-2\\.5.h-2\\.5"
    end

    test "renders lg status dot size" do
      render_inline(AvatarComponent.new(name: "Test", status: :online, size: :lg))

      assert_selector "span.w-3.h-3"
    end

    test "renders xl status dot size" do
      render_inline(AvatarComponent.new(name: "Test", status: :online, size: :xl))

      assert_selector "span.w-4.h-4"
    end

    # ============================================
    # Badge slot
    # ============================================

    test "renders badge slot" do
      render_inline(AvatarComponent.new(name: "Test")) do |avatar|
        avatar.with_badge { '<span class="badge-content">3</span>'.html_safe }
      end

      assert_selector "span.absolute.-top-1.-right-1"
      assert_selector "span.badge-content", text: "3"
    end

    test "does not render badge wrapper when no badge is provided" do
      render_inline(AvatarComponent.new(name: "Test"))

      refute_selector "span.absolute.-top-1.-right-1"
    end

    # ============================================
    # Container classes
    # ============================================

    test "renders with custom container classes" do
      render_inline(AvatarComponent.new(name: "Test", container_classes: "custom-class"))

      assert_selector "div.custom-class"
    end

    # ============================================
    # Wrapper element
    # ============================================

    test "renders relative inline-flex wrapper" do
      render_inline(AvatarComponent.new(name: "Test"))

      assert_selector "div.relative.inline-flex"
    end
  end
end
