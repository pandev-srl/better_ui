# frozen_string_literal: true

require "test_helper"

module BetterUi
  module Forms
    class TextInputComponentTest < ActiveSupport::TestCase
      test "renders text input with default options" do
        render_inline(TextInputComponent.new(name: "user[email]"))

        assert_selector "input[type='text']"
        assert_selector "input[name='user[email]']"
      end

      test "renders with label" do
        render_inline(TextInputComponent.new(name: "email", label: "Email Address"))

        assert_selector "label", text: "Email Address"
        assert_selector "input[type='text']"
      end

      test "renders with value" do
        render_inline(TextInputComponent.new(name: "email", value: "test@example.com"))

        assert_selector "input[value='test@example.com']"
      end

      test "renders with placeholder" do
        render_inline(TextInputComponent.new(name: "email", placeholder: "Enter email"))

        assert_selector "input[placeholder='Enter email']"
      end

      test "renders with hint text" do
        render_inline(TextInputComponent.new(name: "email", hint: "We'll never share your email"))

        assert_text "We'll never share your email"
        assert_selector "div.text-gray-600"
      end

      test "renders with errors" do
        render_inline(TextInputComponent.new(name: "email", errors: [ "Email is invalid" ]))

        assert_text "Email is invalid"
        assert_selector "div.text-danger-600"
        assert_selector "input.border-danger-500"
      end

      test "renders with multiple errors" do
        errors = [ "Email is invalid", "Email can't be blank" ]
        render_inline(TextInputComponent.new(name: "email", errors: errors))

        assert_text "Email is invalid"
        assert_text "Email can't be blank"
      end

      test "renders as required" do
        render_inline(TextInputComponent.new(name: "email", required: true, label: "Email"))

        assert_selector "input[required]"
      end

      test "renders as disabled" do
        render_inline(TextInputComponent.new(name: "email", disabled: true))

        assert_selector "input[disabled]"
        assert_selector "input.cursor-not-allowed"
        assert_selector "input.opacity-60"
      end

      test "renders as readonly" do
        render_inline(TextInputComponent.new(name: "email", readonly: true))

        assert_selector "input[readonly]"
        assert_selector "input.bg-gray-50"
        assert_selector "input.cursor-default"
      end

      # Size tests
      test "renders xs size" do
        render_inline(TextInputComponent.new(name: "email", size: :xs))

        assert_selector "input.text-xs"
        assert_selector "input.py-1.px-2"
      end

      test "renders sm size" do
        render_inline(TextInputComponent.new(name: "email", size: :sm))

        assert_selector "input.text-sm"
      end

      test "renders md size by default" do
        render_inline(TextInputComponent.new(name: "email"))

        assert_selector "input.text-base"
        assert_selector "input.py-2.px-4"
      end

      test "renders lg size" do
        render_inline(TextInputComponent.new(name: "email", size: :lg))

        assert_selector "input.text-lg"
      end

      test "renders xl size" do
        render_inline(TextInputComponent.new(name: "email", size: :xl))

        assert_selector "input.text-xl"
      end

      # Icon slot tests
      test "renders with prefix icon" do
        render_inline(TextInputComponent.new(name: "search")) do |component|
          component.with_prefix_icon { '<svg class="prefix-icon"></svg>'.html_safe }
        end

        assert_selector "svg.prefix-icon"
        assert_selector "input.pl-10" # md size padding adjustment
      end

      test "renders with suffix icon" do
        render_inline(TextInputComponent.new(name: "email")) do |component|
          component.with_suffix_icon { '<svg class="suffix-icon"></svg>'.html_safe }
        end

        assert_selector "svg.suffix-icon"
        assert_selector "input.pr-10" # md size padding adjustment
      end

      test "renders with both prefix and suffix icons" do
        render_inline(TextInputComponent.new(name: "field")) do |component|
          component.with_prefix_icon { '<svg class="prefix"></svg>'.html_safe }
          component.with_suffix_icon { '<svg class="suffix"></svg>'.html_safe }
        end

        assert_selector "svg.prefix"
        assert_selector "svg.suffix"
        assert_selector "input.pl-10.pr-10"
      end

      test "adjusts padding for prefix icon with sm size" do
        render_inline(TextInputComponent.new(name: "field", size: :sm)) do |component|
          component.with_prefix_icon { "<svg></svg>".html_safe }
        end

        assert_selector "input.pl-8"
      end

      test "adjusts padding for prefix icon with xs size" do
        render_inline(TextInputComponent.new(name: "field", size: :xs)) do |component|
          component.with_prefix_icon { "<svg></svg>".html_safe }
        end

        assert_selector "input.pl-6"
      end

      test "adjusts padding for prefix icon with lg size" do
        render_inline(TextInputComponent.new(name: "field", size: :lg)) do |component|
          component.with_prefix_icon { "<svg></svg>".html_safe }
        end

        assert_selector "input.pl-12"
      end

      test "adjusts padding for prefix icon with xl size" do
        render_inline(TextInputComponent.new(name: "field", size: :xl)) do |component|
          component.with_prefix_icon { "<svg></svg>".html_safe }
        end

        assert_selector "input.pl-14"
      end

      test "icon wrapper has correct positioning classes" do
        render_inline(TextInputComponent.new(name: "field")) do |component|
          component.with_prefix_icon { "<span>Icon</span>".html_safe }
        end

        assert_selector "div.absolute.inset-y-0.left-0"
      end

      # Custom classes tests
      test "renders with custom container classes" do
        render_inline(TextInputComponent.new(name: "email", container_classes: "custom-wrapper"))

        assert_selector "div.custom-wrapper"
      end

      test "renders with custom label classes" do
        render_inline(TextInputComponent.new(name: "email", label: "Email", label_classes: "custom-label"))

        assert_selector "label.custom-label"
      end

      test "renders with custom input classes" do
        render_inline(TextInputComponent.new(name: "email", input_classes: "custom-input"))

        assert_selector "input.custom-input"
      end

      test "renders with custom hint classes" do
        render_inline(TextInputComponent.new(name: "email", hint: "Hint", hint_classes: "custom-hint"))

        assert_selector "div.custom-hint"
      end

      test "renders with custom error classes" do
        render_inline(TextInputComponent.new(name: "email", errors: [ "Error" ], error_classes: "custom-error"))

        assert_selector "div.custom-error"
      end

      # Additional HTML options tests
      test "passes through additional HTML options" do
        render_inline(TextInputComponent.new(
          name: "email",
          id: "custom-email",
          data: { controller: "custom" },
          aria: { label: "Email field" }
        ))

        assert_selector "input#custom-email"
        assert_selector "input[data-controller='custom']"
        assert_selector "input[aria-label='Email field']"
      end

      test "supports autocomplete attribute" do
        render_inline(TextInputComponent.new(name: "email", autocomplete: "email"))

        assert_selector "input[autocomplete='email']"
      end

      test "supports maxlength attribute" do
        render_inline(TextInputComponent.new(name: "username", maxlength: 50))

        assert_selector "input[maxlength='50']"
      end

      test "supports pattern attribute" do
        render_inline(TextInputComponent.new(name: "phone", pattern: "[0-9]{10}"))

        assert_selector "input[pattern='[0-9]{10}']"
      end

      # Complete form field rendering test
      test "renders complete form field with all elements" do
        render_inline(TextInputComponent.new(
          name: "user[email]",
          value: "test@example.com",
          label: "Email Address",
          hint: "Enter a valid email",
          placeholder: "you@example.com",
          required: true,
          size: :md
        ))

        assert_selector "label", text: "Email Address"
        assert_selector "input[type='text']"
        assert_selector "input[name='user[email]']"
        assert_selector "input[value='test@example.com']"
        assert_selector "input[placeholder='you@example.com']"
        assert_selector "input[required]"
        assert_text "Enter a valid email"
      end

      # Error state styling test
      test "applies error styling when errors present" do
        render_inline(TextInputComponent.new(
          name: "email",
          errors: [ "Invalid email" ]
        ))

        assert_selector "input.border-danger-500"
        assert_selector "input.focus\\:border-danger-600"
        assert_selector "input.focus\\:ring-danger-500"
      end

      # Base input classes test
      test "applies base input classes" do
        render_inline(TextInputComponent.new(name: "email"))

        assert_selector "input.block.w-full"
        assert_selector "input.rounded-md"
        assert_selector "input.border"
        assert_selector "input.shadow-sm"
      end

      # Focus state classes test
      test "applies focus ring classes" do
        render_inline(TextInputComponent.new(name: "email"))

        assert_selector "input.focus\\:ring-2"
        assert_selector "input.focus\\:ring-primary-500"
        assert_selector "input.focus\\:outline-none"
      end
    end
  end
end
