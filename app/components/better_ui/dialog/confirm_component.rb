# frozen_string_literal: true

module BetterUi
  module Dialog
    class ConfirmComponent < ApplicationComponent
      renders_one :trigger

      ICON_VARIANTS = {
        success:   :check_circle,
        danger:    :exclamation_circle,
        warning:   :exclamation_triangle,
        info:      :information_circle,
        primary:   :information_circle,
        secondary: :information_circle,
        accent:    :information_circle,
        light:     :information_circle,
        dark:      :information_circle
      }.freeze

      def initialize(
        variant: :warning,
        title: nil,
        text: nil,
        icon: true,
        confirm_label: "Confirm",
        cancel_label: "Cancel",
        size: :sm,
        close_on_backdrop: false,
        close_on_escape: false,
        **options
      )
        @variant = validate_variant(normalize_symbol(variant, :warning))
        @title = title
        @text = text
        @icon = icon
        @confirm_label = confirm_label
        @cancel_label = cancel_label
        @size = normalize_symbol(size, :sm)
        @close_on_backdrop = close_on_backdrop
        @close_on_escape = close_on_escape
        @options = options
      end

      private

      attr_reader :variant, :title, :text, :icon, :confirm_label, :cancel_label,
                  :size, :close_on_backdrop, :close_on_escape, :options

      def icon_name
        ICON_VARIANTS[@variant]
      end

      def icon_color_classes
        case @variant
        when :success   then "text-success-600 bg-success-100"
        when :danger    then "text-danger-600 bg-danger-100"
        when :warning   then "text-warning-600 bg-warning-100"
        when :info      then "text-info-600 bg-info-100"
        when :primary   then "text-primary-600 bg-primary-100"
        when :secondary then "text-secondary-600 bg-secondary-100"
        when :accent    then "text-accent-600 bg-accent-100"
        when :light     then "text-grayscale-600 bg-grayscale-100"
        when :dark      then "text-grayscale-800 bg-grayscale-200"
        end
      end

      def normalize_symbol(value, fallback)
        sym = value.to_s.strip.to_sym
        sym.blank? ? fallback : sym
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
