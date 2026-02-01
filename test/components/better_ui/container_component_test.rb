# frozen_string_literal: true

require "test_helper"

module BetterUi
  class ContainerComponentTest < ActiveSupport::TestCase
    # Default rendering
    test "renders with default options" do
      render_inline(ContainerComponent.new) { "Container content" }

      assert_selector "div.w-full"
      assert_selector "div.max-w-screen-lg"  # default size
      assert_selector "div.px-4"             # default padding
      assert_selector "div.mx-auto"          # default centered
      assert_text "Container content"
    end

    # Content rendering
    test "renders content block" do
      render_inline(ContainerComponent.new) { "Hello World" }

      assert_text "Hello World"
    end

    test "renders HTML content" do
      render_inline(ContainerComponent.new) { "<p class='inner'>Nested</p>".html_safe }

      assert_selector "p.inner", text: "Nested"
    end

    # Size tests
    test "renders sm size" do
      render_inline(ContainerComponent.new(size: :sm)) { "Content" }

      assert_selector "div.max-w-screen-sm"
    end

    test "renders md size" do
      render_inline(ContainerComponent.new(size: :md)) { "Content" }

      assert_selector "div.max-w-screen-md"
    end

    test "renders lg size" do
      render_inline(ContainerComponent.new(size: :lg)) { "Content" }

      assert_selector "div.max-w-screen-lg"
    end

    test "renders xl size" do
      render_inline(ContainerComponent.new(size: :xl)) { "Content" }

      assert_selector "div.max-w-screen-xl"
    end

    test "renders full size" do
      render_inline(ContainerComponent.new(size: :full)) { "Content" }

      assert_selector "div.max-w-full"
    end

    test "raises error for invalid size" do
      error = assert_raises(ArgumentError) do
        ContainerComponent.new(size: :invalid)
      end

      assert_match(/Invalid size/, error.message)
    end

    # Padding tests
    test "renders with padding by default" do
      render_inline(ContainerComponent.new) { "Content" }

      assert_selector "div.px-4"
    end

    test "renders with padding when explicitly true" do
      render_inline(ContainerComponent.new(padding: true)) { "Content" }

      assert_selector "div.px-4"
    end

    test "renders without padding when false" do
      render_inline(ContainerComponent.new(padding: false)) { "Content" }

      refute_selector "div.px-4"
    end

    # Centered tests
    test "renders centered by default" do
      render_inline(ContainerComponent.new) { "Content" }

      assert_selector "div.mx-auto"
    end

    test "renders centered when explicitly true" do
      render_inline(ContainerComponent.new(centered: true)) { "Content" }

      assert_selector "div.mx-auto"
    end

    test "renders without centering when false" do
      render_inline(ContainerComponent.new(centered: false)) { "Content" }

      refute_selector "div.mx-auto"
    end

    # Container classes
    test "renders with custom container_classes" do
      render_inline(ContainerComponent.new(container_classes: "my-custom-class")) { "Content" }

      assert_selector "div.my-custom-class"
    end

    test "merges container_classes with component classes" do
      render_inline(ContainerComponent.new(container_classes: "mt-8 mb-4")) { "Content" }

      assert_selector "div.mt-8"
      assert_selector "div.mb-4"
      assert_selector "div.w-full"
    end

    # Additional HTML options
    test "passes through additional HTML options" do
      render_inline(ContainerComponent.new(id: "main-container", data: { controller: "page" })) { "Content" }

      assert_selector "div#main-container"
      assert_selector "div[data-controller='page']"
    end

    # Combined options
    test "renders with no padding and no centering" do
      render_inline(ContainerComponent.new(padding: false, centered: false)) { "Content" }

      assert_selector "div.w-full"
      refute_selector "div.px-4"
      refute_selector "div.mx-auto"
    end

    test "renders full width without padding and centering" do
      render_inline(ContainerComponent.new(size: :full, padding: false, centered: false)) { "Content" }

      assert_selector "div.w-full"
      assert_selector "div.max-w-full"
      refute_selector "div.px-4"
      refute_selector "div.mx-auto"
    end

    test "renders sm size with custom classes and no padding" do
      render_inline(ContainerComponent.new(size: :sm, padding: false, container_classes: "bg-gray-100")) { "Content" }

      assert_selector "div.max-w-screen-sm"
      assert_selector "div.bg-gray-100"
      assert_selector "div.mx-auto"
      refute_selector "div.px-4"
    end

    # Base class always present
    test "always includes w-full base class" do
      render_inline(ContainerComponent.new(size: :sm, padding: false, centered: false)) { "Content" }

      assert_selector "div.w-full"
    end
  end
end
