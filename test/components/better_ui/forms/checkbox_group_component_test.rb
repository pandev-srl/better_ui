# frozen_string_literal: true

require "test_helper"

module BetterUi
  module Forms
    class CheckboxGroupComponentTest < ActiveSupport::TestCase
      # Basic rendering tests
      test "renders fieldset element" do
        render_inline(CheckboxGroupComponent.new(
          name: "user[roles]",
          collection: [ "Admin", "Editor" ]
        ))

        assert_selector "fieldset"
      end

      test "renders checkboxes from simple array collection" do
        render_inline(CheckboxGroupComponent.new(
          name: "user[roles]",
          collection: [ "Admin", "Editor", "Viewer" ]
        ))

        assert_selector "input[type='checkbox']", count: 3
        assert_selector "input[value='Admin']"
        assert_selector "input[value='Editor']"
        assert_selector "input[value='Viewer']"
      end

      test "renders checkboxes from label/value pairs" do
        collection = [ [ "Administrator", "admin" ], [ "Content Editor", "editor" ] ]
        render_inline(CheckboxGroupComponent.new(
          name: "user[roles]",
          collection: collection
        ))

        assert_selector "input[type='checkbox']", count: 2
        assert_selector "input[value='admin']"
        assert_selector "input[value='editor']"
        assert_selector "label", text: "Administrator"
        assert_selector "label", text: "Content Editor"
      end

      test "renders with array field name" do
        render_inline(CheckboxGroupComponent.new(
          name: "user[roles]",
          collection: [ "Admin" ]
        ))

        assert_selector "input[name='user[roles][]']"
      end

      # Selection tests
      test "renders selected values as checked" do
        render_inline(CheckboxGroupComponent.new(
          name: "user[roles]",
          collection: [ "Admin", "Editor", "Viewer" ],
          selected: [ "Admin", "Viewer" ]
        ))

        assert_selector "input[value='Admin'][checked]"
        refute_selector "input[value='Editor'][checked]"
        assert_selector "input[value='Viewer'][checked]"
      end

      test "handles string and integer selected values" do
        collection = [ [ "Option 1", 1 ], [ "Option 2", 2 ], [ "Option 3", 3 ] ]
        render_inline(CheckboxGroupComponent.new(
          name: "options",
          collection: collection,
          selected: [ 1, "3" ]
        ))

        assert_selector "input[value='1'][checked]"
        refute_selector "input[value='2'][checked]"
        assert_selector "input[value='3'][checked]"
      end

      test "handles single selected value (not array)" do
        render_inline(CheckboxGroupComponent.new(
          name: "user[roles]",
          collection: [ "Admin", "Editor" ],
          selected: "Admin"
        ))

        assert_selector "input[value='Admin'][checked]"
        refute_selector "input[value='Editor'][checked]"
      end

      # Legend tests
      test "renders with legend" do
        render_inline(CheckboxGroupComponent.new(
          name: "user[roles]",
          collection: [ "Admin" ],
          legend: "Select Roles"
        ))

        assert_selector "legend", text: "Select Roles"
      end

      test "renders without legend when not provided" do
        render_inline(CheckboxGroupComponent.new(
          name: "user[roles]",
          collection: [ "Admin" ]
        ))

        refute_selector "legend"
      end

      test "renders required indicator with legend" do
        render_inline(CheckboxGroupComponent.new(
          name: "user[roles]",
          collection: [ "Admin" ],
          legend: "Roles",
          required: true
        ))

        assert_selector "legend span.text-danger-600", text: "*"
      end

      # Hint and error tests
      test "renders with hint text" do
        render_inline(CheckboxGroupComponent.new(
          name: "user[roles]",
          collection: [ "Admin" ],
          hint: "Select one or more roles"
        ))

        assert_text "Select one or more roles"
        assert_selector "div.text-gray-600"
      end

      test "renders with errors" do
        render_inline(CheckboxGroupComponent.new(
          name: "user[roles]",
          collection: [ "Admin" ],
          errors: [ "Please select at least one role" ]
        ))

        assert_text "Please select at least one role"
        assert_selector "div.text-danger-600"
      end

      test "renders with multiple errors" do
        errors = [ "Error one", "Error two" ]
        render_inline(CheckboxGroupComponent.new(
          name: "user[roles]",
          collection: [ "Admin" ],
          errors: errors
        ))

        assert_text "Error one"
        assert_text "Error two"
      end

      test "errors are displayed at group level not individual checkboxes" do
        render_inline(CheckboxGroupComponent.new(
          name: "user[roles]",
          collection: [ "Admin", "Editor" ],
          errors: [ "Error" ]
        ))

        # Should have exactly one error container (at group level)
        assert_selector "div.text-danger-600", count: 1
        # Individual checkboxes should not have error styling
        refute_selector "input.border-danger-500"
      end

      # Orientation tests
      test "renders vertical orientation by default" do
        render_inline(CheckboxGroupComponent.new(
          name: "user[roles]",
          collection: [ "Admin", "Editor" ]
        ))

        assert_selector "fieldset > div.flex-col"
      end

      test "renders horizontal orientation" do
        render_inline(CheckboxGroupComponent.new(
          name: "user[roles]",
          collection: [ "Admin", "Editor" ],
          orientation: :horizontal
        ))

        assert_selector "fieldset > div.flex-row"
        assert_selector "fieldset > div.flex-wrap"
      end

      # Size tests
      test "renders xs size checkboxes" do
        render_inline(CheckboxGroupComponent.new(
          name: "user[roles]",
          collection: [ "Admin" ],
          size: :xs
        ))

        assert_selector "input.w-3.h-3"
      end

      test "renders md size by default" do
        render_inline(CheckboxGroupComponent.new(
          name: "user[roles]",
          collection: [ "Admin" ]
        ))

        assert_selector "input.w-5.h-5"
      end

      test "renders xl size checkboxes" do
        render_inline(CheckboxGroupComponent.new(
          name: "user[roles]",
          collection: [ "Admin" ],
          size: :xl
        ))

        assert_selector "input.w-7.h-7"
      end

      test "renders legend size classes for different sizes" do
        render_inline(CheckboxGroupComponent.new(
          name: "user[roles]",
          collection: [ "Admin" ],
          legend: "Roles",
          size: :xl
        ))

        assert_selector "legend.text-lg"
      end

      # Variant tests
      test "renders primary variant by default" do
        render_inline(CheckboxGroupComponent.new(
          name: "user[roles]",
          collection: [ "Admin" ]
        ))

        assert_selector "input.checked\\:bg-primary-600"
      end

      test "renders success variant" do
        render_inline(CheckboxGroupComponent.new(
          name: "user[roles]",
          collection: [ "Admin" ],
          variant: :success
        ))

        assert_selector "input.checked\\:bg-success-600"
      end

      test "applies variant to all checkboxes" do
        render_inline(CheckboxGroupComponent.new(
          name: "user[roles]",
          collection: [ "Admin", "Editor", "Viewer" ],
          variant: :danger
        ))

        assert_selector "input.checked\\:bg-danger-600", count: 3
      end

      # Disabled state
      test "renders all checkboxes as disabled" do
        render_inline(CheckboxGroupComponent.new(
          name: "user[roles]",
          collection: [ "Admin", "Editor" ],
          disabled: true
        ))

        assert_selector "input[disabled]", count: 2
        assert_selector "fieldset[disabled]"
      end

      # Custom classes tests
      test "renders with custom container classes" do
        render_inline(CheckboxGroupComponent.new(
          name: "user[roles]",
          collection: [ "Admin" ],
          container_classes: "custom-fieldset"
        ))

        assert_selector "fieldset.custom-fieldset"
      end

      test "renders with custom legend classes" do
        render_inline(CheckboxGroupComponent.new(
          name: "user[roles]",
          collection: [ "Admin" ],
          legend: "Roles",
          legend_classes: "custom-legend"
        ))

        assert_selector "legend.custom-legend"
      end

      test "renders with custom items classes" do
        render_inline(CheckboxGroupComponent.new(
          name: "user[roles]",
          collection: [ "Admin" ],
          items_classes: "custom-items"
        ))

        assert_selector "div.custom-items"
      end

      test "renders with custom hint classes" do
        render_inline(CheckboxGroupComponent.new(
          name: "user[roles]",
          collection: [ "Admin" ],
          hint: "Hint",
          hint_classes: "custom-hint"
        ))

        assert_selector "div.custom-hint"
      end

      test "renders with custom error classes" do
        render_inline(CheckboxGroupComponent.new(
          name: "user[roles]",
          collection: [ "Admin" ],
          errors: [ "Error" ],
          error_classes: "custom-error"
        ))

        assert_selector "div.custom-error"
      end

      # Additional HTML options tests
      test "passes through additional HTML options to fieldset" do
        render_inline(CheckboxGroupComponent.new(
          name: "user[roles]",
          collection: [ "Admin" ],
          id: "roles-fieldset",
          data: { controller: "checkbox-group" }
        ))

        assert_selector "fieldset#roles-fieldset"
        assert_selector "fieldset[data-controller='checkbox-group']"
      end

      # ID generation tests
      test "generates unique IDs for each checkbox" do
        render_inline(CheckboxGroupComponent.new(
          name: "user[roles]",
          collection: [ "Admin", "Editor" ]
        ))

        assert_selector "input#user_roles_0"
        assert_selector "input#user_roles_1"
      end

      # Validation tests
      test "raises error for invalid size" do
        assert_raises(ArgumentError) do
          CheckboxGroupComponent.new(
            name: "user[roles]",
            collection: [ "Admin" ],
            size: :invalid
          )
        end
      end

      test "raises error for invalid variant" do
        assert_raises(ArgumentError) do
          CheckboxGroupComponent.new(
            name: "user[roles]",
            collection: [ "Admin" ],
            variant: :invalid
          )
        end
      end

      test "raises error for invalid orientation" do
        assert_raises(ArgumentError) do
          CheckboxGroupComponent.new(
            name: "user[roles]",
            collection: [ "Admin" ],
            orientation: :invalid
          )
        end
      end

      # Empty collection test
      test "renders empty items wrapper when collection is empty" do
        render_inline(CheckboxGroupComponent.new(
          name: "user[roles]",
          collection: [],
          legend: "Roles"
        ))

        assert_selector "fieldset"
        assert_selector "legend", text: "Roles"
        refute_selector "input[type='checkbox']"
      end

      # Complete form field rendering test
      test "renders complete checkbox group with all elements" do
        collection = [ [ "Administrator", "admin" ], [ "Editor", "editor" ], [ "Viewer", "viewer" ] ]
        render_inline(CheckboxGroupComponent.new(
          name: "user[roles]",
          collection: collection,
          selected: [ "admin", "viewer" ],
          legend: "User Roles",
          hint: "Select the roles for this user",
          variant: :primary,
          size: :md,
          orientation: :vertical,
          required: true
        ))

        assert_selector "fieldset"
        assert_selector "legend", text: "User Roles"
        assert_selector "legend span.text-danger-600", text: "*"
        assert_selector "input[type='checkbox']", count: 3
        assert_selector "input[value='admin'][checked]"
        assert_selector "input[value='editor']:not([checked])"
        assert_selector "input[value='viewer'][checked]"
        assert_selector "label", text: "Administrator"
        assert_selector "label", text: "Editor"
        assert_selector "label", text: "Viewer"
        assert_text "Select the roles for this user"
      end

      # Gap classes tests
      test "renders appropriate gap classes for vertical orientation" do
        render_inline(CheckboxGroupComponent.new(
          name: "options",
          collection: [ "A", "B" ],
          size: :md,
          orientation: :vertical
        ))

        assert_selector "div.gap-2\\.5"
      end

      test "renders appropriate gap classes for horizontal orientation" do
        render_inline(CheckboxGroupComponent.new(
          name: "options",
          collection: [ "A", "B" ],
          size: :md,
          orientation: :horizontal
        ))

        assert_selector "div.gap-x-6"
        assert_selector "div.gap-y-2\\.5"
      end

      # Label humanization test
      test "humanizes simple values into labels" do
        render_inline(CheckboxGroupComponent.new(
          name: "options",
          collection: [ "option_one", "option_two" ]
        ))

        assert_selector "label", text: "Option one"
        assert_selector "label", text: "Option two"
      end
    end
  end
end
