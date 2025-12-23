# frozen_string_literal: true

module BetterUi
  module Drawer
    # A responsive layout component that composes header and sidebar with mobile drawer support.
    #
    # This component provides a complete page layout with a sticky header, responsive sidebar,
    # and main content area. On mobile, the sidebar becomes a slide-out drawer that can be
    # toggled via a menu button.
    #
    # @example Basic layout
    #   <%= render BetterUi::Drawer::LayoutComponent.new do |layout| %>
    #     <% layout.with_header(sticky: true) do |header| %>
    #       <% header.with_logo { "Logo" } %>
    #       <% header.with_mobile_menu_button { "☰" } %>
    #     <% end %>
    #     <% layout.with_sidebar do |sidebar| %>
    #       <% sidebar.with_navigation { render "nav" } %>
    #     <% end %>
    #     <% layout.with_main do %>
    #       Main content here
    #     <% end %>
    #   <% end %>
    #
    # @example Right-positioned sidebar
    #   <%= render BetterUi::Drawer::LayoutComponent.new(sidebar_position: :right) do |layout| %>
    #     <% layout.with_sidebar(position: :right) do |sidebar| %>
    #       <% sidebar.with_navigation { "Nav" } %>
    #     <% end %>
    #     <% layout.with_main { "Content" } %>
    #   <% end %>
    class LayoutComponent < ApplicationComponent
      # Breakpoint configurations for desktop mode
      BREAKPOINTS = {
        md: "md:flex",
        lg: "lg:flex",
        xl: "xl:flex"
      }.freeze

      # Position configurations
      POSITIONS = %i[left right].freeze

      # @!method with_header
      #   Slot for rendering the HeaderComponent.
      #   @yieldparam [BetterUi::Drawer::HeaderComponent] header the header component instance
      #   @yieldreturn [String] the HTML content for the header
      renders_one :header, HeaderComponent

      # @!method with_sidebar
      #   Slot for rendering the SidebarComponent.
      #   @yieldparam [BetterUi::Drawer::SidebarComponent] sidebar the sidebar component instance
      #   @yieldreturn [String] the HTML content for the sidebar
      renders_one :sidebar, SidebarComponent

      # @!method with_main
      #   Slot for rendering the main content area.
      #   @yieldreturn [String] the HTML content for the main area
      renders_one :main

      # Initializes a new layout component.
      #
      # @param sidebar_position [Symbol] the sidebar position (:left, :right), defaults to :left
      # @param sidebar_breakpoint [Symbol] the breakpoint for desktop sidebar (:md, :lg, :xl), defaults to :lg
      # @param container_classes [String, nil] additional CSS classes for the outer container
      # @param main_classes [String, nil] additional CSS classes for the main content area
      # @param options [Hash] additional HTML attributes passed to the layout element
      #
      # @raise [ArgumentError] if sidebar_position is not one of the allowed values
      # @raise [ArgumentError] if sidebar_breakpoint is not one of the allowed values
      def initialize(
        sidebar_position: :left,
        sidebar_breakpoint: :lg,
        container_classes: nil,
        main_classes: nil,
        **options
      )
        @sidebar_position = validate_position(sidebar_position)
        @sidebar_breakpoint = validate_breakpoint(sidebar_breakpoint)
        @container_classes = container_classes
        @main_classes = main_classes
        @options = options
      end

      # Returns the sidebar position.
      #
      # @return [Symbol] the position (:left or :right)
      attr_reader :sidebar_position

      # Returns the sidebar breakpoint.
      #
      # @return [Symbol] the breakpoint (:md, :lg, or :xl)
      attr_reader :sidebar_breakpoint

      private

      # Returns the complete CSS classes for the outer layout container.
      #
      # @return [String] the merged CSS class string
      # @api private
      def component_classes
        css_classes([
          "h-screen",
          "overflow-hidden",
          "flex",
          "flex-col",
          @container_classes
        ].compact)
      end

      # Returns CSS classes for the body wrapper (contains sidebar + main).
      #
      # @return [String] the merged CSS class string
      # @api private
      def body_wrapper_classes
        css_classes([
          "flex",
          "flex-1",
          "overflow-hidden",
          "relative"
        ])
      end

      # Returns CSS classes for the sidebar wrapper (desktop visibility).
      #
      # @return [String] the merged CSS class string
      # @api private
      def sidebar_wrapper_classes
        css_classes([
          "hidden", # Hidden on mobile by default
          "h-full", # Full height to pass to sidebar
          BREAKPOINTS[@sidebar_breakpoint] # Show on desktop breakpoint
        ])
      end

      # Returns CSS classes for the mobile sidebar wrapper (overlay drawer).
      #
      # @return [String] the merged CSS class string
      # @api private
      def mobile_sidebar_wrapper_classes
        css_classes([
          "fixed",
          "inset-y-0",
          mobile_position_class,
          "z-50",
          "transform",
          "transition-transform",
          "duration-300",
          "ease-in-out",
          initial_transform_class,
          desktop_hidden_class
        ])
      end

      # Returns the position class for mobile sidebar.
      #
      # @return [String] the position class
      # @api private
      def mobile_position_class
        @sidebar_position == :right ? "right-0" : "left-0"
      end

      # Returns the initial transform class for hidden state.
      #
      # @return [String] the transform class
      # @api private
      def initial_transform_class
        @sidebar_position == :right ? "translate-x-full" : "-translate-x-full"
      end

      # Returns CSS class to hide on desktop.
      #
      # @return [String] the hidden class for desktop
      # @api private
      def desktop_hidden_class
        case @sidebar_breakpoint
        when :md then "md:hidden"
        when :lg then "lg:hidden"
        when :xl then "xl:hidden"
        end
      end

      # Returns CSS classes for the overlay.
      #
      # @return [String] the merged CSS class string
      # @api private
      def overlay_classes
        css_classes([
          "fixed",
          "inset-0",
          "bg-black/50",
          "z-40",
          "hidden", # Initially hidden
          "opacity-0",
          "transition-opacity",
          "duration-300",
          desktop_hidden_class
        ])
      end

      # Returns CSS classes for the main content area.
      #
      # @return [String] the merged CSS class string
      # @api private
      def main_wrapper_classes
        css_classes([
          "flex-1",
          "overflow-auto",
          @main_classes
        ].compact)
      end

      # Returns the Stimulus controller identifier.
      #
      # @return [String] the controller name
      # @api private
      def controller_name
        "better-ui--drawer--layout"
      end

      # Returns HTML attributes for the layout element.
      #
      # @return [Hash] HTML attributes hash
      # @api private
      def html_attributes
        @options.merge(
          data: data_attributes
        )
      end

      # Returns data attributes for Stimulus controller.
      #
      # @return [Hash] data attributes hash
      # @api private
      def data_attributes
        attrs = {
          controller: controller_name,
          "#{controller_name}-position-value": @sidebar_position,
          "#{controller_name}-breakpoint-value": @sidebar_breakpoint
        }
        (@options[:data] || {}).merge(attrs)
      end

      # Validates the sidebar_position parameter.
      #
      # @param position [Symbol] the position to validate
      # @return [Symbol] the validated position
      # @raise [ArgumentError] if position is invalid
      # @api private
      def validate_position(position)
        unless POSITIONS.include?(position)
          raise ArgumentError, "Invalid sidebar_position: #{position}. Must be one of: #{POSITIONS.join(', ')}"
        end
        position
      end

      # Validates the sidebar_breakpoint parameter.
      #
      # @param breakpoint [Symbol] the breakpoint to validate
      # @return [Symbol] the validated breakpoint
      # @raise [ArgumentError] if breakpoint is invalid
      # @api private
      def validate_breakpoint(breakpoint)
        unless BREAKPOINTS.key?(breakpoint)
          raise ArgumentError, "Invalid sidebar_breakpoint: #{breakpoint}. Must be one of: #{BREAKPOINTS.keys.join(', ')}"
        end
        breakpoint
      end
    end
  end
end
