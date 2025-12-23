# frozen_string_literal: true

module BetterUi
  module Drawer
    # A navigation item component for sidebar menus with icon, label, and badge support.
    #
    # @example Basic usage
    #   <%= render BetterUi::Drawer::NavItemComponent.new(label: "Dashboard", href: "/dashboard") %>
    #
    # @example With icon and active state
    #   <%= render BetterUi::Drawer::NavItemComponent.new(
    #     label: "Dashboard",
    #     href: "/dashboard",
    #     active: true
    #   ) do |item| %>
    #     <% item.with_icon do %>
    #       <svg>...</svg>
    #     <% end %>
    #   <% end %>
    #
    # @example With badge
    #   <%= render BetterUi::Drawer::NavItemComponent.new(label: "Messages", href: "/messages") do |item| %>
    #     <% item.with_icon do %><svg>...</svg><% end %>
    #     <% item.with_badge do %>5<% end %>
    #   <% end %>
    #
    # @example With HTTP method for logout
    #   <%= render BetterUi::Drawer::NavItemComponent.new(
    #     label: "Logout",
    #     href: "/logout",
    #     method: :delete
    #   ) %>
    class NavItemComponent < ApplicationComponent
      # Visual variant configurations
      VARIANTS = {
        light: {
          base: "text-grayscale-700",
          active: "bg-primary-50 text-primary-700",
          inactive: "hover:bg-grayscale-100",
          badge_bg: "bg-primary-100",
          badge_text: "text-primary-700"
        },
        dark: {
          base: "text-grayscale-300",
          active: "bg-white/10 text-white",
          inactive: "hover:bg-white/5",
          badge_bg: "bg-white/20",
          badge_text: "text-white"
        },
        primary: {
          base: "text-primary-100",
          active: "bg-white/20 text-white",
          inactive: "hover:bg-white/10",
          badge_bg: "bg-white/20",
          badge_text: "text-white"
        }
      }.freeze

      # Allowed HTTP methods
      METHODS = %i[get post put patch delete].freeze

      # @!method with_icon
      #   Slot for rendering the icon (displayed before label).
      #   @yieldreturn [String] the SVG or icon HTML content
      renders_one :icon

      # @!method with_badge
      #   Slot for rendering a badge/counter (displayed after label).
      #   @yieldreturn [String] the badge content (usually a number)
      renders_one :badge

      # Initializes a new nav item component.
      #
      # @param label [String] the link text (required)
      # @param href [String] the link URL (required)
      # @param active [Boolean] whether the item is currently active (default: false)
      # @param method [Symbol, nil] HTTP method for non-GET requests (:post, :put, :patch, :delete)
      # @param variant [Symbol] color variant (:light, :dark, :primary), default: :light
      # @param container_classes [String, nil] additional CSS classes
      # @param options [Hash] additional HTML attributes passed to the link element
      #
      # @raise [ArgumentError] if variant is not one of the allowed values
      # @raise [ArgumentError] if method is provided and not one of the allowed values
      def initialize(
        label:,
        href:,
        active: false,
        method: nil,
        variant: :light,
        container_classes: nil,
        **options
      )
        @label = label
        @href = href
        @active = active
        @method = validate_method(method)
        @variant = validate_variant(variant)
        @container_classes = container_classes
        @options = options
      end

      # Returns the label text.
      #
      # @return [String] the label
      attr_reader :label

      # Returns the href URL.
      #
      # @return [String] the URL
      attr_reader :href

      # Returns whether the item is active.
      #
      # @return [Boolean] true if active
      def active?
        @active
      end

      private

      # Returns the complete CSS classes for the nav item link.
      #
      # @return [String] the merged CSS class string
      # @api private
      def component_classes
        config = VARIANTS[@variant]
        css_classes([
          "flex",
          "items-center",
          "px-4",
          "py-2",
          "rounded-md",
          "transition-colors",
          config[:base],
          active? ? config[:active] : config[:inactive],
          @container_classes
        ].compact)
      end

      # Returns CSS classes for the icon wrapper.
      #
      # @return [String] CSS classes for icon
      # @api private
      def icon_classes
        css_classes([
          "w-5",
          "h-5",
          "mr-3",
          "shrink-0"
        ])
      end

      # Returns CSS classes for the badge.
      #
      # @return [String] CSS classes for badge
      # @api private
      def badge_classes
        config = VARIANTS[@variant]
        css_classes([
          "ml-auto",
          "text-xs",
          "font-medium",
          "px-2",
          "py-0.5",
          "rounded-full",
          config[:badge_bg],
          config[:badge_text]
        ])
      end

      # Returns HTML attributes for the link element.
      #
      # @return [Hash] HTML attributes hash
      # @api private
      def html_attributes
        attrs = @options.dup
        attrs[:href] = @href
        attrs[:class] = component_classes

        if @method && @method != :get
          attrs[:data] ||= {}
          attrs[:data][:turbo_method] = @method
        end

        attrs
      end

      # Whether a non-GET method is specified.
      #
      # @return [Boolean] true if using non-GET method
      # @api private
      def use_turbo_method?
        @method && @method != :get
      end

      # Validates the variant parameter.
      #
      # @param variant [Symbol] the variant to validate
      # @return [Symbol] the validated variant
      # @raise [ArgumentError] if variant is invalid
      # @api private
      def validate_variant(variant)
        unless VARIANTS.key?(variant)
          raise ArgumentError, "Invalid variant: #{variant}. Must be one of: #{VARIANTS.keys.join(', ')}"
        end
        variant
      end

      # Validates the method parameter.
      #
      # @param method [Symbol, nil] the method to validate
      # @return [Symbol, nil] the validated method
      # @raise [ArgumentError] if method is invalid
      # @api private
      def validate_method(method)
        return nil if method.nil?

        unless METHODS.include?(method)
          raise ArgumentError, "Invalid method: #{method}. Must be one of: #{METHODS.join(', ')}"
        end
        method
      end
    end
  end
end
