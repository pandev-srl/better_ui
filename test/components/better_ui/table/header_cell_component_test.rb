# frozen_string_literal: true

require "test_helper"

module BetterUi
  module Table
    class HeaderCellComponentTest < ActiveSupport::TestCase
      test "renders a th element" do
        render_inline(HeaderCellComponent.new(label: "Name"))

        assert_selector "th"
        assert_text "Name"
      end

      test "renders label text" do
        render_inline(HeaderCellComponent.new(label: "Email"))

        assert_selector "th", text: "Email"
      end

      test "renders block content when no label" do
        render_inline(HeaderCellComponent.new) { "Custom Header" }

        assert_selector "th", text: "Custom Header"
      end

      test "prefers label over block content" do
        render_inline(HeaderCellComponent.new(label: "Label")) { "Block" }

        assert_selector "th", text: "Label"
      end

      test "renders with font-semibold" do
        render_inline(HeaderCellComponent.new(label: "Name"))

        assert_selector "th.font-semibold"
      end

      # Alignment tests
      test "renders with default alignment (left)" do
        render_inline(HeaderCellComponent.new(label: "Name"))

        assert_selector "th.text-left"
      end

      test "renders with center alignment" do
        render_inline(HeaderCellComponent.new(label: "Name", align: :center))

        assert_selector "th.text-center"
      end

      test "renders with right alignment" do
        render_inline(HeaderCellComponent.new(label: "Name", align: :right))

        assert_selector "th.text-right"
      end

      test "raises error for invalid alignment" do
        error = assert_raises(ArgumentError) do
          HeaderCellComponent.new(label: "Name", align: :invalid)
        end

        assert_match(/Invalid align/, error.message)
      end

      # Size tests
      test "renders with default size (md)" do
        render_inline(HeaderCellComponent.new(label: "Name"))

        assert_selector "th.px-3"
        assert_selector "th.text-sm"
        assert rendered_html.include?("py-3.5"), "Expected py-3.5 class"
      end

      test "renders with xs size" do
        render_inline(HeaderCellComponent.new(label: "Name", size: :xs))

        assert_selector "th.px-2"
        assert_selector "th.text-xs"
        assert rendered_html.include?("py-1.5"), "Expected py-1.5 class"
      end

      test "renders with sm size" do
        render_inline(HeaderCellComponent.new(label: "Name", size: :sm))

        assert_selector "th.px-3"
        assert_selector "th.py-2"
        assert_selector "th.text-sm"
      end

      test "renders with lg size" do
        render_inline(HeaderCellComponent.new(label: "Name", size: :lg))

        assert_selector "th.px-4"
        assert_selector "th.py-4"
        assert_selector "th.text-base"
      end

      test "renders with xl size" do
        render_inline(HeaderCellComponent.new(label: "Name", size: :xl))

        assert_selector "th.px-6"
        assert_selector "th.py-5"
        assert_selector "th.text-lg"
      end

      test "raises error for invalid size" do
        error = assert_raises(ArgumentError) do
          HeaderCellComponent.new(label: "Name", size: :invalid)
        end

        assert_match(/Invalid size/, error.message)
      end

      # Style tests
      test "renders without borders for default style" do
        render_inline(HeaderCellComponent.new(label: "Name", style: :default))

        refute_selector "th.border"
      end

      test "bordered style does not add borders to header cells" do
        render_inline(HeaderCellComponent.new(label: "Name", style: :bordered))

        refute_selector "th.border"
      end

      # Custom classes
      test "renders with custom container classes" do
        render_inline(HeaderCellComponent.new(label: "Name", container_classes: "custom-header"))

        assert_selector "th.custom-header"
      end

      # HTML attributes passthrough
      test "renders with colspan attribute" do
        render_inline(HeaderCellComponent.new(label: "Name", colspan: 3))

        assert_selector "th[colspan='3']", text: "Name"
      end

      test "renders with rowspan attribute" do
        render_inline(HeaderCellComponent.new(label: "Name", rowspan: 2))

        assert_selector "th[rowspan='2']", text: "Name"
      end

      test "renders with data attributes" do
        render_inline(HeaderCellComponent.new(label: "Name", data: { sort: "asc" }))

        assert_selector "th[data-sort='asc']"
      end

      # Card style tests
      test "renders with align-middle class" do
        render_inline(HeaderCellComponent.new(label: "Name"))

        assert_selector "th.align-middle"
      end

      test "renders with first/last cell padding classes" do
        render_inline(HeaderCellComponent.new(label: "Name"))

        assert rendered_html.include?("first:ps-4"), "Expected first:ps-4 class"
        assert rendered_html.include?("sm:first:ps-6"), "Expected sm:first:ps-6 class"
        assert rendered_html.include?("last:pe-4"), "Expected last:pe-4 class"
        assert rendered_html.include?("sm:last:pe-6"), "Expected sm:last:pe-6 class"
      end
    end
  end
end
