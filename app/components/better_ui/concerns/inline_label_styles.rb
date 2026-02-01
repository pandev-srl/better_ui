# frozen_string_literal: true

module BetterUi
  module Concerns
    # Shared styling methods for inline label components (Badge, Tag).
    #
    # Provides variant-aware color classes for solid, outline, soft, and ghost styles.
    # Components including this concern must define their own STYLES constant and
    # may override hook methods for style divergence.
    #
    # Hook methods:
    #   - outline_light_text_class: CSS class for light variant outline text
    #     (default: "text-grayscale-400")
    module InlineLabelStyles
      extend ActiveSupport::Concern

      private

      def solid_classes
        bg_classes = case @variant
        when :primary
          [ "bg-primary-600" ]
        when :secondary
          [ "bg-secondary-600" ]
        when :accent
          [ "bg-accent-600" ]
        when :success
          [ "bg-success-600" ]
        when :danger
          [ "bg-danger-600" ]
        when :warning
          [ "bg-warning-600" ]
        when :info
          [ "bg-info-600" ]
        when :light
          [ "bg-grayscale-100" ]
        when :dark
          [ "bg-grayscale-900" ]
        end

        bg_classes + [ text_color_for_solid ]
      end

      def outline_classes
        color_classes = case @variant
        when :primary
          [ "border-primary-600", "text-primary-600" ]
        when :secondary
          [ "border-secondary-600", "text-secondary-600" ]
        when :accent
          [ "border-accent-600", "text-accent-600" ]
        when :success
          [ "border-success-600", "text-success-600" ]
        when :danger
          [ "border-danger-600", "text-danger-600" ]
        when :warning
          [ "border-warning-600", "text-warning-600" ]
        when :info
          [ "border-info-600", "text-info-600" ]
        when :light
          [ "border-grayscale-400", outline_light_text_class ]
        when :dark
          [ "border-grayscale-700", "text-grayscale-700" ]
        end

        [ "bg-transparent", "border" ] + color_classes
      end

      def soft_classes
        case @variant
        when :primary
          [ "bg-primary-100", "text-primary-700" ]
        when :secondary
          [ "bg-secondary-100", "text-secondary-700" ]
        when :accent
          [ "bg-accent-100", "text-accent-700" ]
        when :success
          [ "bg-success-100", "text-success-700" ]
        when :danger
          [ "bg-danger-100", "text-danger-700" ]
        when :warning
          [ "bg-warning-100", "text-warning-700" ]
        when :info
          [ "bg-info-100", "text-info-700" ]
        when :light
          [ "bg-grayscale-100", "text-grayscale-700" ]
        when :dark
          [ "bg-grayscale-800", "text-grayscale-100" ]
        end
      end

      def ghost_classes
        color_classes = case @variant
        when :primary
          [ "text-primary-600" ]
        when :secondary
          [ "text-secondary-600" ]
        when :accent
          [ "text-accent-600" ]
        when :success
          [ "text-success-600" ]
        when :danger
          [ "text-danger-600" ]
        when :warning
          [ "text-warning-600" ]
        when :info
          [ "text-info-600" ]
        when :light
          [ "text-grayscale-700" ]
        when :dark
          [ "text-grayscale-700" ]
        end

        [ "bg-transparent" ] + color_classes
      end

      def text_color_for_solid
        @variant == :light ? "text-grayscale-900" : "text-grayscale-50"
      end

      # Hook method for outline light variant text class.
      # Override in including component to customize.
      #
      # @return [String] CSS class for outline light text color
      def outline_light_text_class
        "text-grayscale-400"
      end

      def validate_variant(variant)
        unless BetterUi::ApplicationComponent::VARIANTS.key?(variant)
          raise ArgumentError, "Invalid variant: #{variant}. Must be one of: #{BetterUi::ApplicationComponent::VARIANTS.keys.join(", ")}"
        end
        variant
      end
    end
  end
end
