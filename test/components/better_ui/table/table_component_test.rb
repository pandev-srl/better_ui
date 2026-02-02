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

      test "bordered style uses variant ring color on wrapper" do
        render_inline(TableComponent.new(style: :bordered, variant: :primary)) do |t|
          t.with_row do |r|
            r.with_cell { "Content" }
          end
        end

        assert_selector "div.ring-primary-300"
      end

      test "bordered style does not add borders to cells" do
        render_inline(TableComponent.new(style: :bordered)) do |t|
          t.with_row do |r|
            r.with_cell { "Content" }
          end
        end

        refute_selector "td.border"
      end

      test "bordered style adds divide-y to tbody like default" do
        render_inline(TableComponent.new(style: :bordered)) do |t|
          t.with_row do |r|
            r.with_cell { "Content" }
          end
        end

        assert_selector "tbody.divide-y"
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

        assert_selector "tr.hover\\:bg-primary-100"
      end

      test "collection mode rows get hoverable classes" do
        users = [ ::OpenStruct.new(name: "John") ]

        render_inline(TableComponent.new(collection: users, hoverable: true)) do |t|
          t.with_column(key: :name, label: "Name")
        end

        assert_selector "tr.hover\\:bg-primary-100"
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

      test "bordered style in collection mode uses variant ring and dividers" do
        users = [ ::OpenStruct.new(name: "John") ]

        render_inline(TableComponent.new(collection: users, style: :bordered, variant: :primary)) do |t|
          t.with_column(key: :name, label: "Name")
        end

        assert_selector "div.ring-primary-300"
        assert_selector "table.divide-y"
        refute_selector "th.border"
        refute_selector "td.border"
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

      # ==========================================
      # Scope attribute tests (Feature 1)
      # ==========================================

      test "slot mode header cell has scope col by default" do
        render_inline(TableComponent.new) do |t|
          t.with_header do |h|
            h.with_cell(label: "Name")
          end
          t.with_row do |r|
            r.with_cell { "John" }
          end
        end

        assert_selector 'th[scope="col"]', text: "Name"
      end

      test "slot mode header cell with scope row" do
        render_inline(TableComponent.new) do |t|
          t.with_header do |h|
            h.with_cell(label: "Name", scope: :row)
          end
          t.with_row do |r|
            r.with_cell { "John" }
          end
        end

        assert_selector 'th[scope="row"]', text: "Name"
      end

      test "slot mode header cell with scope nil omits attribute" do
        render_inline(TableComponent.new) do |t|
          t.with_header do |h|
            h.with_cell(label: "Name", scope: nil)
          end
          t.with_row do |r|
            r.with_cell { "John" }
          end
        end

        assert_selector "th", text: "Name"
        refute_selector "th[scope]"
      end

      test "collection mode header has scope col" do
        users = [ ::OpenStruct.new(name: "John") ]

        render_inline(TableComponent.new(collection: users)) do |t|
          t.with_column(key: :name, label: "Name")
        end

        assert_selector 'th[scope="col"]', text: "Name"
      end

      # ==========================================
      # Border radius tests (Feature 2)
      # ==========================================

      test "renders with default rounded md" do
        render_inline(TableComponent.new) do |t|
          t.with_row do |r|
            r.with_cell { "Content" }
          end
        end

        assert_selector "div.sm\\:rounded-lg"
      end

      test "renders with rounded none" do
        render_inline(TableComponent.new(rounded: :none)) do |t|
          t.with_row do |r|
            r.with_cell { "Content" }
          end
        end

        refute_selector "div.sm\\:rounded-lg"
        refute_selector "div.sm\\:rounded-sm"
      end

      test "renders with rounded sm" do
        render_inline(TableComponent.new(rounded: :sm)) do |t|
          t.with_row do |r|
            r.with_cell { "Content" }
          end
        end

        assert_selector "div.sm\\:rounded-sm"
      end

      test "renders with rounded lg" do
        render_inline(TableComponent.new(rounded: :lg)) do |t|
          t.with_row do |r|
            r.with_cell { "Content" }
          end
        end

        assert_selector "div.sm\\:rounded-xl"
      end

      test "renders with rounded xl" do
        render_inline(TableComponent.new(rounded: :xl)) do |t|
          t.with_row do |r|
            r.with_cell { "Content" }
          end
        end

        assert_selector "div.sm\\:rounded-2xl"
      end

      test "renders with rounded full" do
        render_inline(TableComponent.new(rounded: :full)) do |t|
          t.with_row do |r|
            r.with_cell { "Content" }
          end
        end

        assert_selector "div.sm\\:rounded-full"
      end

      test "raises error for invalid rounded" do
        error = assert_raises(ArgumentError) do
          TableComponent.new(rounded: :invalid)
        end

        assert_match(/Invalid rounded/, error.message)
      end

      # ==========================================
      # Row highlighting tests (Feature 3)
      # ==========================================

      test "slot mode row not highlighted by default" do
        render_inline(TableComponent.new(variant: :primary)) do |t|
          t.with_row do |r|
            r.with_cell { "John" }
          end
        end

        refute_selector "tr.bg-primary-100"
      end

      test "slot mode row highlighted with primary variant" do
        render_inline(TableComponent.new(variant: :primary)) do |t|
          t.with_row(highlighted: true) do |r|
            r.with_cell { "John" }
          end
        end

        assert_selector "tr.bg-primary-100"
      end

      test "slot mode row highlighted with success variant" do
        render_inline(TableComponent.new(variant: :success)) do |t|
          t.with_row(highlighted: true) do |r|
            r.with_cell { "John" }
          end
        end

        assert_selector "tr.bg-success-100"
      end

      test "slot mode row highlighted with danger variant" do
        render_inline(TableComponent.new(variant: :danger)) do |t|
          t.with_row(highlighted: true) do |r|
            r.with_cell { "John" }
          end
        end

        assert_selector "tr.bg-danger-100"
      end

      test "slot mode row highlighted with dark variant" do
        render_inline(TableComponent.new(variant: :dark)) do |t|
          t.with_row(highlighted: true) do |r|
            r.with_cell { "John" }
          end
        end

        assert_selector "tr.bg-grayscale-700"
      end

      test "slot mode row highlighted combined with hoverable" do
        render_inline(TableComponent.new(variant: :primary, hoverable: true)) do |t|
          t.with_row(highlighted: true) do |r|
            r.with_cell { "John" }
          end
        end

        assert_selector "tr.bg-primary-100"
        assert_selector "tr.hover\\:bg-primary-100"
      end

      test "collection mode row highlighting with proc" do
        users = [
          ::OpenStruct.new(name: "John", active: true),
          ::OpenStruct.new(name: "Jane", active: false)
        ]

        render_inline(TableComponent.new(
          collection: users,
          variant: :primary,
          row_highlighted: ->(item) { item.active }
        )) do |t|
          t.with_column(key: :name, label: "Name")
        end

        html_doc = Nokogiri::HTML.fragment(rendered_html)
        rows = html_doc.css("tbody tr")
        assert rows[0]["class"].include?("bg-primary-100"), "First row should be highlighted"
        refute rows[1]["class"].include?("bg-primary-100"), "Second row should not be highlighted"
      end

      test "collection mode row highlighting with danger variant" do
        users = [ ::OpenStruct.new(name: "John", flagged: true) ]

        render_inline(TableComponent.new(
          collection: users,
          variant: :danger,
          row_highlighted: ->(item) { item.flagged }
        )) do |t|
          t.with_column(key: :name, label: "Name")
        end

        assert_selector "tr.bg-danger-100"
      end

      test "collection mode no highlighting without proc" do
        users = [ ::OpenStruct.new(name: "John") ]

        render_inline(TableComponent.new(collection: users, variant: :primary)) do |t|
          t.with_column(key: :name, label: "Name")
        end

        refute_selector "tr.bg-primary-100"
      end

      # ==========================================
      # Sortable header tests (Feature 4)
      # ==========================================

      test "slot mode header cell not sortable by default" do
        render_inline(TableComponent.new) do |t|
          t.with_header do |h|
            h.with_cell(label: "Name")
          end
          t.with_row do |r|
            r.with_cell { "John" }
          end
        end

        refute_selector "th.cursor-pointer"
        refute_selector "th span.flex"
      end

      test "slot mode sortable header cell has cursor-pointer" do
        render_inline(TableComponent.new) do |t|
          t.with_header do |h|
            h.with_cell(label: "Name", sortable: true)
          end
          t.with_row do |r|
            r.with_cell { "John" }
          end
        end

        assert_selector "th.cursor-pointer"
        assert_selector "th.select-none"
      end

      test "slot mode sortable header has unsorted SVG icon" do
        render_inline(TableComponent.new) do |t|
          t.with_header do |h|
            h.with_cell(label: "Name", sortable: true)
          end
          t.with_row do |r|
            r.with_cell { "John" }
          end
        end

        assert_selector "th span.flex.items-center.gap-1"
        assert_selector "th span svg"
      end

      test "slot mode sorted asc header has chevron-up SVG" do
        render_inline(TableComponent.new) do |t|
          t.with_header do |h|
            h.with_cell(label: "Name", sortable: true, sorted: true, sort_direction: :asc)
          end
          t.with_row do |r|
            r.with_cell { "John" }
          end
        end

        assert_selector "th span svg"
        # Asc SVG has a single path (chevron up)
        html_doc = Nokogiri::HTML.fragment(rendered_html)
        svg = html_doc.at_css("th span svg")
        assert svg, "Expected SVG icon in sorted asc header"
      end

      test "slot mode sorted desc header has chevron-down SVG" do
        render_inline(TableComponent.new) do |t|
          t.with_header do |h|
            h.with_cell(label: "Name", sortable: true, sorted: true, sort_direction: :desc)
          end
          t.with_row do |r|
            r.with_cell { "John" }
          end
        end

        assert_selector "th span svg"
        html_doc = Nokogiri::HTML.fragment(rendered_html)
        svg = html_doc.at_css("th span svg")
        assert svg, "Expected SVG icon in sorted desc header"
      end

      test "slot mode non-sortable header has no SVG icon" do
        render_inline(TableComponent.new) do |t|
          t.with_header do |h|
            h.with_cell(label: "Name")
          end
          t.with_row do |r|
            r.with_cell { "John" }
          end
        end

        refute_selector "th svg"
      end

      test "raises error for invalid sort_direction" do
        error = assert_raises(ArgumentError) do
          HeaderCellComponent.new(label: "Name", sortable: true, sort_direction: :invalid)
        end

        assert_match(/Invalid sort_direction/, error.message)
      end

      test "collection mode sortable column has SVG icon" do
        users = [ ::OpenStruct.new(name: "John") ]

        render_inline(TableComponent.new(collection: users)) do |t|
          t.with_column(key: :name, label: "Name", sortable: true)
        end

        assert_selector "th.cursor-pointer"
        assert_selector "th.select-none"
        assert_selector "th span svg"
      end

      test "collection mode sorted asc column has SVG icon" do
        users = [ ::OpenStruct.new(name: "John") ]

        render_inline(TableComponent.new(collection: users)) do |t|
          t.with_column(key: :name, label: "Name", sortable: true, sorted: true, sort_direction: :asc)
        end

        assert_selector "th span svg"
      end

      test "collection mode sorted desc column has SVG icon" do
        users = [ ::OpenStruct.new(name: "John") ]

        render_inline(TableComponent.new(collection: users)) do |t|
          t.with_column(key: :name, label: "Name", sortable: true, sorted: true, sort_direction: :desc)
        end

        assert_selector "th span svg"
      end

      test "collection mode non-sortable column has no SVG icon" do
        users = [ ::OpenStruct.new(name: "John") ]

        render_inline(TableComponent.new(collection: users)) do |t|
          t.with_column(key: :name, label: "Name")
        end

        refute_selector "th.cursor-pointer"
        refute_selector "th svg"
      end

      # ==========================================
      # Sort link tests (Feature 7)
      # ==========================================

      test "collection mode sortable column with sort_url renders link" do
        users = [ ::OpenStruct.new(name: "John") ]

        render_inline(TableComponent.new(collection: users)) do |t|
          t.with_column(key: :name, label: "Name", sortable: true,
                        sort_url: "/users?sort=name&direction=desc")
        end

        assert_selector 'th a[href="/users?sort=name&direction=desc"]'
        assert_selector "th a svg"
      end

      test "collection mode sortable column without sort_url renders span" do
        users = [ ::OpenStruct.new(name: "John") ]

        render_inline(TableComponent.new(collection: users)) do |t|
          t.with_column(key: :name, label: "Name", sortable: true)
        end

        refute_selector "th a"
        assert_selector "th span.flex"
      end

      test "collection mode sort_url column with sort_html adds data attributes" do
        users = [ ::OpenStruct.new(name: "John") ]

        render_inline(TableComponent.new(collection: users)) do |t|
          t.with_column(key: :name, label: "Name", sortable: true,
                        sort_url: "/users?sort=name",
                        sort_html: { data: { turbo_frame: "users_list" } })
        end

        assert_selector 'th a[data-turbo-frame="users_list"]'
      end

      test "table-level sort_url renders links on all sortable columns" do
        users = [ ::OpenStruct.new(name: "John", email: "j@example.com") ]

        render_inline(TableComponent.new(
          collection: users,
          sort_url: ->(key, dir) { "/users?sort=#{key}&direction=#{dir}" }
        )) do |t|
          t.with_column(key: :name, label: "Name", sortable: true)
          t.with_column(key: :email, label: "Email", sortable: true)
          t.with_column(key: :role, label: "Role")
        end

        html_doc = Nokogiri::HTML.fragment(rendered_html)
        links = html_doc.css("th a")
        assert_equal 2, links.size, "Expected 2 sort links (only sortable columns)"
      end

      test "table-level sort_column derives sorted state" do
        users = [ ::OpenStruct.new(name: "John", email: "j@example.com") ]

        render_inline(TableComponent.new(
          collection: users,
          sort_column: :name,
          sort_direction: :asc,
          sort_url: ->(key, dir) { "/users?sort=#{key}&direction=#{dir}" }
        )) do |t|
          t.with_column(key: :name, label: "Name", sortable: true)
          t.with_column(key: :email, label: "Email", sortable: true)
        end

        html_doc = Nokogiri::HTML.fragment(rendered_html)
        # Name column should be sorted (variant icon color)
        name_th = html_doc.css("th").first
        name_icon_span = name_th.at_css("a > span")
        assert name_icon_span, "Expected icon span in name header"

        # Email column should be unsorted (grayscale icon color)
        email_th = html_doc.css("th").last
        email_icon_span = email_th.at_css("a > span")
        assert email_icon_span, "Expected icon span in email header"
        assert email_icon_span["class"].include?("text-grayscale-400"), "Expected unsorted icon class"
      end

      test "table-level sort_url generates next direction URL (asc toggles to desc)" do
        users = [ ::OpenStruct.new(name: "John") ]
        captured_args = []

        render_inline(TableComponent.new(
          collection: users,
          sort_column: :name,
          sort_direction: :asc,
          sort_url: ->(key, dir) { captured_args << [ key, dir ]; "/users?sort=#{key}&direction=#{dir}" }
        )) do |t|
          t.with_column(key: :name, label: "Name", sortable: true)
        end

        assert_equal [ :name, :desc ], captured_args.first, "Expected next direction to be :desc when current is :asc"
      end

      test "table-level sort_url generates next direction URL (desc toggles to asc)" do
        users = [ ::OpenStruct.new(name: "John") ]
        captured_args = []

        render_inline(TableComponent.new(
          collection: users,
          sort_column: :name,
          sort_direction: :desc,
          sort_url: ->(key, dir) { captured_args << [ key, dir ]; "/users?sort=#{key}&direction=#{dir}" }
        )) do |t|
          t.with_column(key: :name, label: "Name", sortable: true)
        end

        assert_equal [ :name, :asc ], captured_args.first, "Expected next direction to be :asc when current is :desc"
      end

      test "table-level sort_url unsorted column defaults to asc" do
        users = [ ::OpenStruct.new(name: "John", email: "j@example.com") ]
        captured_args = []

        render_inline(TableComponent.new(
          collection: users,
          sort_column: :name,
          sort_direction: :asc,
          sort_url: ->(key, dir) { captured_args << [ key, dir ]; "/users?sort=#{key}&direction=#{dir}" }
        )) do |t|
          t.with_column(key: :name, label: "Name", sortable: true)
          t.with_column(key: :email, label: "Email", sortable: true)
        end

        email_args = captured_args.find { |k, _| k == :email }
        assert_equal [ :email, :asc ], email_args, "Expected unsorted column to default to :asc"
      end

      test "table-level sort_html adds attributes to all sort links" do
        users = [ ::OpenStruct.new(name: "John") ]

        render_inline(TableComponent.new(
          collection: users,
          sort_url: ->(key, dir) { "/users?sort=#{key}&direction=#{dir}" },
          sort_html: { data: { turbo_frame: "main" } }
        )) do |t|
          t.with_column(key: :name, label: "Name", sortable: true)
        end

        assert_selector 'th a[data-turbo-frame="main"]'
      end

      test "column-level sort_url overrides table-level sort_url" do
        users = [ ::OpenStruct.new(name: "John") ]

        render_inline(TableComponent.new(
          collection: users,
          sort_url: ->(key, dir) { "/table-level?sort=#{key}&direction=#{dir}" }
        )) do |t|
          t.with_column(key: :name, label: "Name", sortable: true,
                        sort_url: "/column-level?sort=name")
        end

        assert_selector 'th a[href="/column-level?sort=name"]'
        refute_selector 'th a[href^="/table-level"]'
      end

      test "column-level sort_html overrides table-level sort_html" do
        users = [ ::OpenStruct.new(name: "John") ]

        render_inline(TableComponent.new(
          collection: users,
          sort_url: ->(key, dir) { "/users?sort=#{key}&direction=#{dir}" },
          sort_html: { data: { turbo_frame: "table-frame" } }
        )) do |t|
          t.with_column(key: :name, label: "Name", sortable: true,
                        sort_html: { data: { turbo_frame: "column-frame" } })
        end

        assert_selector 'th a[data-turbo-frame="column-frame"]'
        refute_selector 'th a[data-turbo-frame="table-frame"]'
      end

      test "non-sortable column never gets sort link even with table-level sort_url" do
        users = [ ::OpenStruct.new(name: "John") ]

        render_inline(TableComponent.new(
          collection: users,
          sort_url: ->(key, dir) { "/users?sort=#{key}&direction=#{dir}" }
        )) do |t|
          t.with_column(key: :name, label: "Name")
        end

        refute_selector "th a"
      end

      test "header_partial still overrides sort link rendering" do
        users = [ ::OpenStruct.new(name: "John") ]

        render_inline(TableComponent.new(
          collection: users,
          sort_url: ->(key, dir) { "/users?sort=#{key}&direction=#{dir}" },
          header_partial: "shared/test_table_header"
        )) do |t|
          t.with_column(key: :name, label: "Name", sortable: true)
        end

        refute_selector "th a"
        assert_text "Custom Header"
      end

      # ==========================================
      # Partials system tests (Feature 5)
      # ==========================================

      test "collection mode renders body_row_partial for each item" do
        users = [
          ::OpenStruct.new(name: "John", email: "john@example.com"),
          ::OpenStruct.new(name: "Jane", email: "jane@example.com")
        ]

        render_inline(TableComponent.new(
          collection: users,
          body_row_partial: "shared/test_table_row"
        )) do |t|
          t.with_column(key: :name, label: "Name")
          t.with_column(key: :email, label: "Email")
        end

        assert_selector "tr.custom-row", count: 2
        assert_text "Custom: John"
        assert_text "Custom: Jane"
      end

      test "collection mode falls back to default rendering without body_row_partial" do
        users = [ ::OpenStruct.new(name: "John") ]

        render_inline(TableComponent.new(collection: users)) do |t|
          t.with_column(key: :name, label: "Name")
        end

        assert_selector "td", text: "John"
        refute_selector "tr.custom-row"
      end

      test "collection mode renders header_partial override" do
        users = [ ::OpenStruct.new(name: "John") ]

        render_inline(TableComponent.new(
          collection: users,
          header_partial: "shared/test_table_header"
        )) do |t|
          t.with_column(key: :name, label: "Name")
        end

        assert_selector "thead"
        assert_text "Custom Header"
      end

      test "collection mode renders footer_partial" do
        users = [ ::OpenStruct.new(name: "John") ]

        render_inline(TableComponent.new(
          collection: users,
          footer_partial: "shared/test_table_footer"
        )) do |t|
          t.with_column(key: :name, label: "Name")
        end

        assert_selector "tfoot"
        assert_text "Custom Footer"
      end

      # ==========================================
      # row_html customization tests (Feature 6)
      # ==========================================

      test "row_html adds custom CSS classes to collection rows" do
        users = [ ::OpenStruct.new(name: "John", admin: true) ]

        render_inline(TableComponent.new(
          collection: users,
          row_html: ->(_user) { { class: "font-bold" } }
        )) do |t|
          t.with_column(key: :name, label: "Name")
        end

        assert_selector "tr.font-bold"
      end

      test "row_html merges classes with striped classes" do
        users = [ ::OpenStruct.new(name: "John") ]

        render_inline(TableComponent.new(
          collection: users,
          striped: true,
          variant: :primary,
          row_html: ->(_user) { { class: "font-bold" } }
        )) do |t|
          t.with_column(key: :name, label: "Name")
        end

        html_doc = Nokogiri::HTML.fragment(rendered_html)
        row = html_doc.at_css("tbody tr")
        assert row["class"].include?("font-bold"), "Expected custom class"
        assert row["class"].include?("even:bg-primary-50"), "Expected striped class"
      end

      test "row_html merges classes with highlighted classes" do
        users = [ ::OpenStruct.new(name: "John", active: true) ]

        render_inline(TableComponent.new(
          collection: users,
          variant: :primary,
          row_highlighted: ->(item) { item.active },
          row_html: ->(_user) { { class: "custom-highlight" } }
        )) do |t|
          t.with_column(key: :name, label: "Name")
        end

        html_doc = Nokogiri::HTML.fragment(rendered_html)
        row = html_doc.at_css("tbody tr")
        assert row["class"].include?("custom-highlight"), "Expected custom class"
        assert row["class"].include?("bg-primary-100"), "Expected highlighted class"
      end

      test "row_html adds data attributes to rows" do
        users = [ ::OpenStruct.new(name: "John", id: 42) ]

        render_inline(TableComponent.new(
          collection: users,
          row_html: ->(user) { { data: { id: user.id } } }
        )) do |t|
          t.with_column(key: :name, label: "Name")
        end

        assert_selector 'tr[data-id="42"]'
      end

      test "row_html adds id attribute to rows" do
        users = [ ::OpenStruct.new(name: "John") ]

        render_inline(TableComponent.new(
          collection: users,
          row_html: ->(_user) { { id: "user-row" } }
        )) do |t|
          t.with_column(key: :name, label: "Name")
        end

        assert_selector "tr#user-row"
      end

      test "row_html 2-arity proc receives item and index" do
        users = [
          ::OpenStruct.new(name: "John"),
          ::OpenStruct.new(name: "Jane")
        ]

        render_inline(TableComponent.new(
          collection: users,
          row_html: ->(_user, idx) { { id: "row-#{idx}" } }
        )) do |t|
          t.with_column(key: :name, label: "Name")
        end

        assert_selector "tr#row-0"
        assert_selector "tr#row-1"
      end

      test "row_html nil return from proc is treated as no-op" do
        users = [ ::OpenStruct.new(name: "John") ]

        render_inline(TableComponent.new(
          collection: users,
          row_html: ->(_user) { nil }
        )) do |t|
          t.with_column(key: :name, label: "Name")
        end

        assert_selector "tbody tr"
        assert_text "John"
      end

      test "row_html raises ArgumentError for non-hash return" do
        users = [ ::OpenStruct.new(name: "John") ]

        error = assert_raises(ArgumentError) do
          render_inline(TableComponent.new(
            collection: users,
            row_html: ->(_user) { "invalid" }
          )) do |t|
            t.with_column(key: :name, label: "Name")
          end
        end

        assert_match(/row_html proc must return a Hash or nil/, error.message)
      end

      test "row_html combines multiple attributes (id + class + data)" do
        users = [ ::OpenStruct.new(name: "John", id: 7) ]

        render_inline(TableComponent.new(
          collection: users,
          row_html: ->(user) { { id: "user-#{user.id}", class: "special", data: { role: "admin" } } }
        )) do |t|
          t.with_column(key: :name, label: "Name")
        end

        assert_selector 'tr#user-7.special[data-role="admin"]'
      end

      test "row_html is ignored when body_row_partial is set" do
        users = [
          ::OpenStruct.new(name: "John", email: "john@example.com")
        ]

        render_inline(TableComponent.new(
          collection: users,
          body_row_partial: "shared/test_table_row",
          row_html: ->(_user) { { class: "should-not-appear" } }
        )) do |t|
          t.with_column(key: :name, label: "Name")
          t.with_column(key: :email, label: "Email")
        end

        assert_selector "tr.custom-row"
        refute_selector "tr.should-not-appear"
      end

      test "collection mode works without row_html (backward compat)" do
        users = [ ::OpenStruct.new(name: "John") ]

        render_inline(TableComponent.new(collection: users)) do |t|
          t.with_column(key: :name, label: "Name")
        end

        assert_selector "tbody tr"
        assert_text "John"
      end

      test "partials are ignored in slot mode" do
        render_inline(TableComponent.new(
          body_row_partial: "shared/test_table_row",
          header_partial: "shared/test_table_header",
          footer_partial: "shared/test_table_footer"
        )) do |t|
          t.with_header do |h|
            h.with_cell(label: "Name")
          end
          t.with_row do |r|
            r.with_cell { "John" }
          end
        end

        assert_selector "th", text: "Name"
        assert_selector "td", text: "John"
        refute_selector "tr.custom-row"
        html_doc = Nokogiri::HTML.fragment(rendered_html)
        assert_not html_doc.text.include?("Custom Header"), "Expected 'Custom Header' not to be rendered in slot mode"
        assert_not html_doc.text.include?("Custom Footer"), "Expected 'Custom Footer' not to be rendered in slot mode"
      end
    end
  end
end
