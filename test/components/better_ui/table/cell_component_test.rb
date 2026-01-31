# frozen_string_literal: true

require "test_helper"

module BetterUi
  module Table
    class CellComponentTest < ActiveSupport::TestCase
      test "renders a td element" do
        render_inline(CellComponent.new) { "Cell content" }

        assert_selector "td"
        assert_text "Cell content"
      end

      test "renders with default alignment (left)" do
        render_inline(CellComponent.new) { "Content" }

        assert_selector "td.text-left"
      end

      test "renders with center alignment" do
        render_inline(CellComponent.new(align: :center)) { "Content" }

        assert_selector "td.text-center"
      end

      test "renders with right alignment" do
        render_inline(CellComponent.new(align: :right)) { "Content" }

        assert_selector "td.text-right"
      end

      test "raises error for invalid alignment" do
        error = assert_raises(ArgumentError) do
          CellComponent.new(align: :invalid)
        end

        assert_match(/Invalid align/, error.message)
      end

      # Size tests
      test "renders with default size (md)" do
        render_inline(CellComponent.new) { "Content" }

        assert_selector "td.px-3"
        assert_selector "td.py-4"
        assert_selector "td.text-sm"
      end

      test "renders with xs size" do
        render_inline(CellComponent.new(size: :xs)) { "Content" }

        assert_selector "td.px-2"
        assert_selector "td.py-2"
        assert_selector "td.text-xs"
      end

      test "renders with sm size" do
        render_inline(CellComponent.new(size: :sm)) { "Content" }

        assert_selector "td.px-3"
        assert_selector "td.text-sm"
        assert rendered_html.include?("py-2.5"), "Expected py-2.5 class"
      end

      test "renders with lg size" do
        render_inline(CellComponent.new(size: :lg)) { "Content" }

        assert_selector "td.px-4"
        assert_selector "td.py-5"
        assert_selector "td.text-base"
      end

      test "renders with xl size" do
        render_inline(CellComponent.new(size: :xl)) { "Content" }

        assert_selector "td.px-6"
        assert_selector "td.py-6"
        assert_selector "td.text-lg"
      end

      test "raises error for invalid size" do
        error = assert_raises(ArgumentError) do
          CellComponent.new(size: :invalid)
        end

        assert_match(/Invalid size/, error.message)
      end

      # Style tests
      test "renders without borders for default style" do
        render_inline(CellComponent.new(style: :default)) { "Content" }

        refute_selector "td.border"
      end

      test "bordered style does not add borders to cells" do
        render_inline(CellComponent.new(style: :bordered)) { "Content" }

        refute_selector "td.border"
      end

      # Custom classes
      test "renders with custom container classes" do
        render_inline(CellComponent.new(container_classes: "custom-class")) { "Content" }

        assert_selector "td.custom-class"
      end

      test "renders block content" do
        render_inline(CellComponent.new) { "<strong>Bold</strong>".html_safe }

        assert_selector "td strong", text: "Bold"
      end

      # HTML attributes passthrough
      test "renders with colspan attribute" do
        render_inline(CellComponent.new(colspan: 3)) { "Spanning" }

        assert_selector "td[colspan='3']", text: "Spanning"
      end

      test "renders with rowspan attribute" do
        render_inline(CellComponent.new(rowspan: 2)) { "Spanning" }

        assert_selector "td[rowspan='2']", text: "Spanning"
      end

      test "renders with data attributes" do
        render_inline(CellComponent.new(data: { action: "click" })) { "Content" }

        assert_selector "td[data-action='click']"
      end

      # Card style tests
      test "renders with text-black class" do
        render_inline(CellComponent.new) { "Content" }

        assert_selector "td.text-black"
      end

      test "renders with align-middle class" do
        render_inline(CellComponent.new) { "Content" }

        assert_selector "td.align-middle"
      end

      test "renders with first/last cell padding classes" do
        render_inline(CellComponent.new) { "Content" }

        assert rendered_html.include?("first:ps-4"), "Expected first:ps-4 class"
        assert rendered_html.include?("sm:first:ps-6"), "Expected sm:first:ps-6 class"
        assert rendered_html.include?("last:pe-4"), "Expected last:pe-4 class"
        assert rendered_html.include?("sm:last:pe-6"), "Expected sm:last:pe-6 class"
      end
    end
  end
end
