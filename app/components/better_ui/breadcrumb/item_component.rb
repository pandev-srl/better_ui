# frozen_string_literal: true

module BetterUi
  module Breadcrumb
    # A breadcrumb item component that renders as a link or current page indicator.
    #
    # When an href is provided, the item renders as a link. When href is nil,
    # it renders as a span with aria-current="page" to indicate the current page.
    #
    # @example Link item
    #   <%= render BetterUi::Breadcrumb::ItemComponent.new(label: "Home", href: "/") %>
    #
    # @example Current page item (no href)
    #   <%= render BetterUi::Breadcrumb::ItemComponent.new(label: "Settings") %>
    #
    # @example With icon
    #   <%= render BetterUi::Breadcrumb::ItemComponent.new(label: "Home", href: "/") do |item| %>
    #     <% item.with_icon_before do %>
    #       <svg>...</svg>
    #     <% end %>
    #   <% end %>
    class ItemComponent < ApplicationComponent
      # @!method with_icon_before
      #   Slot for rendering an icon before the label.
      #   @yieldreturn [String] the SVG or icon HTML content
      renders_one :icon_before

      # Initializes a new breadcrumb item component.
      #
      # @param label [String] the text to display (required)
      # @param href [String, nil] the link URL (nil renders as current page)
      # @param options [Hash] additional HTML attributes passed to the element
      def initialize(label:, href: nil, **options)
        @label = label
        @href = href
        @options = options
      end

      # Whether this item represents the current page.
      #
      # @return [Boolean] true if no href is provided
      def current?
        @href.nil?
      end

      private

      # Returns CSS classes for the current page indicator.
      #
      # @return [String] the merged CSS class string
      # @api private
      def current_classes
        css_classes(
          "text-grayscale-500",
          "font-medium",
          "inline-flex",
          "items-center",
          "gap-1"
        )
      end

      # Returns CSS classes for the link element.
      #
      # @return [String] the merged CSS class string
      # @api private
      def link_classes
        css_classes(
          "text-grayscale-600",
          "hover:text-grayscale-900",
          "inline-flex",
          "items-center",
          "gap-1",
          "transition-colors"
        )
      end
    end
  end
end
