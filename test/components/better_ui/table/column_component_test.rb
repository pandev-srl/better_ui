# frozen_string_literal: true

require "test_helper"

module BetterUi
  module Table
    class ColumnComponentTest < ActiveSupport::TestCase
      test "renders empty string (data holder only)" do
        render_inline(ColumnComponent.new(key: :name))

        assert_equal "", rendered_html.strip
      end

      # display_label tests
      test "display_label returns label when provided" do
        column = ColumnComponent.new(key: :name, label: "Full Name")

        assert_equal "Full Name", column.display_label
      end

      test "display_label humanizes key when no label" do
        column = ColumnComponent.new(key: :first_name)

        assert_equal "First name", column.display_label
      end

      test "display_label returns empty string when no key or label" do
        column = ColumnComponent.new

        assert_equal "", column.display_label
      end

      # value_for tests
      test "value_for extracts value using key method" do
        item = Struct.new(:name).new("John")
        column = ColumnComponent.new(key: :name)

        assert_equal "John", column.value_for(item)
      end

      test "value_for extracts value using hash key" do
        item = { name: "John" }
        column = ColumnComponent.new(key: :name)

        assert_equal "John", column.value_for(item)
      end

      test "value_for uses formatter block when provided" do
        item = Struct.new(:role).new("admin")
        column = ColumnComponent.new(key: :role) { |i| i.role.upcase }

        assert_equal "ADMIN", column.value_for(item)
      end

      test "value_for prefers formatter over key extraction" do
        item = Struct.new(:name).new("John")
        column = ColumnComponent.new(key: :name) { |_i| "Custom" }

        assert_equal "Custom", column.value_for(item)
      end

      test "value_for returns empty string when no key or formatter" do
        item = Struct.new(:name).new("John")
        column = ColumnComponent.new

        assert_equal "", column.value_for(item)
      end

      # Alignment tests
      test "default alignment is left" do
        column = ColumnComponent.new(key: :name)

        assert_equal :left, column.align
      end

      test "accepts center alignment" do
        column = ColumnComponent.new(key: :name, align: :center)

        assert_equal :center, column.align
      end

      test "accepts right alignment" do
        column = ColumnComponent.new(key: :name, align: :right)

        assert_equal :right, column.align
      end

      test "raises error for invalid alignment" do
        error = assert_raises(ArgumentError) do
          ColumnComponent.new(key: :name, align: :invalid)
        end

        assert_match(/Invalid align/, error.message)
      end

      # Custom classes
      test "stores header_classes" do
        column = ColumnComponent.new(key: :name, header_classes: "custom-header")

        assert_equal "custom-header", column.header_classes
      end

      test "stores cell_classes" do
        column = ColumnComponent.new(key: :name, cell_classes: "custom-cell")

        assert_equal "custom-cell", column.cell_classes
      end

      # Attribute readers
      test "exposes key" do
        column = ColumnComponent.new(key: :email)

        assert_equal :email, column.key
      end

      test "exposes label" do
        column = ColumnComponent.new(label: "Email Address")

        assert_equal "Email Address", column.label
      end

      test "exposes formatter" do
        formatter = ->(item) { item.to_s }
        column = ColumnComponent.new(key: :name, &formatter)

        assert_equal formatter, column.formatter
      end

      # Sort URL and HTML tests
      test "stores sort_url" do
        column = ColumnComponent.new(key: :name, sort_url: "/users?sort=name")

        assert_equal "/users?sort=name", column.sort_url
      end

      test "sort_url defaults to nil" do
        column = ColumnComponent.new(key: :name)

        assert_nil column.sort_url
      end

      test "stores sort_html" do
        column = ColumnComponent.new(key: :name, sort_html: { data: { turbo_frame: "main" } })

        assert_equal({ data: { turbo_frame: "main" } }, column.sort_html)
      end

      test "sort_html defaults to empty hash" do
        column = ColumnComponent.new(key: :name)

        assert_equal({}, column.sort_html)
      end
    end
  end
end
