# frozen_string_literal: true

module BetterUi
  module Drawer
    # A flexible sidebar component for drawer layouts with support for header, navigation, and footer.
    #
    # This component provides a responsive sidebar that can slide in from left or right on mobile,
    # with configurable width and visual variants. It supports slots for header (logo/brand),
    # main navigation, and footer sections.
    #
    # @example Basic sidebar
    #   <%= render BetterUi::Drawer::SidebarComponent.new do |sidebar| %>
    #     <% sidebar.with_navigation do %>
    #       <nav>Navigation links</nav>
    #     <% end %>
    #   <% end %>
    #
    # @example Sidebar with all sections
    #   <%= render BetterUi::Drawer::SidebarComponent.new(position: :left, width: :md) do |sidebar| %>
    #     <% sidebar.with_header { image_tag("logo.svg") } %>
    #     <% sidebar.with_navigation do %>
    #       <nav>Main navigation</nav>
    #     <% end %>
    #     <% sidebar.with_footer { "User info" } %>
    #   <% end %>
    class SidebarComponent < ApplicationComponent
      # Width configurations
      WIDTHS = {
        sm: "w-16",    # 64px - icon-only sidebar
        md: "w-64",    # 256px - standard sidebar
        lg: "w-80"     # 320px - wide sidebar
      }.freeze

      # Position configurations
      POSITIONS = %i[left right].freeze

      # Visual variant configurations
      SIDEBAR_VARIANTS = {
        light: {
          bg: "bg-white",
          border: "border-grayscale-200",
          text: "text-grayscale-900"
        },
        dark: {
          bg: "bg-grayscale-900",
          border: "border-grayscale-700",
          text: "text-white"
        },
        primary: {
          bg: "bg-primary-800",
          border: "border-primary-900",
          text: "text-white"
        }
      }.freeze

      # @!method with_header
      #   Slot for rendering the sidebar header section (logo, brand).
      #   @yieldreturn [String] the HTML content for the header
      renders_one :header

      # @!method with_navigation
      #   Slot for rendering the main navigation content.
      #   @yieldreturn [String] the HTML content for navigation
      renders_one :navigation

      # @!method with_footer
      #   Slot for rendering the sidebar footer section (user info, settings).
      #   @yieldreturn [String] the HTML content for the footer
      renders_one :footer

      # Initializes a new sidebar component.
      #
      # @param variant [Symbol] the visual variant (:light, :dark, :primary), defaults to :light
      # @param position [Symbol] the sidebar position (:left, :right), defaults to :left
      # @param width [Symbol] the width variant (:sm, :md, :lg), defaults to :md
      # @param collapsible [Boolean] whether sidebar can be collapsed (icon-only mode), defaults to true
      # @param container_classes [String, nil] additional CSS classes for the container
      # @param header_classes [String, nil] additional CSS classes for the header section
      # @param navigation_classes [String, nil] additional CSS classes for the navigation section
      # @param footer_classes [String, nil] additional CSS classes for the footer section
      # @param options [Hash] additional HTML attributes passed to the sidebar element
      #
      # @raise [ArgumentError] if variant is not one of the allowed values
      # @raise [ArgumentError] if position is not one of the allowed values
      # @raise [ArgumentError] if width is not one of the allowed values
      def initialize(
        variant: :light,
        position: :left,
        width: :md,
        collapsible: true,
        container_classes: nil,
        header_classes: nil,
        navigation_classes: nil,
        footer_classes: nil,
        **options
      )
        @variant = validate_variant(variant)
        @position = validate_position(position)
        @width = validate_width(width)
        @collapsible = collapsible
        @container_classes = container_classes
        @header_classes = header_classes
        @navigation_classes = navigation_classes
        @footer_classes = footer_classes
        @options = options
      end

      # Returns the sidebar position.
      #
      # @return [Symbol] the position (:left or :right)
      attr_reader :position

      private

      # Returns the complete CSS classes for the sidebar container.
      #
      # @return [String] the merged CSS class string
      # @api private
      def component_classes
        css_classes([
          "flex",
          "flex-col",
          "h-full",
          width_class,
          variant_classes,
          border_classes,
          "shrink-0",
          @container_classes
        ].flatten.compact)
      end

      # Returns CSS class for the width.
      #
      # @return [String] the width class
      # @api private
      def width_class
        WIDTHS[@width]
      end

      # Returns CSS classes for the variant.
      #
      # @return [Array<String>] array of CSS classes for the variant
      # @api private
      def variant_classes
        config = SIDEBAR_VARIANTS[@variant]
        [ config[:bg], config[:text] ]
      end

      # Returns CSS classes for the border based on position.
      #
      # @return [String] the border class
      # @api private
      def border_classes
        border_color = SIDEBAR_VARIANTS[@variant][:border]
        case @position
        when :left
          "border-r #{border_color}"
        when :right
          "border-l #{border_color}"
        end
      end

      # Returns CSS classes for the header section.
      #
      # @return [String] CSS classes for header wrapper
      # @api private
      def header_wrapper_classes
        css_classes([
          "shrink-0",
          "p-4",
          "border-b",
          SIDEBAR_VARIANTS[@variant][:border],
          @header_classes
        ].compact)
      end

      # Returns CSS classes for the navigation section.
      #
      # @return [String] CSS classes for navigation wrapper
      # @api private
      def navigation_wrapper_classes
        css_classes([
          "flex-1",
          "overflow-y-auto",
          "p-4",
          @navigation_classes
        ].compact)
      end

      # Returns CSS classes for the footer section.
      #
      # @return [String] CSS classes for footer wrapper
      # @api private
      def footer_wrapper_classes
        css_classes([
          "shrink-0",
          "p-4",
          "border-t",
          SIDEBAR_VARIANTS[@variant][:border],
          @footer_classes
        ].compact)
      end

      # Returns HTML attributes for the sidebar element.
      #
      # @return [Hash] HTML attributes hash
      # @api private
      def html_attributes
        @options.merge(data: data_attributes)
      end

      # Returns data attributes for the sidebar.
      #
      # @return [Hash] data attributes hash
      # @api private
      def data_attributes
        attrs = {}
        attrs[:position] = @position
        attrs[:collapsible] = @collapsible
        (@options[:data] || {}).merge(attrs)
      end

      # Validates the variant parameter.
      #
      # @param variant [Symbol] the variant to validate
      # @return [Symbol] the validated variant
      # @raise [ArgumentError] if variant is invalid
      # @api private
      def validate_variant(variant)
        unless SIDEBAR_VARIANTS.key?(variant)
          raise ArgumentError, "Invalid variant: #{variant}. Must be one of: #{SIDEBAR_VARIANTS.keys.join(', ')}"
        end
        variant
      end

      # Validates the position parameter.
      #
      # @param position [Symbol] the position to validate
      # @return [Symbol] the validated position
      # @raise [ArgumentError] if position is invalid
      # @api private
      def validate_position(position)
        unless POSITIONS.include?(position)
          raise ArgumentError, "Invalid position: #{position}. Must be one of: #{POSITIONS.join(', ')}"
        end
        position
      end

      # Validates the width parameter.
      #
      # @param width [Symbol] the width to validate
      # @return [Symbol] the validated width
      # @raise [ArgumentError] if width is invalid
      # @api private
      def validate_width(width)
        unless WIDTHS.key?(width)
          raise ArgumentError, "Invalid width: #{width}. Must be one of: #{WIDTHS.keys.join(', ')}"
        end
        width
      end
    end
  end
end
