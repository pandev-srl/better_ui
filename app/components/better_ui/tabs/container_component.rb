# frozen_string_literal: true

module BetterUi
  module Tabs
    # A flexible tabs container component with two operating modes.
    #
    # This component provides a tabbed interface with support for:
    # - **JS mode**: Client-side tab switching (all content in DOM)
    # - **Turbo mode**: Server-rendered content via Turbo Frames
    #
    # @example Basic JS mode tabs
    #   <%= render BetterUi::Tabs::ContainerComponent.new(mode: :js) do |tabs| %>
    #     <% tabs.with_tab(id: "profile", label: "Profile", active: true) %>
    #     <% tabs.with_tab(id: "settings", label: "Settings") %>
    #     <% tabs.with_panel(id: "profile", active: true) { "Profile content" } %>
    #     <% tabs.with_panel(id: "settings") { "Settings content" } %>
    #   <% end %>
    #
    # @example Turbo mode with Turbo Frames
    #   <%= render BetterUi::Tabs::ContainerComponent.new(mode: :turbo, frame_id: "tab-content") do |tabs| %>
    #     <% tabs.with_tab(id: "profile", label: "Profile", href: profile_path, active: true) %>
    #     <% tabs.with_tab(id: "settings", label: "Settings", href: settings_path) %>
    #   <% end %>
    #   <turbo-frame id="tab-content"><%= yield %></turbo-frame>
    class ContainerComponent < ApplicationComponent
      # Valid operating modes
      MODES = %i[js turbo].freeze

      # Tab visual styles
      STYLES = %i[underline pills bordered].freeze

      # Size configurations with tab-specific styling
      SIZES = %i[xs sm md lg xl].freeze

      # Tab alignment options
      ALIGNMENTS = %i[start center end stretch].freeze

      # Tab list positions
      POSITIONS = %i[top bottom left right].freeze

      # @!method with_tab
      #   Slot for rendering tab buttons/links
      #   @yieldparam [BetterUi::Tabs::TabComponent] tab the tab component instance
      #   @yieldreturn [String] the HTML content for the tab
      renders_many :tabs, lambda { |**args|
        TabComponent.new(
          **args,
          mode: @mode,
          style: @style,
          variant: @variant,
          size: @size,
          frame_id: @frame_id,
          container_id: container_id
        )
      }

      # @!method with_panel
      #   Slot for rendering tab panels (JS mode only)
      #   @yieldparam [BetterUi::Tabs::PanelComponent] panel the panel component instance
      #   @yieldreturn [String] the HTML content for the panel
      renders_many :panels, lambda { |**args|
        PanelComponent.new(**args, container_id: container_id)
      }

      # @!method with_loader
      #   Slot for rendering a custom loader (Turbo mode only)
      #   @yieldreturn [String] the HTML content for the custom loader
      renders_one :loader

      # Initializes a new tabs container component.
      #
      # @param mode [Symbol] operating mode (:js, :turbo), defaults to :js
      # @param style [Symbol] visual style (:underline, :pills, :bordered), defaults to :underline
      # @param variant [Symbol] color variant from VARIANTS, defaults to :primary
      # @param size [Symbol] size (:xs, :sm, :md, :lg, :xl), defaults to :md
      # @param alignment [Symbol] tab alignment (:start, :center, :end, :stretch), defaults to :start
      # @param position [Symbol] tab list position (:top, :bottom, :left, :right), defaults to :top
      # @param frame_id [String, nil] Turbo Frame ID (required for turbo mode)
      # @param default_tab [String, nil] ID of the default active tab
      # @param persist [Boolean] persist active tab in URL hash or localStorage
      # @param persist_key [String, nil] localStorage key for persistence
      # @param show_loading [Boolean, nil] show loading indicator in turbo mode (default: true for turbo)
      # @param loader_delay [Integer] delay in milliseconds before showing the loader (default: 1000)
      # @param id [String, nil] explicit ID for the container (auto-generated if nil)
      # @param options [Hash] additional HTML attributes
      #
      # @raise [ArgumentError] if mode is invalid
      # @raise [ArgumentError] if style is invalid
      # @raise [ArgumentError] if size is invalid
      # @raise [ArgumentError] if alignment is invalid
      # @raise [ArgumentError] if position is invalid
      # @raise [ArgumentError] if turbo mode is used without frame_id
      def initialize(
        mode: :js,
        style: :underline,
        variant: :primary,
        size: :md,
        alignment: :start,
        position: :top,
        frame_id: nil,
        default_tab: nil,
        persist: false,
        persist_key: nil,
        show_loading: nil,
        loader_delay: 1000,
        id: nil,
        **options
      )
        @mode = validate_mode(mode)
        @style = validate_style(style)
        @variant = validate_variant(variant)
        @size = validate_size(size)
        @alignment = validate_alignment(alignment)
        @position = validate_position(position)
        @frame_id = frame_id
        @default_tab = default_tab
        @persist = persist
        @persist_key = persist_key
        @show_loading = show_loading.nil? ? (@mode == :turbo) : show_loading
        @loader_delay = loader_delay
        @explicit_id = id
        @options = options

        validate_turbo_requirements!
      end

      # Returns the operating mode.
      # @return [Symbol] the mode (:js or :turbo)
      attr_reader :mode

      # Returns the visual style.
      # @return [Symbol] the style (:underline, :pills, or :bordered)
      attr_reader :style

      # Returns the color variant.
      # @return [Symbol] the variant
      attr_reader :variant

      # Returns the size.
      # @return [Symbol] the size
      attr_reader :size

      # Returns the tab alignment.
      # @return [Symbol] the alignment
      attr_reader :alignment

      # Returns the tab list position.
      # @return [Symbol] the position
      attr_reader :position

      # Returns the Turbo Frame ID.
      # @return [String, nil] the frame_id
      attr_reader :frame_id

      # Returns the default active tab ID.
      # @return [String, nil] the default_tab
      attr_reader :default_tab

      # Returns whether persistence is enabled.
      # @return [Boolean] the persist flag
      attr_reader :persist

      # Returns the persistence key for localStorage.
      # @return [String, nil] the persist_key
      attr_reader :persist_key

      # Returns whether loading indicator is shown in turbo mode.
      # @return [Boolean] the show_loading flag
      attr_reader :show_loading

      # Returns the loader delay in milliseconds.
      # @return [Integer] the loader_delay value
      attr_reader :loader_delay

      # Generates a unique container ID.
      # @return [String] the container ID
      def container_id
        @container_id ||= @explicit_id || "tabs-#{SecureRandom.hex(4)}"
      end

      private

      # Returns the complete CSS classes for the container.
      # @return [String] the merged CSS class string
      # @api private
      def component_classes
        css_classes([
          "bui-tabs",
          position_layout_class,
          @options[:class]
        ].compact)
      end

      # Returns layout class based on position.
      # @return [String] the layout class
      # @api private
      def position_layout_class
        case @position
        when :left, :right then "flex"
        else ""
        end
      end

      # Returns CSS classes for the tab list container.
      # @return [String] the merged CSS class string
      # @api private
      def tablist_classes
        css_classes([
          "bui-tabs__list",
          "flex",
          tablist_direction_class,
          alignment_class,
          style_container_class
        ].compact)
      end

      # Returns flex direction based on position.
      # @return [String] the direction class
      # @api private
      def tablist_direction_class
        case @position
        when :left, :right then "flex-col"
        else "flex-row"
        end
      end

      # Returns alignment classes.
      # @return [String] the alignment class
      # @api private
      def alignment_class
        case @alignment
        when :start then "justify-start"
        when :center then "justify-center"
        when :end then "justify-end"
        when :stretch then "justify-stretch"
        end
      end

      # Returns style-specific container classes.
      # @return [String] the style container class
      # @api private
      def style_container_class
        case @style
        when :underline then border_class_for_position
        when :pills then "gap-1"
        when :bordered then "gap-0"
        end
      end

      # Returns border class based on position.
      # @return [String] the border class
      # @api private
      def border_class_for_position
        case @position
        when :bottom then "border-t border-grayscale-200"
        when :left then "border-r border-grayscale-200"
        when :right then "border-l border-grayscale-200"
        else "border-b border-grayscale-200"
        end
      end

      # Returns CSS classes for the panels container.
      # @return [String] the merged CSS class string
      # @api private
      def panels_classes
        css_classes([
          "bui-tabs__panels",
          "flex-1"
        ])
      end

      # Returns order classes for tab list based on position.
      # @return [String] the order class
      # @api private
      def tablist_order_class
        case @position
        when :bottom then "order-2"
        when :right then "order-2"
        else ""
        end
      end

      # Returns order classes for panels based on position.
      # @return [String] the order class
      # @api private
      def panels_order_class
        case @position
        when :bottom then "order-1"
        when :right then "order-1"
        else ""
        end
      end

      # Returns the Stimulus controller identifier.
      # @return [String] the controller name
      # @api private
      def controller_name
        "better-ui--tabs--container"
      end

      # Returns HTML attributes for the container element.
      # @return [Hash] HTML attributes hash
      # @api private
      def html_attributes
        @options.except(:class).merge(
          id: container_id,
          data: data_attributes
        )
      end

      # Returns data attributes for Stimulus controller.
      # @return [Hash] data attributes hash
      # @api private
      def data_attributes
        attrs = {
          controller: controller_name,
          "#{controller_name}-mode-value": @mode,
          "#{controller_name}-default-tab-value": @default_tab,
          "#{controller_name}-persist-value": @persist,
          "#{controller_name}-persist-key-value": @persist_key,
          "#{controller_name}-frame-id-value": @frame_id,
          "#{controller_name}-show-loading-value": @show_loading,
          "#{controller_name}-loader-delay-value": @loader_delay
        }.compact
        (@options[:data] || {}).merge(attrs)
      end

      # Validates the mode parameter.
      # @param mode [Symbol] the mode to validate
      # @return [Symbol] the validated mode
      # @raise [ArgumentError] if mode is invalid
      # @api private
      def validate_mode(mode)
        unless MODES.include?(mode)
          raise ArgumentError, "Invalid mode: #{mode}. Must be one of: #{MODES.join(', ')}"
        end
        mode
      end

      # Validates the style parameter.
      # @param style [Symbol] the style to validate
      # @return [Symbol] the validated style
      # @raise [ArgumentError] if style is invalid
      # @api private
      def validate_style(style)
        unless STYLES.include?(style)
          raise ArgumentError, "Invalid style: #{style}. Must be one of: #{STYLES.join(', ')}"
        end
        style
      end

      # Validates the variant parameter.
      # @param variant [Symbol] the variant to validate
      # @return [Symbol] the validated variant
      # @raise [ArgumentError] if variant is invalid
      # @api private
      def validate_variant(variant)
        unless VARIANTS.keys.include?(variant)
          raise ArgumentError, "Invalid variant: #{variant}. Must be one of: #{VARIANTS.keys.join(', ')}"
        end
        variant
      end

      # Validates the size parameter.
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

      # Validates the alignment parameter.
      # @param alignment [Symbol] the alignment to validate
      # @return [Symbol] the validated alignment
      # @raise [ArgumentError] if alignment is invalid
      # @api private
      def validate_alignment(alignment)
        unless ALIGNMENTS.include?(alignment)
          raise ArgumentError, "Invalid alignment: #{alignment}. Must be one of: #{ALIGNMENTS.join(', ')}"
        end
        alignment
      end

      # Validates the position parameter.
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

      # Validates turbo mode requirements.
      # @raise [ArgumentError] if turbo mode is used without frame_id
      # @api private
      def validate_turbo_requirements!
        if @mode == :turbo && @frame_id.nil?
          raise ArgumentError, "frame_id is required when mode is :turbo"
        end
      end

      # Returns the spinner color class for the loading indicator.
      # Uses literal strings for Tailwind JIT compatibility.
      # @return [String] the text color class
      # @api private
      def spinner_color_class
        case @variant
        when :primary   then "text-primary-600"
        when :secondary then "text-secondary-600"
        when :accent    then "text-accent-600"
        when :success   then "text-success-600"
        when :danger    then "text-danger-600"
        when :warning   then "text-warning-600"
        when :info      then "text-info-600"
        when :light     then "text-grayscale-600"
        when :dark      then "text-grayscale-800"
        end
      end
    end
  end
end
