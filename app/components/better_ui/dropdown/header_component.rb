# frozen_string_literal: true

module BetterUi
  module Dropdown
    class HeaderComponent < ApplicationComponent
      def initialize(text: nil, container_classes: nil)
        @text = text
        @container_classes = container_classes
      end

      private

      def display_text
        content.present? ? content : @text
      end

      def component_classes
        css_classes(
          "px-3 py-2 text-xs font-semibold uppercase tracking-wider text-grayscale-500",
          @container_classes
        )
      end
    end
  end
end
