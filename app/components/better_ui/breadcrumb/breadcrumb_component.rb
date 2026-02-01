# frozen_string_literal: true

module BetterUi
  module Breadcrumb
    # A breadcrumb navigation component that renders an ordered list of items
    # with configurable separators and sizes.
    #
    # This is a compound component that uses ItemComponent for individual breadcrumb items.
    # The last item (without href) is typically rendered as the current page indicator.
    #
    # @example Basic breadcrumb
    #   <%= render BetterUi::Breadcrumb::BreadcrumbComponent.new do |breadcrumb| %>
    #     <% breadcrumb.with_item(label: "Home", href: "/") %>
    #     <% breadcrumb.with_item(label: "Products", href: "/products") %>
    #     <% breadcrumb.with_item(label: "Widget") %>
    #   <% end %>
    #
    # @example With chevron separator and large size
    #   <%= render BetterUi::Breadcrumb::BreadcrumbComponent.new(separator: :chevron, size: :lg) do |breadcrumb| %>
    #     <% breadcrumb.with_item(label: "Home", href: "/") %>
    #     <% breadcrumb.with_item(label: "Settings") %>
    #   <% end %>
    class BreadcrumbComponent < ApplicationComponent
      # @!method with_item
      #   Slot for rendering breadcrumb items.
      #   @param label [String] the item label text
      #   @param href [String, nil] the item link URL
      #   @yieldparam [BetterUi::Breadcrumb::ItemComponent] item the item component instance
      #   @yieldreturn [String] the HTML content for the item
      renders_many :items, BetterUi::Breadcrumb::ItemComponent

      # Allowed separator types
      SEPARATORS = %i[slash chevron dot].freeze

      # Allowed size options
      SIZES = %i[sm md lg].freeze

      # Initializes a new breadcrumb component.
      #
      # @param separator [Symbol] the separator type (:slash, :chevron, :dot), defaults to :slash
      # @param size [Symbol] the text size (:sm, :md, :lg), defaults to :md
      # @param container_classes [String, nil] additional CSS classes for the nav element
      # @param options [Hash] additional HTML attributes passed to the nav element
      #
      # @raise [ArgumentError] if separator is not one of the allowed values
      # @raise [ArgumentError] if size is not one of the allowed values
      def initialize(
        separator: :slash,
        size: :md,
        container_classes: nil,
        **options
      )
        @separator = validate_separator(separator)
        @size = validate_size(size)
        @container_classes = container_classes
        @options = options
      end

      private

      # Returns the complete CSS classes for the ordered list element.
      #
      # @return [String] the merged CSS class string
      # @api private
      def component_classes
        css_classes(
          "flex",
          "items-center",
          "flex-wrap",
          "gap-1",
          size_classes
        )
      end

      # Returns CSS classes for separator elements.
      #
      # @return [String] the merged CSS class string
      # @api private
      def separator_classes
        css_classes(
          "mx-2",
          "text-grayscale-400"
        )
      end

      # Returns the separator content (character or SVG) based on the separator type.
      #
      # @return [String] the separator HTML content
      # @api private
      def separator_content
        case @separator
        when :slash
          "/"
        when :chevron
          chevron_svg
        when :dot
          "\u00B7"
        end
      end

      # Returns the size-specific CSS class.
      #
      # @return [String] the Tailwind text size class
      # @api private
      def size_classes
        case @size
        when :sm then "text-sm"
        when :md then "text-base"
        when :lg then "text-lg"
        end
      end

      # Returns an SVG chevron-right icon for the chevron separator.
      #
      # @return [String] the SVG HTML markup
      # @api private
      def chevron_svg
        '<svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4" viewBox="0 0 20 20" fill="currentColor"><path fill-rule="evenodd" d="M7.293 14.707a1 1 0 010-1.414L10.586 10 7.293 6.707a1 1 0 011.414-1.414l4 4a1 1 0 010 1.414l-4 4a1 1 0 01-1.414 0z" clip-rule="evenodd" /></svg>'.html_safe
      end

      # Validates the separator parameter.
      #
      # @param separator [Symbol] the separator to validate
      # @return [Symbol] the validated separator
      # @raise [ArgumentError] if separator is invalid
      # @api private
      def validate_separator(separator)
        unless SEPARATORS.include?(separator)
          raise ArgumentError, "Invalid separator: #{separator}. Must be one of: #{SEPARATORS.join(', ')}"
        end
        separator
      end

      # Validates the size parameter.
      #
      # @param size [Symbol] the size to validate
      # @return [Symbol] the validated size
      # @raise [ArgumentError] if size is invalid
      # @api private
      def validate_size(size)
        unless SIZES.include?(size)
          raise ArgumentError, "Invalid size: #{size}. Must be one of: #{SIZES.join(', ')}"
        end
        size
      end
    end
  end
end
