# frozen_string_literal: true

module BetterUi
  module Drawer
    # A flexible header component for drawer layouts with support for logo, navigation, and actions.
    #
    # This component provides a responsive header with slots for logo, navigation, actions,
    # and mobile menu button. It supports sticky positioning and multiple visual variants.
    #
    # @example Basic header
    #   <%= render BetterUi::Drawer::HeaderComponent.new do |header| %>
    #     <% header.with_logo { image_tag("logo.svg") } %>
    #     <% header.with_actions { "User Menu" } %>
    #   <% end %>
    #
    # @example Header with navigation
    #   <%= render BetterUi::Drawer::HeaderComponent.new(sticky: true, variant: :light) do |header| %>
    #     <% header.with_logo { "Brand" } %>
    #     <% header.with_navigation do %>
    #       <nav>Navigation links</nav>
    #     <% end %>
    #     <% header.with_mobile_menu_button do %>
    #       <button>Menu</button>
    #     <% end %>
    #     <% header.with_actions { "Actions" } %>
    #   <% end %>
    class HeaderComponent < ApplicationComponent
      # Height configurations
      HEIGHTS = {
        sm: "h-12",
        md: "h-16",
        lg: "h-20"
      }.freeze

      # Visual variant configurations
      HEADER_VARIANTS = {
        light: {
          bg: "bg-white",
          border: "border-b border-grayscale-200",
          text: "text-grayscale-900"
        },
        dark: {
          bg: "bg-grayscale-900",
          border: "border-b border-grayscale-700",
          text: "text-white"
        },
        transparent: {
          bg: "bg-transparent",
          border: "",
          text: "text-grayscale-900"
        },
        primary: {
          bg: "bg-primary-600",
          border: "border-b border-primary-700",
          text: "text-white"
        }
      }.freeze

      # @!method with_logo
      #   Slot for rendering the logo/brand section (left side).
      #   @yieldreturn [String] the HTML content for the logo
      renders_one :logo

      # @!method with_navigation
      #   Slot for rendering the main navigation (center or after logo).
      #   Hidden on mobile by default.
      #   @yieldreturn [String] the HTML content for navigation
      renders_one :navigation

      # @!method with_actions
      #   Slot for rendering actions section (right side).
      #   Typically contains user menu, notifications, etc.
      #   @yieldreturn [String] the HTML content for actions
      renders_one :actions

      # @!method with_mobile_menu_button
      #   Slot for rendering the mobile menu toggle button.
      #   Only visible on mobile screens.
      #   @yieldreturn [String] the HTML content for the mobile menu button
      renders_one :mobile_menu_button

      # Initializes a new header component.
      #
      # @param variant [Symbol] the visual variant (:light, :dark, :transparent, :primary), defaults to :light
      # @param sticky [Boolean] whether the header is sticky/fixed at top, defaults to true
      # @param height [Symbol] the height variant (:sm, :md, :lg), defaults to :md
      # @param container_classes [String, nil] additional CSS classes for the container
      # @param options [Hash] additional HTML attributes passed to the header element
      #
      # @raise [ArgumentError] if variant is not one of the allowed values
      # @raise [ArgumentError] if height is not one of the allowed values
      def initialize(
        variant: :light,
        sticky: true,
        height: :md,
        container_classes: nil,
        **options
      )
        @variant = validate_variant(variant)
        @sticky = sticky
        @height = validate_height(height)
        @container_classes = container_classes
        @options = options
      end

      private

      # Returns the complete CSS classes for the header container.
      #
      # @return [String] the merged CSS class string
      # @api private
      def component_classes
        css_classes([
          "w-full",
          height_class,
          variant_classes,
          sticky_classes,
          "flex",
          "items-center",
          "justify-between",
          "px-4",
          "z-40",
          @container_classes
        ].flatten.compact)
      end

      # Returns CSS class for the height.
      #
      # @return [String] the height class
      # @api private
      def height_class
        HEIGHTS[@height]
      end

      # Returns CSS classes for the variant.
      #
      # @return [Array<String>] array of CSS classes for the variant
      # @api private
      def variant_classes
        config = HEADER_VARIANTS[@variant]
        [config[:bg], config[:border], config[:text]]
      end

      # Returns CSS classes for sticky positioning.
      #
      # @return [String, nil] sticky class or nil
      # @api private
      def sticky_classes
        @sticky ? "sticky top-0" : nil
      end

      # Returns CSS classes for the logo section.
      #
      # @return [String] CSS classes for logo wrapper
      # @api private
      def logo_classes
        css_classes([
          "flex",
          "items-center",
          "shrink-0"
        ])
      end

      # Returns CSS classes for the navigation section.
      #
      # @return [String] CSS classes for navigation wrapper
      # @api private
      def navigation_classes
        css_classes([
          "hidden",
          "lg:flex",
          "flex-1",
          "items-center",
          "justify-center",
          "px-4"
        ])
      end

      # Returns CSS classes for the actions section.
      #
      # @return [String] CSS classes for actions wrapper
      # @api private
      def actions_classes
        css_classes([
          "flex",
          "items-center",
          "gap-2"
        ])
      end

      # Returns CSS classes for the mobile menu button.
      #
      # @return [String] CSS classes for mobile menu button wrapper
      # @api private
      def mobile_menu_button_classes
        css_classes([
          "lg:hidden",
          "flex",
          "items-center"
        ])
      end

      # Returns HTML attributes for the header element.
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
        unless HEADER_VARIANTS.key?(variant)
          raise ArgumentError, "Invalid variant: #{variant}. Must be one of: #{HEADER_VARIANTS.keys.join(', ')}"
        end
        variant
      end

      # Validates the height parameter.
      #
      # @param height [Symbol] the height to validate
      # @return [Symbol] the validated height
      # @raise [ArgumentError] if height is invalid
      # @api private
      def validate_height(height)
        unless HEIGHTS.key?(height)
          raise ArgumentError, "Invalid height: #{height}. Must be one of: #{HEIGHTS.keys.join(', ')}"
        end
        height
      end
    end
  end
end
