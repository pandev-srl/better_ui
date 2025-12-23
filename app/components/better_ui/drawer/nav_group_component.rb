# frozen_string_literal: true

module BetterUi
  module Drawer
    # A navigation group component for sidebar menus with a title and collection of items.
    #
    # @example Basic usage
    #   <%= render BetterUi::Drawer::NavGroupComponent.new(title: "Main") do |group| %>
    #     <% group.with_item(label: "Dashboard", href: "/dashboard", active: true) do |item| %>
    #       <% item.with_icon do %><svg>...</svg><% end %>
    #     <% end %>
    #     <% group.with_item(label: "Settings", href: "/settings") do |item| %>
    #       <% item.with_icon do %><svg>...</svg><% end %>
    #     <% end %>
    #   <% end %>
    #
    # @example Without title
    #   <%= render BetterUi::Drawer::NavGroupComponent.new do |group| %>
    #     <% group.with_item(label: "Home", href: "/") %>
    #   <% end %>
    #
    # @example With variant for dark sidebar
    #   <%= render BetterUi::Drawer::NavGroupComponent.new(title: "Menu", variant: :dark) do |group| %>
    #     <% group.with_item(label: "Dashboard", href: "/") %>
    #   <% end %>
    class NavGroupComponent < ApplicationComponent
      # Visual variant configurations for title
      VARIANTS = {
        light: {
          title: "text-grayscale-500"
        },
        dark: {
          title: "text-grayscale-400"
        },
        primary: {
          title: "text-primary-200"
        }
      }.freeze

      # @!method with_item
      #   Slot for rendering navigation items.
      #   All parameters are passed to NavItemComponent.
      #   @param label [String] the item label text
      #   @param href [String] the link URL
      #   @param active [Boolean] whether the item is currently active
      #   @param method [Symbol, nil] HTTP method for non-GET requests
      #   @yieldparam [NavItemComponent] item the nav item component instance
      renders_many :items, ->(label:, href:, active: false, method: nil, container_classes: nil, **options, &block) {
        NavItemComponent.new(
          label: label,
          href: href,
          active: active,
          method: method,
          variant: @variant,
          container_classes: container_classes,
          **options,
          &block
        )
      }

      # Initializes a new nav group component.
      #
      # @param title [String, nil] the group title (optional)
      # @param variant [Symbol] color variant (:light, :dark, :primary), default: :light
      # @param container_classes [String, nil] additional CSS classes
      # @param options [Hash] additional HTML attributes
      #
      # @raise [ArgumentError] if variant is not one of the allowed values
      def initialize(
        title: nil,
        variant: :light,
        container_classes: nil,
        **options
      )
        @title = title
        @variant = validate_variant(variant)
        @container_classes = container_classes
        @options = options
      end

      # Returns the title text.
      #
      # @return [String, nil] the title
      attr_reader :title

      private

      # Returns CSS classes for the group container.
      #
      # @return [String] the merged CSS class string
      # @api private
      def component_classes
        css_classes([
          @container_classes
        ].compact)
      end

      # Returns CSS classes for the title.
      #
      # @return [String] CSS classes for the title
      # @api private
      def title_classes
        config = VARIANTS[@variant]
        css_classes([
          "px-4",
          "text-xs",
          "font-semibold",
          "uppercase",
          "tracking-wider",
          config[:title]
        ])
      end

      # Returns CSS classes for the items container.
      #
      # @return [String] CSS classes for items wrapper
      # @api private
      def items_wrapper_classes
        css_classes([
          @title ? "mt-2" : nil,
          "space-y-1"
        ].compact)
      end

      # Returns HTML attributes for the group element.
      #
      # @return [Hash] HTML attributes hash
      # @api private
      def html_attributes
        @options
      end

      # Whether to render the title.
      #
      # @return [Boolean] true if title should be rendered
      # @api private
      def render_title?
        @title.present?
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
    end
  end
end
