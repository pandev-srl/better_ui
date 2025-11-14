# frozen_string_literal: true

module BetterUi
  module Forms
    # @label Textarea
    class TextareaComponentPreview < ViewComponent::Preview
      # @label Default
      # @display bg_color #f5f5f5
      def default
        render BetterUi::Forms::TextareaComponent.new(
          name: "example",
          label: "Example Field",
          placeholder: "Enter text here"
        )
      end

      # @label With Value
      # @display bg_color #f5f5f5
      def with_value
        render BetterUi::Forms::TextareaComponent.new(
          name: "description",
          label: "Description",
          value: "This is a sample description that spans multiple lines.\nIt demonstrates how the textarea component handles pre-populated content."
        )
      end

      # @label With Hint
      # @display bg_color #f5f5f5
      def with_hint
        render BetterUi::Forms::TextareaComponent.new(
          name: "bio",
          label: "Biography",
          hint: "Tell us about yourself in 500 characters or less.",
          placeholder: "Write your bio here...",
          maxlength: 500
        )
      end

      # @label With Errors
      # @display bg_color #f5f5f5
      def with_errors
        render BetterUi::Forms::TextareaComponent.new(
          name: "content",
          label: "Post Content",
          value: "Too short",
          errors: [
            "Content is too short (minimum is 50 characters)",
            "Content must be more descriptive"
          ]
        )
      end

      # @label Required Field
      # @display bg_color #f5f5f5
      def required
        render BetterUi::Forms::TextareaComponent.new(
          name: "message",
          label: "Message",
          required: true,
          placeholder: "Enter your message"
        )
      end

      # @label Disabled State
      # @display bg_color #f5f5f5
      def disabled
        render BetterUi::Forms::TextareaComponent.new(
          name: "disabled_field",
          label: "Disabled Field",
          value: "Cannot edit this content.\nThis textarea is disabled.",
          disabled: true
        )
      end

      # @label Readonly State
      # @display bg_color #f5f5f5
      def readonly
        render BetterUi::Forms::TextareaComponent.new(
          name: "readonly_field",
          label: "Readonly Field",
          value: "View only content.\nYou can read but not edit this.",
          readonly: true
        )
      end

      # @label Custom Rows
      # @display bg_color #f5f5f5
      def custom_rows
        render BetterUi::Forms::TextareaComponent.new(
          name: "large_text",
          label: "Large Text Area",
          rows: 10,
          placeholder: "This textarea has 10 rows for more content"
        )
      end

      # @label With Character Limit
      # @display bg_color #f5f5f5
      def with_character_limit
        render BetterUi::Forms::TextareaComponent.new(
          name: "tweet",
          label: "Tweet",
          maxlength: 280,
          hint: "Maximum 280 characters",
          placeholder: "What's happening?"
        )
      end

      # @label Resize None
      # @display bg_color #f5f5f5
      def resize_none
        render BetterUi::Forms::TextareaComponent.new(
          name: "fixed_size",
          label: "Fixed Size",
          resize: :none,
          placeholder: "This textarea cannot be resized"
        )
      end

      # @label Resize Horizontal
      # @display bg_color #f5f5f5
      def resize_horizontal
        render BetterUi::Forms::TextareaComponent.new(
          name: "horizontal_resize",
          label: "Horizontal Resize",
          resize: :horizontal,
          placeholder: "This textarea can be resized horizontally"
        )
      end

      # @label Resize Both
      # @display bg_color #f5f5f5
      def resize_both
        render BetterUi::Forms::TextareaComponent.new(
          name: "both_resize",
          label: "Resize Both Directions",
          resize: :both,
          placeholder: "This textarea can be resized in all directions"
        )
      end

      # @label With Prefix Icon
      # @display bg_color #f5f5f5
      def with_prefix_icon
        render BetterUi::Forms::TextareaComponent.new(
          name: "notes",
          label: "Notes",
          placeholder: "Write your notes here..."
        ) do |component|
          component.with_prefix_icon do
            '<svg class="h-5 w-5 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M11 5H6a2 2 0 00-2 2v11a2 2 0 002 2h11a2 2 0 002-2v-5m-1.414-9.414a2 2 0 112.828 2.828L11.828 15H9v-2.828l8.586-8.586z"/>
            </svg>'.html_safe
          end
        end
      end

      # @label With Suffix Icon
      # @display bg_color #f5f5f5
      def with_suffix_icon
        render BetterUi::Forms::TextareaComponent.new(
          name: "verified_content",
          label: "Verified Content",
          value: "This content has been verified and approved."
        ) do |component|
          component.with_suffix_icon do
            '<svg class="h-5 w-5 text-success-600" fill="currentColor" viewBox="0 0 20 20">
              <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" clip-rule="evenodd"/>
            </svg>'.html_safe
          end
        end
      end

      # @label With Both Icons
      # @display bg_color #f5f5f5
      def with_both_icons
        render BetterUi::Forms::TextareaComponent.new(
          name: "comment",
          label: "Comment",
          placeholder: "Add your comment..."
        ) do |component|
          component.with_prefix_icon do
            '<svg class="h-5 w-5 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M7 8h10M7 12h4m1 8l-4-4H5a2 2 0 01-2-2V6a2 2 0 012-2h14a2 2 0 012 2v8a2 2 0 01-2 2h-3l-4 4z"/>
            </svg>'.html_safe
          end
          component.with_suffix_icon do
            '<svg class="h-5 w-5 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 16h-1v-4h-1m1-4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"/>
            </svg>'.html_safe
          end
        end
      end

      # @label All Sizes
      # @display bg_color #f5f5f5
      def all_sizes
        render_with_template
      end

      # @label All Resize Variants
      # @display bg_color #f5f5f5
      def all_resize_variants
        render_with_template
      end

      # @label Form Integration
      # @display bg_color #f5f5f5
      def form_integration
        render_with_template
      end

      # @label Playground
      # @param size select { choices: [xs, sm, md, lg, xl] }
      # @param rows text
      # @param resize select { choices: [none, vertical, horizontal, both] }
      # @param disabled toggle
      # @param readonly toggle
      # @param required toggle
      # @param with_hint toggle
      # @param with_error toggle
      def playground(size: :md, rows: "4", resize: :vertical, disabled: false, readonly: false, required: false, with_hint: false, with_error: false)
        render BetterUi::Forms::TextareaComponent.new(
          name: "playground",
          label: "Playground Textarea",
          placeholder: "Type something...",
          size: size.to_sym,
          rows: rows.to_i,
          resize: resize.to_sym,
          disabled: disabled,
          readonly: readonly,
          required: required,
          hint: with_hint ? "This is a helpful hint" : nil,
          errors: with_error ? [ "This field has an error" ] : nil
        )
      end
    end
  end
end
