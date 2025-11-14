# frozen_string_literal: true

module BetterUi
  # ActionMessagesComponent displays a list of messages with customizable styles and variants.
  #
  # This component is designed for displaying form validation errors, flash notifications,
  # success messages, warnings, and other user feedback. It supports multiple visual styles
  # (solid, soft, outline, ghost), all semantic color variants, optional titles, dismissible
  # functionality, and auto-dismiss timers.
  #
  # Features:
  # - 9 color variants (primary, secondary, accent, success, danger, warning, info, light, dark)
  # - 4 visual styles (solid, soft, outline, ghost)
  # - Optional title/heading
  # - Dismissible with close button
  # - Auto-dismiss after N seconds
  # - Stimulus controller integration for interactivity
  # - Icon slot for custom icons (via ViewComponent slots)
  #
  # @example Basic usage
  #   <%= render BetterUi::ActionMessagesComponent.new(messages: ["This is a message"]) %>
  #
  # @example Form validation errors
  #   <%= render BetterUi::ActionMessagesComponent.new(
  #     variant: :danger,
  #     title: "Please correct the following errors:",
  #     messages: @user.errors.full_messages
  #   ) %>
  #
  # @example Success notification with auto-dismiss
  #   <%= render BetterUi::ActionMessagesComponent.new(
  #     variant: :success,
  #     style: :solid,
  #     dismissible: true,
  #     auto_dismiss: 5,
  #     messages: ["Your changes have been saved."]
  #   ) %>
  #
  # @example With custom styling
  #   <%= render BetterUi::ActionMessagesComponent.new(
  #     variant: :warning,
  #     style: :outline,
  #     title: "Warning",
  #     messages: ["This action cannot be undone"],
  #     container_classes: "shadow-lg"
  #   ) %>
  #
  # @see ApplicationComponent
  class ActionMessagesComponent < ApplicationComponent
    attr_reader :messages, :variant, :style, :dismissible, :auto_dismiss, :title, :container_classes

    # Initialize the ActionMessages component
    #
    # @param messages [Array<String>] List of messages to display
    # @param variant [Symbol] Color variant (:primary, :secondary, :accent, :success, :danger, :warning, :info, :light, :dark)
    # @param style [Symbol] Visual style (:solid, :soft, :outline, :ghost)
    # @param dismissible [Boolean] Whether to show a dismiss button
    # @param auto_dismiss [Integer, Float, nil] Auto-dismiss after N seconds (nil to disable)
    # @param title [String, nil] Optional title/heading above messages
    # @param container_classes [String, nil] Custom CSS classes to merge with container
    # @param options [Hash] Additional HTML attributes (id, data, aria, etc.)
    def initialize(
      messages: [],
      variant: :info,
      style: :soft,
      dismissible: false,
      auto_dismiss: nil,
      title: nil,
      container_classes: nil,
      **options
    )
      # Convert messages to array (handles nil and single strings)
      @messages = Array(messages)
      @variant = variant.to_sym
      @style = style.to_sym
      @dismissible = dismissible
      @auto_dismiss = auto_dismiss
      @title = title
      @container_classes = container_classes
      @options = options

      # Validate parameters on initialization
      validate_variant!
      validate_style!
    end

    # Build CSS classes for the main container
    # Combines base classes (rounded, padding) with style-specific classes and custom classes
    # @return [String] Merged CSS class string
    def component_classes
      base_classes = [ "rounded-lg", "p-4", "relative" ]
      style_classes = send("#{@style}_classes") # Dynamically call solid_classes, soft_classes, etc.

      # Use TailwindMerge to intelligently merge classes (handles conflicts)
      css_classes(base_classes, style_classes, @container_classes)
    end

    # Build HTML attributes for the component
    # Adds Stimulus controller and auto-dismiss data attribute if configured
    # @return [Hash] HTML attributes hash
    def component_attributes
      attrs = @options.dup
      attrs[:data] ||= {}
      # Register Stimulus controller for dismiss/auto-dismiss functionality
      attrs[:data][:controller] = "better-ui--action-messages"

      # Add auto-dismiss value if configured (Stimulus will read this)
      if @auto_dismiss.present? && @auto_dismiss.to_f > 0
        attrs[:data][:"better-ui--action-messages-auto-dismiss-value"] = @auto_dismiss.to_f
      end

      attrs
    end

    # CSS classes for the title element
    # @return [String] Merged CSS class string
    def title_classes
      css_classes("font-semibold", "mb-2", title_color_classes)
    end

    # CSS classes for the content wrapper (contains icon slot and message list)
    # @return [String] Merged CSS class string
    def content_wrapper_classes
      css_classes("flex", "gap-3")
    end

    # CSS classes for the message list (<ul>)
    # @return [String] Merged CSS class string
    def list_classes
      css_classes("list-none", "list-inside", "space-y-1", "flex-1")
    end

    # CSS classes for individual message list items (<li>)
    # @return [String] Merged CSS class string
    def list_item_classes
      css_classes("text-sm")
    end

    # CSS classes for the dismiss button
    # @return [String] Merged CSS class string
    def dismiss_button_classes
      button_base = [ "absolute", "top-3", "right-3", "p-1", "rounded", "transition-colors" ]
      button_colors = dismiss_button_color_classes

      css_classes(button_base, button_colors)
    end

    private

    # Validates that the variant is one of the allowed variants.
    #
    # @raise [ArgumentError] if variant is not in ApplicationComponent::VARIANTS
    # @api private
    def validate_variant!
      unless BetterUi::ApplicationComponent::VARIANTS.key?(@variant)
        raise ArgumentError, "Invalid variant: #{@variant}. Must be one of #{BetterUi::ApplicationComponent::VARIANTS.keys.join(', ')}"
      end
    end

    # Validates that the style is one of the allowed styles.
    #
    # @raise [ArgumentError] if style is not valid (solid, soft, outline, ghost)
    # @api private
    def validate_style!
      valid_styles = [ :solid, :soft, :outline, :ghost ]
      unless valid_styles.include?(@style)
        raise ArgumentError, "Invalid style: #{@style}. Must be one of #{valid_styles.join(', ')}"
      end
    end

    # ============================================================================
    # STYLE METHODS
    # ============================================================================
    # Each style method returns hardcoded CSS class strings for Tailwind JIT.
    # Dynamic class generation (e.g., "bg-#{variant}-600") breaks Tailwind's
    # static scanner, so we use case statements with explicit class strings.
    # ============================================================================

    # Solid style: full color background with white/dark text.
    #
    # Best for: Bold, high-contrast messages
    # @return [Array<String>] array of CSS classes for solid style
    # @api private
    def solid_classes
      bg_classes = case @variant
      when :primary
        [ "bg-primary-600" ]
      when :secondary
        [ "bg-secondary-500" ]
      when :accent
        [ "bg-accent-500" ]
      when :success
        [ "bg-success-600" ]
      when :danger
        [ "bg-danger-600" ]
      when :warning
        [ "bg-warning-500" ]
      when :info
        [ "bg-info-500" ]
      when :light
        [ "bg-grayscale-100" ]
      when :dark
        [ "bg-grayscale-900" ]
      end

      text_classes = solid_text_color_classes

      bg_classes + text_classes
    end

    # Soft style: light background (shade 50) with colored text and subtle border.
    #
    # Best for: Gentle, non-intrusive messages (default style)
    # @return [Array<String>] array of CSS classes for soft style
    # @api private
    def soft_classes
      bg_classes = case @variant
      when :primary
        [ "bg-primary-50" ]
      when :secondary
        [ "bg-secondary-50" ]
      when :accent
        [ "bg-accent-50" ]
      when :success
        [ "bg-success-50" ]
      when :danger
        [ "bg-danger-50" ]
      when :warning
        [ "bg-warning-50" ]
      when :info
        [ "bg-info-50" ]
      when :light
        [ "bg-grayscale-50" ]
      when :dark
        [ "bg-grayscale-100" ]
      end

      border_classes = case @variant
      when :primary
        [ "border", "border-primary-200" ]
      when :secondary
        [ "border", "border-secondary-200" ]
      when :accent
        [ "border", "border-accent-200" ]
      when :success
        [ "border", "border-success-200" ]
      when :danger
        [ "border", "border-danger-200" ]
      when :warning
        [ "border", "border-warning-200" ]
      when :info
        [ "border", "border-info-200" ]
      when :light
        [ "border", "border-grayscale-200" ]
      when :dark
        [ "border", "border-grayscale-300" ]
      end

      text_classes = soft_text_color_classes

      bg_classes + border_classes + text_classes
    end

    # Outline style: white background with thick colored border.
    #
    # Best for: Clean, professional look with emphasis on border
    # @return [Array<String>] array of CSS classes for outline style
    # @api private
    def outline_classes
      border_classes = case @variant
      when :primary
        [ "border-2", "border-primary-500", "bg-white" ]
      when :secondary
        [ "border-2", "border-secondary-500", "bg-white" ]
      when :accent
        [ "border-2", "border-accent-500", "bg-white" ]
      when :success
        [ "border-2", "border-success-500", "bg-white" ]
      when :danger
        [ "border-2", "border-danger-500", "bg-white" ]
      when :warning
        [ "border-2", "border-warning-500", "bg-white" ]
      when :info
        [ "border-2", "border-info-500", "bg-white" ]
      when :light
        [ "border-2", "border-grayscale-300", "bg-white" ]
      when :dark
        [ "border-2", "border-grayscale-700", "bg-white" ]
      end

      text_classes = outline_text_color_classes

      border_classes + text_classes
    end

    # Ghost style: transparent background with colored text and hover effect.
    #
    # Best for: Subtle, minimal messages that blend with the page
    # @return [Array<String>] array of CSS classes for ghost style
    # @api private
    def ghost_classes
      text_classes = ghost_text_color_classes
      hover_classes = ghost_hover_classes

      text_classes + hover_classes
    end

    # ============================================================================
    # TEXT COLOR HELPERS
    # ============================================================================
    # These methods return text colors appropriate for each style.
    # ============================================================================

    # Text colors for solid style backgrounds.
    #
    # @return [Array<String>] array of text color classes for solid style
    # @api private
    def solid_text_color_classes
      case @variant
      when :light
        [ "text-grayscale-900" ]
      when :dark
        [ "text-white" ]
      when :warning
        [ "text-grayscale-900" ]
      else
        [ "text-white" ]
      end
    end

    # Text colors for soft style backgrounds.
    #
    # @return [Array<String>] array of text color classes for soft style
    # @api private
    def soft_text_color_classes
      case @variant
      when :primary
        [ "text-primary-900" ]
      when :secondary
        [ "text-secondary-900" ]
      when :accent
        [ "text-accent-900" ]
      when :success
        [ "text-success-900" ]
      when :danger
        [ "text-danger-900" ]
      when :warning
        [ "text-warning-900" ]
      when :info
        [ "text-info-900" ]
      when :light
        [ "text-grayscale-900" ]
      when :dark
        [ "text-grayscale-900" ]
      end
    end

    # Text colors for outline style.
    #
    # @return [Array<String>] array of text color classes for outline style
    # @api private
    def outline_text_color_classes
      case @variant
      when :primary
        [ "text-primary-700" ]
      when :secondary
        [ "text-secondary-700" ]
      when :accent
        [ "text-accent-700" ]
      when :success
        [ "text-success-700" ]
      when :danger
        [ "text-danger-700" ]
      when :warning
        [ "text-warning-700" ]
      when :info
        [ "text-info-700" ]
      when :light
        [ "text-grayscale-700" ]
      when :dark
        [ "text-grayscale-900" ]
      end
    end

    # Text colors for ghost style.
    #
    # @return [Array<String>] array of text color classes for ghost style
    # @api private
    def ghost_text_color_classes
      case @variant
      when :primary
        [ "text-primary-600" ]
      when :secondary
        [ "text-secondary-600" ]
      when :accent
        [ "text-accent-600" ]
      when :success
        [ "text-success-600" ]
      when :danger
        [ "text-danger-600" ]
      when :warning
        [ "text-warning-600" ]
      when :info
        [ "text-info-600" ]
      when :light
        [ "text-grayscale-600" ]
      when :dark
        [ "text-grayscale-900" ]
      end
    end

    # Hover background colors for ghost style.
    #
    # @return [Array<String>] array of hover background color classes
    # @api private
    def ghost_hover_classes
      case @variant
      when :primary
        [ "hover:bg-primary-50" ]
      when :secondary
        [ "hover:bg-secondary-50" ]
      when :accent
        [ "hover:bg-accent-50" ]
      when :success
        [ "hover:bg-success-50" ]
      when :danger
        [ "hover:bg-danger-50" ]
      when :warning
        [ "hover:bg-warning-50" ]
      when :info
        [ "hover:bg-info-50" ]
      when :light
        [ "hover:bg-grayscale-50" ]
      when :dark
        [ "hover:bg-grayscale-100" ]
      end
    end

    # Get appropriate text color for title based on current style.
    #
    # Delegates to the corresponding text color method for the active style.
    #
    # @return [Array<String>] array of text color classes for the title
    # @api private
    def title_color_classes
      case @style
      when :solid
        solid_text_color_classes
      when :soft
        soft_text_color_classes
      when :outline
        outline_text_color_classes
      when :ghost
        ghost_text_color_classes
      end
    end

    # Get appropriate colors for dismiss button based on style and variant.
    #
    # Button colors must provide good contrast and visibility for all style
    # and variant combinations.
    #
    # @return [Array<String>] array of text and hover background color classes for dismiss button
    # @api private
    def dismiss_button_color_classes
      case @style
      when :solid
        case @variant
        when :light
          [ "text-grayscale-700", "hover:bg-grayscale-200" ]
        when :dark
          [ "text-grayscale-300", "hover:bg-grayscale-800" ]
        when :warning
          [ "text-grayscale-700", "hover:bg-warning-600" ]
        else
          [ "text-white", "hover:bg-black", "hover:bg-opacity-10" ]
        end
      when :soft
        case @variant
        when :primary
          [ "text-primary-700", "hover:bg-primary-100" ]
        when :secondary
          [ "text-secondary-700", "hover:bg-secondary-100" ]
        when :accent
          [ "text-accent-700", "hover:bg-accent-100" ]
        when :success
          [ "text-success-700", "hover:bg-success-100" ]
        when :danger
          [ "text-danger-700", "hover:bg-danger-100" ]
        when :warning
          [ "text-warning-700", "hover:bg-warning-100" ]
        when :info
          [ "text-info-700", "hover:bg-info-100" ]
        when :light
          [ "text-grayscale-700", "hover:bg-grayscale-100" ]
        when :dark
          [ "text-grayscale-700", "hover:bg-grayscale-200" ]
        end
      when :outline
        case @variant
        when :primary
          [ "text-primary-600", "hover:bg-primary-50" ]
        when :secondary
          [ "text-secondary-600", "hover:bg-secondary-50" ]
        when :accent
          [ "text-accent-600", "hover:bg-accent-50" ]
        when :success
          [ "text-success-600", "hover:bg-success-50" ]
        when :danger
          [ "text-danger-600", "hover:bg-danger-50" ]
        when :warning
          [ "text-warning-600", "hover:bg-warning-50" ]
        when :info
          [ "text-info-600", "hover:bg-info-50" ]
        when :light
          [ "text-grayscale-600", "hover:bg-grayscale-50" ]
        when :dark
          [ "text-grayscale-800", "hover:bg-grayscale-100" ]
        end
      when :ghost
        case @variant
        when :primary
          [ "text-primary-600", "hover:bg-primary-100" ]
        when :secondary
          [ "text-secondary-600", "hover:bg-secondary-100" ]
        when :accent
          [ "text-accent-600", "hover:bg-accent-100" ]
        when :success
          [ "text-success-600", "hover:bg-success-100" ]
        when :danger
          [ "text-danger-600", "hover:bg-danger-100" ]
        when :warning
          [ "text-warning-600", "hover:bg-warning-100" ]
        when :info
          [ "text-info-600", "hover:bg-info-100" ]
        when :light
          [ "text-grayscale-600", "hover:bg-grayscale-100" ]
        when :dark
          [ "text-grayscale-800", "hover:bg-grayscale-200" ]
        end
      end
    end
  end
end
