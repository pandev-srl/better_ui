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

    # Variant-based CSS class mappings for table components
    # Used for O(1) lookup instead of case/when statements
    VARIANT_STRIPED = {
      primary: "even:bg-primary-50",
      secondary: "even:bg-secondary-50",
      accent: "even:bg-accent-50",
      success: "even:bg-success-50",
      danger: "even:bg-danger-50",
      warning: "even:bg-warning-50",
      info: "even:bg-info-50",
      light: "even:bg-grayscale-50",
      dark: "even:bg-grayscale-700"
    }.freeze

    VARIANT_HOVERABLE = {
      primary: "hover:bg-primary-100 transition-colors",
      secondary: "hover:bg-secondary-100 transition-colors",
      accent: "hover:bg-accent-100 transition-colors",
      success: "hover:bg-success-100 transition-colors",
      danger: "hover:bg-danger-100 transition-colors",
      warning: "hover:bg-warning-100 transition-colors",
      info: "hover:bg-info-100 transition-colors",
      light: "hover:bg-grayscale-100 transition-colors",
      dark: "hover:bg-grayscale-600 transition-colors"
    }.freeze

    VARIANT_HIGHLIGHTED = {
      primary: "bg-primary-100",
      secondary: "bg-secondary-100",
      accent: "bg-accent-100",
      success: "bg-success-100",
      danger: "bg-danger-100",
      warning: "bg-warning-100",
      info: "bg-info-100",
      light: "bg-grayscale-100",
      dark: "bg-grayscale-700"
    }.freeze

    VARIANT_HEADER_BG = {
      primary: "bg-primary-50",
      secondary: "bg-secondary-50",
      accent: "bg-accent-50",
      success: "bg-success-50",
      danger: "bg-danger-50",
      warning: "bg-warning-50",
      info: "bg-info-50",
      light: "bg-grayscale-100",
      dark: "bg-grayscale-800"
    }.freeze

    VARIANT_HEADER_TEXT = {
      primary: "text-primary-900",
      secondary: "text-secondary-900",
      accent: "text-accent-900",
      success: "text-success-900",
      danger: "text-danger-900",
      warning: "text-warning-900",
      info: "text-info-900",
      light: "text-grayscale-700",
      dark: "text-grayscale-50"
    }.freeze

    VARIANT_DIVIDE = {
      primary: "divide-y divide-primary-300",
      secondary: "divide-y divide-secondary-300",
      accent: "divide-y divide-accent-300",
      success: "divide-y divide-success-300",
      danger: "divide-y divide-danger-300",
      warning: "divide-y divide-warning-300",
      info: "divide-y divide-info-300",
      light: "divide-y divide-grayscale-300",
      dark: "divide-y divide-grayscale-700"
    }.freeze

    VARIANT_BODY_DIVIDE = {
      primary: "divide-primary-200",
      secondary: "divide-secondary-200",
      accent: "divide-accent-200",
      success: "divide-success-200",
      danger: "divide-danger-200",
      warning: "divide-warning-200",
      info: "divide-info-200",
      light: "divide-grayscale-200",
      dark: "divide-grayscale-600"
    }.freeze

    VARIANT_RING = {
      primary: "ring-primary-300",
      secondary: "ring-secondary-300",
      accent: "ring-accent-300",
      success: "ring-success-300",
      danger: "ring-danger-300",
      warning: "ring-warning-300",
      info: "ring-info-300",
      light: "ring-grayscale-300",
      dark: "ring-grayscale-700"
    }.freeze

    VARIANT_SORT_ICON = {
      primary: "text-primary-700",
      secondary: "text-secondary-700",
      accent: "text-accent-700",
      success: "text-success-700",
      danger: "text-danger-700",
      warning: "text-warning-700",
      info: "text-info-700",
      light: "text-grayscale-500",
      dark: "text-grayscale-300"
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
