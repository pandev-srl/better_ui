# frozen_string_literal: true

require "test_helper"

module BetterUi
  module Forms
    class NumberInputComponentTest < ActiveSupport::TestCase
      test "renders number input with default options" do
        render_inline(NumberInputComponent.new(name: "user[age]"))

        assert_selector "input[type='number']"
        assert_selector "input[name='user[age]']"
      end

      test "renders with label" do
        render_inline(NumberInputComponent.new(name: "age", label: "Your Age"))

        assert_selector "label", text: "Your Age"
        assert_selector "input[type='number']"
      end

      test "renders with numeric value" do
        render_inline(NumberInputComponent.new(name: "quantity", value: 5))

        assert_selector "input[value='5']"
      end

      test "renders with string value" do
        render_inline(NumberInputComponent.new(name: "quantity", value: "10"))

        assert_selector "input[value='10']"
      end

      test "renders with placeholder" do
        render_inline(NumberInputComponent.new(name: "age", placeholder: "Enter your age"))

        assert_selector "input[placeholder='Enter your age']"
      end

      # Min/Max/Step attribute tests
      test "renders with min attribute" do
        render_inline(NumberInputComponent.new(name: "age", min: 0))

        assert_selector "input[min='0']"
      end

      test "renders with max attribute" do
        render_inline(NumberInputComponent.new(name: "age", max: 120))

        assert_selector "input[max='120']"
      end

      test "renders with step attribute" do
        render_inline(NumberInputComponent.new(name: "price", step: 0.01))

        assert_selector "input[step='0.01']"
      end

      test "renders with min, max, and step" do
        render_inline(NumberInputComponent.new(name: "price", min: 0, max: 1000, step: 0.01))

        assert_selector "input[min='0']"
        assert_selector "input[max='1000']"
        assert_selector "input[step='0.01']"
      end

      test "does not render min attribute when not provided" do
        render_inline(NumberInputComponent.new(name: "age"))

        refute_selector "input[min]"
      end

      test "does not render max attribute when not provided" do
        render_inline(NumberInputComponent.new(name: "age"))

        refute_selector "input[max]"
      end

      test "does not render step attribute when not provided" do
        render_inline(NumberInputComponent.new(name: "age"))

        refute_selector "input[step]"
      end

      # Spinner control tests
      test "shows spinner by default" do
        render_inline(NumberInputComponent.new(name: "quantity"))

        # When spinner is visible, hide-number-spinner class should not be present
        refute_selector "input.hide-number-spinner"
      end

      test "hides spinner when show_spinner is false" do
        render_inline(NumberInputComponent.new(name: "quantity", show_spinner: false))

        assert_selector "input.hide-number-spinner"
      end

      test "shows spinner when show_spinner is explicitly true" do
        render_inline(NumberInputComponent.new(name: "quantity", show_spinner: true))

        refute_selector "input.hide-number-spinner"
      end

      # Hint and error tests
      test "renders with hint text" do
        render_inline(NumberInputComponent.new(name: "age", hint: "Must be 18 or older"))

        assert_text "Must be 18 or older"
      end

      test "renders with errors" do
        render_inline(NumberInputComponent.new(name: "age", errors: [ "Age must be a number" ]))

        assert_text "Age must be a number"
        assert_selector "div.text-danger-600"
        assert_selector "input.border-danger-500"
      end

      # State tests
      test "renders as required" do
        render_inline(NumberInputComponent.new(name: "age", required: true, label: "Age"))

        assert_selector "input[required]"
      end

      test "renders as disabled" do
        render_inline(NumberInputComponent.new(name: "age", disabled: true))

        assert_selector "input[disabled]"
        assert_selector "input.cursor-not-allowed"
      end

      test "renders as readonly" do
        render_inline(NumberInputComponent.new(name: "age", readonly: true))

        assert_selector "input[readonly]"
        assert_selector "input.bg-gray-50"
      end

      # Size tests
      test "renders xs size" do
        render_inline(NumberInputComponent.new(name: "quantity", size: :xs))

        assert_selector "input.text-xs"
        assert_selector "input.py-1.px-2"
      end

      test "renders sm size" do
        render_inline(NumberInputComponent.new(name: "quantity", size: :sm))

        assert_selector "input.text-sm"
      end

      test "renders md size by default" do
        render_inline(NumberInputComponent.new(name: "quantity"))

        assert_selector "input.text-base"
        assert_selector "input.py-2.px-4"
      end

      test "renders lg size" do
        render_inline(NumberInputComponent.new(name: "quantity", size: :lg))

        assert_selector "input.text-lg"
      end

      test "renders xl size" do
        render_inline(NumberInputComponent.new(name: "quantity", size: :xl))

        assert_selector "input.text-xl"
      end

      # Icon slot tests
      test "renders with prefix icon" do
        render_inline(NumberInputComponent.new(name: "price")) do |component|
          component.with_prefix_icon { '<span class="prefix">$</span>'.html_safe }
        end

        assert_selector "span.prefix", text: "$"
        assert_selector "input.pl-10" # md size padding adjustment
      end

      test "renders with suffix icon" do
        render_inline(NumberInputComponent.new(name: "weight")) do |component|
          component.with_suffix_icon { '<span class="suffix">kg</span>'.html_safe }
        end

        assert_selector "span.suffix", text: "kg"
        assert_selector "input.pr-10" # md size padding adjustment
      end

      test "renders with both prefix and suffix icons" do
        render_inline(NumberInputComponent.new(name: "range")) do |component|
          component.with_prefix_icon { "<span>Min</span>".html_safe }
          component.with_suffix_icon { "<span>Max</span>".html_safe }
        end

        assert_selector "span", text: "Min"
        assert_selector "span", text: "Max"
        assert_selector "input.pl-10.pr-10"
      end

      test "adjusts padding for icon with no spinner" do
        render_inline(NumberInputComponent.new(name: "price", show_spinner: false)) do |component|
          component.with_prefix_icon { "<span>$</span>".html_safe }
        end

        assert_selector "input.pl-10.hide-number-spinner"
      end

      test "icon wrapper has correct positioning classes" do
        render_inline(NumberInputComponent.new(name: "field")) do |component|
          component.with_prefix_icon { "<span>Icon</span>".html_safe }
        end

        assert_selector "div.absolute.inset-y-0.left-0"
      end

      # Custom classes tests
      test "renders with custom container classes" do
        render_inline(NumberInputComponent.new(name: "quantity", container_classes: "custom-wrapper"))

        assert_selector "div.custom-wrapper"
      end

      test "renders with custom input classes" do
        render_inline(NumberInputComponent.new(name: "quantity", input_classes: "custom-input"))

        assert_selector "input.custom-input"
      end

      # Additional HTML options tests
      test "passes through additional HTML options" do
        render_inline(NumberInputComponent.new(
          name: "quantity",
          id: "custom-quantity",
          data: { controller: "quantity" }
        ))

        assert_selector "input#custom-quantity"
        assert_selector "input[data-controller='quantity']"
      end

      # Complete form field rendering test
      test "renders complete number field with all elements" do
        render_inline(NumberInputComponent.new(
          name: "product[price]",
          value: 19.99,
          label: "Price",
          hint: "Enter product price",
          placeholder: "0.00",
          min: 0,
          step: 0.01,
          required: true,
          size: :md
        ))

        assert_selector "label", text: "Price"
        assert_selector "input[type='number']"
        assert_selector "input[name='product[price]']"
        assert_selector "input[value='19.99']"
        assert_selector "input[placeholder='0.00']"
        assert_selector "input[min='0']"
        assert_selector "input[step='0.01']"
        assert_selector "input[required]"
        assert_text "Enter product price"
      end

      # Currency input use case
      test "renders currency input with dollar sign prefix" do
        render_inline(NumberInputComponent.new(
          name: "amount",
          label: "Amount",
          min: 0,
          step: 0.01,
          show_spinner: false
        )) do |component|
          component.with_prefix_icon { '<span class="text-gray-500">$</span>'.html_safe }
        end

        assert_selector "span.text-gray-500", text: "$"
        assert_selector "input[min='0']"
        assert_selector "input[step='0.01']"
        assert_selector "input.hide-number-spinner"
      end

      # Weight input use case
      test "renders weight input with unit suffix" do
        render_inline(NumberInputComponent.new(
          name: "weight",
          label: "Weight",
          min: 0
        )) do |component|
          component.with_suffix_icon { '<span class="text-gray-500">kg</span>'.html_safe }
        end

        assert_selector "span.text-gray-500", text: "kg"
        assert_selector "input[min='0']"
      end

      # Age input use case
      test "renders age input with constraints" do
        render_inline(NumberInputComponent.new(
          name: "user[age]",
          label: "Age",
          min: 0,
          max: 120,
          required: true,
          errors: []
        ))

        assert_selector "input[type='number']"
        assert_selector "input[min='0']"
        assert_selector "input[max='120']"
        assert_selector "input[required]"
      end

      # Quantity input use case
      test "renders quantity input with step and no decimal" do
        render_inline(NumberInputComponent.new(
          name: "quantity",
          label: "Quantity",
          min: 1,
          step: 1,
          value: 1
        ))

        assert_selector "input[min='1']"
        assert_selector "input[step='1']"
        assert_selector "input[value='1']"
      end

      # Error state styling test
      test "applies error styling when errors present" do
        render_inline(NumberInputComponent.new(
          name: "age",
          errors: [ "Age is invalid" ]
        ))

        assert_selector "input.border-danger-500"
        assert_selector "input.focus\\:border-danger-600"
      end

      # Base input classes test
      test "applies base input classes" do
        render_inline(NumberInputComponent.new(name: "quantity"))

        assert_selector "input.block.w-full"
        assert_selector "input.rounded-md"
        assert_selector "input.border"
      end
    end
  end
end
