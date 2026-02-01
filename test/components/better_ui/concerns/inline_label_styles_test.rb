# frozen_string_literal: true

require "test_helper"

module BetterUi
  module Concerns
    class InlineLabelStylesTest < ActiveSupport::TestCase
      # Test the concern through BadgeComponent (which uses default hook values)
      # and TagComponent (which overrides outline_light_text_class)

      # ============================================
      # solid_classes via BadgeComponent
      # ============================================

      test "solid_classes returns correct classes for each variant" do
        expected = {
          primary: "bg-primary-600",
          secondary: "bg-secondary-600",
          accent: "bg-accent-600",
          success: "bg-success-600",
          danger: "bg-danger-600",
          warning: "bg-warning-600",
          info: "bg-info-600",
          light: "bg-grayscale-100",
          dark: "bg-grayscale-900"
        }

        expected.each do |variant, bg_class|
          render_inline(BadgeComponent.new(variant: variant, style: :solid)) { "Test" }
          assert_selector "span.#{bg_class.gsub('.', '\\\\.')}"
        end
      end

      # ============================================
      # text_color_for_solid
      # ============================================

      test "text_color_for_solid returns dark text for light variant" do
        render_inline(BadgeComponent.new(variant: :light, style: :solid)) { "Light" }
        assert_selector "span.text-grayscale-900"
      end

      test "text_color_for_solid returns light text for non-light variants" do
        render_inline(BadgeComponent.new(variant: :primary, style: :solid)) { "Primary" }
        assert_selector "span.text-grayscale-50"
      end

      # ============================================
      # outline_classes with default hook (Badge)
      # ============================================

      test "outline_classes uses default outline_light_text_class for Badge" do
        render_inline(BadgeComponent.new(variant: :light, style: :outline)) { "Light" }
        assert_selector "span.text-grayscale-400"
      end

      # ============================================
      # outline_classes with overridden hook (Tag)
      # ============================================

      test "outline_classes uses overridden outline_light_text_class for Tag" do
        render_inline(TagComponent.new(variant: :light, style: :outline)) { "Light" }
        assert_selector "span.text-grayscale-500"
      end

      # ============================================
      # soft_classes shared between Badge and Tag
      # ============================================

      test "soft_classes are identical for Badge and Tag" do
        BetterUi::ApplicationComponent::VARIANTS.keys.each do |variant|
          render_inline(BadgeComponent.new(variant: variant, style: :soft)) { "Badge" }
          badge_html = rendered_html

          render_inline(TagComponent.new(variant: variant, style: :soft)) { "Tag" }
          tag_html = rendered_html

          # Both should contain the same bg and text color classes
          badge_doc = Nokogiri::HTML.fragment(badge_html)
          tag_doc = Nokogiri::HTML.fragment(tag_html)

          badge_classes = badge_doc.at_css("span")["class"].split
          tag_classes = tag_doc.at_css("span")["class"].split

          # Extract only the bg- and text- classes (the ones from soft_classes)
          badge_style = badge_classes.select { |c| c.start_with?("bg-", "text-") }.sort
          tag_style = tag_classes.select { |c| c.start_with?("bg-", "text-") }.sort

          assert_equal badge_style, tag_style, "Soft style classes should match for variant #{variant}"
        end
      end

      # ============================================
      # ghost_classes (Badge only, Tag doesn't support ghost)
      # ============================================

      test "ghost_classes returns transparent background" do
        render_inline(BadgeComponent.new(style: :ghost)) { "Ghost" }
        assert_selector "span.bg-transparent"
      end

      # ============================================
      # validate_variant
      # ============================================

      test "validate_variant accepts all valid variants" do
        BetterUi::ApplicationComponent::VARIANTS.keys.each do |variant|
          assert_nothing_raised { BadgeComponent.new(variant: variant) }
        end
      end

      test "validate_variant raises ArgumentError for invalid variant" do
        error = assert_raises(ArgumentError) do
          BadgeComponent.new(variant: :nonexistent)
        end
        assert_match(/Invalid variant/, error.message)
      end
    end
  end
end
