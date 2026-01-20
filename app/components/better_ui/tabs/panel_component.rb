# frozen_string_literal: true

module BetterUi
  module Tabs
    # A tab panel component that contains the content for a single tab.
    #
    # This component renders the panel content with proper ARIA attributes
    # for accessibility. Used in JS mode where all panel content is present
    # in the DOM.
    #
    # @example Basic panel
    #   <%= render BetterUi::Tabs::PanelComponent.new(id: "profile") do %>
    #     <p>Profile content here</p>
    #   <% end %>
    #
    # @example Active panel
    #   <%= render BetterUi::Tabs::PanelComponent.new(id: "profile", active: true) do %>
    #     <p>This panel is initially visible</p>
    #   <% end %>
    class PanelComponent < ApplicationComponent
      # Initializes a new panel component.
      #
      # @param id [String] unique identifier matching the corresponding tab
      # @param active [Boolean] whether this panel is initially visible
      # @param container_id [String] parent container ID for ARIA
      # @param options [Hash] additional HTML attributes
      def initialize(
        id:,
        active: false,
        container_id: nil,
        **options
      )
        @id = id
        @active = active
        @container_id = container_id
        @options = options
      end

      # Returns the panel ID.
      # @return [String] the id
      attr_reader :id

      # Returns whether this panel is active (visible).
      # @return [Boolean] the active state
      attr_reader :active

      # Returns the panel element ID.
      # @return [String] the panel element ID
      def panel_element_id
        "#{@container_id}-panel-#{@id}"
      end

      # Returns the corresponding tab element ID.
      # @return [String] the tab element ID
      def tab_element_id
        "#{@container_id}-tab-#{@id}"
      end

      private

      # Returns the complete CSS classes for the panel.
      # @return [String] the merged CSS class string
      # @api private
      def component_classes
        css_classes([
          "bui-tabs__panel",
          visibility_classes,
          @options[:class]
        ].compact)
      end

      # Returns visibility classes based on active state.
      # @return [String] visibility classes
      # @api private
      def visibility_classes
        @active ? "" : "hidden"
      end

      # Returns HTML attributes for the panel element.
      # @return [Hash] HTML attributes hash
      # @api private
      def html_attributes
        @options.except(:class).merge(
          id: panel_element_id,
          class: component_classes,
          role: "tabpanel",
          "aria-labelledby": tab_element_id,
          tabindex: "0",
          data: data_attributes
        )
      end

      # Returns data attributes for Stimulus.
      # @return [Hash] data attributes hash
      # @api private
      def data_attributes
        attrs = {
          "better-ui--tabs--container-target": "panel",
          "panel-id": @id
        }
        (@options[:data] || {}).merge(attrs)
      end
    end
  end
end
