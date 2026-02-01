# frozen_string_literal: true

module BetterUi
  # @label Heading
  class HeadingComponentPreview < ViewComponent::Preview
    # @label Default
    # @display bg_color #ffffff
    def default
      render BetterUi::HeadingComponent.new { "Default Heading" }
    end

    # @label All Levels
    # @display bg_color #ffffff
    def all_levels
      render_with_template
    end

    # @label With Subtitle (String)
    # @display bg_color #ffffff
    def with_subtitle
      render BetterUi::HeadingComponent.new(
        level: :h2,
        subtitle: "This is a subtitle passed as a string parameter"
      ) { "Heading with Subtitle" }
    end

    # @label With Subtitle (Slot)
    # @display bg_color #ffffff
    def with_subtitle_slot
      render BetterUi::HeadingComponent.new(level: :h2) do |heading|
        heading.with_subtitle do
          "<span>Rich subtitle with <strong>bold text</strong> and <em>emphasis</em></span>".html_safe
        end
        "Heading with Rich Subtitle"
      end
    end

    # @label With Actions
    # @display bg_color #ffffff
    def with_actions
      render BetterUi::HeadingComponent.new(level: :h2) do |heading|
        heading.with_actions do
          "<button class='inline-flex items-center px-4 py-2 bg-primary-600 text-white rounded-lg text-sm font-medium'>Add New</button>".html_safe
        end
        "Page Title"
      end
    end

    # @label With Divider
    # @display bg_color #ffffff
    def with_divider
      render BetterUi::HeadingComponent.new(
        level: :h2,
        divider: true,
        subtitle: "This heading has a divider line below"
      ) { "Section Title" }
    end

    # @label All Variants
    # @display bg_color #ffffff
    def all_variants
      render_with_template
    end

    # @label All Alignments
    # @display bg_color #ffffff
    def all_alignments
      render_with_template
    end

    # @label Complete Example
    # @display bg_color #ffffff
    def complete_example
      render BetterUi::HeadingComponent.new(
        level: :h1,
        variant: :primary,
        divider: true,
        subtitle: "Manage your team members and their account permissions here"
      ) do |heading|
        heading.with_actions do
          "<button class='inline-flex items-center px-4 py-2 bg-primary-600 text-white rounded-lg text-sm font-medium'>Add Member</button>".html_safe
        end
        "Team Members"
      end
    end

    # @label Playground
    # @param level select { choices: [h1, h2, h3, h4, h5, h6] }
    # @param variant select { choices: [~, primary, secondary, accent, success, danger, warning, info, light, dark] }
    # @param align select { choices: [left, center, right] }
    # @param divider toggle
    # @param subtitle text
    # @param with_actions toggle
    def playground(level: :h2, variant: nil, align: :left, divider: false, subtitle: "Optional subtitle text", with_actions: false)
      resolved_variant = variant == "~" || variant.blank? ? nil : variant.to_sym

      render BetterUi::HeadingComponent.new(
        level: level.to_sym,
        variant: resolved_variant,
        align: align.to_sym,
        divider: divider,
        subtitle: subtitle.presence
      ) do |heading|
        if with_actions
          heading.with_actions do
            "<button class='inline-flex items-center px-3 py-1.5 bg-primary-600 text-white rounded-lg text-sm font-medium'>Action</button>".html_safe
          end
        end
        "Playground Heading"
      end
    end
  end
end
