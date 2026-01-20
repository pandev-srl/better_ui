# frozen_string_literal: true

module BetterUi
  module Tabs
    # A single tab component rendered as a button (JS mode) or link (Turbo mode).
    #
    # This component renders the clickable tab element with proper ARIA attributes
    # and styling based on the parent container's configuration.
    #
    # @example Basic tab
    #   <%= render BetterUi::Tabs::TabComponent.new(id: "profile", label: "Profile") %>
    #
    # @example Tab with icon and badge
    #   <%= render BetterUi::Tabs::TabComponent.new(id: "messages", label: "Messages") do |tab| %>
    #     <% tab.with_icon { icon_svg } %>
    #     <% tab.with_badge { "3" } %>
    #   <% end %>
    class TabComponent < ApplicationComponent
      # @!method with_icon
      #   Slot for rendering an icon before the label
      #   @yieldreturn [String] the HTML content for the icon
      renders_one :icon

      # @!method with_badge
      #   Slot for rendering a badge after the label
      #   @yieldreturn [String] the HTML content for the badge
      renders_one :badge

      # Initializes a new tab component.
      #
      # @param id [String] unique identifier for this tab
      # @param label [String] display text for the tab
      # @param href [String, nil] URL for Turbo mode navigation
      # @param active [Boolean] whether this tab is initially active
      # @param disabled [Boolean] whether this tab is disabled
      # @param mode [Symbol] operating mode passed from container (:js, :turbo)
      # @param style [Symbol] visual style passed from container
      # @param variant [Symbol] color variant passed from container
      # @param size [Symbol] size passed from container
      # @param frame_id [String, nil] Turbo Frame ID passed from container
      # @param container_id [String] parent container ID for ARIA
      # @param options [Hash] additional HTML attributes
      def initialize(
        id:,
        label:,
        href: nil,
        active: false,
        disabled: false,
        mode: :js,
        style: :underline,
        variant: :primary,
        size: :md,
        frame_id: nil,
        container_id: nil,
        **options
      )
        @id = id
        @label = label
        @href = href
        @active = active
        @disabled = disabled
        @mode = mode
        @style = style
        @variant = variant
        @size = size
        @frame_id = frame_id
        @container_id = container_id
        @options = options
      end

      # Returns the tab ID.
      # @return [String] the id
      attr_reader :id

      # Returns the tab label.
      # @return [String] the label
      attr_reader :label

      # Returns whether this tab is active.
      # @return [Boolean] the active state
      attr_reader :active

      # Returns whether this tab is disabled.
      # @return [Boolean] the disabled state
      attr_reader :disabled

      # Returns the associated panel ID.
      # @return [String] the panel element ID
      def panel_id
        "#{@container_id}-panel-#{@id}"
      end

      # Returns the tab element ID.
      # @return [String] the tab element ID
      def tab_element_id
        "#{@container_id}-tab-#{@id}"
      end

      private

      # Returns the complete CSS classes for the tab.
      # @return [String] the merged CSS class string
      # @api private
      def component_classes
        css_classes([
          "bui-tabs__tab",
          base_classes,
          size_classes,
          style_classes,
          state_classes,
          @options[:class]
        ].compact)
      end

      # Returns base classes for all tabs.
      # @return [String] base classes
      # @api private
      def base_classes
        "inline-flex items-center gap-2 font-medium transition-colors duration-200 focus:outline-none focus-visible:ring-2 focus-visible:ring-offset-2"
      end

      # Returns size-specific classes.
      # @return [String] size classes
      # @api private
      def size_classes
        case @size
        when :xs then "px-2 py-1 text-xs"
        when :sm then "px-3 py-1.5 text-sm"
        when :md then "px-4 py-2 text-sm"
        when :lg then "px-5 py-2.5 text-base"
        when :xl then "px-6 py-3 text-lg"
        end
      end

      # Returns style-specific classes.
      # @return [String] style classes
      # @api private
      def style_classes
        case @style
        when :underline then underline_style_classes
        when :pills then pills_style_classes
        when :bordered then bordered_style_classes
        end
      end

      # Returns underline style classes.
      # @return [String] style classes
      # @api private
      def underline_style_classes
        if @active
          active_underline_classes
        else
          "border-b-2 border-transparent text-grayscale-600 hover:text-grayscale-900 hover:border-grayscale-300"
        end
      end

      # Returns active underline classes based on variant.
      # @return [String] style classes
      # @api private
      def active_underline_classes
        base = "border-b-2"
        case @variant
        when :primary then "#{base} border-primary-600 text-primary-600"
        when :secondary then "#{base} border-secondary-600 text-secondary-600"
        when :accent then "#{base} border-accent-600 text-accent-600"
        when :success then "#{base} border-success-600 text-success-600"
        when :danger then "#{base} border-danger-600 text-danger-600"
        when :warning then "#{base} border-warning-600 text-warning-600"
        when :info then "#{base} border-info-600 text-info-600"
        when :light then "#{base} border-grayscale-400 text-grayscale-700"
        when :dark then "#{base} border-grayscale-900 text-grayscale-900"
        end
      end

      # Returns pills style classes.
      # @return [String] style classes
      # @api private
      def pills_style_classes
        if @active
          active_pills_classes
        else
          "rounded-lg text-grayscale-600 hover:text-grayscale-900 hover:bg-grayscale-100"
        end
      end

      # Returns active pills classes based on variant.
      # @return [String] style classes
      # @api private
      def active_pills_classes
        base = "rounded-lg"
        case @variant
        when :primary then "#{base} bg-primary-600 text-white"
        when :secondary then "#{base} bg-secondary-600 text-white"
        when :accent then "#{base} bg-accent-600 text-white"
        when :success then "#{base} bg-success-600 text-white"
        when :danger then "#{base} bg-danger-600 text-white"
        when :warning then "#{base} bg-warning-500 text-white"
        when :info then "#{base} bg-info-600 text-white"
        when :light then "#{base} bg-grayscale-200 text-grayscale-800"
        when :dark then "#{base} bg-grayscale-800 text-white"
        end
      end

      # Returns bordered style classes.
      # @return [String] style classes
      # @api private
      def bordered_style_classes
        if @active
          active_bordered_classes
        else
          "border border-transparent text-grayscale-600 hover:text-grayscale-900 rounded-t-lg -mb-px"
        end
      end

      # Returns active bordered classes based on variant.
      # @return [String] style classes
      # @api private
      def active_bordered_classes
        base = "border border-grayscale-200 rounded-t-lg -mb-px bg-white"
        border_bottom = "border-b-white"
        case @variant
        when :primary then "#{base} #{border_bottom} text-primary-600"
        when :secondary then "#{base} #{border_bottom} text-secondary-600"
        when :accent then "#{base} #{border_bottom} text-accent-600"
        when :success then "#{base} #{border_bottom} text-success-600"
        when :danger then "#{base} #{border_bottom} text-danger-600"
        when :warning then "#{base} #{border_bottom} text-warning-600"
        when :info then "#{base} #{border_bottom} text-info-600"
        when :light then "#{base} #{border_bottom} text-grayscale-700"
        when :dark then "#{base} #{border_bottom} text-grayscale-900"
        end
      end

      # Returns state classes for disabled or focus.
      # @return [String] state classes
      # @api private
      def state_classes
        if @disabled
          "opacity-50 cursor-not-allowed"
        else
          "cursor-pointer"
        end
      end

      # Returns the element tag (button for JS mode, anchor for Turbo mode).
      # @return [Symbol] the tag name
      # @api private
      def element_tag
        @mode == :turbo ? :a : :button
      end

      # Returns HTML attributes for the tab element.
      # @return [Hash] HTML attributes hash
      # @api private
      def html_attributes
        attrs = @options.except(:class).merge(
          id: tab_element_id,
          class: component_classes,
          role: "tab",
          "aria-selected": @active.to_s,
          "aria-controls": panel_id,
          tabindex: @active ? "0" : "-1",
          data: data_attributes
        )

        if @mode == :turbo
          attrs[:href] = @href
          attrs["data-turbo-frame"] = @frame_id if @frame_id
        else
          attrs[:type] = "button"
        end

        attrs[:disabled] = true if @disabled && @mode == :js
        attrs["aria-disabled"] = "true" if @disabled

        attrs
      end

      # Returns data attributes for Stimulus.
      # @return [Hash] data attributes hash
      # @api private
      def data_attributes
        attrs = {
          "better-ui--tabs--container-target": "tab",
          "tab-id": @id,
          "active-classes": active_style_classes_for_data,
          "inactive-classes": inactive_style_classes_for_data,
          action: "click->better-ui--tabs--container#selectTab keydown->better-ui--tabs--container#handleKeydown"
        }
        (@options[:data] || {}).merge(attrs)
      end

      # Returns active style classes for storing in data attribute.
      # @return [String] active classes
      # @api private
      def active_style_classes_for_data
        case @style
        when :underline then active_underline_classes
        when :pills then active_pills_classes
        when :bordered then active_bordered_classes
        end
      end

      # Returns inactive style classes for storing in data attribute.
      # @return [String] inactive classes
      # @api private
      def inactive_style_classes_for_data
        case @style
        when :underline then "border-b-2 border-transparent text-grayscale-600 hover:text-grayscale-900 hover:border-grayscale-300"
        when :pills then "rounded-lg text-grayscale-600 hover:text-grayscale-900 hover:bg-grayscale-100"
        when :bordered then "border border-transparent text-grayscale-600 hover:text-grayscale-900 rounded-t-lg -mb-px"
        end
      end
    end
  end
end
