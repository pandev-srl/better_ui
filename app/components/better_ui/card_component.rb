# frozen_string_literal: true

module BetterUi
  # A flexible card component for displaying content in a styled container.
  #
  # This component provides a versatile box container with support for multiple color variants,
  # visual styles, sizes, and optional header/footer sections. Perfect for displaying grouped
  # content, information panels, dashboards, and feature highlights.
  #
  # @example Basic card
  #   <%= render BetterUi::CardComponent.new do %>
  #     Card content here
  #   <% end %>
  #
  # @example Card with header and footer
  #   <%= render BetterUi::CardComponent.new(variant: :primary, style: :outline) do |card| %>
  #     <% card.with_header { "Card Title" } %>
  #     <% card.with_body { "Main content goes here" } %>
  #     <% card.with_footer { "Footer actions" } %>
  #   <% end %>
  #
  # @example Transparent card
  #   <%= render BetterUi::CardComponent.new(style: :ghost) do %>
  #     Transparent card content
  #   <% end %>
  #
  # @example Large success card without shadow
  #   <%= render BetterUi::CardComponent.new(variant: :success, size: :lg, shadow: false) do |card| %>
  #     <% card.with_header { "Success!" } %>
  #     <% card.with_body { "Operation completed successfully" } %>
  #   <% end %>
  #
  # @example Different styles
  #   # Solid (default): Filled colored background
  #   <%= render BetterUi::CardComponent.new(style: :solid) { "Solid card" } %>
  #
  #   # Outline: White background with colored border
  #   <%= render BetterUi::CardComponent.new(style: :outline) { "Outline card" } %>
  #
  #   # Ghost: Transparent background
  #   <%= render BetterUi::CardComponent.new(style: :ghost) { "Ghost card" } %>
  #
  #   # Soft: Light colored background
  #   <%= render BetterUi::CardComponent.new(style: :soft) { "Soft card" } %>
  #
  #   # Bordered: Neutral gray border (variant-agnostic)
  #   <%= render BetterUi::CardComponent.new(style: :bordered) { "Bordered card" } %>
  class CardComponent < ApplicationComponent
    # Size configurations for padding, text, and border radius
    SIZES = {
      xs: { padding: "p-3", text: "text-xs", radius: "rounded" },
      sm: { padding: "p-4", text: "text-sm", radius: "rounded-md" },
      md: { padding: "p-6", text: "text-base", radius: "rounded-lg" },
      lg: { padding: "p-8", text: "text-lg", radius: "rounded-lg" },
      xl: { padding: "p-10", text: "text-xl", radius: "rounded-xl" }
    }.freeze

    # Available visual styles
    STYLES = %i[solid outline ghost soft bordered].freeze

    # @!method with_header
    #   Slot for rendering optional header content at the top of the card.
    #   The header is separated from the body with a divider.
    #   @yieldreturn [String] the HTML content for the header
    renders_one :header

    # @!method with_body
    #   Slot for rendering the main body content of the card.
    #   If not provided, the card will render its default content in the body.
    #   @yieldreturn [String] the HTML content for the body
    renders_one :body

    # @!method with_footer
    #   Slot for rendering optional footer content at the bottom of the card.
    #   The footer is separated from the body with a divider.
    #   @yieldreturn [String] the HTML content for the footer
    renders_one :footer

    # Initializes a new card component.
    #
    # @param variant [Symbol] the color variant (:primary, :secondary, :accent, :success, :danger, :warning, :info, :light, :dark), defaults to :primary
    # @param style [Symbol] the visual style (:solid, :outline, :ghost, :soft, :bordered), defaults to :solid
    # @param size [Symbol] the size variant (:xs, :sm, :md, :lg, :xl), defaults to :md
    # @param shadow [Boolean] whether to apply shadow, defaults to true
    # @param header_padding [Boolean] whether to apply padding to header section, defaults to true
    # @param body_padding [Boolean] whether to apply padding to body section, defaults to true
    # @param footer_padding [Boolean] whether to apply padding to footer section, defaults to true
    # @param container_classes [String, nil] additional CSS classes for the outer wrapper
    # @param header_classes [String, nil] additional CSS classes for the header section
    # @param body_classes [String, nil] additional CSS classes for the body section
    # @param footer_classes [String, nil] additional CSS classes for the footer section
    # @param options [Hash] additional HTML attributes passed to the card element
    #
    # @raise [ArgumentError] if variant is not one of the allowed values
    # @raise [ArgumentError] if style is not one of the allowed values
    # @raise [ArgumentError] if size is not one of the allowed values
    #
    # @example With all options
    #   <%= render BetterUi::CardComponent.new(
    #     variant: :primary,
    #     style: :outline,
    #     size: :lg,
    #     shadow: true,
    #     container_classes: "mb-4",
    #     id: "my-card",
    #     data: { controller: "custom" }
    #   ) do |card| %>
    #     <% card.with_header { "Title" } %>
    #     <% card.with_body { "Content" } %>
    #   <% end %>
    #
    # @example Full-width image with no body padding
    #   <%= render BetterUi::CardComponent.new(body_padding: false) do |card| %>
    #     <% card.with_header { "Gallery" } %>
    #     <% card.with_body do %>
    #       <%= image_tag "photo.jpg", class: "w-full" %>
    #     <% end %>
    #   <% end %>
    #
    # @example Table container with no padding
    #   <%= render BetterUi::CardComponent.new(
    #     body_padding: false,
    #     style: :bordered
    #   ) do |card| %>
    #     <% card.with_body do %>
    #       <table class="w-full">...</table>
    #     <% end %>
    #   <% end %>
    def initialize(
      variant: :primary,
      style: :solid,
      size: :md,
      shadow: true,
      header_padding: true,
      body_padding: true,
      footer_padding: true,
      container_classes: nil,
      header_classes: nil,
      body_classes: nil,
      footer_classes: nil,
      **options
    )
      @variant = validate_variant(variant)
      @style = validate_style(style)
      @size = validate_size(size)
      @shadow = shadow
      @header_padding = header_padding
      @body_padding = body_padding
      @footer_padding = footer_padding
      @container_classes = container_classes
      @header_classes = header_classes
      @body_classes = body_classes
      @footer_classes = footer_classes
      @options = options
    end

    private

    # Returns the complete CSS classes for the card container.
    #
    # @return [String] the merged CSS class string
    # @api private
    def component_classes
      css_classes([
        "flex",
        "flex-col",
        size_config[:radius],
        size_config[:text],
        style_classes,
        shadow_classes,
        @container_classes
      ].flatten.compact)
    end

    # Returns CSS classes specific to the selected style.
    #
    # @return [Array<String>] array of CSS classes for the style
    # @api private
    def style_classes
      case @style
      when :solid then solid_classes
      when :outline then outline_classes
      when :ghost then ghost_classes
      when :soft then soft_classes
      when :bordered then bordered_classes
      end
    end

    # Returns CSS classes for solid style.
    # Filled background with subtle border and dark text.
    #
    # @return [Array<String>] array of CSS classes
    # @api private
    def solid_classes
      case @variant
      when :primary
        [ "bg-primary-50", "border", "border-primary-200", "text-primary-900" ]
      when :secondary
        [ "bg-secondary-50", "border", "border-secondary-200", "text-secondary-900" ]
      when :accent
        [ "bg-accent-50", "border", "border-accent-200", "text-accent-900" ]
      when :success
        [ "bg-success-50", "border", "border-success-200", "text-success-900" ]
      when :danger
        [ "bg-danger-50", "border", "border-danger-200", "text-danger-900" ]
      when :warning
        [ "bg-warning-50", "border", "border-warning-200", "text-warning-900" ]
      when :info
        [ "bg-info-50", "border", "border-info-200", "text-info-900" ]
      when :light
        [ "bg-light", "border", "border-grayscale-200", "text-grayscale-900" ]
      when :dark
        [ "bg-dark", "border", "border-grayscale-700", "text-grayscale-50" ]
      end
    end

    # Returns CSS classes for outline style.
    # White background with colored border.
    #
    # @return [Array<String>] array of CSS classes
    # @api private
    def outline_classes
      case @variant
      when :primary
        [ "bg-white", "border-2", "border-primary-500", "text-primary-700" ]
      when :secondary
        [ "bg-white", "border-2", "border-secondary-500", "text-secondary-700" ]
      when :accent
        [ "bg-white", "border-2", "border-accent-500", "text-accent-700" ]
      when :success
        [ "bg-white", "border-2", "border-success-500", "text-success-700" ]
      when :danger
        [ "bg-white", "border-2", "border-danger-500", "text-danger-700" ]
      when :warning
        [ "bg-white", "border-2", "border-warning-500", "text-warning-700" ]
      when :info
        [ "bg-white", "border-2", "border-info-500", "text-info-700" ]
      when :light
        [ "bg-white", "border-2", "border-grayscale-300", "text-grayscale-700" ]
      when :dark
        [ "bg-white", "border-2", "border-grayscale-900", "text-grayscale-900" ]
      end
    end

    # Returns CSS classes for ghost style.
    # Transparent background with colored text (for transparent cards).
    #
    # @return [Array<String>] array of CSS classes
    # @api private
    def ghost_classes
      case @variant
      when :primary
        [ "bg-transparent", "text-primary-600" ]
      when :secondary
        [ "bg-transparent", "text-secondary-600" ]
      when :accent
        [ "bg-transparent", "text-accent-600" ]
      when :success
        [ "bg-transparent", "text-success-600" ]
      when :danger
        [ "bg-transparent", "text-danger-600" ]
      when :warning
        [ "bg-transparent", "text-warning-600" ]
      when :info
        [ "bg-transparent", "text-info-600" ]
      when :light
        [ "bg-transparent", "text-grayscale-400" ]
      when :dark
        [ "bg-transparent", "text-grayscale-900" ]
      end
    end

    # Returns CSS classes for soft style.
    # Light background with subtle border and medium text.
    #
    # @return [Array<String>] array of CSS classes
    # @api private
    def soft_classes
      case @variant
      when :primary
        [ "bg-primary-50", "border", "border-primary-100", "text-primary-800" ]
      when :secondary
        [ "bg-secondary-50", "border", "border-secondary-100", "text-secondary-800" ]
      when :accent
        [ "bg-accent-50", "border", "border-accent-100", "text-accent-800" ]
      when :success
        [ "bg-success-50", "border", "border-success-100", "text-success-800" ]
      when :danger
        [ "bg-danger-50", "border", "border-danger-100", "text-danger-800" ]
      when :warning
        [ "bg-warning-50", "border", "border-warning-100", "text-warning-800" ]
      when :info
        [ "bg-info-50", "border", "border-info-100", "text-info-800" ]
      when :light
        [ "bg-light", "border", "border-grayscale-100", "text-grayscale-800" ]
      when :dark
        [ "bg-grayscale-800", "border", "border-grayscale-700", "text-grayscale-100" ]
      end
    end

    # Returns CSS classes for bordered style.
    # Neutral white background with gray border, variant-agnostic.
    # Perfect for visual content separation and isolation.
    #
    # @return [Array<String>] array of CSS classes
    # @api private
    def bordered_classes
      [ "bg-white", "border", "border-gray-300", "text-gray-900" ]
    end

    # Returns shadow CSS classes based on the shadow parameter.
    #
    # @return [String, nil] shadow class or nil
    # @api private
    def shadow_classes
      @shadow ? "shadow-md" : nil
    end

    # Returns the size configuration hash for the current size.
    #
    # @return [Hash] size configuration with padding, text, radius, and gap
    # @api private
    def size_config
      SIZES[@size]
    end

    # Returns CSS classes for the header section.
    #
    # @return [String] CSS classes for header
    # @api private
    def header_wrapper_classes
      css_classes([
        (@header_padding ? size_config[:padding] : nil),
        "border-b",
        border_color_class,
        @header_classes
      ].flatten.compact)
    end

    # Returns CSS classes for the body section.
    #
    # @return [String] CSS classes for body
    # @api private
    def body_wrapper_classes
      css_classes([
        (@body_padding ? size_config[:padding] : nil),
        @body_classes
      ].flatten.compact)
    end

    # Returns CSS classes for the footer section.
    #
    # @return [String] CSS classes for footer
    # @api private
    def footer_wrapper_classes
      css_classes([
        (@footer_padding ? size_config[:padding] : nil),
        "border-t",
        border_color_class,
        @footer_classes
      ].flatten.compact)
    end

    # Returns the appropriate border color class based on variant and style.
    #
    # @return [String] border color class
    # @api private
    def border_color_class
      case @style
      when :solid
        case @variant
        when :primary then "border-primary-200"
        when :secondary then "border-secondary-200"
        when :accent then "border-accent-200"
        when :success then "border-success-200"
        when :danger then "border-danger-200"
        when :warning then "border-warning-200"
        when :info then "border-info-200"
        when :light then "border-grayscale-200"
        when :dark then "border-grayscale-700"
        end
      when :outline
        case @variant
        when :primary then "border-primary-500"
        when :secondary then "border-secondary-500"
        when :accent then "border-accent-500"
        when :success then "border-success-500"
        when :danger then "border-danger-500"
        when :warning then "border-warning-500"
        when :info then "border-info-500"
        when :light then "border-grayscale-300"
        when :dark then "border-grayscale-900"
        end
      when :soft
        case @variant
        when :primary then "border-primary-100"
        when :secondary then "border-secondary-100"
        when :accent then "border-accent-100"
        when :success then "border-success-100"
        when :danger then "border-danger-100"
        when :warning then "border-warning-100"
        when :info then "border-info-100"
        when :light then "border-grayscale-100"
        when :dark then "border-grayscale-700"
        end
      when :ghost
        "border-transparent"
      when :bordered
        "border-gray-300"
      end
    end

    # Returns HTML attributes for the card element.
    #
    # @return [Hash] HTML attributes hash
    # @api private
    def html_attributes
      @options
    end

    # Validates the variant parameter.
    #
    # @param variant [Symbol] the variant to validate
    # @return [Symbol] the validated variant
    # @raise [ArgumentError] if variant is invalid
    # @api private
    def validate_variant(variant)
      unless BetterUi::ApplicationComponent::VARIANTS.key?(variant)
        raise ArgumentError, "Invalid variant: #{variant}. Must be one of: #{BetterUi::ApplicationComponent::VARIANTS.keys.join(', ')}"
      end
      variant
    end

    # Validates the style parameter.
    #
    # @param style [Symbol] the style to validate
    # @return [Symbol] the validated style
    # @raise [ArgumentError] if style is invalid
    # @api private
    def validate_style(style)
      unless STYLES.include?(style)
        raise ArgumentError, "Invalid style: #{style}. Must be one of: #{STYLES.join(', ')}"
      end
      style
    end

    # Validates the size parameter.
    #
    # @param size [Symbol] the size to validate
    # @return [Symbol] the validated size
    # @raise [ArgumentError] if size is invalid
    # @api private
    def validate_size(size)
      unless SIZES.key?(size)
        raise ArgumentError, "Invalid size: #{size}. Must be one of: #{SIZES.keys.join(', ')}"
      end
      size
    end
  end
end
