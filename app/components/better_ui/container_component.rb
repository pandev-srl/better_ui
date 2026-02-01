# frozen_string_literal: true

module BetterUi
  # A responsive container component for constraining content width.
  #
  # This component provides a simple wrapper div with configurable max-width,
  # horizontal padding, and centering. It is ideal for wrapping page content
  # to maintain readable line lengths and consistent layout across breakpoints.
  #
  # @example Basic container (default: lg, padded, centered)
  #   <%= render BetterUi::ContainerComponent.new do %>
  #     Page content here
  #   <% end %>
  #
  # @example Extra-large container
  #   <%= render BetterUi::ContainerComponent.new(size: :xl) do %>
  #     Wide content area
  #   <% end %>
  #
  # @example Full-width container without padding
  #   <%= render BetterUi::ContainerComponent.new(size: :full, padding: false) do %>
  #     Edge-to-edge content
  #   <% end %>
  #
  # @example Non-centered container
  #   <%= render BetterUi::ContainerComponent.new(centered: false) do %>
  #     Left-aligned content
  #   <% end %>
  class ContainerComponent < ApplicationComponent
    # Available container sizes mapped to Tailwind max-width classes.
    #
    # @note Classes must be hardcoded strings for Tailwind JIT detection.
    SIZES = {
      sm: "max-w-screen-sm",
      md: "max-w-screen-md",
      lg: "max-w-screen-lg",
      xl: "max-w-screen-xl",
      full: "max-w-full"
    }.freeze

    # Initializes a new container component.
    #
    # @param size [Symbol] the max-width size (:sm, :md, :lg, :xl, :full), defaults to :lg
    # @param padding [Boolean] whether to apply horizontal padding, defaults to true
    # @param centered [Boolean] whether to center the container with mx-auto, defaults to true
    # @param container_classes [String, nil] additional CSS classes for the container
    # @param options [Hash] additional HTML attributes passed to the container div
    #
    # @raise [ArgumentError] if size is not one of the allowed values
    #
    # @example With all options
    #   <%= render BetterUi::ContainerComponent.new(
    #     size: :xl,
    #     padding: true,
    #     centered: true,
    #     container_classes: "my-8",
    #     id: "main-content",
    #     data: { controller: "page" }
    #   ) do %>
    #     Content here
    #   <% end %>
    def initialize(
      size: :lg,
      padding: true,
      centered: true,
      container_classes: nil,
      **options
    )
      @size = validate_size(size)
      @padding = padding
      @centered = centered
      @container_classes = container_classes
      @options = options
    end

    private

    attr_reader :size, :padding, :centered, :container_classes, :options

    # Returns the complete CSS classes for the container element.
    #
    # @return [String] the merged CSS class string
    # @api private
    def component_classes
      css_classes([
        "w-full",
        size_classes,
        padding_classes,
        centered_classes,
        @container_classes
      ].flatten.compact)
    end

    # Returns the max-width class for the current size.
    #
    # @return [String] Tailwind max-width class
    # @api private
    def size_classes
      SIZES[@size]
    end

    # Returns horizontal padding classes when padding is enabled.
    #
    # @return [String, nil] padding classes or nil
    # @api private
    def padding_classes
      return nil unless @padding

      "px-4 sm:px-6 lg:px-8"
    end

    # Returns centering class when centered is enabled.
    #
    # @return [String, nil] centering class or nil
    # @api private
    def centered_classes
      return nil unless @centered

      "mx-auto"
    end

    # Returns HTML attributes for the container element.
    #
    # @return [Hash] HTML attributes hash
    # @api private
    def html_attributes
      @options
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
