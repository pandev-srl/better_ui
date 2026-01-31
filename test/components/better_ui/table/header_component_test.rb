# frozen_string_literal: true

require "test_helper"

module BetterUi
  module Table
    class HeaderComponentTest < ActiveSupport::TestCase
      test "renders a tr element" do
        render_inline(HeaderComponent.new) do |h|
          h.with_cell(label: "Name")
        end

        assert_selector "tr"
      end

      test "renders header cells within the row" do
        render_inline(HeaderComponent.new) do |h|
          h.with_cell(label: "Name")
          h.with_cell(label: "Email")
        end

        assert_text "Name"
        assert_text "Email"
        assert_selector "th", count: 2
      end

      test "passes size to header cells" do
        render_inline(HeaderComponent.new(size: :lg)) do |h|
          h.with_cell(label: "Name")
        end

        assert_selector "th.px-5"
        assert_selector "th.py-3"
      end

      test "passes style to header cells" do
        render_inline(HeaderComponent.new(style: :bordered)) do |h|
          h.with_cell(label: "Name")
        end

        assert_selector "th.border"
      end

      test "renders with custom container classes" do
        render_inline(HeaderComponent.new(container_classes: "custom-header-row")) do |h|
          h.with_cell(label: "Name")
        end

        assert_selector "tr.custom-header-row"
      end

      test "cells inherit font-semibold" do
        render_inline(HeaderComponent.new) do |h|
          h.with_cell(label: "Name")
        end

        assert_selector "th.font-semibold"
      end

      test "allows cell alignment" do
        render_inline(HeaderComponent.new) do |h|
          h.with_cell(label: "Name")
          h.with_cell(label: "Actions", align: :right)
        end

        assert_selector "th.text-left", text: "Name"
        assert_selector "th.text-right", text: "Actions"
      end

      test "renders with default size (md)" do
        render_inline(HeaderComponent.new) do |h|
          h.with_cell(label: "Name")
        end

        assert_selector "th.px-4"
        assert_selector "th.py-2"
      end

      test "renders with xs size" do
        render_inline(HeaderComponent.new(size: :xs)) do |h|
          h.with_cell(label: "Name")
        end

        assert_selector "th.px-2"
        assert_selector "th.py-1"
      end

      test "renders with xl size" do
        render_inline(HeaderComponent.new(size: :xl)) do |h|
          h.with_cell(label: "Name")
        end

        assert_selector "th.px-6"
        assert_selector "th.py-4"
      end
    end
  end
end
