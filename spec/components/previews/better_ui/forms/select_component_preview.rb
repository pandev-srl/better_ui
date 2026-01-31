# frozen_string_literal: true

module BetterUi
  module Forms
    # @label Select
    class SelectComponentPreview < ViewComponent::Preview
      COUNTRIES = [
        [ "Italy", "it" ],
        [ "France", "fr" ],
        [ "Germany", "de" ],
        [ "Spain", "es" ],
        [ "United Kingdom", "uk" ],
        [ "United States", "us" ]
      ].freeze

      # @label Default
      # @display bg_color #f5f5f5
      def default
        render BetterUi::Forms::SelectComponent.new(
          name: "country",
          collection: COUNTRIES,
          label: "Country",
          placeholder: "Select a country"
        )
      end

      # @label With Value
      # @display bg_color #f5f5f5
      def with_value
        render BetterUi::Forms::SelectComponent.new(
          name: "country",
          collection: COUNTRIES,
          label: "Country",
          value: "fr"
        )
      end

      # @label With Hint
      # @display bg_color #f5f5f5
      def with_hint
        render BetterUi::Forms::SelectComponent.new(
          name: "country",
          collection: COUNTRIES,
          label: "Country",
          hint: "Select the country you currently reside in.",
          placeholder: "Select a country"
        )
      end

      # @label With Errors
      # @display bg_color #f5f5f5
      def with_errors
        render BetterUi::Forms::SelectComponent.new(
          name: "country",
          collection: COUNTRIES,
          label: "Country",
          errors: [
            "Country can't be blank",
            "Country is not included in the list"
          ]
        )
      end

      # @label Required
      # @display bg_color #f5f5f5
      def required
        render BetterUi::Forms::SelectComponent.new(
          name: "country",
          collection: COUNTRIES,
          label: "Country",
          required: true,
          placeholder: "Select a country"
        )
      end

      # @label Disabled
      # @display bg_color #f5f5f5
      def disabled
        render BetterUi::Forms::SelectComponent.new(
          name: "country",
          collection: COUNTRIES,
          label: "Country",
          value: "it",
          disabled: true
        )
      end

      # @label Readonly
      # @display bg_color #f5f5f5
      def readonly
        render BetterUi::Forms::SelectComponent.new(
          name: "country",
          collection: COUNTRIES,
          label: "Country",
          value: "de",
          readonly: true
        )
      end

      # @label Clearable
      # @display bg_color #f5f5f5
      def clearable
        render BetterUi::Forms::SelectComponent.new(
          name: "country",
          collection: COUNTRIES,
          label: "Country",
          value: "es",
          clearable: true
        )
      end

      # @label With Prefix Icon
      # @display bg_color #f5f5f5
      def with_prefix_icon
        render BetterUi::Forms::SelectComponent.new(
          name: "country",
          collection: COUNTRIES,
          label: "Country",
          placeholder: "Select a country"
        ) do |component|
          component.with_prefix_icon do
            '<svg class="h-5 w-5 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3.055 11H5a2 2 0 012 2v1a2 2 0 002 2 2 2 0 012 2v2.945M8 3.935V5.5A2.5 2.5 0 0010.5 8h.5a2 2 0 012 2 2 2 0 104 0 2 2 0 012-2h1.064M15 20.488V18a2 2 0 012-2h3.064M21 12a9 9 0 11-18 0 9 9 0 0118 0z"/>
            </svg>'.html_safe
          end
        end
      end

      # @label All Sizes
      # @display bg_color #f5f5f5
      def all_sizes
        render_with_template
      end

      # @label All States
      # @display bg_color #f5f5f5
      def all_states
        render_with_template
      end

      # @label Playground
      # @param size select { choices: [xs, sm, md, lg, xl] }
      # @param disabled toggle
      # @param readonly toggle
      # @param required toggle
      # @param clearable toggle
      # @param with_hint toggle
      # @param with_error toggle
      def playground(size: :md, disabled: false, readonly: false, required: false, clearable: false, with_hint: false, with_error: false)
        render BetterUi::Forms::SelectComponent.new(
          name: "playground",
          collection: COUNTRIES,
          label: "Playground Select",
          placeholder: "Select an option...",
          value: "it",
          size: size.to_sym,
          disabled: disabled,
          readonly: readonly,
          required: required,
          clearable: clearable,
          hint: with_hint ? "This is a helpful hint" : nil,
          errors: with_error ? [ "This field has an error" ] : nil
        )
      end
    end
  end
end
