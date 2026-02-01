# frozen_string_literal: true

require "test_helper"

module BetterUi
  module Dropdown
    class HeaderComponentTest < ActiveSupport::TestCase
      test "renders with text param" do
        render_inline(HeaderComponent.new(text: "Actions"))

        assert_selector "div[role='presentation']", text: "Actions"
      end

      test "renders with block content" do
        render_inline(HeaderComponent.new) { "Custom Header" }

        assert_selector "div[role='presentation']", text: "Custom Header"
      end

      test "prefers block content over text param" do
        render_inline(HeaderComponent.new(text: "Param Text")) { "Block Text" }

        assert_text "Block Text"
      end

      test "renders with label styling" do
        render_inline(HeaderComponent.new(text: "Section"))

        assert_selector "div.px-3"
        assert_selector "div.py-2"
        assert_selector "div.text-xs"
        assert_selector "div.font-semibold"
        assert_selector "div.uppercase"
        assert_selector "div.tracking-wider"
        assert_selector "div.text-grayscale-500"
      end

      test "applies custom container_classes" do
        render_inline(HeaderComponent.new(text: "Test", container_classes: "my-class"))

        assert_selector "div.my-class"
      end
    end
  end
end
