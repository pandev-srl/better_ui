# frozen_string_literal: true

require "test_helper"

module BetterUi
  module Forms
    class BaseComponentTest < ActiveSupport::TestCase
      # Test subclass to test BaseComponent functionality
      class TestInputComponent < BaseComponent
        def call
          content_tag(:div, class: wrapper_classes) do
            content_tag(:input, nil, input_attributes)
          end
        end
      end

      test "initializes with required name parameter" do
        component = TestInputComponent.new(name: "test_field")

        assert_equal "test_field", component.instance_variable_get(:@name)
      end

      test "initializes with default values" do
        component = TestInputComponent.new(name: "test")

        assert_nil component.instance_variable_get(:@value)
        assert_nil component.instance_variable_get(:@label)
        assert_nil component.instance_variable_get(:@hint)
        assert_nil component.instance_variable_get(:@placeholder)
        assert_equal :md, component.instance_variable_get(:@size)
        assert_equal false, component.instance_variable_get(:@disabled)
        assert_equal false, component.instance_variable_get(:@readonly)
        assert_equal false, component.instance_variable_get(:@required)
        assert_empty component.instance_variable_get(:@errors)
      end

      test "initializes with custom values" do
        component = TestInputComponent.new(
          name: "email",
          value: "test@example.com",
          label: "Email Address",
          hint: "Enter your email",
          placeholder: "you@example.com",
          size: :lg,
          disabled: true,
          readonly: true,
          required: true,
          errors: [ "Invalid email" ]
        )

        assert_equal "test@example.com", component.instance_variable_get(:@value)
        assert_equal "Email Address", component.instance_variable_get(:@label)
        assert_equal "Enter your email", component.instance_variable_get(:@hint)
        assert_equal "you@example.com", component.instance_variable_get(:@placeholder)
        assert_equal :lg, component.instance_variable_get(:@size)
        assert component.instance_variable_get(:@disabled)
        assert component.instance_variable_get(:@readonly)
        assert component.instance_variable_get(:@required)
        assert_equal [ "Invalid email" ], component.instance_variable_get(:@errors)
      end

      # Size validation tests
      test "validates size parameter" do
        component = TestInputComponent.new(name: "test", size: :md)

        assert_equal :md, component.instance_variable_get(:@size)
      end

      test "raises error for invalid size" do
        error = assert_raises(ArgumentError) do
          TestInputComponent.new(name: "test", size: :invalid)
        end

        assert_match(/Invalid size/, error.message)
        assert_match(/xs, sm, md, lg, xl/, error.message)
      end

      test "accepts all valid sizes" do
        [ :xs, :sm, :md, :lg, :xl ].each do |size|
          component = TestInputComponent.new(name: "test", size: size)
          assert_equal size, component.instance_variable_get(:@size)
        end
      end

      # Errors handling tests
      test "converts string error to array" do
        component = TestInputComponent.new(name: "test", errors: "Error message")

        assert_equal [ "Error message" ], component.instance_variable_get(:@errors)
      end

      test "handles array of errors" do
        errors = [ "Error 1", "Error 2" ]
        component = TestInputComponent.new(name: "test", errors: errors)

        assert_equal errors, component.instance_variable_get(:@errors)
      end

      test "filters out blank errors" do
        errors = [ "Error 1", "", nil, "Error 2", "   " ]
        component = TestInputComponent.new(name: "test", errors: errors)

        assert_equal [ "Error 1", "Error 2" ], component.instance_variable_get(:@errors)
      end

      test "handles nil errors" do
        component = TestInputComponent.new(name: "test", errors: nil)

        assert_empty component.instance_variable_get(:@errors)
      end

      # Custom classes tests
      test "accepts custom container classes" do
        component = TestInputComponent.new(name: "test", container_classes: "custom-wrapper")

        assert_equal "custom-wrapper", component.instance_variable_get(:@container_classes)
      end

      test "accepts custom label classes" do
        component = TestInputComponent.new(name: "test", label_classes: "custom-label")

        assert_equal "custom-label", component.instance_variable_get(:@label_classes)
      end

      test "accepts custom input classes" do
        component = TestInputComponent.new(name: "test", input_classes: "custom-input")

        assert_equal "custom-input", component.instance_variable_get(:@input_classes)
      end

      test "accepts custom hint classes" do
        component = TestInputComponent.new(name: "test", hint_classes: "custom-hint")

        assert_equal "custom-hint", component.instance_variable_get(:@hint_classes)
      end

      test "accepts custom error classes" do
        component = TestInputComponent.new(name: "test", error_classes: "custom-error")

        assert_equal "custom-error", component.instance_variable_get(:@error_classes)
      end

      # Additional options tests
      test "accepts additional HTML options" do
        component = TestInputComponent.new(
          name: "test",
          id: "custom-id",
          data: { controller: "custom" },
          aria: { label: "Test field" }
        )

        options = component.instance_variable_get(:@options)
        assert_equal "custom-id", options[:id]
        assert_equal({ controller: "custom" }, options[:data])
        assert_equal({ label: "Test field" }, options[:aria])
      end

      # Call method requirement test
      test "raises NotImplementedError when call is not implemented" do
        error = assert_raises(NotImplementedError) do
          BaseComponent.new(name: "test").call
        end

        assert_match(/Subclasses must implement/, error.message)
      end

      # Size-specific class generation tests
      test "generates correct label size classes for xs" do
        component = TestInputComponent.new(name: "test", size: :xs)

        assert_equal "text-xs", component.send(:label_size_classes)
      end

      test "generates correct label size classes for sm" do
        component = TestInputComponent.new(name: "test", size: :sm)

        assert_equal "text-sm", component.send(:label_size_classes)
      end

      test "generates correct label size classes for md" do
        component = TestInputComponent.new(name: "test", size: :md)

        assert_equal "text-sm", component.send(:label_size_classes)
      end

      test "generates correct label size classes for lg" do
        component = TestInputComponent.new(name: "test", size: :lg)

        assert_equal "text-base", component.send(:label_size_classes)
      end

      test "generates correct label size classes for xl" do
        component = TestInputComponent.new(name: "test", size: :xl)

        assert_equal "text-lg", component.send(:label_size_classes)
      end

      # Input size classes tests
      test "generates correct input size classes for xs" do
        component = TestInputComponent.new(name: "test", size: :xs)
        classes = component.send(:size_input_classes)

        assert_includes classes, "text-xs"
        assert_includes classes, "py-1"
        assert_includes classes, "px-2"
      end

      test "generates correct input size classes for md" do
        component = TestInputComponent.new(name: "test", size: :md)
        classes = component.send(:size_input_classes)

        assert_includes classes, "text-base"
        assert_includes classes, "py-2"
        assert_includes classes, "px-4"
      end

      test "generates correct input size classes for xl" do
        component = TestInputComponent.new(name: "test", size: :xl)
        classes = component.send(:size_input_classes)

        assert_includes classes, "text-xl"
        assert_includes classes, "py-3"
        assert_includes classes, "px-6"
      end

      # State classes tests
      test "generates normal state classes by default" do
        component = TestInputComponent.new(name: "test")
        classes = component.send(:state_input_classes)

        assert_includes classes, "border-gray-300"
        assert_includes classes, "bg-white"
        assert_includes classes, "focus:border-primary-500"
      end

      test "generates disabled state classes when disabled" do
        component = TestInputComponent.new(name: "test", disabled: true)
        classes = component.send(:state_input_classes)

        assert_includes classes, "bg-gray-100"
        assert_includes classes, "cursor-not-allowed"
        assert_includes classes, "opacity-60"
      end

      test "generates readonly state classes when readonly" do
        component = TestInputComponent.new(name: "test", readonly: true)
        classes = component.send(:state_input_classes)

        assert_includes classes, "bg-gray-50"
        assert_includes classes, "cursor-default"
      end

      test "generates error state classes when errors present" do
        component = TestInputComponent.new(name: "test", errors: [ "Error" ])
        classes = component.send(:state_input_classes)

        assert_includes classes, "border-danger-500"
        assert_includes classes, "focus:border-danger-600"
      end

      test "disabled state takes precedence over error state" do
        component = TestInputComponent.new(name: "test", disabled: true, errors: [ "Error" ])
        classes = component.send(:state_input_classes)

        assert_includes classes, "cursor-not-allowed"
        refute_includes classes, "border-danger-500"
      end

      # has_errors? helper test
      test "has_errors? returns true when errors present" do
        component = TestInputComponent.new(name: "test", errors: [ "Error" ])

        assert component.send(:has_errors?)
      end

      test "has_errors? returns false when no errors" do
        component = TestInputComponent.new(name: "test")

        refute component.send(:has_errors?)
      end

      # Input attributes generation tests
      test "generates input attributes with all values" do
        component = TestInputComponent.new(
          name: "user[email]",
          value: "test@example.com",
          placeholder: "Email",
          disabled: true,
          readonly: true,
          required: true
        )

        attrs = component.send(:input_attributes)

        assert_equal "user[email]", attrs[:name]
        assert_equal "test@example.com", attrs[:value]
        assert_equal "Email", attrs[:placeholder]
        assert attrs[:disabled]
        assert attrs[:readonly]
        assert attrs[:required]
      end

      test "input attributes omit false boolean values" do
        component = TestInputComponent.new(
          name: "test",
          disabled: false,
          readonly: false,
          required: false
        )

        attrs = component.send(:input_attributes)

        refute attrs.key?(:disabled)
        refute attrs.key?(:readonly)
        refute attrs.key?(:required)
      end

      test "input attributes include CSS classes" do
        component = TestInputComponent.new(name: "test")
        attrs = component.send(:input_attributes)

        assert attrs[:class].present?
        assert_kind_of String, attrs[:class]
      end
    end
  end
end
