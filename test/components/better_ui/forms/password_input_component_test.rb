# frozen_string_literal: true

require "test_helper"

module BetterUi
  module Forms
    class PasswordInputComponentTest < ActiveSupport::TestCase
      test "renders password input with default options" do
        render_inline(PasswordInputComponent.new(name: "user[password]"))

        assert_selector "input[type='password']"
        assert_selector "input[name='user[password]']"
      end

      test "renders with label" do
        render_inline(PasswordInputComponent.new(name: "password", label: "Password"))

        assert_selector "label", text: "Password"
        assert_selector "input[type='password']"
      end

      test "renders with value" do
        render_inline(PasswordInputComponent.new(name: "password", value: "secret123"))

        assert_selector "input[value='secret123']"
      end

      test "renders with placeholder" do
        render_inline(PasswordInputComponent.new(name: "password", placeholder: "Enter password"))

        assert_selector "input[placeholder='Enter password']"
      end

      # Stimulus controller tests
      test "includes Stimulus controller on wrapper" do
        render_inline(PasswordInputComponent.new(name: "password"))

        assert_selector "div[data-controller='better_ui--forms--password_input']"
      end

      test "includes Stimulus target on input" do
        render_inline(PasswordInputComponent.new(name: "password"))

        assert_selector "input[data-better-ui--forms--password-input-target='input']"
      end

      # Toggle button tests
      test "renders toggle button by default" do
        render_inline(PasswordInputComponent.new(name: "password"))

        assert_selector "button"
        assert_selector "button svg" # eye icon
      end

      test "does not render toggle button when disabled" do
        render_inline(PasswordInputComponent.new(name: "password", disabled: true))

        refute_selector "button"
      end

      test "does not render toggle button when readonly" do
        render_inline(PasswordInputComponent.new(name: "password", readonly: true))

        refute_selector "button"
      end

      test "toggle button is positioned correctly" do
        render_inline(PasswordInputComponent.new(name: "password"))

        # The button is inside a positioned wrapper div
        assert_selector "div.absolute.inset-y-0.right-0 button"
      end

      # Icon size tests for toggle button
      test "toggle button icon has correct size for xs" do
        render_inline(PasswordInputComponent.new(name: "password", size: :xs))

        assert_selector "button svg.w-4.h-4"
      end

      test "toggle button icon has correct size for sm" do
        render_inline(PasswordInputComponent.new(name: "password", size: :sm))

        assert_selector "button svg.w-4.h-4"
      end

      test "toggle button icon has correct size for md" do
        render_inline(PasswordInputComponent.new(name: "password", size: :md))

        assert_selector "button svg.w-5.h-5"
      end

      test "toggle button icon has correct size for lg" do
        render_inline(PasswordInputComponent.new(name: "password", size: :lg))

        assert_selector "button svg.w-5.h-5"
      end

      test "toggle button icon has correct size for xl" do
        render_inline(PasswordInputComponent.new(name: "password", size: :xl))

        assert_selector "button svg.w-6.h-6"
      end

      # Padding adjustment for toggle button
      test "adjusts input padding for toggle button with md size" do
        render_inline(PasswordInputComponent.new(name: "password", size: :md))

        # Toggle button acts as suffix icon, so padding should be adjusted
        assert_selector "input.pr-10"
      end

      test "adjusts input padding for toggle button with sm size" do
        render_inline(PasswordInputComponent.new(name: "password", size: :sm))

        assert_selector "input.pr-8"
      end

      test "adjusts input padding for toggle button with xs size" do
        render_inline(PasswordInputComponent.new(name: "password", size: :xs))

        assert_selector "input.pr-6"
      end

      test "adjusts input padding for toggle button with lg size" do
        render_inline(PasswordInputComponent.new(name: "password", size: :lg))

        assert_selector "input.pr-12"
      end

      test "adjusts input padding for toggle button with xl size" do
        render_inline(PasswordInputComponent.new(name: "password", size: :xl))

        assert_selector "input.pr-14"
      end

      # Prefix icon tests
      test "renders with prefix icon" do
        render_inline(PasswordInputComponent.new(name: "password")) do |component|
          component.with_prefix_icon { '<svg class="lock-icon"></svg>'.html_safe }
        end

        assert_selector "svg.lock-icon"
        # Should have both prefix and suffix (toggle) padding adjustments
        assert_selector "input.pl-10.pr-10"
      end

      test "prefix icon with toggle button adjusts padding correctly" do
        render_inline(PasswordInputComponent.new(name: "password", size: :md)) do |component|
          component.with_prefix_icon { "<span>Icon</span>".html_safe }
        end

        assert_selector "input.pl-10" # prefix icon padding
        assert_selector "input.pr-10" # toggle button padding
      end

      # Hint and error tests
      test "renders with hint text" do
        render_inline(PasswordInputComponent.new(
          name: "password",
          hint: "Must be at least 8 characters"
        ))

        assert_text "Must be at least 8 characters"
      end

      test "renders with errors" do
        render_inline(PasswordInputComponent.new(
          name: "password",
          errors: [ "Password is too short" ]
        ))

        assert_text "Password is too short"
        assert_selector "div.text-danger-600"
        assert_selector "input.border-danger-500"
      end

      test "renders with multiple errors" do
        errors = [ "Password is too short", "Password must include a number" ]
        render_inline(PasswordInputComponent.new(name: "password", errors: errors))

        assert_text "Password is too short"
        assert_text "Password must include a number"
      end

      # State tests
      test "renders as required" do
        render_inline(PasswordInputComponent.new(name: "password", required: true, label: "Password"))

        assert_selector "input[required]"
      end

      test "renders as disabled" do
        render_inline(PasswordInputComponent.new(name: "password", disabled: true))

        assert_selector "input[disabled]"
        assert_selector "input.cursor-not-allowed"
      end

      test "renders as readonly" do
        render_inline(PasswordInputComponent.new(name: "password", readonly: true))

        assert_selector "input[readonly]"
        assert_selector "input.bg-gray-50"
      end

      # Size tests
      test "renders xs size" do
        render_inline(PasswordInputComponent.new(name: "password", size: :xs))

        assert_selector "input.text-xs"
        assert_selector "input.py-1"
      end

      test "renders sm size" do
        render_inline(PasswordInputComponent.new(name: "password", size: :sm))

        assert_selector "input.text-sm"
      end

      test "renders md size by default" do
        render_inline(PasswordInputComponent.new(name: "password"))

        assert_selector "input.text-base"
        assert_selector "input.py-2.px-4"
      end

      test "renders lg size" do
        render_inline(PasswordInputComponent.new(name: "password", size: :lg))

        assert_selector "input.text-lg"
      end

      test "renders xl size" do
        render_inline(PasswordInputComponent.new(name: "password", size: :xl))

        assert_selector "input.text-xl"
      end

      # Custom classes tests
      test "renders with custom container classes" do
        render_inline(PasswordInputComponent.new(name: "password", container_classes: "custom-wrapper"))

        assert_selector "div.custom-wrapper"
      end

      test "renders with custom label classes" do
        render_inline(PasswordInputComponent.new(name: "password", label: "Password", label_classes: "custom-label"))

        assert_selector "label.custom-label"
      end

      test "renders with custom input classes" do
        render_inline(PasswordInputComponent.new(name: "password", input_classes: "custom-input"))

        assert_selector "input.custom-input"
      end

      # Additional HTML options tests
      test "passes through additional HTML options" do
        render_inline(PasswordInputComponent.new(
          name: "password",
          id: "custom-password",
          data: { test: "value" }
        ))

        assert_selector "input#custom-password"
        assert_selector "input[data-test='value']"
      end

      test "supports autocomplete attribute" do
        render_inline(PasswordInputComponent.new(name: "password", autocomplete: "current-password"))

        assert_selector "input[autocomplete='current-password']"
      end

      # Complete form field rendering test
      test "renders complete password field with all elements" do
        render_inline(PasswordInputComponent.new(
          name: "user[password]",
          label: "Password",
          hint: "Must be at least 8 characters with 1 number",
          placeholder: "Enter password",
          required: true,
          size: :md
        ))

        assert_selector "label", text: "Password"
        assert_selector "input[type='password']"
        assert_selector "input[name='user[password]']"
        assert_selector "input[placeholder='Enter password']"
        assert_selector "input[required]"
        assert_text "Must be at least 8 characters with 1 number"
        assert_selector "button" # toggle button
      end

      # Login form use case
      test "renders login password field" do
        render_inline(PasswordInputComponent.new(
          name: "user[password]",
          label: "Password",
          required: true,
          autocomplete: "current-password"
        ))

        assert_selector "input[type='password']"
        assert_selector "input[required]"
        assert_selector "input[autocomplete='current-password']"
        assert_selector "button" # visibility toggle
      end

      # Registration form use case
      test "renders registration password field with validation" do
        render_inline(PasswordInputComponent.new(
          name: "user[password]",
          label: "Create Password",
          hint: "Minimum 8 characters, 1 uppercase, 1 number, 1 special character",
          required: true,
          autocomplete: "new-password"
        ))

        assert_selector "input[type='password']"
        assert_selector "input[autocomplete='new-password']"
        assert_text "Minimum 8 characters, 1 uppercase, 1 number, 1 special character"
      end

      # Password confirmation use case
      test "renders password confirmation field" do
        render_inline(PasswordInputComponent.new(
          name: "user[password_confirmation]",
          label: "Confirm Password",
          required: true,
          autocomplete: "new-password"
        ))

        assert_selector "input[name='user[password_confirmation]']"
        assert_selector "input[required]"
      end

      # Error state with password field
      test "renders password field with validation errors" do
        render_inline(PasswordInputComponent.new(
          name: "user[password]",
          label: "Password",
          errors: [
            "Password is too short (minimum is 8 characters)",
            "Password must include at least one number"
          ]
        ))

        assert_selector "input.border-danger-500"
        assert_text "Password is too short (minimum is 8 characters)"
        assert_text "Password must include at least one number"
      end

      # Base input classes test
      test "applies base input classes" do
        render_inline(PasswordInputComponent.new(name: "password"))

        assert_selector "input.block.w-full"
        assert_selector "input.rounded-md"
        assert_selector "input.border"
      end

      # Wrapper classes test
      test "input wrapper has relative positioning" do
        render_inline(PasswordInputComponent.new(name: "password"))

        assert_selector "div.relative.flex.items-center"
      end
    end
  end
end
