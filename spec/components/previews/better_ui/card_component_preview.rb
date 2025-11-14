# frozen_string_literal: true

module BetterUi
  # @label Card
  class CardComponentPreview < ViewComponent::Preview
    # @label Default
    # @display bg_color #f5f5f5
    def default
      render BetterUi::CardComponent.new do
        "This is a default card with solid primary style and medium size."
      end
    end

    # @label With Header
    # @display bg_color #f5f5f5
    def with_header
      render BetterUi::CardComponent.new do |card|
        card.with_header { "Card Header" }
        card.with_body { "This card has a header section separated by a divider." }
      end
    end

    # @label With Footer
    # @display bg_color #f5f5f5
    def with_footer
      render BetterUi::CardComponent.new do |card|
        card.with_body { "This card has a footer section for actions or additional information." }
        card.with_footer { "Card Footer" }
      end
    end

    # @label With All Sections
    # @display bg_color #f5f5f5
    def with_all_sections
      render BetterUi::CardComponent.new do |card|
        card.with_header { "Complete Card" }
        card.with_body { "This card demonstrates all three sections: header, body, and footer." }
        card.with_footer { "Footer with actions" }
      end
    end

    # @label Solid Style
    # @display bg_color #f5f5f5
    def solid_style
      render BetterUi::CardComponent.new(variant: :primary, style: :solid) do |card|
        card.with_header { "Solid Card" }
        card.with_body { "Filled background with subtle border and dark text. Best for emphasis." }
      end
    end

    # @label Outline Style
    # @display bg_color #f5f5f5
    def outline_style
      render BetterUi::CardComponent.new(variant: :primary, style: :outline) do |card|
        card.with_header { "Outline Card" }
        card.with_body { "White background with colored border. Clean and minimal." }
      end
    end

    # @label Ghost Style (Transparent)
    # @display bg_color #f5f5f5
    def ghost_style
      render BetterUi::CardComponent.new(variant: :primary, style: :ghost) do |card|
        card.with_header { "Ghost Card" }
        card.with_body { "Transparent background with colored text. Most subtle option." }
      end
    end

    # @label Soft Style
    # @display bg_color #f5f5f5
    def soft_style
      render BetterUi::CardComponent.new(variant: :primary, style: :soft) do |card|
        card.with_header { "Soft Card" }
        card.with_body { "Light colored background with subtle border. Gentle appearance." }
      end
    end

    # @label Bordered Style (Neutral)
    # @display bg_color #f5f5f5
    def bordered_style
      render BetterUi::CardComponent.new(style: :bordered) do |card|
        card.with_header { "Bordered Card" }
        card.with_body { "Neutral gray border for visual content separation. Variant-agnostic - perfect for isolating content." }
      end
    end

    # @label Success Card
    # @display bg_color #f5f5f5
    def success_card
      render BetterUi::CardComponent.new(variant: :success) do |card|
        card.with_header { "✓ Success" }
        card.with_body { "Operation completed successfully!" }
      end
    end

    # @label Danger Card
    # @display bg_color #f5f5f5
    def danger_card
      render BetterUi::CardComponent.new(variant: :danger) do |card|
        card.with_header { "⚠ Error" }
        card.with_body { "An error occurred while processing your request." }
      end
    end

    # @label Info Card
    # @display bg_color #f5f5f5
    def info_card
      render BetterUi::CardComponent.new(variant: :info) do |card|
        card.with_header { "ℹ Information" }
        card.with_body { "Here's some helpful information for you." }
      end
    end

    # @label Without Shadow
    # @display bg_color #f5f5f5
    def without_shadow
      render BetterUi::CardComponent.new(shadow: false) do |card|
        card.with_header { "Flat Card" }
        card.with_body { "This card has no shadow elevation." }
      end
    end

    # @label Extra Small Size
    # @display bg_color #f5f5f5
    def extra_small_size
      render BetterUi::CardComponent.new(size: :xs) do |card|
        card.with_header { "XS Card" }
        card.with_body { "Extra small card with compact padding." }
      end
    end

    # @label Small Size
    # @display bg_color #f5f5f5
    def small_size
      render BetterUi::CardComponent.new(size: :sm) do |card|
        card.with_header { "Small Card" }
        card.with_body { "Small card with reduced padding." }
      end
    end

    # @label Large Size
    # @display bg_color #f5f5f5
    def large_size
      render BetterUi::CardComponent.new(size: :lg) do |card|
        card.with_header { "Large Card" }
        card.with_body { "Large card with generous padding." }
      end
    end

    # @label Extra Large Size
    # @display bg_color #f5f5f5
    def extra_large_size
      render BetterUi::CardComponent.new(size: :xl) do |card|
        card.with_header { "XL Card" }
        card.with_body { "Extra large card with maximum padding." }
      end
    end

    # @label All Variants
    # @display bg_color #f5f5f5
    def all_variants
      render_with_template
    end

    # @label All Styles
    # @display bg_color #f5f5f5
    def all_styles
      render_with_template
    end

    # @label All Sizes
    # @display bg_color #f5f5f5
    def all_sizes
      render_with_template
    end

    # @label Full-Width Image
    # @display bg_color #f5f5f5
    def full_width_image
      render BetterUi::CardComponent.new(body_padding: false) do |card|
        card.with_header { "Photo Gallery" }
        card.with_body do
          "<div class='bg-gradient-to-r from-blue-500 to-purple-600 h-48 flex items-center justify-center text-white font-bold'>Full-Width Image Placeholder</div>".html_safe
        end
        card.with_footer { "Image caption or actions" }
      end
    end

    # @label Table Container
    # @display bg_color #f5f5f5
    def table_container
      render BetterUi::CardComponent.new(body_padding: false, style: :bordered) do |card|
        card.with_header { "Data Table" }
        card.with_body do
          "<table class='w-full'><thead class='bg-gray-50'><tr><th class='px-6 py-3 text-left'>Name</th><th class='px-6 py-3 text-left'>Status</th></tr></thead><tbody><tr class='border-t'><td class='px-6 py-4'>Item 1</td><td class='px-6 py-4'>Active</td></tr><tr class='border-t'><td class='px-6 py-4'>Item 2</td><td class='px-6 py-4'>Pending</td></tr></tbody></table>".html_safe
        end
      end
    end

    # @label No Padding
    # @display bg_color #f5f5f5
    def no_padding
      render BetterUi::CardComponent.new(
        header_padding: false,
        body_padding: false,
        footer_padding: false
      ) do |card|
        card.with_header do
          "<div class='bg-blue-100 p-4 font-bold'>Custom Padded Header</div>".html_safe
        end
        card.with_body do
          "<div class='bg-white p-8'>Content with custom padding</div>".html_safe
        end
        card.with_footer do
          "<div class='bg-gray-100 p-4'>Custom Padded Footer</div>".html_safe
        end
      end
    end

    # @label Selective Padding
    # @display bg_color #f5f5f5
    def selective_padding
      render BetterUi::CardComponent.new(
        variant: :info,
        header_padding: true,
        body_padding: false,
        footer_padding: true
      ) do |card|
        card.with_header { "Normal Header (with padding)" }
        card.with_body do
          "<div class='bg-gradient-to-b from-blue-50 to-white p-8'>Body with custom padding - the card body_padding is false, allowing custom spacing</div>".html_safe
        end
        card.with_footer { "Normal Footer (with padding)" }
      end
    end

    # @label Playground
    # @param variant select { choices: [primary, secondary, accent, success, danger, warning, info, light, dark] }
    # @param style select { choices: [solid, outline, ghost, soft, bordered] }
    # @param size select { choices: [xs, sm, md, lg, xl] }
    # @param shadow toggle
    # @param header_padding toggle
    # @param body_padding toggle
    # @param footer_padding toggle
    # @param with_header toggle
    # @param with_footer toggle
    def playground(variant: :primary, style: :solid, size: :md, shadow: true, header_padding: true, body_padding: true, footer_padding: true, with_header: true, with_footer: false)
      render BetterUi::CardComponent.new(
        variant: variant.to_sym,
        style: style.to_sym,
        size: size.to_sym,
        shadow: shadow,
        header_padding: header_padding,
        body_padding: body_padding,
        footer_padding: footer_padding
      ) do |card|
        if with_header
          card.with_header { "Playground Card Header" }
        end

        card.with_body { "This is an interactive card playground. Adjust the parameters to see how the card changes." }

        if with_footer
          card.with_footer { "Card Footer" }
        end
      end
    end
  end
end
