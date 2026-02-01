# frozen_string_literal: true

module BetterUi
  module Dropdown
    class DividerComponent < ApplicationComponent
      def initialize(container_classes: nil)
        @container_classes = container_classes
      end

      private

      def component_classes
        css_classes(
          "border-t border-grayscale-200 my-1",
          @container_classes
        )
      end
    end
  end
end
