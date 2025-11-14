# frozen_string_literal: true

module BetterUi
  # Lookbook previews for ActionMessagesComponent
  #
  # Provides interactive examples of the component with different configurations:
  #   - All variants showcase (9 color variants)
  #   - All styles showcase (4 visual styles)
  #   - Real-world examples (form errors, success messages)
  #   - Feature demonstrations (dismissible, auto-dismiss, icons, titles)
  #   - Interactive playground with configurable parameters
  #
  # View at: http://localhost:3000/lookbook
  #
  # @label Action Messages
  class ActionMessagesComponentPreview < ViewComponent::Preview
    # Basic component with default settings (info variant, soft style)
    # @label Default
    def default
      render BetterUi::ActionMessagesComponent.new(
        messages: [ "This is an informational message." ]
      )
    end

    # Showcase all 9 color variants using soft style
    # Demonstrates the full color palette available for messages
    # @label All Variants
    # @display bg_color #f5f5f5
    def all_variants
      @variants = ApplicationComponent::VARIANTS.keys
      render_with_template
    end

    # Showcase all 4 visual styles using primary variant
    # Demonstrates solid, soft, outline, and ghost appearances
    # @label All Styles
    # @display bg_color #f5f5f5
    def all_styles
      @styles = [ :solid, :soft, :outline, :ghost ]
      @variant = :primary
      render_with_template
    end

    # Real-world example: Form validation errors
    # Common use case showing danger variant with multiple error messages
    # @label Form Errors
    def form_errors
      render BetterUi::ActionMessagesComponent.new(
        variant: :danger,
        style: :soft,
        title: "Please correct the following errors:",
        messages: [
          "Email can't be blank",
          "Password is too short (minimum is 8 characters)",
          "Password confirmation doesn't match Password"
        ]
      )
    end

    # Real-world example: Success notification
    # Common use case showing success variant with confirmation message
    # @label Success Message
    def success_message
      render BetterUi::ActionMessagesComponent.new(
        variant: :success,
        style: :soft,
        title: "Success!",
        messages: [ "Your changes have been saved successfully." ]
      )
    end

    # Demonstrates title feature with common message types
    # Shows how titles provide context for message lists
    # @label With Title
    # @display bg_color #f5f5f5
    def with_title
      @variants = [ :info, :success, :warning, :danger ]
      render_with_template
    end

    # Demonstrates icon slot with custom SVG icon
    # Icons are passed as block content to the component
    # @label With Icon
    def with_icon
      render BetterUi::ActionMessagesComponent.new(
        variant: :success,
        style: :soft,
        title: "Payment Successful",
        messages: [
          "Your payment has been processed.",
          "You will receive a confirmation email shortly."
        ]
      ) do
        tag.svg(
          class: "w-6 h-6 text-success-600 mt-1",
          fill: "none",
          stroke: "currentColor",
          viewBox: "0 0 24 24",
          xmlns: "http://www.w3.org/2000/svg"
        ) do
          tag.path(
            stroke_linecap: "round",
            stroke_linejoin: "round",
            stroke_width: "2",
            d: "M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z"
          )
        end
      end
    end

    # Demonstrates manual dismiss functionality
    # Click X button to see smooth fade-out animation
    # @label Dismissible
    # @display bg_color #f5f5f5
    def dismissible
      @variants = [ :info, :warning, :danger ]
      render_with_template
    end

    # Demonstrates auto-dismiss feature with different durations
    # Messages automatically disappear after configured seconds
    # Refresh page to see the messages again
    # @label Auto Dismiss
    # @display bg_color #f5f5f5
    def auto_dismiss
      render_with_template
    end

    # Demonstrates multiple features working together
    # Shows icon, title, dismissible button, and auto-dismiss all at once
    # @label Combined Features
    def combined
      render BetterUi::ActionMessagesComponent.new(
        variant: :warning,
        style: :soft,
        title: "Session Expiring",
        dismissible: true,
        auto_dismiss: 10,
        messages: [
          "Your session will expire in 10 seconds.",
          "Please save your work to avoid losing data."
        ]
      ) do
        tag.svg(
          class: "w-6 h-6 text-warning-600 mt-1",
          fill: "none",
          stroke: "currentColor",
          viewBox: "0 0 24 24",
          xmlns: "http://www.w3.org/2000/svg"
        ) do
          tag.path(
            stroke_linecap: "round",
            stroke_linejoin: "round",
            stroke_width: "2",
            d: "M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z"
          )
        end
      end
    end

    # Demonstrates component with many messages
    # Shows how the component handles longer lists of items
    # @label Multiple Messages
    def multiple_messages
      render BetterUi::ActionMessagesComponent.new(
        variant: :info,
        style: :soft,
        title: "System Updates",
        messages: [
          "Database backup completed successfully",
          "Cache cleared for all users",
          "Email queue processed (142 emails sent)",
          "Security scan completed - no issues found",
          "Server maintenance scheduled for tonight at 2 AM"
        ]
      )
    end

    # Edge case: Component with empty messages array
    # Shows that component handles empty state gracefully
    # @label Empty Messages
    def empty_messages
      render BetterUi::ActionMessagesComponent.new(
        variant: :info,
        style: :soft,
        title: "No new notifications",
        messages: []
      )
    end

    # Interactive playground with configurable parameters
    # Experiment with different variants, styles, and features in real-time
    # @label Playground
    # @param variant select { choices: [primary, secondary, accent, success, danger, warning, info, light, dark] } Matches ApplicationComponent::VARIANTS.keys
    # @param style select { choices: [solid, soft, outline, ghost] }
    # @param dismissible toggle
    # @param auto_dismiss number
    # @param title text
    # @param message_1 text
    # @param message_2 text
    # @param message_3 text
    def playground(
      variant: :info,
      style: :soft,
      dismissible: false,
      auto_dismiss: nil,
      title: "Notification",
      message_1: "This is the first message.",
      message_2: "This is the second message.",
      message_3: ""
    )
      messages = [ message_1, message_2, message_3 ].reject(&:blank?)

      render BetterUi::ActionMessagesComponent.new(
        variant: variant.to_sym,
        style: style.to_sym,
        dismissible: dismissible,
        auto_dismiss: auto_dismiss&.to_f&.positive? ? auto_dismiss.to_f : nil,
        title: title.present? ? title : nil,
        messages: messages
      )
    end
  end
end
