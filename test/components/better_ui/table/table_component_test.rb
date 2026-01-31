# frozen_string_literal: true

require "test_helper"
require "ostruct"

module BetterUi
  module Table
    class TableComponentTest < ActiveSupport::TestCase
      # ==========================================
      # Basic rendering tests
      # ==========================================

      test "renders a table element" do
        render_inline(TableComponent.new) do |t|
          t.with_header do |h|
            h.with_cell(label: "Name")
          end
          t.with_row do |r|
            r.with_cell { "John" }
          end
        end

        assert_selector "table"
      end

      test "renders with responsive wrapper by default" do
        render_inline(TableComponent.new) do |t|
          t.with_header do |h|
            h.with_cell(label: "Name")
          end
          t.with_row do |r|
            r.with_cell { "John" }
          end
        end

        assert_selector "div.overflow-x-auto"
        assert_selector "div.shadow-sm"
        assert_selector "div.sm\\:rounded-lg"
        assert_selector "div.overflow-x-auto table"
      end

      test "renders without responsive wrapper when disabled" do
        render_inline(TableComponent.new(responsive: false)) do |t|
          t.with_header do |h|
            h.with_cell(label: "Name")
          end
          t.with_row do |r|
            r.with_cell { "John" }
          end
        end

        refute_selector "div.overflow-x-auto"
        assert_selector "div.overflow-hidden"
        assert_selector "div.shadow-sm"
        assert_selector "div.sm\\:rounded-lg"
        assert_selector "div table"
      end

      test "renders with min-w-full class" do
        render_inline(TableComponent.new) do |t|
          t.with_row do |r|
            r.with_cell { "Content" }
          end
        end

        assert_selector "table.min-w-full"
      end

      # ==========================================
      # Slot mode tests
      # ==========================================

      test "slot mode renders header" do
        render_inline(TableComponent.new) do |t|
          t.with_header do |h|
            h.with_cell(label: "Name")
            h.with_cell(label: "Email")
          end
          t.with_row do |r|
            r.with_cell { "John" }
            r.with_cell { "john@example.com" }
          end
        end

        assert_selector "thead"
        assert_selector "thead th", text: "Name"
        assert_selector "thead th", text: "Email"
      end

      test "slot mode renders rows in tbody" do
        render_inline(TableComponent.new) do |t|
          t.with_row do |r|
            r.with_cell { "John" }
          end
          t.with_row do |r|
            r.with_cell { "Jane" }
          end
        end

        assert_selector "tbody"
        assert_selector "tbody tr", count: 2
        assert_text "John"
        assert_text "Jane"
      end

      test "slot mode renders footer" do
        render_inline(TableComponent.new) do |t|
          t.with_row do |r|
            r.with_cell { "John" }
          end
          t.with_footer_row do |r|
            r.with_cell { "Total: 1" }
          end
        end

        assert_selector "tfoot"
        assert_text "Total: 1"
      end

      test "slot mode renders empty state when no rows" do
        render_inline(TableComponent.new) do |t|
          t.with_header do |h|
            h.with_cell(label: "Name")
          end
          t.with_empty_state do
            "No records found."
          end
        end

        assert_text "No records found."
        assert_selector "tbody td"
      end

      test "slot mode does not render empty state when rows present" do
        render_inline(TableComponent.new) do |t|
          t.with_row do |r|
            r.with_cell { "John" }
          end
          t.with_empty_state do
            "No records found."
          end
        end

        assert_text "John"
        html_doc = Nokogiri::HTML.fragment(rendered_html)
        assert_not html_doc.text.include?("No records found."), "Expected empty state text not to be rendered"
      end

      # ==========================================
      # Collection mode tests
      # ==========================================

      test "collection mode renders header from columns" do
        users = [
          ::OpenStruct.new(name: "John", email: "john@example.com")
        ]

        render_inline(TableComponent.new(collection: users)) do |t|
          t.with_column(key: :name, label: "Name")
          t.with_column(key: :email, label: "Email")
        end

        assert_selector "thead"
        assert_selector "thead th", text: "Name"
        assert_selector "thead th", text: "Email"
      end

      test "collection mode auto-humanizes key for label" do
        users = [ ::OpenStruct.new(first_name: "John") ]

        render_inline(TableComponent.new(collection: users)) do |t|
          t.with_column(key: :first_name)
        end

        assert_selector "thead th", text: "First name"
      end

      test "collection mode renders rows from collection" do
        users = [
          ::OpenStruct.new(name: "John", email: "john@example.com"),
          ::OpenStruct.new(name: "Jane", email: "jane@example.com")
        ]

        render_inline(TableComponent.new(collection: users)) do |t|
          t.with_column(key: :name, label: "Name")
          t.with_column(key: :email, label: "Email")
        end

        assert_selector "tbody tr", count: 2
        assert_text "John"
        assert_text "jane@example.com"
      end

      test "collection mode uses formatter block" do
        users = [ ::OpenStruct.new(role: "admin") ]

        render_inline(TableComponent.new(collection: users)) do |t|
          t.with_column(key: :role, label: "Role") { |user| user.role.upcase }
        end

        assert_text "ADMIN"
      end

      test "collection mode renders empty state for empty collection" do
        render_inline(TableComponent.new(collection: [])) do |t|
          t.with_column(key: :name, label: "Name")
          t.with_empty_state do
            "No users found."
          end
        end

        assert_text "No users found."
      end

      test "collection mode works with hash items" do
        items = [
          { name: "John", email: "john@example.com" }
        ]

        render_inline(TableComponent.new(collection: items)) do |t|
          t.with_column(key: :name, label: "Name")
          t.with_column(key: :email, label: "Email")
        end

        assert_text "John"
        assert_text "john@example.com"
      end

      # ==========================================
      # Variant tests
      # ==========================================

      test "renders primary variant header" do
        render_inline(TableComponent.new(variant: :primary)) do |t|
          t.with_header do |h|
            h.with_cell(label: "Name")
          end
          t.with_row do |r|
            r.with_cell { "Content" }
          end
        end

        assert_selector "thead.bg-primary-50"
        assert_selector "thead.text-primary-900"
      end

      test "renders secondary variant header" do
        render_inline(TableComponent.new(variant: :secondary)) do |t|
          t.with_header do |h|
            h.with_cell(label: "Name")
          end
          t.with_row do |r|
            r.with_cell { "Content" }
          end
        end

        assert_selector "thead.bg-secondary-50"
        assert_selector "thead.text-secondary-900"
      end

      test "renders accent variant header" do
        render_inline(TableComponent.new(variant: :accent)) do |t|
          t.with_header do |h|
            h.with_cell(label: "Name")
          end
          t.with_row do |r|
            r.with_cell { "Content" }
          end
        end

        assert_selector "thead.bg-accent-50"
        assert_selector "thead.text-accent-900"
      end

      test "renders success variant header" do
        render_inline(TableComponent.new(variant: :success)) do |t|
          t.with_header do |h|
            h.with_cell(label: "Name")
          end
          t.with_row do |r|
            r.with_cell { "Content" }
          end
        end

        assert_selector "thead.bg-success-50"
        assert_selector "thead.text-success-900"
      end

      test "renders danger variant header" do
        render_inline(TableComponent.new(variant: :danger)) do |t|
          t.with_header do |h|
            h.with_cell(label: "Name")
          end
          t.with_row do |r|
            r.with_cell { "Content" }
          end
        end

        assert_selector "thead.bg-danger-50"
        assert_selector "thead.text-danger-900"
      end

      test "renders warning variant header" do
        render_inline(TableComponent.new(variant: :warning)) do |t|
          t.with_header do |h|
            h.with_cell(label: "Name")
          end
          t.with_row do |r|
            r.with_cell { "Content" }
          end
        end

        assert_selector "thead.bg-warning-50"
        assert_selector "thead.text-warning-900"
      end

      test "renders info variant header" do
        render_inline(TableComponent.new(variant: :info)) do |t|
          t.with_header do |h|
            h.with_cell(label: "Name")
          end
          t.with_row do |r|
            r.with_cell { "Content" }
          end
        end

        assert_selector "thead.bg-info-50"
        assert_selector "thead.text-info-900"
      end

      test "renders light variant header" do
        render_inline(TableComponent.new(variant: :light)) do |t|
          t.with_header do |h|
            h.with_cell(label: "Name")
          end
          t.with_row do |r|
            r.with_cell { "Content" }
          end
        end

        assert_selector "thead.bg-grayscale-100"
        assert_selector "thead.text-grayscale-700"
      end

      test "renders dark variant header" do
        render_inline(TableComponent.new(variant: :dark)) do |t|
          t.with_header do |h|
            h.with_cell(label: "Name")
          end
          t.with_row do |r|
            r.with_cell { "Content" }
          end
        end

        assert_selector "thead.bg-grayscale-800"
        assert_selector "thead.text-grayscale-50"
      end

      test "raises error for invalid variant" do
        error = assert_raises(ArgumentError) do
          TableComponent.new(variant: :invalid)
        end

        assert_match(/Invalid variant/, error.message)
      end

      # ==========================================
      # Style tests
      # ==========================================

      test "renders default style with divide-y on tbody" do
        render_inline(TableComponent.new(style: :default)) do |t|
          t.with_row do |r|
            r.with_cell { "Content" }
          end
        end

        assert_selector "tbody.divide-y"
        assert_selector "tbody.divide-primary-200"
        assert_selector "tbody.bg-white"
      end

      test "renders bordered style with border on table" do
        render_inline(TableComponent.new(style: :bordered)) do |t|
          t.with_row do |r|
            r.with_cell { "Content" }
          end
        end

        assert_selector "table.border"
        assert_selector "table.border-grayscale-200"
      end

      test "bordered style adds borders to cells" do
        render_inline(TableComponent.new(style: :bordered)) do |t|
          t.with_row do |r|
            r.with_cell { "Content" }
          end
        end

        assert_selector "td.border"
      end

      test "bordered style does not add divide-y to tbody" do
        render_inline(TableComponent.new(style: :bordered)) do |t|
          t.with_row do |r|
            r.with_cell { "Content" }
          end
        end

        refute_selector "tbody.divide-y"
      end

      test "raises error for invalid style" do
        error = assert_raises(ArgumentError) do
          TableComponent.new(style: :invalid)
        end

        assert_match(/Invalid style/, error.message)
      end

      # ==========================================
      # Size tests
      # ==========================================

      test "passes size to slot-mode cells" do
        render_inline(TableComponent.new(size: :xs)) do |t|
          t.with_row do |r|
            r.with_cell { "Content" }
          end
        end

        assert_selector "td.px-2"
        assert_selector "td.py-2"
      end

      test "applies size to collection-mode cells" do
        users = [ ::OpenStruct.new(name: "John") ]

        render_inline(TableComponent.new(collection: users, size: :lg)) do |t|
          t.with_column(key: :name, label: "Name")
        end

        assert_selector "td.px-4"
        assert_selector "td.py-5"
      end

      test "raises error for invalid size" do
        error = assert_raises(ArgumentError) do
          TableComponent.new(size: :invalid)
        end

        assert_match(/Invalid size/, error.message)
      end

      # ==========================================
      # Striped tests
      # ==========================================

      test "slot mode rows get striped classes" do
        render_inline(TableComponent.new(striped: true, variant: :primary)) do |t|
          t.with_row do |r|
            r.with_cell { "Row 1" }
          end
        end

        assert_selector "tr.even\\:bg-primary-50"
      end

      test "collection mode rows get striped classes" do
        users = [ ::OpenStruct.new(name: "John") ]

        render_inline(TableComponent.new(collection: users, striped: true, variant: :success)) do |t|
          t.with_column(key: :name, label: "Name")
        end

        assert_selector "tr.even\\:bg-success-50"
      end

      # ==========================================
      # Hoverable tests
      # ==========================================

      test "slot mode rows get hoverable classes" do
        render_inline(TableComponent.new(hoverable: true)) do |t|
          t.with_row do |r|
            r.with_cell { "Row 1" }
          end
        end

        assert_selector "tr.hover\\:bg-grayscale-100"
      end

      test "collection mode rows get hoverable classes" do
        users = [ ::OpenStruct.new(name: "John") ]

        render_inline(TableComponent.new(collection: users, hoverable: true)) do |t|
          t.with_column(key: :name, label: "Name")
        end

        assert_selector "tr.hover\\:bg-grayscale-100"
      end

      # ==========================================
      # Caption tests
      # ==========================================

      test "renders caption when provided" do
        render_inline(TableComponent.new(caption: "User list")) do |t|
          t.with_row do |r|
            r.with_cell { "Content" }
          end
        end

        assert_selector "caption", text: "User list"
        assert_selector "caption.caption-bottom"
        assert_selector "caption.text-grayscale-500"
      end

      test "does not render caption when nil" do
        render_inline(TableComponent.new) do |t|
          t.with_row do |r|
            r.with_cell { "Content" }
          end
        end

        refute_selector "caption"
      end

      # ==========================================
      # Shadow tests
      # ==========================================

      test "renders with shadow-sm by default" do
        render_inline(TableComponent.new) do |t|
          t.with_row do |r|
            r.with_cell { "Content" }
          end
        end

        assert_selector "div.shadow-sm"
      end

      test "renders with shadow-md when specified" do
        render_inline(TableComponent.new(shadow: :md)) do |t|
          t.with_row do |r|
            r.with_cell { "Content" }
          end
        end

        assert_selector "div.shadow-md"
      end

      test "renders without shadow when disabled" do
        render_inline(TableComponent.new(shadow: false)) do |t|
          t.with_row do |r|
            r.with_cell { "Content" }
          end
        end

        refute_selector "div.shadow-sm"
        refute_selector "div.shadow-md"
      end

      test "renders with shadow-sm for boolean true (backward compat)" do
        render_inline(TableComponent.new(shadow: true)) do |t|
          t.with_row do |r|
            r.with_cell { "Content" }
          end
        end

        assert_selector "div.shadow-sm"
      end

      # ==========================================
      # Custom classes tests
      # ==========================================

      test "renders with custom container classes" do
        render_inline(TableComponent.new(container_classes: "my-wrapper")) do |t|
          t.with_row do |r|
            r.with_cell { "Content" }
          end
        end

        assert_selector "div.my-wrapper"
      end

      test "renders with custom table classes" do
        render_inline(TableComponent.new(table_classes: "my-table")) do |t|
          t.with_row do |r|
            r.with_cell { "Content" }
          end
        end

        assert_selector "table.my-table"
      end

      test "renders with custom header classes" do
        render_inline(TableComponent.new(header_classes: "my-header")) do |t|
          t.with_header do |h|
            h.with_cell(label: "Name")
          end
          t.with_row do |r|
            r.with_cell { "Content" }
          end
        end

        assert_selector "thead.my-header"
      end

      test "renders with custom body classes" do
        render_inline(TableComponent.new(body_classes: "my-body")) do |t|
          t.with_row do |r|
            r.with_cell { "Content" }
          end
        end

        assert_selector "tbody.my-body"
      end

      test "renders with custom footer classes" do
        render_inline(TableComponent.new(footer_classes: "my-footer")) do |t|
          t.with_row do |r|
            r.with_cell { "Content" }
          end
          t.with_footer_row do |r|
            r.with_cell { "Footer" }
          end
        end

        assert_selector "tfoot.my-footer"
      end

      # ==========================================
      # Mode detection tests
      # ==========================================

      test "collection_mode? returns true when collection provided" do
        component = TableComponent.new(collection: [])
        assert component.collection_mode?
      end

      test "collection_mode? returns false when no collection" do
        component = TableComponent.new
        refute component.collection_mode?
      end

      # ==========================================
      # Footer tests
      # ==========================================

      test "renders tfoot with border" do
        render_inline(TableComponent.new) do |t|
          t.with_row do |r|
            r.with_cell { "Content" }
          end
          t.with_footer_row do |r|
            r.with_cell { "Total" }
          end
        end

        assert_selector "tfoot.border-t"
      end

      # ==========================================
      # Collection mode with column alignment
      # ==========================================

      test "collection mode respects column alignment" do
        users = [ ::OpenStruct.new(name: "John", amount: "$100") ]

        render_inline(TableComponent.new(collection: users)) do |t|
          t.with_column(key: :name, label: "Name")
          t.with_column(key: :amount, label: "Amount", align: :right)
        end

        assert_selector "th.text-right", text: "Amount"
        assert_selector "td.text-right", text: "$100"
      end

      # ==========================================
      # Collection mode with custom classes
      # ==========================================

      test "collection mode applies column header_classes" do
        users = [ ::OpenStruct.new(name: "John") ]

        render_inline(TableComponent.new(collection: users)) do |t|
          t.with_column(key: :name, label: "Name", header_classes: "custom-th")
        end

        assert_selector "th.custom-th"
      end

      test "collection mode applies column cell_classes" do
        users = [ ::OpenStruct.new(name: "John") ]

        render_inline(TableComponent.new(collection: users)) do |t|
          t.with_column(key: :name, label: "Name", cell_classes: "custom-td")
        end

        assert_selector "td.custom-td"
      end

      # ==========================================
      # Bordered style in collection mode
      # ==========================================

      test "bordered style in collection mode adds borders to cells" do
        users = [ ::OpenStruct.new(name: "John") ]

        render_inline(TableComponent.new(collection: users, style: :bordered)) do |t|
          t.with_column(key: :name, label: "Name")
        end

        assert_selector "th.border"
        assert_selector "td.border"
      end

      # ==========================================
      # Variant header in collection mode
      # ==========================================

      test "collection mode renders variant header" do
        users = [ ::OpenStruct.new(name: "John") ]

        render_inline(TableComponent.new(collection: users, variant: :danger)) do |t|
          t.with_column(key: :name, label: "Name")
        end

        assert_selector "thead.bg-danger-50"
        assert_selector "thead.text-danger-900"
      end

      # ==========================================
      # All striped variant coverage for collection mode
      # ==========================================

      test "collection mode striped secondary" do
        users = [ ::OpenStruct.new(name: "John") ]
        render_inline(TableComponent.new(collection: users, striped: true, variant: :secondary)) do |t|
          t.with_column(key: :name)
        end
        assert_selector "tr.even\\:bg-secondary-50"
      end

      test "collection mode striped accent" do
        users = [ ::OpenStruct.new(name: "John") ]
        render_inline(TableComponent.new(collection: users, striped: true, variant: :accent)) do |t|
          t.with_column(key: :name)
        end
        assert_selector "tr.even\\:bg-accent-50"
      end

      test "collection mode striped danger" do
        users = [ ::OpenStruct.new(name: "John") ]
        render_inline(TableComponent.new(collection: users, striped: true, variant: :danger)) do |t|
          t.with_column(key: :name)
        end
        assert_selector "tr.even\\:bg-danger-50"
      end

      test "collection mode striped warning" do
        users = [ ::OpenStruct.new(name: "John") ]
        render_inline(TableComponent.new(collection: users, striped: true, variant: :warning)) do |t|
          t.with_column(key: :name)
        end
        assert_selector "tr.even\\:bg-warning-50"
      end

      test "collection mode striped info" do
        users = [ ::OpenStruct.new(name: "John") ]
        render_inline(TableComponent.new(collection: users, striped: true, variant: :info)) do |t|
          t.with_column(key: :name)
        end
        assert_selector "tr.even\\:bg-info-50"
      end

      test "collection mode striped light" do
        users = [ ::OpenStruct.new(name: "John") ]
        render_inline(TableComponent.new(collection: users, striped: true, variant: :light)) do |t|
          t.with_column(key: :name)
        end
        assert_selector "tr.even\\:bg-grayscale-50"
      end

      test "collection mode striped dark" do
        users = [ ::OpenStruct.new(name: "John") ]
        render_inline(TableComponent.new(collection: users, striped: true, variant: :dark)) do |t|
          t.with_column(key: :name)
        end
        assert_selector "tr.even\\:bg-grayscale-700"
      end

      test "collection mode striped primary" do
        users = [ ::OpenStruct.new(name: "John") ]
        render_inline(TableComponent.new(collection: users, striped: true, variant: :primary)) do |t|
          t.with_column(key: :name)
        end
        assert_selector "tr.even\\:bg-primary-50"
      end
    end
  end
end
