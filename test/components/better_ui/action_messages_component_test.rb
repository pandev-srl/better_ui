# frozen_string_literal: true

require "test_helper"

module BetterUi
  class ActionMessagesComponentTest < ActiveSupport::TestCase
    test "renders with default options" do
      render_inline(ActionMessagesComponent.new(messages: [ "Test message" ]))

      assert_selector "div[data-controller='better-ui--action-messages']"
      assert_selector "div.rounded-lg.p-4"
      assert_selector "div.bg-info-50" # default variant (info) with soft style
      assert_text "Test message"
    end

    test "renders single message" do
      render_inline(ActionMessagesComponent.new(messages: [ "Single message" ]))

      assert_text "Single message"
      assert_selector "ul li", count: 1
    end

    test "renders multiple messages" do
      messages = [ "First message", "Second message", "Third message" ]
      render_inline(ActionMessagesComponent.new(messages: messages))

      assert_text "First message"
      assert_text "Second message"
      assert_text "Third message"
      assert_selector "ul li", count: 3
    end

    test "renders with empty messages array" do
      render_inline(ActionMessagesComponent.new(messages: []))

      assert_selector "div[data-controller='better-ui--action-messages']"
      assert_selector "ul li", count: 0
    end

    test "handles nil messages" do
      render_inline(ActionMessagesComponent.new(messages: nil))

      assert_selector "div[data-controller='better-ui--action-messages']"
      assert_selector "ul li", count: 0
    end

    test "converts single string message to array" do
      render_inline(ActionMessagesComponent.new(messages: "Single string"))

      assert_text "Single string"
      assert_selector "ul li", count: 1
    end

    # Variant tests
    test "renders primary variant" do
      render_inline(ActionMessagesComponent.new(messages: [ "Message" ], variant: :primary))

      assert_selector "div.bg-primary-50" # soft style default
    end

    test "renders secondary variant" do
      render_inline(ActionMessagesComponent.new(messages: [ "Message" ], variant: :secondary))

      assert_selector "div.bg-secondary-50"
    end

    test "renders success variant" do
      render_inline(ActionMessagesComponent.new(messages: [ "Message" ], variant: :success))

      assert_selector "div.bg-success-50"
    end

    test "renders danger variant" do
      render_inline(ActionMessagesComponent.new(messages: [ "Message" ], variant: :danger))

      assert_selector "div.bg-danger-50"
    end

    test "renders warning variant" do
      render_inline(ActionMessagesComponent.new(messages: [ "Message" ], variant: :warning))

      assert_selector "div.bg-warning-50"
    end

    test "renders info variant" do
      render_inline(ActionMessagesComponent.new(messages: [ "Message" ], variant: :info))

      assert_selector "div.bg-info-50"
    end

    test "renders light variant" do
      render_inline(ActionMessagesComponent.new(messages: [ "Message" ], variant: :light))

      assert_selector "div.bg-grayscale-50"
    end

    test "renders dark variant" do
      render_inline(ActionMessagesComponent.new(messages: [ "Message" ], variant: :dark))

      assert_selector "div.bg-grayscale-100"
    end

    test "raises error for invalid variant" do
      error = assert_raises(ArgumentError) do
        ActionMessagesComponent.new(messages: [ "Message" ], variant: :invalid)
      end

      assert_match(/Invalid variant/, error.message)
    end

    # Style tests
    test "renders solid style" do
      render_inline(ActionMessagesComponent.new(messages: [ "Message" ], style: :solid, variant: :primary))

      assert_selector "div.bg-primary-600"
      assert_selector "div.text-white"
    end

    test "renders soft style" do
      render_inline(ActionMessagesComponent.new(messages: [ "Message" ], style: :soft))

      assert_selector "div.bg-info-50"
      assert_selector "div.border"
    end

    test "renders outline style" do
      render_inline(ActionMessagesComponent.new(messages: [ "Message" ], style: :outline, variant: :success))

      assert_selector "div.bg-white"
      assert_selector "div.border-2.border-success-500"
    end

    test "renders ghost style" do
      render_inline(ActionMessagesComponent.new(messages: [ "Message" ], style: :ghost))

      assert_selector "div.hover\\:bg-info-50"
    end

    test "raises error for invalid style" do
      error = assert_raises(ArgumentError) do
        ActionMessagesComponent.new(messages: [ "Message" ], style: :invalid)
      end

      assert_match(/Invalid style/, error.message)
    end

    # Title tests
    test "renders with title" do
      render_inline(ActionMessagesComponent.new(messages: [ "Message" ], title: "Error"))

      assert_text "Error"
      assert_selector "div.font-semibold.mb-2"
    end

    test "renders without title by default" do
      render_inline(ActionMessagesComponent.new(messages: [ "Message" ]))

      refute_selector "div.font-semibold.mb-2"
    end

    # Dismissible tests
    test "renders dismiss button when dismissible is true" do
      render_inline(ActionMessagesComponent.new(messages: [ "Message" ], dismissible: true))

      assert_selector "button.absolute.top-3.right-3"
      assert_selector "button svg" # close icon
    end

    test "does not render dismiss button when dismissible is false" do
      render_inline(ActionMessagesComponent.new(messages: [ "Message" ], dismissible: false))

      refute_selector "button.absolute.top-3.right-3"
    end

    test "does not render dismiss button by default" do
      render_inline(ActionMessagesComponent.new(messages: [ "Message" ]))

      refute_selector "button.absolute.top-3.right-3"
    end

    # Auto-dismiss tests
    test "includes auto-dismiss data attribute when set" do
      render_inline(ActionMessagesComponent.new(messages: [ "Message" ], auto_dismiss: 5))

      assert_selector "div[data-better-ui--action-messages-auto-dismiss-value='5.0']"
    end

    test "includes auto-dismiss with float value" do
      render_inline(ActionMessagesComponent.new(messages: [ "Message" ], auto_dismiss: 3.5))

      assert_selector "div[data-better-ui--action-messages-auto-dismiss-value='3.5']"
    end

    test "does not include auto-dismiss data attribute when nil" do
      render_inline(ActionMessagesComponent.new(messages: [ "Message" ], auto_dismiss: nil))

      refute_selector "div[data-better-ui--action-messages-auto-dismiss-value]"
    end

    test "does not include auto-dismiss data attribute when zero" do
      render_inline(ActionMessagesComponent.new(messages: [ "Message" ], auto_dismiss: 0))

      refute_selector "div[data-better-ui--action-messages-auto-dismiss-value]"
    end

    # Stimulus controller tests
    test "includes Stimulus controller data attribute" do
      render_inline(ActionMessagesComponent.new(messages: [ "Message" ]))

      assert_selector "div[data-controller='better-ui--action-messages']"
    end

    # Custom classes tests
    test "renders with custom container classes" do
      render_inline(ActionMessagesComponent.new(messages: [ "Message" ], container_classes: "custom-class"))

      assert_selector "div.custom-class"
    end

    # Additional HTML options tests
    test "passes through additional HTML options" do
      render_inline(ActionMessagesComponent.new(messages: [ "Message" ], id: "my-messages"))

      assert_selector "div#my-messages"
    end

    # Combined variant and style tests
    test "renders danger solid message" do
      render_inline(ActionMessagesComponent.new(
        messages: [ "Error occurred" ],
        variant: :danger,
        style: :solid
      ))

      assert_selector "div.bg-danger-600"
      assert_selector "div.text-white"
      assert_text "Error occurred"
    end

    test "renders success outline message with title" do
      render_inline(ActionMessagesComponent.new(
        messages: [ "Saved successfully" ],
        variant: :success,
        style: :outline,
        title: "Success"
      ))

      assert_selector "div.border-2.border-success-500"
      assert_text "Success"
      assert_text "Saved successfully"
    end

    test "renders warning soft message with auto-dismiss" do
      render_inline(ActionMessagesComponent.new(
        messages: [ "Warning message" ],
        variant: :warning,
        style: :soft,
        auto_dismiss: 10
      ))

      assert_selector "div.bg-warning-50"
      assert_selector "div[data-better-ui--action-messages-auto-dismiss-value='10.0']"
      assert_text "Warning message"
    end

    # Form validation error use case
    test "renders multiple validation errors" do
      errors = [
        "Email can't be blank",
        "Email is invalid",
        "Password is too short"
      ]

      render_inline(ActionMessagesComponent.new(
        messages: errors,
        variant: :danger,
        title: "Please fix the following errors:"
      ))

      assert_text "Please fix the following errors:"
      assert_text "Email can't be blank"
      assert_text "Email is invalid"
      assert_text "Password is too short"
      assert_selector "ul li", count: 3
    end

    # Flash notification use case
    test "renders flash notification with dismissible and auto-dismiss" do
      render_inline(ActionMessagesComponent.new(
        messages: [ "Your profile has been updated" ],
        variant: :success,
        style: :solid,
        dismissible: true,
        auto_dismiss: 5
      ))

      assert_text "Your profile has been updated"
      assert_selector "button" # dismiss button
      assert_selector "div[data-better-ui--action-messages-auto-dismiss-value='5.0']"
    end

    # Comprehensive variant+style combination tests for full coverage
    test "renders primary solid variant" do
      render_inline(ActionMessagesComponent.new(messages: [ "Test" ], variant: :primary, style: :solid))
      assert_selector "div.bg-primary-600"
    end

    test "renders primary outline variant" do
      render_inline(ActionMessagesComponent.new(messages: [ "Test" ], variant: :primary, style: :outline))
      assert_selector "div.border-primary-500"
    end

    test "renders primary ghost variant" do
      render_inline(ActionMessagesComponent.new(messages: [ "Test" ], variant: :primary, style: :ghost))
      assert_selector "div.text-primary-600"
    end

    test "renders secondary solid variant" do
      render_inline(ActionMessagesComponent.new(messages: [ "Test" ], variant: :secondary, style: :solid))
      assert_selector "div.bg-secondary-500"
    end

    test "renders secondary outline variant" do
      render_inline(ActionMessagesComponent.new(messages: [ "Test" ], variant: :secondary, style: :outline))
      assert_selector "div.border-secondary-500"
    end

    test "renders secondary ghost variant" do
      render_inline(ActionMessagesComponent.new(messages: [ "Test" ], variant: :secondary, style: :ghost))
      assert_selector "div.text-secondary-600"
    end

    test "renders accent solid variant" do
      render_inline(ActionMessagesComponent.new(messages: [ "Test" ], variant: :accent, style: :solid))
      assert_selector "div.bg-accent-500"
    end

    test "renders accent outline variant" do
      render_inline(ActionMessagesComponent.new(messages: [ "Test" ], variant: :accent, style: :outline))
      assert_selector "div.border-accent-500"
    end

    test "renders accent ghost variant" do
      render_inline(ActionMessagesComponent.new(messages: [ "Test" ], variant: :accent, style: :ghost))
      assert_selector "div.text-accent-600"
    end

    test "renders success solid variant" do
      render_inline(ActionMessagesComponent.new(messages: [ "Test" ], variant: :success, style: :solid))
      assert_selector "div.bg-success-600"
    end

    test "renders success outline variant" do
      render_inline(ActionMessagesComponent.new(messages: [ "Test" ], variant: :success, style: :outline))
      assert_selector "div.border-success-500"
    end

    test "renders success ghost variant" do
      render_inline(ActionMessagesComponent.new(messages: [ "Test" ], variant: :success, style: :ghost))
      assert_selector "div.text-success-600"
    end

    test "renders danger solid variant" do
      render_inline(ActionMessagesComponent.new(messages: [ "Test" ], variant: :danger, style: :solid))
      assert_selector "div.bg-danger-600"
    end

    test "renders danger outline variant" do
      render_inline(ActionMessagesComponent.new(messages: [ "Test" ], variant: :danger, style: :outline))
      assert_selector "div.border-danger-500"
    end

    test "renders danger ghost variant" do
      render_inline(ActionMessagesComponent.new(messages: [ "Test" ], variant: :danger, style: :ghost))
      assert_selector "div.text-danger-600"
    end

    test "renders warning solid variant" do
      render_inline(ActionMessagesComponent.new(messages: [ "Test" ], variant: :warning, style: :solid))
      assert_selector "div.bg-warning-500"
    end

    test "renders warning outline variant" do
      render_inline(ActionMessagesComponent.new(messages: [ "Test" ], variant: :warning, style: :outline))
      assert_selector "div.border-warning-500"
    end

    test "renders warning ghost variant" do
      render_inline(ActionMessagesComponent.new(messages: [ "Test" ], variant: :warning, style: :ghost))
      assert_selector "div.text-warning-600"
    end

    test "renders info solid variant" do
      render_inline(ActionMessagesComponent.new(messages: [ "Test" ], variant: :info, style: :solid))
      assert_selector "div.bg-info-500"
    end

    test "renders info outline variant" do
      render_inline(ActionMessagesComponent.new(messages: [ "Test" ], variant: :info, style: :outline))
      assert_selector "div.border-info-500"
    end

    test "renders info ghost variant" do
      render_inline(ActionMessagesComponent.new(messages: [ "Test" ], variant: :info, style: :ghost))
      assert_selector "div.text-info-600"
    end

    test "renders light solid variant" do
      render_inline(ActionMessagesComponent.new(messages: [ "Test" ], variant: :light, style: :solid))
      assert_selector "div.bg-grayscale-100"
    end

    test "renders light outline variant" do
      render_inline(ActionMessagesComponent.new(messages: [ "Test" ], variant: :light, style: :outline))
      assert_selector "div.border-grayscale-300"
    end

    test "renders light ghost variant" do
      render_inline(ActionMessagesComponent.new(messages: [ "Test" ], variant: :light, style: :ghost))
      assert_selector "div.text-grayscale-600"
    end

    test "renders dark solid variant" do
      render_inline(ActionMessagesComponent.new(messages: [ "Test" ], variant: :dark, style: :solid))
      assert_selector "div.bg-grayscale-900"
    end

    test "renders dark outline variant" do
      render_inline(ActionMessagesComponent.new(messages: [ "Test" ], variant: :dark, style: :outline))
      assert_selector "div.border-grayscale-700"
    end

    test "renders dark ghost variant" do
      render_inline(ActionMessagesComponent.new(messages: [ "Test" ], variant: :dark, style: :ghost))
      assert_selector "div.text-grayscale-900"
    end

    # Test dismissible with different styles
    test "renders dismissible with solid style" do
      render_inline(ActionMessagesComponent.new(
        messages: [ "Test" ],
        variant: :primary,
        style: :solid,
        dismissible: true
      ))
      assert_selector "button" # dismiss button
    end

    test "renders dismissible with ghost style" do
      render_inline(ActionMessagesComponent.new(
        messages: [ "Test" ],
        variant: :danger,
        style: :ghost,
        dismissible: true
      ))
      assert_selector "button" # dismiss button
    end

    # Test title with different styles
    test "renders title with solid style" do
      render_inline(ActionMessagesComponent.new(
        messages: [ "Test" ],
        variant: :warning,
        style: :solid,
        title: "Warning Title"
      ))
      assert_text "Warning Title"
    end

    test "renders title with ghost style" do
      render_inline(ActionMessagesComponent.new(
        messages: [ "Test" ],
        variant: :info,
        style: :ghost,
        title: "Info Title"
      ))
      assert_text "Info Title"
    end

    # Comprehensive dismissible button tests for 100% coverage
    test "renders dismissible light solid message" do
      render_inline(ActionMessagesComponent.new(
        messages: [ "Test" ],
        variant: :light,
        style: :solid,
        dismissible: true
      ))
      assert_selector "button" # dismiss button
    end

    test "renders dismissible dark solid message" do
      render_inline(ActionMessagesComponent.new(
        messages: [ "Test" ],
        variant: :dark,
        style: :solid,
        dismissible: true
      ))
      assert_selector "button" # dismiss button
    end

    test "renders dismissible warning solid message" do
      render_inline(ActionMessagesComponent.new(
        messages: [ "Test" ],
        variant: :warning,
        style: :solid,
        dismissible: true
      ))
      assert_selector "button" # dismiss button
    end

    test "renders dismissible primary soft message" do
      render_inline(ActionMessagesComponent.new(
        messages: [ "Test" ],
        variant: :primary,
        style: :soft,
        dismissible: true
      ))
      assert_selector "button" # dismiss button
    end

    test "renders dismissible secondary soft message" do
      render_inline(ActionMessagesComponent.new(
        messages: [ "Test" ],
        variant: :secondary,
        style: :soft,
        dismissible: true
      ))
      assert_selector "button" # dismiss button
    end

    test "renders dismissible accent soft message" do
      render_inline(ActionMessagesComponent.new(
        messages: [ "Test" ],
        variant: :accent,
        style: :soft,
        dismissible: true
      ))
      assert_selector "button" # dismiss button
    end

    test "renders dismissible success soft message" do
      render_inline(ActionMessagesComponent.new(
        messages: [ "Test" ],
        variant: :success,
        style: :soft,
        dismissible: true
      ))
      assert_selector "button" # dismiss button
    end

    test "renders dismissible danger soft message" do
      render_inline(ActionMessagesComponent.new(
        messages: [ "Test" ],
        variant: :danger,
        style: :soft,
        dismissible: true
      ))
      assert_selector "button" # dismiss button
    end

    test "renders dismissible warning soft message" do
      render_inline(ActionMessagesComponent.new(
        messages: [ "Test" ],
        variant: :warning,
        style: :soft,
        dismissible: true
      ))
      assert_selector "button" # dismiss button
    end

    test "renders dismissible info soft message" do
      render_inline(ActionMessagesComponent.new(
        messages: [ "Test" ],
        variant: :info,
        style: :soft,
        dismissible: true
      ))
      assert_selector "button" # dismiss button
    end

    test "renders dismissible light soft message" do
      render_inline(ActionMessagesComponent.new(
        messages: [ "Test" ],
        variant: :light,
        style: :soft,
        dismissible: true
      ))
      assert_selector "button" # dismiss button
    end

    test "renders dismissible dark soft message" do
      render_inline(ActionMessagesComponent.new(
        messages: [ "Test" ],
        variant: :dark,
        style: :soft,
        dismissible: true
      ))
      assert_selector "button" # dismiss button
    end

    test "renders dismissible primary outline message" do
      render_inline(ActionMessagesComponent.new(
        messages: [ "Test" ],
        variant: :primary,
        style: :outline,
        dismissible: true
      ))
      assert_selector "button" # dismiss button
    end

    test "renders dismissible secondary outline message" do
      render_inline(ActionMessagesComponent.new(
        messages: [ "Test" ],
        variant: :secondary,
        style: :outline,
        dismissible: true
      ))
      assert_selector "button" # dismiss button
    end

    test "renders dismissible accent outline message" do
      render_inline(ActionMessagesComponent.new(
        messages: [ "Test" ],
        variant: :accent,
        style: :outline,
        dismissible: true
      ))
      assert_selector "button" # dismiss button
    end

    test "renders dismissible success outline message" do
      render_inline(ActionMessagesComponent.new(
        messages: [ "Test" ],
        variant: :success,
        style: :outline,
        dismissible: true
      ))
      assert_selector "button" # dismiss button
    end

    test "renders dismissible danger outline message" do
      render_inline(ActionMessagesComponent.new(
        messages: [ "Test" ],
        variant: :danger,
        style: :outline,
        dismissible: true
      ))
      assert_selector "button" # dismiss button
    end

    test "renders dismissible warning outline message" do
      render_inline(ActionMessagesComponent.new(
        messages: [ "Test" ],
        variant: :warning,
        style: :outline,
        dismissible: true
      ))
      assert_selector "button" # dismiss button
    end

    test "renders dismissible info outline message" do
      render_inline(ActionMessagesComponent.new(
        messages: [ "Test" ],
        variant: :info,
        style: :outline,
        dismissible: true
      ))
      assert_selector "button" # dismiss button
    end

    test "renders dismissible light outline message" do
      render_inline(ActionMessagesComponent.new(
        messages: [ "Test" ],
        variant: :light,
        style: :outline,
        dismissible: true
      ))
      assert_selector "button" # dismiss button
    end

    test "renders dismissible dark outline message" do
      render_inline(ActionMessagesComponent.new(
        messages: [ "Test" ],
        variant: :dark,
        style: :outline,
        dismissible: true
      ))
      assert_selector "button" # dismiss button
    end

    test "renders dismissible primary ghost message" do
      render_inline(ActionMessagesComponent.new(
        messages: [ "Test" ],
        variant: :primary,
        style: :ghost,
        dismissible: true
      ))
      assert_selector "button" # dismiss button
    end

    test "renders dismissible secondary ghost message" do
      render_inline(ActionMessagesComponent.new(
        messages: [ "Test" ],
        variant: :secondary,
        style: :ghost,
        dismissible: true
      ))
      assert_selector "button" # dismiss button
    end

    test "renders dismissible accent ghost message" do
      render_inline(ActionMessagesComponent.new(
        messages: [ "Test" ],
        variant: :accent,
        style: :ghost,
        dismissible: true
      ))
      assert_selector "button" # dismiss button
    end

    test "renders dismissible success ghost message" do
      render_inline(ActionMessagesComponent.new(
        messages: [ "Test" ],
        variant: :success,
        style: :ghost,
        dismissible: true
      ))
      assert_selector "button" # dismiss button
    end

    test "renders dismissible warning ghost message" do
      render_inline(ActionMessagesComponent.new(
        messages: [ "Test" ],
        variant: :warning,
        style: :ghost,
        dismissible: true
      ))
      assert_selector "button" # dismiss button
    end

    test "renders dismissible info ghost message" do
      render_inline(ActionMessagesComponent.new(
        messages: [ "Test" ],
        variant: :info,
        style: :ghost,
        dismissible: true
      ))
      assert_selector "button" # dismiss button
    end

    test "renders dismissible light ghost message" do
      render_inline(ActionMessagesComponent.new(
        messages: [ "Test" ],
        variant: :light,
        style: :ghost,
        dismissible: true
      ))
      assert_selector "button" # dismiss button
    end

    test "renders dismissible dark ghost message" do
      render_inline(ActionMessagesComponent.new(
        messages: [ "Test" ],
        variant: :dark,
        style: :ghost,
        dismissible: true
      ))
      assert_selector "button" # dismiss button
    end
  end
end
