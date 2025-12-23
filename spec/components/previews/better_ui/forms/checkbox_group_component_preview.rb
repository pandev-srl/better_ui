# frozen_string_literal: true

module BetterUi
  module Forms
    # @label Checkbox Group
    class CheckboxGroupComponentPreview < ViewComponent::Preview
      # @label Default
      # @display bg_color #f5f5f5
      def default
        render BetterUi::Forms::CheckboxGroupComponent.new(
          name: "interests",
          collection: [ "Sports", "Music", "Art", "Technology" ],
          legend: "Interests"
        )
      end

      # @label With Selection
      # @display bg_color #f5f5f5
      def with_selection
        render BetterUi::Forms::CheckboxGroupComponent.new(
          name: "roles",
          collection: [
            [ "Administrator", "admin" ],
            [ "Editor", "editor" ],
            [ "Viewer", "viewer" ]
          ],
          selected: [ "admin", "viewer" ],
          legend: "User Roles"
        )
      end

      # @label Horizontal Layout
      # @display bg_color #f5f5f5
      def horizontal
        render BetterUi::Forms::CheckboxGroupComponent.new(
          name: "days",
          collection: [ "Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun" ],
          orientation: :horizontal,
          legend: "Available Days"
        )
      end

      # @label With Hint
      # @display bg_color #f5f5f5
      def with_hint
        render BetterUi::Forms::CheckboxGroupComponent.new(
          name: "notifications",
          collection: [
            [ "Email notifications", "email" ],
            [ "Push notifications", "push" ],
            [ "SMS notifications", "sms" ]
          ],
          legend: "Notification Preferences",
          hint: "Select how you'd like to be notified"
        )
      end

      # @label With Errors
      # @display bg_color #f5f5f5
      def with_errors
        render BetterUi::Forms::CheckboxGroupComponent.new(
          name: "terms",
          collection: [
            [ "Terms of Service", "tos" ],
            [ "Privacy Policy", "privacy" ]
          ],
          legend: "Legal Agreements",
          errors: [ "You must accept all agreements to continue" ]
        )
      end

      # @label Required Field
      # @display bg_color #f5f5f5
      def required
        render BetterUi::Forms::CheckboxGroupComponent.new(
          name: "skills",
          collection: [ "Ruby", "JavaScript", "Python", "Go" ],
          legend: "Programming Skills",
          required: true,
          hint: "Select at least one skill"
        )
      end

      # @label Disabled State
      # @display bg_color #f5f5f5
      def disabled
        render BetterUi::Forms::CheckboxGroupComponent.new(
          name: "permissions",
          collection: [
            [ "Read", "read" ],
            [ "Write", "write" ],
            [ "Delete", "delete" ]
          ],
          selected: [ "read" ],
          legend: "Permissions (Disabled)",
          disabled: true
        )
      end

      # @label All Variants
      # @display bg_color #f5f5f5
      def all_variants
        render_with_template
      end

      # @label Orientations
      # @display bg_color #f5f5f5
      def orientations
        render_with_template
      end

      # @label Form Integration
      # @display bg_color #f5f5f5
      def form_integration
        render_with_template
      end

      # @label Playground
      # @param variant select { choices: [primary, secondary, accent, success, danger, warning, info, light, dark] }
      # @param size select { choices: [xs, sm, md, lg, xl] }
      # @param orientation select { choices: [vertical, horizontal] }
      # @param disabled toggle
      # @param required toggle
      # @param with_hint toggle
      # @param with_error toggle
      def playground(
        variant: :primary,
        size: :md,
        orientation: :vertical,
        disabled: false,
        required: false,
        with_hint: false,
        with_error: false
      )
        render BetterUi::Forms::CheckboxGroupComponent.new(
          name: "playground",
          collection: [ "Option A", "Option B", "Option C" ],
          legend: "Playground Group",
          variant: variant.to_sym,
          size: size.to_sym,
          orientation: orientation.to_sym,
          disabled: disabled,
          required: required,
          hint: with_hint ? "Select one or more options" : nil,
          errors: with_error ? [ "Please make a selection" ] : nil
        )
      end
    end
  end
end
