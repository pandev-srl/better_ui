# frozen_string_literal: true

module BetterUi
  module Dialog
    class DialogComponent < ApplicationComponent
      renders_one :trigger

      SIZES = {
        sm:   "sm:max-w-sm",
        md:   "sm:max-w-md",
        lg:   "sm:max-w-lg",
        xl:   "sm:max-w-xl",
        xxl:  "sm:max-w-2xl",
        full: "sm:max-w-full sm:mx-4"
      }.freeze

      def initialize(
        size: :md,
        close_on_backdrop: true,
        close_on_escape: true,
        open: false,
        show_close_button: true,
        container_classes: nil,
        **options
      )
        @size = validate_size(size)
        @close_on_backdrop = close_on_backdrop
        @close_on_escape = close_on_escape
        @open = open
        @show_close_button = show_close_button
        @container_classes = container_classes
        @options = options
      end

      private

      attr_reader :size, :close_on_backdrop, :close_on_escape, :open,
                  :show_close_button, :container_classes, :options

      def component_id
        @options[:id] || "dialog-#{object_id}"
      end

      def controller_data
        {
          controller: "better-ui--dialog--dialog",
          "better-ui--dialog--dialog-open-value": @open,
          "better-ui--dialog--dialog-close-on-backdrop-value": @close_on_backdrop,
          "better-ui--dialog--dialog-close-on-escape-value": @close_on_escape
        }
      end

      def component_attributes
        {
          id: component_id,
          data: controller_data,
          **@options.except(:id)
        }
      end

      def panel_classes
        css_classes(
          "relative w-full text-left",
          "transition-all duration-200",
          "opacity-0 scale-95 translate-y-4 sm:translate-y-0 sm:scale-95",
          SIZES[@size],
          @container_classes
        )
      end

      def validate_size(size)
        size = size.to_s.strip.to_sym if size.respond_to?(:to_s)
        size = :md if size.blank?
        unless SIZES.key?(size)
          raise ArgumentError, "Invalid size: #{size}. Must be one of: #{SIZES.keys.join(", ")}"
        end
        size
      end
    end
  end
end
