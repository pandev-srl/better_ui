# frozen_string_literal: true

require "test_helper"

module BetterUi
  module Table
    class RowComponentTest < ActiveSupport::TestCase
      test "renders a tr element" do
        render_inline(RowComponent.new) do |r|
          r.with_cell { "Cell 1" }
        end

        assert_selector "tr"
      end

      test "renders cells within the row" do
        render_inline(RowComponent.new) do |r|
          r.with_cell { "Cell 1" }
          r.with_cell { "Cell 2" }
        end

        assert_text "Cell 1"
        assert_text "Cell 2"
        assert_selector "td", count: 2
      end

      test "passes size to cells" do
        render_inline(RowComponent.new(size: :lg)) do |r|
          r.with_cell { "Content" }
        end

        assert_selector "td.px-4"
        assert_selector "td.py-5"
      end

      test "passes style to cells" do
        render_inline(RowComponent.new(style: :bordered)) do |r|
          r.with_cell { "Content" }
        end

        assert_selector "td.border"
      end

      # Striped tests
      test "renders without striped classes by default" do
        render_inline(RowComponent.new) do |r|
          r.with_cell { "Content" }
        end

        refute_selector "tr[class*='even:']"
      end

      test "renders with striped classes for primary variant" do
        render_inline(RowComponent.new(striped: true, variant: :primary)) do |r|
          r.with_cell { "Content" }
        end

        assert_selector "tr.even\\:bg-primary-50"
      end

      test "renders with striped classes for secondary variant" do
        render_inline(RowComponent.new(striped: true, variant: :secondary)) do |r|
          r.with_cell { "Content" }
        end

        assert_selector "tr.even\\:bg-secondary-50"
      end

      test "renders with striped classes for accent variant" do
        render_inline(RowComponent.new(striped: true, variant: :accent)) do |r|
          r.with_cell { "Content" }
        end

        assert_selector "tr.even\\:bg-accent-50"
      end

      test "renders with striped classes for success variant" do
        render_inline(RowComponent.new(striped: true, variant: :success)) do |r|
          r.with_cell { "Content" }
        end

        assert_selector "tr.even\\:bg-success-50"
      end

      test "renders with striped classes for danger variant" do
        render_inline(RowComponent.new(striped: true, variant: :danger)) do |r|
          r.with_cell { "Content" }
        end

        assert_selector "tr.even\\:bg-danger-50"
      end

      test "renders with striped classes for warning variant" do
        render_inline(RowComponent.new(striped: true, variant: :warning)) do |r|
          r.with_cell { "Content" }
        end

        assert_selector "tr.even\\:bg-warning-50"
      end

      test "renders with striped classes for info variant" do
        render_inline(RowComponent.new(striped: true, variant: :info)) do |r|
          r.with_cell { "Content" }
        end

        assert_selector "tr.even\\:bg-info-50"
      end

      test "renders with striped classes for light variant" do
        render_inline(RowComponent.new(striped: true, variant: :light)) do |r|
          r.with_cell { "Content" }
        end

        assert_selector "tr.even\\:bg-grayscale-50"
      end

      test "renders with striped classes for dark variant" do
        render_inline(RowComponent.new(striped: true, variant: :dark)) do |r|
          r.with_cell { "Content" }
        end

        assert_selector "tr.even\\:bg-grayscale-700"
      end

      # Hoverable tests
      test "renders without hover classes by default" do
        render_inline(RowComponent.new) do |r|
          r.with_cell { "Content" }
        end

        refute_selector "tr.transition-colors"
      end

      test "renders with hover classes when hoverable" do
        render_inline(RowComponent.new(hoverable: true)) do |r|
          r.with_cell { "Content" }
        end

        assert_selector "tr.hover\\:bg-grayscale-100"
        assert_selector "tr.transition-colors"
      end

      # Custom classes
      test "renders with custom container classes" do
        render_inline(RowComponent.new(container_classes: "custom-row")) do |r|
          r.with_cell { "Content" }
        end

        assert_selector "tr.custom-row"
      end

      # Cell alignment passthrough
      test "allows cell alignment override" do
        render_inline(RowComponent.new) do |r|
          r.with_cell(align: :right) { "Right" }
        end

        assert_selector "td.text-right"
      end
    end
  end
end
