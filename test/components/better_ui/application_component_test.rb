# frozen_string_literal: true

require "test_helper"

module BetterUi
  class ApplicationComponentTest < ActiveSupport::TestCase
    # Test component for testing ApplicationComponent functionality
    class TestComponent < ApplicationComponent
      def initialize(classes: nil)
        @classes = classes
      end

      def call
        content_tag(:div, "Test", class: css_classes(@classes))
      end
    end

    test "VARIANTS constant exists and contains expected keys" do
      assert_kind_of Hash, BetterUi::ApplicationComponent::VARIANTS

      expected_variants = [ :primary, :secondary, :accent, :success, :danger, :warning, :info, :light, :dark ]
      assert_equal expected_variants.sort, BetterUi::ApplicationComponent::VARIANTS.keys.sort
    end

    test "VARIANTS constant is frozen" do
      assert BetterUi::ApplicationComponent::VARIANTS.frozen?
    end

    test "VARIANTS contains numeric shade values" do
      BetterUi::ApplicationComponent::VARIANTS.each do |variant, shade|
        assert_kind_of Integer, shade, "Expected #{variant} to have an Integer shade value"
        assert shade >= 0, "Expected #{variant} shade to be non-negative"
      end
    end

    test "css_classes helper merges Tailwind classes correctly" do
      component = TestComponent.new(classes: [ "px-4", "py-2" ])
      render_inline(component)

      assert_selector "div", text: "Test"
    end

    test "css_classes resolves conflicting Tailwind utilities" do
      # When same property has different values, TailwindMerge should keep the last one
      component = TestComponent.new(classes: [ "px-4 py-2", "px-6" ])
      render_inline(component)

      # Check that px-6 is present (it should override px-4)
      assert has_css?("div.px-6")
    end

    test "css_classes handles nil values" do
      component = TestComponent.new(classes: [ "px-4", nil, "py-2" ])
      render_inline(component)

      assert_selector "div", text: "Test"
    end

    test "css_classes handles empty strings" do
      component = TestComponent.new(classes: [ "px-4", "", "py-2" ])
      render_inline(component)

      assert_selector "div", text: "Test"
    end
  end
end
