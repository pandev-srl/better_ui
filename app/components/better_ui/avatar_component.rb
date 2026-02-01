# frozen_string_literal: true

module BetterUi
  # An avatar component for displaying user profile images or initials.
  #
  # Supports image display, initials fallback from a name, multiple sizes,
  # shapes, color variants, status indicators, and a badge slot.
  #
  # @example With image
  #   <%= render BetterUi::AvatarComponent.new(src: user.avatar_url, alt: user.name) %>
  #
  # @example With initials fallback
  #   <%= render BetterUi::AvatarComponent.new(name: "John Doe", variant: :primary) %>
  #
  # @example With status indicator
  #   <%= render BetterUi::AvatarComponent.new(
  #     src: user.avatar_url,
  #     name: user.name,
  #     status: :online,
  #     size: :lg
  #   ) %>
  #
  # @example With badge slot
  #   <%= render BetterUi::AvatarComponent.new(src: user.avatar_url) do |avatar| %>
  #     <% avatar.with_badge do %>
  #       <span class="bg-red-500 text-white text-xs rounded-full w-5 h-5 flex items-center justify-center">3</span>
  #     <% end %>
  #   <% end %>
  class AvatarComponent < ApplicationComponent
    # Size configurations mapping to Tailwind dimension and text classes
    SIZES = {
      xs: "w-6 h-6 text-xs",
      sm: "w-8 h-8 text-sm",
      md: "w-10 h-10 text-base",
      lg: "w-14 h-14 text-lg",
      xl: "w-20 h-20 text-xl"
    }.freeze

    # Shape configurations mapping to Tailwind border-radius classes
    SHAPES = {
      circle: "rounded-full",
      square: "rounded-none",
      rounded: "rounded-lg"
    }.freeze

    # Status indicator colors
    STATUSES = %i[online offline busy away].freeze

    # Status dot size classes scaled by avatar size
    STATUS_DOT_SIZES = {
      xs: "w-2 h-2",
      sm: "w-2 h-2",
      md: "w-2.5 h-2.5",
      lg: "w-3 h-3",
      xl: "w-4 h-4"
    }.freeze

    # @!method with_badge
    #   Slot for rendering an optional badge overlay (e.g., notification count).
    #   Positioned at top-right of the avatar.
    #   @yieldreturn [String] the HTML content for the badge
    renders_one :badge

    # Initializes a new avatar component.
    #
    # @param src [String, nil] URL of the avatar image
    # @param alt [String, nil] Alt text for the image (falls back to name)
    # @param name [String, nil] Full name used to generate initials fallback
    # @param variant [Symbol] Color variant for initials background
    # @param size [Symbol] Avatar size (:xs, :sm, :md, :lg, :xl)
    # @param shape [Symbol] Avatar shape (:circle, :square, :rounded)
    # @param status [Symbol, nil] Status indicator (:online, :offline, :busy, :away)
    # @param container_classes [String, nil] Additional CSS classes for the outer wrapper
    # @param options [Hash] Additional HTML attributes
    #
    # @raise [ArgumentError] if variant, size, shape, or status is invalid
    def initialize(
      src: nil,
      alt: nil,
      name: nil,
      variant: :primary,
      size: :md,
      shape: :circle,
      status: nil,
      container_classes: nil,
      **options
    )
      @src = src
      @alt = alt
      @name = name
      @variant = validate_variant(variant)
      @size = validate_size(size)
      @shape = validate_shape(shape)
      @status = validate_status(status) if status
      @container_classes = container_classes
      @options = options
    end

    private

    attr_reader :src, :alt, :name, :variant, :size, :shape, :status,
                :container_classes, :options

    # Returns the combined CSS classes for the avatar element (img or div).
    #
    # @return [String] merged CSS class string
    # @api private
    def component_classes
      css_classes(
        SIZES[@size],
        SHAPES[@shape],
        variant_classes,
        @container_classes
      )
    end

    # Returns variant-specific background and text color classes for initials mode.
    # When an image is provided, no variant background is needed.
    #
    # @return [String, nil] variant CSS classes or nil
    # @api private
    def variant_classes
      return nil if @src

      case @variant
      when :primary   then "bg-primary-100 text-primary-700"
      when :secondary then "bg-secondary-100 text-secondary-700"
      when :accent    then "bg-accent-100 text-accent-700"
      when :success   then "bg-success-100 text-success-700"
      when :danger    then "bg-danger-100 text-danger-700"
      when :warning   then "bg-warning-100 text-warning-700"
      when :info      then "bg-info-100 text-info-700"
      when :light     then "bg-grayscale-100 text-grayscale-700"
      when :dark      then "bg-grayscale-800 text-grayscale-100"
      end
    end

    # Returns CSS classes for the status indicator dot.
    #
    # @return [String] combined status color and size classes
    # @api private
    def status_classes
      color = case @status
      when :online  then "bg-success-500"
      when :offline then "bg-grayscale-400"
      when :busy    then "bg-danger-500"
      when :away    then "bg-warning-500"
      end

      "#{color} #{STATUS_DOT_SIZES[@size]}"
    end

    # Extracts initials from the name.
    # Takes the first letter of the first word and the first letter of the second word (if present).
    #
    # @return [String] uppercase initials (e.g., "JD" for "John Doe", "A" for "Alice")
    # @api private
    def initials
      return "" unless @name

      parts = @name.strip.split(/\s+/)
      result = parts[0][0].to_s
      result += parts[1][0].to_s if parts.length > 1
      result.upcase
    end

    # Returns the alt text for the image, falling back to name.
    #
    # @return [String, nil] alt text
    # @api private
    def alt_text
      @alt || @name
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

    # Validates the shape parameter.
    #
    # @param shape [Symbol] the shape to validate
    # @return [Symbol] the validated shape
    # @raise [ArgumentError] if shape is invalid
    # @api private
    def validate_shape(shape)
      unless SHAPES.key?(shape)
        raise ArgumentError, "Invalid shape: #{shape}. Must be one of: #{SHAPES.keys.join(', ')}"
      end
      shape
    end

    # Validates the status parameter.
    #
    # @param status [Symbol] the status to validate
    # @return [Symbol] the validated status
    # @raise [ArgumentError] if status is invalid
    # @api private
    def validate_status(status)
      unless STATUSES.include?(status)
        raise ArgumentError, "Invalid status: #{status}. Must be one of: #{STATUSES.join(', ')}"
      end
      status
    end
  end
end
