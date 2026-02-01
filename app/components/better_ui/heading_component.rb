# frozen_string_literal: true

module BetterUi
  # A flexible heading component for rendering semantic HTML headings with
  # optional subtitle, actions, divider, and color variant support.
  #
  # This component renders headings (h1-h6) with consistent typography,
  # alignment, and optional subtitle text. It supports an actions slot
  # for placing buttons or other controls alongside the heading.
  #
  # @example Basic heading
  #   <%= render BetterUi::HeadingComponent.new(level: :h2) { "Page Title" } %>
  #
  # @example Heading with subtitle
  #   <%= render BetterUi::HeadingComponent.new(level: :h1, subtitle: "A brief description") { "Dashboard" } %>
  #
  # @example Heading with actions slot
  #   <%= render BetterUi::HeadingComponent.new(level: :h2) do |heading| %>
  #     <% heading.with_actions do %>
  #       <%= render BetterUi::ButtonComponent.new(variant: :primary) { "Add New" } %>
  #     <% end %>
  #     Page Title
  #   <% end %>
  #
  # @example Heading with divider and variant
  #   <%= render BetterUi::HeadingComponent.new(level: :h3, variant: :primary, divider: true) { "Section Title" } %>
  #
  # @example Heading with rich subtitle slot
  #   <%= render BetterUi::HeadingComponent.new(level: :h2) do |heading| %>
  #     <% heading.with_subtitle do %>
  #       <span>Rich <strong>subtitle</strong> content</span>
  #     <% end %>
  #     Page Title
  #   <% end %>
  class HeadingComponent < ApplicationComponent
    # Available heading levels
    LEVELS = %i[h1 h2 h3 h4 h5 h6].freeze

    # Available alignment options
    ALIGNMENTS = %i[left center right].freeze

    # @!method with_subtitle
    #   Slot for rendering rich subtitle content below the heading.
    #   Takes precedence over the subtitle string parameter when both are provided.
    #   @yieldreturn [String] the HTML content for the subtitle
    renders_one :subtitle

    # @!method with_actions
    #   Slot for rendering action buttons or controls aligned to the right of the heading.
    #   @yieldreturn [String] the HTML content for the actions area
    renders_one :actions

    # Initializes a new heading component.
    #
    # @param level [Symbol] the heading level (:h1, :h2, :h3, :h4, :h5, :h6), defaults to :h2
    # @param subtitle [String, nil] subtitle text displayed below the heading
    # @param divider [Boolean] whether to show a divider line below the heading block, defaults to false
    # @param variant [Symbol, nil] the color variant (:primary, :secondary, :accent, :success, :danger, :warning, :info, :light, :dark).
    #   Defaults to nil (inherits color from parent).
    # @param align [Symbol] text alignment (:left, :center, :right), defaults to :left
    # @param container_classes [String, nil] additional CSS classes for the outer wrapper
    # @param options [Hash] additional HTML attributes passed to the heading element
    #
    # @raise [ArgumentError] if level is not one of the allowed values
    # @raise [ArgumentError] if align is not one of the allowed values
    # @raise [ArgumentError] if variant is provided but not one of the allowed values
    def initialize(
      level: :h2,
      subtitle: nil,
      divider: false,
      variant: nil,
      align: :left,
      container_classes: nil,
      **options
    )
      @level = validate_level(level)
      @subtitle_text = subtitle
      @divider = divider
      @variant = variant ? validate_variant(variant) : nil
      @align = validate_align(align)
      @container_classes = container_classes
      @options = options
    end

    private

    # Returns the complete CSS classes for the outer wrapper div.
    #
    # @return [String] the merged CSS class string
    # @api private
    def wrapper_classes
      css_classes([
        align_classes,
        divider_classes,
        @container_classes
      ].flatten.compact)
    end

    # Returns the complete CSS classes for the heading element.
    #
    # @return [String] the merged CSS class string
    # @api private
    def component_classes
      css_classes([
        level_classes,
        variant_classes
      ].flatten.compact)
    end

    # Returns the CSS classes for the subtitle paragraph.
    #
    # @return [String] the merged CSS class string
    # @api private
    def subtitle_classes
      css_classes([
        "mt-1",
        "text-grayscale-500",
        subtitle_size_class
      ].compact)
    end

    # Returns typography classes based on heading level.
    #
    # @return [String] typography CSS classes
    # @api private
    def level_classes
      case @level
      when :h1 then "text-4xl font-bold"
      when :h2 then "text-3xl font-semibold"
      when :h3 then "text-2xl font-semibold"
      when :h4 then "text-xl font-medium"
      when :h5 then "text-lg font-medium"
      when :h6 then "text-base font-medium"
      end
    end

    # Returns alignment classes.
    #
    # @return [String] alignment CSS class
    # @api private
    def align_classes
      case @align
      when :left then "text-left"
      when :center then "text-center"
      when :right then "text-right"
      end
    end

    # Returns color classes based on variant.
    # Returns nil when no variant is set (inherits color).
    #
    # @return [String, nil] color CSS class or nil
    # @api private
    def variant_classes
      return nil if @variant.nil?

      case @variant
      when :primary   then "text-primary-600"
      when :secondary then "text-secondary-600"
      when :accent    then "text-accent-600"
      when :success   then "text-success-600"
      when :danger    then "text-danger-600"
      when :warning   then "text-warning-600"
      when :info      then "text-info-600"
      when :light     then "text-grayscale-400"
      when :dark      then "text-grayscale-900"
      end
    end

    # Returns divider classes when divider is enabled.
    #
    # @return [String, nil] divider CSS classes or nil
    # @api private
    def divider_classes
      return nil unless @divider

      "border-b border-grayscale-200 pb-3"
    end

    # Returns subtitle font size based on heading level.
    #
    # @return [String] subtitle size CSS class
    # @api private
    def subtitle_size_class
      case @level
      when :h1 then "text-lg"
      when :h2 then "text-base"
      when :h3 then "text-sm"
      when :h4 then "text-sm"
      when :h5 then "text-xs"
      when :h6 then "text-xs"
      end
    end

    # Returns whether the subtitle should be displayed.
    # Either the subtitle slot or the subtitle text parameter must be present.
    #
    # @return [Boolean] whether to show the subtitle
    # @api private
    def show_subtitle?
      subtitle? || @subtitle_text.present?
    end

    # Returns the heading tag name as a string.
    #
    # @return [String] the HTML heading tag
    # @api private
    def heading_tag
      @level.to_s
    end

    # Returns HTML attributes for the heading element.
    #
    # @return [Hash] HTML attributes hash
    # @api private
    def html_attributes
      @options
    end

    # Validates the level parameter.
    #
    # @param level [Symbol] the level to validate
    # @return [Symbol] the validated level
    # @raise [ArgumentError] if level is invalid
    # @api private
    def validate_level(level)
      unless LEVELS.include?(level)
        raise ArgumentError, "Invalid level: #{level}. Must be one of: #{LEVELS.join(', ')}"
      end
      level
    end

    # Validates the align parameter.
    #
    # @param align [Symbol] the alignment to validate
    # @return [Symbol] the validated alignment
    # @raise [ArgumentError] if align is invalid
    # @api private
    def validate_align(align)
      unless ALIGNMENTS.include?(align)
        raise ArgumentError, "Invalid align: #{align}. Must be one of: #{ALIGNMENTS.join(', ')}"
      end
      align
    end

    # Validates the variant parameter.
    #
    # @param variant [Symbol] the variant to validate
    # @return [Symbol] the validated variant
    # @raise [ArgumentError] if variant is invalid
    # @api private
    def validate_variant(variant)
      unless BetterUi::ApplicationComponent::VARIANTS.key?(variant)
        raise ArgumentError, "Invalid variant: #{variant}. Must be one of: #{BetterUi::ApplicationComponent::VARIANTS.keys.join(', ')}"
      end
      variant
    end
  end
end
