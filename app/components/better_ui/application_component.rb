# frozen_string_literal: true

module BetterUi
  # Base component class for all ViewComponents in BetterUi.
  #
  # This class provides:
  # - Common configuration for all components
  # - Shared helper methods
  # - Consistent behavior across components
  #
  # Usage:
  #   class BetterUi::MyComponent < BetterUi::ApplicationComponent
  #     # component implementation
  #   end
  #
  # Best Practices:
  # - Use composition over inheritance
  # - Keep instance methods private
  # - Pass data explicitly (avoid global state)
  # - Test against rendered content, not internals
  class ApplicationComponent < ViewComponent::Base
    # Enable content areas (slots) by default
    # Allows components to accept flexible content blocks
    # Example: <%= render(BetterUi::MyComponent.new) do |c| %>
    #            <% c.with_header { "Title" } %>
    #          <% end %>

    # Color variant definitions with default shades
    #
    # This is the single source of truth for all color variants used throughout BetterUi.
    # Use VARIANTS.keys to iterate over available variants in components and preview templates.
    #
    # Related CSS definitions:
    # - CSS custom properties defined in host app via generator (better_ui_theme.css @theme inline)
    # - Typography color utilities: .text-heading-{variant} (@layer utilities)
    #
    # Note: Case statements in components must use hardcoded Tailwind class strings
    # (e.g., "bg-primary-600") for the JIT compiler to detect them at build time.
    # The VARIANTS constant is used for iteration and validation only.
    VARIANTS = {
      primary: 600,      # Strong, trustworthy actions
      secondary: 500,    # Neutral, supporting elements
      accent: 500,       # Highlights and special features
      success: 600,      # Positive actions, confirmations
      danger: 600,       # Destructive actions, errors
      warning: 500,      # Caution, alerts
      info: 500,         # Informational, tips
      light: 100,        # Light backgrounds and light text
      dark: 900          # Dark backgrounds and dark text
    }.freeze

    # Shadow size definitions mapping to Tailwind shadow classes.
    # Used across all components for consistent elevation styling.
    #
    # @example Usage in component
    #   SHADOWS[@shadow] # => "shadow-sm"
    SHADOWS = {
      none: nil,
      sm: "shadow-sm",
      md: "shadow-md",
      lg: "shadow-lg",
      xl: "shadow-xl"
    }.freeze

    private

    # Normalizes a shadow parameter value.
    # Accepts Symbol sizes (:sm, :md, etc.), booleans for backward compatibility,
    # or false/nil to disable shadows.
    #
    # @param value [Symbol, Boolean] the shadow value to normalize
    # @param default [Symbol] the default shadow size (used when value is true)
    # @return [Symbol] normalized shadow key
    def normalize_shadow(value, default: :sm)
      case value
      when false, nil, :none then :none
      when true then default
      when Symbol
        unless SHADOWS.key?(value)
          raise ArgumentError, "Invalid shadow: #{value}. Must be one of: #{SHADOWS.keys.join(', ')}"
        end
        value
      else
        raise ArgumentError, "Invalid shadow: #{value}. Must be a Symbol or Boolean"
      end
    end

    # Helper to merge CSS classes intelligently using TailwindMerge
    # Resolves conflicting Tailwind utility classes
    #
    # @param classes [Array<String>] CSS class names to merge
    # @return [String] Merged CSS classes
    #
    # Example:
    #   css_classes("px-4 py-2", "px-6") #=> "py-2 px-6"
    def css_classes(*classes)
      TailwindMerge::Merger.new.merge(classes.compact.join(" "))
    end
  end
end
