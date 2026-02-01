# frozen_string_literal: true

require "test_helper"

module BetterUi
  module Dropdown
    class DividerComponentTest < ActiveSupport::TestCase
      test "renders a separator div" do
        render_inline(DividerComponent.new)

        assert_selector "div[role='separator']"
      end

      test "renders with border styling" do
        render_inline(DividerComponent.new)

        assert_selector "div.border-t"
      end

      test "renders with default border color" do
        render_inline(DividerComponent.new)

        assert_selector "div.border-grayscale-200"
      end

      test "renders with margin" do
        render_inline(DividerComponent.new)

        assert_selector "div.my-1"
      end

      test "applies custom container_classes" do
        render_inline(DividerComponent.new(container_classes: "my-custom-class"))

        assert_selector "div.my-custom-class"
      end
    end
  end
end
