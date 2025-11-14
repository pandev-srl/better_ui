# frozen_string_literal: true

require "test_helper"

module BetterUi
  module Forms
    class TextareaComponentTest < ActiveSupport::TestCase
      test "renders textarea with default options" do
        render_inline(TextareaComponent.new(name: "post[content]"))

        assert_selector "textarea"
        assert_selector "textarea[name='post[content]']"
        assert_selector "textarea[rows='4']" # default rows
      end

      test "renders with label" do
        render_inline(TextareaComponent.new(name: "content", label: "Post Content"))

        assert_selector "label", text: "Post Content"
        assert_selector "textarea"
      end

      test "renders with value" do
        render_inline(TextareaComponent.new(name: "content", value: "Sample text"))

        assert_selector "textarea", text: "Sample text"
      end

      test "renders with placeholder" do
        render_inline(TextareaComponent.new(name: "content", placeholder: "Write something..."))

        assert_selector "textarea[placeholder='Write something...']"
      end

      # Rows and cols tests
      test "renders with default rows" do
        render_inline(TextareaComponent.new(name: "content"))

        assert_selector "textarea[rows='4']"
      end

      test "renders with custom rows" do
        render_inline(TextareaComponent.new(name: "content", rows: 10))

        assert_selector "textarea[rows='10']"
      end

      test "renders with cols attribute" do
        render_inline(TextareaComponent.new(name: "content", cols: 80))

        assert_selector "textarea[cols='80']"
      end

      test "does not render cols attribute when not provided" do
        render_inline(TextareaComponent.new(name: "content"))

        refute_selector "textarea[cols]"
      end

      # Maxlength tests
      test "renders with maxlength attribute" do
        render_inline(TextareaComponent.new(name: "bio", maxlength: 500))

        assert_selector "textarea[maxlength='500']"
      end

      test "does not render maxlength attribute when not provided" do
        render_inline(TextareaComponent.new(name: "content"))

        refute_selector "textarea[maxlength]"
      end

      # Resize tests
      test "renders with vertical resize by default" do
        render_inline(TextareaComponent.new(name: "content"))

        assert_selector "textarea.resize-y"
      end

      test "renders with no resize" do
        render_inline(TextareaComponent.new(name: "content", resize: :none))

        assert_selector "textarea.resize-none"
      end

      test "renders with horizontal resize" do
        render_inline(TextareaComponent.new(name: "content", resize: :horizontal))

        assert_selector "textarea.resize-x"
      end

      test "renders with both directions resize" do
        render_inline(TextareaComponent.new(name: "content", resize: :both))

        assert_selector "textarea.resize"
      end

      test "defaults to vertical resize when invalid value provided" do
        render_inline(TextareaComponent.new(name: "content", resize: :invalid))

        assert_selector "textarea.resize-y"
      end

      # Hint and error tests
      test "renders with hint text" do
        render_inline(TextareaComponent.new(name: "content", hint: "Maximum 500 characters"))

        assert_text "Maximum 500 characters"
        assert_selector "div.text-gray-600"
      end

      test "renders with errors" do
        render_inline(TextareaComponent.new(name: "content", errors: [ "Content can't be blank" ]))

        assert_text "Content can't be blank"
        assert_selector "div.text-danger-600"
        assert_selector "textarea.border-danger-500"
      end

      test "renders with multiple errors" do
        errors = [ "Content can't be blank", "Content is too short" ]
        render_inline(TextareaComponent.new(name: "content", errors: errors))

        assert_text "Content can't be blank"
        assert_text "Content is too short"
      end

      # State tests
      test "renders as required" do
        render_inline(TextareaComponent.new(name: "content", required: true, label: "Content"))

        assert_selector "textarea[required]"
      end

      test "renders as disabled" do
        render_inline(TextareaComponent.new(name: "content", disabled: true))

        assert_selector "textarea[disabled]"
        assert_selector "textarea.cursor-not-allowed"
        assert_selector "textarea.opacity-60"
      end

      test "renders as readonly" do
        render_inline(TextareaComponent.new(name: "content", readonly: true))

        assert_selector "textarea[readonly]"
        assert_selector "textarea.bg-gray-50"
        assert_selector "textarea.cursor-default"
      end

      # Size tests
      test "renders xs size" do
        render_inline(TextareaComponent.new(name: "content", size: :xs))

        assert_selector "textarea.text-xs"
        assert_selector "textarea.py-1.px-2"
      end

      test "renders sm size" do
        render_inline(TextareaComponent.new(name: "content", size: :sm))

        assert_selector "textarea.text-sm"
      end

      test "renders md size by default" do
        render_inline(TextareaComponent.new(name: "content"))

        assert_selector "textarea.text-base"
        assert_selector "textarea.py-2.px-4"
      end

      test "renders lg size" do
        render_inline(TextareaComponent.new(name: "content", size: :lg))

        assert_selector "textarea.text-lg"
      end

      test "renders xl size" do
        render_inline(TextareaComponent.new(name: "content", size: :xl))

        assert_selector "textarea.text-xl"
      end

      # Icon slot tests
      test "renders with prefix icon" do
        render_inline(TextareaComponent.new(name: "content")) do |component|
          component.with_prefix_icon { '<svg class="prefix-icon"></svg>'.html_safe }
        end

        assert_selector "svg.prefix-icon"
        assert_selector "textarea.pl-10" # md size padding adjustment
      end

      test "renders with suffix icon" do
        render_inline(TextareaComponent.new(name: "content")) do |component|
          component.with_suffix_icon { '<svg class="suffix-icon"></svg>'.html_safe }
        end

        assert_selector "svg.suffix-icon"
        assert_selector "textarea.pr-10" # md size padding adjustment
      end

      test "renders with both prefix and suffix icons" do
        render_inline(TextareaComponent.new(name: "content")) do |component|
          component.with_prefix_icon { '<svg class="prefix"></svg>'.html_safe }
          component.with_suffix_icon { '<svg class="suffix"></svg>'.html_safe }
        end

        assert_selector "svg.prefix"
        assert_selector "svg.suffix"
        assert_selector "textarea.pl-10.pr-10"
      end

      test "icon wrapper positioned at top for textarea" do
        render_inline(TextareaComponent.new(name: "content")) do |component|
          component.with_prefix_icon { "<span>Icon</span>".html_safe }
        end

        assert_selector "div.absolute.top-0.left-0"
      end

      test "adjusts padding for prefix icon with sm size" do
        render_inline(TextareaComponent.new(name: "content", size: :sm)) do |component|
          component.with_prefix_icon { "<svg></svg>".html_safe }
        end

        assert_selector "textarea.pl-8"
      end

      test "adjusts padding for prefix icon with xs size" do
        render_inline(TextareaComponent.new(name: "content", size: :xs)) do |component|
          component.with_prefix_icon { "<svg></svg>".html_safe }
        end

        assert_selector "textarea.pl-6"
      end

      test "adjusts padding for prefix icon with lg size" do
        render_inline(TextareaComponent.new(name: "content", size: :lg)) do |component|
          component.with_prefix_icon { "<svg></svg>".html_safe }
        end

        assert_selector "textarea.pl-12"
      end

      test "adjusts padding for prefix icon with xl size" do
        render_inline(TextareaComponent.new(name: "content", size: :xl)) do |component|
          component.with_prefix_icon { "<svg></svg>".html_safe }
        end

        assert_selector "textarea.pl-14"
      end

      # Custom classes tests
      test "renders with custom container classes" do
        render_inline(TextareaComponent.new(name: "content", container_classes: "custom-wrapper"))

        assert_selector "div.custom-wrapper"
      end

      test "renders with custom label classes" do
        render_inline(TextareaComponent.new(name: "content", label: "Content", label_classes: "custom-label"))

        assert_selector "label.custom-label"
      end

      test "renders with custom input classes" do
        render_inline(TextareaComponent.new(name: "content", input_classes: "custom-textarea"))

        assert_selector "textarea.custom-textarea"
      end

      test "renders with custom hint classes" do
        render_inline(TextareaComponent.new(name: "content", hint: "Hint", hint_classes: "custom-hint"))

        assert_selector "div.custom-hint"
      end

      test "renders with custom error classes" do
        render_inline(TextareaComponent.new(name: "content", errors: [ "Error" ], error_classes: "custom-error"))

        assert_selector "div.custom-error"
      end

      # Additional HTML options tests
      test "passes through additional HTML options" do
        render_inline(TextareaComponent.new(
          name: "content",
          id: "custom-content",
          data: { controller: "counter" },
          aria: { label: "Content field" }
        ))

        assert_selector "textarea#custom-content"
        assert_selector "textarea[data-controller='counter']"
        assert_selector "textarea[aria-label='Content field']"
      end

      # Complete form field rendering test
      test "renders complete textarea field with all elements" do
        render_inline(TextareaComponent.new(
          name: "post[body]",
          value: "Initial content",
          label: "Post Body",
          hint: "Write your post content here",
          placeholder: "Start writing...",
          rows: 8,
          maxlength: 1000,
          resize: :vertical,
          required: true,
          size: :md
        ))

        assert_selector "label", text: "Post Body"
        assert_selector "textarea[name='post[body]']"
        assert_selector "textarea", text: "Initial content"
        assert_selector "textarea[placeholder='Start writing...']"
        assert_selector "textarea[rows='8']"
        assert_selector "textarea[maxlength='1000']"
        assert_selector "textarea[required]"
        assert_selector "textarea.resize-y"
        assert_text "Write your post content here"
      end

      # Blog post content use case
      test "renders blog post content textarea" do
        render_inline(TextareaComponent.new(
          name: "post[content]",
          label: "Post Content",
          hint: "Write your blog post content",
          rows: 12,
          resize: :vertical,
          required: true
        ))

        assert_selector "textarea[rows='12']"
        assert_selector "textarea[required]"
        assert_selector "textarea.resize-y"
        assert_text "Write your blog post content"
      end

      # Comment textarea use case
      test "renders comment textarea" do
        render_inline(TextareaComponent.new(
          name: "comment[body]",
          label: "Comment",
          placeholder: "Add a comment...",
          rows: 3,
          resize: :none
        ))

        assert_selector "textarea[rows='3']"
        assert_selector "textarea.resize-none"
        assert_selector "textarea[placeholder='Add a comment...']"
      end

      # Bio textarea with character limit use case
      test "renders bio textarea with character limit" do
        render_inline(TextareaComponent.new(
          name: "user[bio]",
          label: "Bio",
          hint: "Maximum 500 characters",
          maxlength: 500,
          rows: 6,
          resize: :none
        ))

        assert_selector "textarea[maxlength='500']"
        assert_selector "textarea[rows='6']"
        assert_selector "textarea.resize-none"
        assert_text "Maximum 500 characters"
      end

      # Description textarea use case
      test "renders product description textarea" do
        render_inline(TextareaComponent.new(
          name: "product[description]",
          label: "Product Description",
          placeholder: "Describe your product...",
          rows: 8,
          required: true
        ))

        assert_selector "textarea[required]"
        assert_selector "textarea[rows='8']"
      end

      # Error state styling test
      test "applies error styling when errors present" do
        render_inline(TextareaComponent.new(
          name: "content",
          errors: [ "Content is too short" ]
        ))

        assert_selector "textarea.border-danger-500"
        assert_selector "textarea.focus\\:border-danger-600"
        assert_selector "textarea.focus\\:ring-danger-500"
      end

      # Base textarea classes test
      test "applies base textarea classes" do
        render_inline(TextareaComponent.new(name: "content"))

        assert_selector "textarea.block.w-full"
        assert_selector "textarea.rounded-md"
        assert_selector "textarea.border"
        assert_selector "textarea.shadow-sm"
      end

      # Focus state classes test
      test "applies focus ring classes" do
        render_inline(TextareaComponent.new(name: "content"))

        assert_selector "textarea.focus\\:ring-2"
        assert_selector "textarea.focus\\:ring-primary-500"
        assert_selector "textarea.focus\\:outline-none"
      end

      # Type attribute test
      test "does not include type attribute on textarea" do
        render_inline(TextareaComponent.new(name: "content"))

        refute_selector "textarea[type]"
      end

      # Textarea with icons and resize
      test "combines icon padding and resize classes correctly" do
        render_inline(TextareaComponent.new(name: "content", resize: :none)) do |component|
          component.with_prefix_icon { "<span>Icon</span>".html_safe }
        end

        assert_selector "textarea.pl-10.resize-none"
      end
    end
  end
end
