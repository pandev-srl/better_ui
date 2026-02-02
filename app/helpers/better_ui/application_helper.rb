# frozen_string_literal: true

module BetterUi
  # View helpers for rendering BetterUi components with a concise API.
  #
  # All helpers follow the `bui_<component>` naming convention and delegate
  # to the corresponding ViewComponent class.
  #
  # @example Basic button
  #   <%= bui_button(variant: :primary) { "Click me" } %>
  #
  # @example Card with slots
  #   <%= bui_card(variant: :success) do |card| %>
  #     <% card.with_header { "Title" } %>
  #     <% card.with_body { "Content" } %>
  #   <% end %>
  module ApplicationHelper
    # ============================================
    # Core Components
    # ============================================

    # Renders a button component.
    #
    # @param options [Hash] Options passed to ButtonComponent
    # @option options [Symbol] :variant Color variant (:primary, :secondary, :accent, :success, :danger, :warning, :info, :light, :dark)
    # @option options [Symbol] :style Button style (:solid, :outline, :ghost, :soft)
    # @option options [Symbol] :size Size (:xs, :sm, :md, :lg, :xl)
    # @option options [Boolean] :show_loader Show loading spinner
    # @option options [Boolean] :show_loader_on_click Show loader on click
    # @option options [Boolean] :disabled Disable the button
    # @option options [Symbol] :type Button type (:button, :submit, :reset)
    # @yield Button content
    # @return [String] Rendered HTML
    #
    # @example Simple button
    #   <%= bui_button(variant: :primary) { "Click me" } %>
    #
    # @example Submit button with loader
    #   <%= bui_button(type: :submit, show_loader_on_click: true) { "Save" } %>
    def bui_button(**options, &block)
      render BetterUi::ButtonComponent.new(**options), &block
    end

    # Renders a link component.
    #
    # @param href [String] Link URL (required)
    # @param options [Hash] Options passed to LinkComponent
    # @option options [Symbol] :variant Color variant (:primary, :secondary, :accent, :success, :danger, :warning, :info, :light, :dark)
    # @option options [Symbol] :style Link style (:default, :underline, :ghost)
    # @option options [Symbol] :size Size (:xs, :sm, :md, :lg, :xl)
    # @option options [String, nil] :target Link target (_blank, _self, etc.)
    # @option options [String, nil] :rel Custom rel attribute
    # @option options [Boolean] :disabled Disable the link
    # @yield Link content
    # @return [String] Rendered HTML
    #
    # @example Simple link
    #   <%= bui_link("/users", variant: :primary) { "View Users" } %>
    #
    # @example External link
    #   <%= bui_link("https://example.com", target: "_blank") { "External" } %>
    def bui_link(href, **options, &block)
      render BetterUi::LinkComponent.new(href: href, **options), &block
    end

    # Renders a card component.
    #
    # @param options [Hash] Options passed to CardComponent
    # @option options [Symbol] :variant Color variant
    # @option options [Symbol] :style Card style (:solid, :outline, :ghost, :soft, :bordered)
    # @option options [Symbol] :size Size (:xs, :sm, :md, :lg, :xl)
    # @option options [Boolean] :shadow Show shadow
    # @yield [card] Block with card slots
    # @yieldparam card [BetterUi::CardComponent] The card component for slot access
    # @return [String] Rendered HTML
    #
    # @example Card with header and body
    #   <%= bui_card(variant: :primary) do |card| %>
    #     <% card.with_header { "Title" } %>
    #     <% card.with_body { "Content goes here" } %>
    #     <% card.with_footer { "Footer" } %>
    #   <% end %>
    def bui_card(**options, &block)
      render BetterUi::CardComponent.new(**options), &block
    end

    # Renders an avatar component for displaying user images or initials.
    #
    # @param options [Hash] Options passed to AvatarComponent
    # @option options [String, nil] :src Image URL
    # @option options [String, nil] :alt Image alt text (falls back to name)
    # @option options [String, nil] :name Full name for generating initials
    # @option options [Symbol] :variant Color variant for initials background
    # @option options [Symbol] :size Size (:xs, :sm, :md, :lg, :xl)
    # @option options [Symbol] :shape Shape (:circle, :square, :rounded)
    # @option options [Symbol, nil] :status Status indicator (:online, :offline, :busy, :away)
    # @yield [avatar] Block with avatar slots (badge)
    # @yieldparam avatar [BetterUi::AvatarComponent] The avatar component for slot access
    # @return [String] Rendered HTML
    #
    # @example Avatar with image
    #   <%= bui_avatar(src: user.avatar_url, alt: user.name) %>
    #
    # @example Avatar with initials and status
    #   <%= bui_avatar(name: "John Doe", variant: :primary, status: :online) %>
    def bui_avatar(**options, &block)
      render BetterUi::AvatarComponent.new(**options), &block
    end

    # Renders a container component for constraining content width.
    #
    # @param options [Hash] Options passed to ContainerComponent
    # @option options [Symbol] :size Max-width size (:sm, :md, :lg, :xl, :full)
    # @option options [Boolean] :padding Apply horizontal padding (default: true)
    # @option options [Boolean] :centered Center with mx-auto (default: true)
    # @option options [String, nil] :container_classes Additional CSS classes
    # @yield Container content
    # @return [String] Rendered HTML
    #
    # @example Default container
    #   <%= bui_container { "Page content" } %>
    #
    # @example Full-width container without padding
    #   <%= bui_container(size: :full, padding: false) { "Edge-to-edge content" } %>
    def bui_container(**options, &block)
      render BetterUi::ContainerComponent.new(**options), &block
    end

    # Renders a heading component.
    #
    # @param options [Hash] Options passed to HeadingComponent
    # @option options [Symbol] :level Heading level (:h1, :h2, :h3, :h4, :h5, :h6)
    # @option options [String, nil] :subtitle Subtitle text
    # @option options [Boolean] :divider Show divider line below
    # @option options [Symbol, nil] :variant Color variant (:primary, :secondary, etc.) or nil for inherit
    # @option options [Symbol] :align Text alignment (:left, :center, :right)
    # @option options [String, nil] :container_classes Additional CSS classes
    # @yield [heading] Block with heading slots and content
    # @yieldparam heading [BetterUi::HeadingComponent] The heading component for slot access
    # @return [String] Rendered HTML
    #
    # @example Simple heading
    #   <%= bui_heading(level: :h1, variant: :primary) { "Page Title" } %>
    #
    # @example Heading with subtitle and actions
    #   <%= bui_heading(level: :h2, subtitle: "Description") do |heading| %>
    #     <% heading.with_actions { bui_button(variant: :primary) { "Add" } } %>
    #     Page Title
    #   <% end %>
    def bui_heading(**options, &block)
      render BetterUi::HeadingComponent.new(**options), &block
    end

    # Renders a tag component.
    #
    # @param options [Hash] Options passed to TagComponent
    # @option options [Symbol] :variant Color variant (:primary, :secondary, :accent, :success, :danger, :warning, :info, :light, :dark)
    # @option options [Symbol] :style Tag style (:solid, :outline, :soft)
    # @option options [Symbol] :size Size (:xs, :sm, :md, :lg)
    # @option options [Boolean] :dismissible Show dismiss button (default: false)
    # @option options [String, nil] :href Makes tag clickable (renders as <a>)
    # @yield Tag content
    # @return [String] Rendered HTML
    #
    # @example Simple tag
    #   <%= bui_tag(variant: :success) { "Active" } %>
    #
    # @example Dismissible tag
    #   <%= bui_tag(variant: :info, dismissible: true) { "New" } %>
    #
    # @example Tag as link
    #   <%= bui_tag(variant: :primary, href: "/tags/ruby") { "Ruby" } %>
    def bui_tag(**options, &block)
      render BetterUi::TagComponent.new(**options), &block
    end

    # Renders action messages (alerts/flash messages).
    #
    # @param messages [Array<String>] Messages to display
    # @param options [Hash] Options passed to ActionMessagesComponent
    # @option options [Symbol] :variant Color variant
    # @option options [Symbol] :style Alert style (:solid, :soft, :outline, :ghost)
    # @option options [Boolean] :dismissible Allow dismissing
    # @option options [Integer, Float, nil] :auto_dismiss Auto-dismiss after seconds
    # @option options [String, nil] :title Alert title
    # @return [String] Rendered HTML
    #
    # @example Success message
    #   <%= bui_action_messages(["Saved successfully!"], variant: :success, dismissible: true) %>
    #
    # @example Error messages
    #   <%= bui_action_messages(@errors, variant: :danger, title: "Errors occurred") %>
    def bui_action_messages(messages = [], **options)
      render BetterUi::ActionMessagesComponent.new(messages: messages, **options)
    end

    # Renders a progress bar component.
    #
    # @param options [Hash] Options passed to ProgressComponent
    # @option options [Numeric] :value Current value (0-100 by default)
    # @option options [Numeric] :max Maximum value (default: 100)
    # @option options [Symbol] :variant Color variant (:primary, :secondary, :accent, :success, :danger, :warning, :info, :light, :dark)
    # @option options [Symbol] :size Bar height (:xs, :sm, :md, :lg)
    # @option options [String, nil] :label Text above the bar
    # @option options [Boolean] :show_value Show percentage text
    # @option options [Boolean] :animated Striped animation effect
    # @option options [String, nil] :container_classes Additional CSS classes
    # @return [String] Rendered HTML
    #
    # @example Default progress bar
    #   <%= bui_progress(value: 50) %>
    #
    # @example With label and value display
    #   <%= bui_progress(value: 75, label: "Upload progress", show_value: true, variant: :success) %>
    def bui_progress(**options)
      render BetterUi::ProgressComponent.new(**options)
    end

    # Renders a spinner (loading indicator) component.
    #
    # @param options [Hash] Options passed to SpinnerComponent
    # @option options [Symbol] :variant Color variant (:primary, :secondary, :accent, :success, :danger, :warning, :info, :light, :dark)
    # @option options [Symbol] :size Size (:xs, :sm, :md, :lg, :xl)
    # @option options [String, nil] :label Accessible sr-only label text
    # @option options [String, nil] :container_classes Additional CSS classes
    # @return [String] Rendered HTML
    #
    # @example Default spinner
    #   <%= bui_spinner %>
    #
    # @example Large success spinner with label
    #   <%= bui_spinner(variant: :success, size: :lg, label: "Saving...") %>
    def bui_spinner(**options)
      render BetterUi::SpinnerComponent.new(**options)
    end

    # Renders a FontAwesome icon component.
    #
    # @param name [String] FontAwesome icon name (e.g., "user", "check", "arrow-right")
    # @param options [Hash] Options passed to FaIconComponent
    # @option options [Symbol] :style Icon style (:regular, :solid, :light, :thin, :brands)
    # @option options [Symbol, nil] :variant Color variant (nil = inherit, or :primary, :secondary, etc.)
    # @option options [Symbol] :size Size (:xs, :sm, :md, :lg, :xl, :"2xl")
    # @option options [Boolean] :spin Spin animation (default: false)
    # @option options [Boolean] :pulse Pulse animation (default: false)
    # @option options [Symbol, nil] :flip Flip transformation (:horizontal, :vertical, :both)
    # @option options [Integer, nil] :rotate Rotation (90, 180, 270)
    # @option options [Boolean] :fixed_width Fixed width (default: false)
    # @option options [String, nil] :container_classes Additional CSS classes
    # @return [String] Rendered HTML
    #
    # @example Default icon
    #   <%= bui_fa_icon("user") %>
    #
    # @example Solid icon with color and size
    #   <%= bui_fa_icon("heart", style: :solid, variant: :danger, size: :lg) %>
    #
    # @example Spinning icon
    #   <%= bui_fa_icon("spinner", style: :solid, spin: true) %>
    def bui_fa_icon(name, **options)
      render BetterUi::FaIconComponent.new(name: name, **options)
    end

    # Renders a badge component.
    #
    # @param options [Hash] Options passed to BadgeComponent
    # @option options [Symbol] :variant Color variant (:primary, :secondary, :accent, :success, :danger, :warning, :info, :light, :dark)
    # @option options [Symbol] :style Badge style (:solid, :outline, :soft, :ghost)
    # @option options [Symbol] :size Size (:xs, :sm, :md, :lg)
    # @option options [Boolean] :pill Pill shape (default: true)
    # @option options [Boolean] :dot Show dot indicator
    # @option options [Integer, nil] :counter Show numeric counter
    # @yield Badge content
    # @return [String] Rendered HTML
    #
    # @example Simple badge
    #   <%= bui_badge(variant: :success) { "Active" } %>
    #
    # @example Counter badge
    #   <%= bui_badge(variant: :danger, counter: 5) %>
    #
    # @example Dot badge
    #   <%= bui_badge(variant: :success, dot: true) %>
    def bui_badge(**options, &block)
      render BetterUi::BadgeComponent.new(**options), &block
    end

    # Renders a divider component for visually separating content.
    #
    # @param options [Hash] Options passed to DividerComponent
    # @option options [Symbol] :orientation Direction (:horizontal, :vertical)
    # @option options [Symbol] :style Border style (:solid, :dashed, :dotted)
    # @option options [Symbol, nil] :variant Color variant (nil for default gray)
    # @option options [Symbol] :size Thickness (:xs, :sm, :md)
    # @option options [String, nil] :label Centered text label
    # @option options [Symbol] :label_position Label alignment (:left, :center, :right)
    # @option options [Symbol] :spacing Outer margins (:xs, :sm, :md, :lg, :xl)
    # @return [String] Rendered HTML
    #
    # @example Basic divider
    #   <%= bui_divider %>
    #
    # @example Dashed divider with label
    #   <%= bui_divider(style: :dashed, label: "OR", variant: :primary) %>
    #
    # @example Vertical divider
    #   <%= bui_divider(orientation: :vertical) %>
    def bui_divider(**options)
      render BetterUi::DividerComponent.new(**options)
    end

    # Renders a tooltip component that wraps content and shows a tooltip on hover.
    #
    # @param text [String] Tooltip content (required)
    # @param options [Hash] Options passed to TooltipComponent
    # @option options [Symbol] :position Tooltip position (:top, :right, :bottom, :left)
    # @option options [Symbol] :variant Tooltip style (:dark, :light)
    # @option options [Symbol] :size Tooltip size (:sm, :md)
    # @option options [String, nil] :container_classes Additional CSS classes
    # @yield Content to wrap with the tooltip
    # @return [String] Rendered HTML
    #
    # @example Simple tooltip
    #   <%= bui_tooltip("Save changes") { bui_button(variant: :primary) { "Save" } } %>
    #
    # @example Tooltip with position
    #   <%= bui_tooltip("Delete item", position: :bottom, variant: :light) do %>
    #     <button>Delete</button>
    #   <% end %>
    def bui_tooltip(text, **options, &block)
      render BetterUi::TooltipComponent.new(text: text, **options), &block
    end

    # ============================================
    # Form Components
    # ============================================

    # Renders a text input component.
    #
    # @param name [String] Input name attribute
    # @param options [Hash] Options passed to Forms::TextInputComponent
    # @option options [String, nil] :value Input value
    # @option options [String, nil] :label Label text
    # @option options [String, nil] :hint Hint text
    # @option options [String, nil] :placeholder Placeholder text
    # @option options [Symbol] :size Size (:xs, :sm, :md, :lg, :xl)
    # @option options [Boolean] :disabled Disabled state
    # @option options [Boolean] :readonly Readonly state
    # @option options [Boolean] :required Required field
    # @option options [Array<String>, String, nil] :errors Error messages
    # @yield [input] Block with input slots
    # @return [String] Rendered HTML
    #
    # @example Basic text input
    #   <%= bui_text_input("email", label: "Email", placeholder: "you@example.com") %>
    #
    # @example With icon
    #   <%= bui_text_input("search") do |input| %>
    #     <% input.with_prefix_icon { icon_svg } %>
    #   <% end %>
    def bui_text_input(name, **options, &block)
      render BetterUi::Forms::TextInputComponent.new(name: name, **options), &block
    end

    # Renders an email input component.
    #
    # @param name [String] Input name attribute
    # @param options [Hash] Options passed to Forms::TextInputComponent (see {#bui_text_input})
    # @yield [input] Block with input slots
    # @return [String] Rendered HTML
    #
    # @example Email input
    #   <%= bui_email_input("email", label: "Email", placeholder: "you@example.com") %>
    def bui_email_input(name, **options, &block)
      render BetterUi::Forms::TextInputComponent.new(name: name, type: :email, **options), &block
    end

    # Renders a telephone input component.
    #
    # @param name [String] Input name attribute
    # @param options [Hash] Options passed to Forms::TextInputComponent (see {#bui_text_input})
    # @yield [input] Block with input slots
    # @return [String] Rendered HTML
    #
    # @example Telephone input
    #   <%= bui_tel_input("phone", label: "Phone", placeholder: "+1 (555) 000-0000") %>
    def bui_tel_input(name, **options, &block)
      render BetterUi::Forms::TextInputComponent.new(name: name, type: :tel, **options), &block
    end

    # Renders a date input component.
    #
    # @param name [String] Input name attribute
    # @param options [Hash] Options passed to Forms::TextInputComponent (see {#bui_text_input})
    # @yield [input] Block with input slots
    # @return [String] Rendered HTML
    #
    # @example Date input
    #   <%= bui_date_input("birthday", label: "Date of Birth") %>
    def bui_date_input(name, **options, &block)
      render BetterUi::Forms::TextInputComponent.new(name: name, type: :date, **options), &block
    end

    # Renders a time input component.
    #
    # @param name [String] Input name attribute
    # @param options [Hash] Options passed to Forms::TextInputComponent (see {#bui_text_input})
    # @yield [input] Block with input slots
    # @return [String] Rendered HTML
    #
    # @example Time input
    #   <%= bui_time_input("start_time", label: "Start Time") %>
    def bui_time_input(name, **options, &block)
      render BetterUi::Forms::TextInputComponent.new(name: name, type: :time, **options), &block
    end

    # Renders a number input component.
    #
    # @param name [String] Input name attribute
    # @param options [Hash] Options passed to Forms::NumberInputComponent
    # @option options [Numeric, nil] :value Input value
    # @option options [String, nil] :label Label text
    # @option options [Numeric, nil] :min Minimum value
    # @option options [Numeric, nil] :max Maximum value
    # @option options [Numeric, nil] :step Step value
    # @option options [Boolean] :show_spinner Show up/down arrows (default: true)
    # @yield [input] Block with input slots
    # @return [String] Rendered HTML
    #
    # @example Number input with range
    #   <%= bui_number_input("quantity", min: 1, max: 100, label: "Quantity") %>
    #
    # @example Price input
    #   <%= bui_number_input("price", step: 0.01) do |input| %>
    #     <% input.with_prefix_icon { "$" } %>
    #   <% end %>
    def bui_number_input(name, **options, &block)
      render BetterUi::Forms::NumberInputComponent.new(name: name, **options), &block
    end

    # Renders a password input component with visibility toggle.
    #
    # @param name [String] Input name attribute
    # @param options [Hash] Options passed to Forms::PasswordInputComponent
    # @option options [String, nil] :label Label text
    # @option options [String, nil] :hint Hint text
    # @option options [Symbol] :size Size (:xs, :sm, :md, :lg, :xl)
    # @yield [input] Block with input slots
    # @return [String] Rendered HTML
    #
    # @example Password input
    #   <%= bui_password_input("password", label: "Password", hint: "Min 8 characters") %>
    def bui_password_input(name, **options, &block)
      render BetterUi::Forms::PasswordInputComponent.new(name: name, **options), &block
    end

    # Renders a textarea component.
    #
    # @param name [String] Input name attribute
    # @param options [Hash] Options passed to Forms::TextareaComponent
    # @option options [String, nil] :value Textarea content
    # @option options [String, nil] :label Label text
    # @option options [Integer] :rows Number of visible rows (default: 4)
    # @option options [Integer, nil] :cols Width in characters
    # @option options [Integer, nil] :maxlength Maximum characters
    # @option options [Symbol] :resize Resize behavior (:none, :vertical, :horizontal, :both)
    # @yield [textarea] Block with textarea slots
    # @return [String] Rendered HTML
    #
    # @example Textarea with maxlength
    #   <%= bui_textarea("bio", rows: 6, maxlength: 500, label: "Bio") %>
    def bui_textarea(name, **options, &block)
      render BetterUi::Forms::TextareaComponent.new(name: name, **options), &block
    end

    # Renders a checkbox component.
    #
    # @param name [String] Input name attribute
    # @param options [Hash] Options passed to Forms::CheckboxComponent
    # @option options [String] :value Value when checked (default: "1")
    # @option options [Boolean] :checked Checked state
    # @option options [String, nil] :label Label text
    # @option options [String, nil] :hint Hint text
    # @option options [Symbol] :variant Color variant (:primary, :secondary, etc.)
    # @option options [Symbol] :size Size (:xs, :sm, :md, :lg, :xl)
    # @option options [Symbol] :label_position Label position (:left, :right)
    # @option options [Boolean] :disabled Disabled state
    # @option options [Boolean] :readonly Readonly state
    # @option options [Boolean] :required Required field
    # @option options [Array<String>, String, nil] :errors Error messages
    # @return [String] Rendered HTML
    #
    # @example Basic checkbox
    #   <%= bui_checkbox("newsletter", label: "Subscribe to newsletter") %>
    #
    # @example Checkbox with variant
    #   <%= bui_checkbox("active", label: "Active", variant: :success, checked: true) %>
    def bui_checkbox(name, **options)
      render BetterUi::Forms::CheckboxComponent.new(name: name, **options)
    end

    # Renders a checkbox group component.
    #
    # @param name [String] Input name attribute (will have [] appended for array submission)
    # @param collection [Array] Collection of options (values or [label, value] pairs)
    # @param options [Hash] Options passed to Forms::CheckboxGroupComponent
    # @option options [Array] :selected Currently selected values
    # @option options [String, nil] :legend Legend text for the fieldset
    # @option options [String, nil] :hint Hint text
    # @option options [Symbol] :variant Color variant (:primary, :secondary, etc.)
    # @option options [Symbol] :size Size (:xs, :sm, :md, :lg, :xl)
    # @option options [Symbol] :orientation Layout orientation (:vertical, :horizontal)
    # @option options [Boolean] :disabled Disabled state
    # @option options [Boolean] :required Required field
    # @option options [Array<String>, String, nil] :errors Error messages
    # @return [String] Rendered HTML
    #
    # @example Basic checkbox group
    #   <%= bui_checkbox_group("roles", ["Admin", "Editor", "Viewer"], legend: "Roles") %>
    #
    # @example With label/value pairs and selected values
    #   <%= bui_checkbox_group("permissions",
    #     [["Read", "read"], ["Write", "write"]],
    #     selected: ["read"],
    #     orientation: :horizontal
    #   ) %>
    def bui_checkbox_group(name, collection, **options)
      render BetterUi::Forms::CheckboxGroupComponent.new(name: name, collection: collection, **options)
    end

    # Renders a custom select dropdown component.
    #
    # @param name [String] Input name attribute
    # @param collection [Array] Collection of options (values or [label, value] pairs)
    # @param options [Hash] Options passed to Forms::SelectComponent
    # @option options [String, nil] :value Selected value
    # @option options [String, nil] :label Label text
    # @option options [String, nil] :hint Hint text
    # @option options [String, nil] :placeholder Placeholder text
    # @option options [Symbol] :size Size (:xs, :sm, :md, :lg, :xl)
    # @option options [Boolean] :disabled Disabled state
    # @option options [Boolean] :readonly Readonly state
    # @option options [Boolean] :required Required field
    # @option options [Boolean] :clearable Show clear button
    # @option options [String, nil] :dropdown_classes Custom dropdown classes
    # @option options [Array<String>, String, nil] :errors Error messages
    # @yield [select] Block with select slots (e.g., prefix_icon)
    # @return [String] Rendered HTML
    #
    # @example Basic select
    #   <%= bui_select("country", [["Italy", "it"], ["France", "fr"]], label: "Country") %>
    #
    # @example With prefix icon
    #   <%= bui_select("country", [["Italy", "it"]], clearable: true) do |s| %>
    #     <% s.with_prefix_icon { icon_svg } %>
    #   <% end %>
    def bui_select(name, collection, **options, &block)
      render BetterUi::Forms::SelectComponent.new(name: name, collection: collection, **options), &block
    end

    # ============================================
    # Drawer Components
    # ============================================

    # Renders a drawer layout component with header, sidebar, and main content areas.
    #
    # @param options [Hash] Options passed to Drawer::LayoutComponent
    # @option options [Symbol] :sidebar_position Sidebar position (:left, :right)
    # @option options [Symbol] :sidebar_breakpoint Desktop breakpoint (:md, :lg, :xl)
    # @yield [layout] Block with layout slots
    # @yieldparam layout [BetterUi::Drawer::LayoutComponent] The layout component
    # @return [String] Rendered HTML
    #
    # @example Full layout
    #   <%= bui_drawer_layout(sidebar_position: :left) do |layout| %>
    #     <% layout.with_header { render_header } %>
    #     <% layout.with_sidebar { render_sidebar } %>
    #     <% layout.with_main { yield } %>
    #   <% end %>
    def bui_drawer_layout(**options, &block)
      render BetterUi::Drawer::LayoutComponent.new(**options), &block
    end

    # Renders a drawer sidebar component.
    #
    # @param options [Hash] Options passed to Drawer::SidebarComponent
    # @option options [Symbol] :variant Color variant (:light, :dark, :primary)
    # @option options [Symbol] :position Position (:left, :right)
    # @option options [Symbol] :width Width (:sm, :md, :lg)
    # @option options [Boolean] :collapsible Allow collapsing
    # @yield [sidebar] Block with sidebar slots
    # @return [String] Rendered HTML
    #
    # @example Sidebar with navigation
    #   <%= bui_drawer_sidebar(variant: :dark) do |sidebar| %>
    #     <% sidebar.with_header { "App Name" } %>
    #     <% sidebar.with_navigation { render_nav } %>
    #     <% sidebar.with_footer { render_footer } %>
    #   <% end %>
    def bui_drawer_sidebar(**options, &block)
      render BetterUi::Drawer::SidebarComponent.new(**options), &block
    end

    # Renders a drawer header component.
    #
    # @param options [Hash] Options passed to Drawer::HeaderComponent
    # @option options [Symbol] :variant Color variant (:light, :dark, :transparent, :primary)
    # @option options [Boolean] :sticky Sticky positioning (default: true)
    # @option options [Symbol] :height Height (:sm, :md, :lg)
    # @yield [header] Block with header slots
    # @return [String] Rendered HTML
    #
    # @example Header with logo and navigation
    #   <%= bui_drawer_header(variant: :light) do |header| %>
    #     <% header.with_logo { image_tag("logo.svg") } %>
    #     <% header.with_navigation { render_nav } %>
    #     <% header.with_actions { render_actions } %>
    #     <% header.with_mobile_menu_button { hamburger_button } %>
    #   <% end %>
    def bui_drawer_header(**options, &block)
      render BetterUi::Drawer::HeaderComponent.new(**options), &block
    end

    # Renders a drawer navigation item.
    #
    # @param label [String] Item label text
    # @param href [String] Link URL
    # @param options [Hash] Options passed to Drawer::NavItemComponent
    # @option options [Boolean] :active Active state
    # @option options [Symbol, nil] :method HTTP method (:get, :post, :put, :patch, :delete)
    # @option options [Symbol] :variant Color variant (:light, :dark, :primary)
    # @yield [item] Block with item slots
    # @return [String] Rendered HTML
    #
    # @example Navigation item with icon
    #   <%= bui_drawer_nav_item("Dashboard", dashboard_path, active: true) do |item| %>
    #     <% item.with_icon { dashboard_icon } %>
    #   <% end %>
    def bui_drawer_nav_item(label, href, **options, &block)
      render BetterUi::Drawer::NavItemComponent.new(label: label, href: href, **options), &block
    end

    # Renders a drawer navigation group with title and items.
    #
    # @param options [Hash] Options passed to Drawer::NavGroupComponent
    # @option options [String, nil] :title Group title
    # @option options [Symbol] :variant Color variant (:light, :dark, :primary)
    # @yield [group] Block with group slots
    # @return [String] Rendered HTML
    #
    # @example Navigation group with items
    #   <%= bui_drawer_nav_group(title: "Main Menu") do |group| %>
    #     <% group.with_item(label: "Home", href: root_path) %>
    #     <% group.with_item(label: "Settings", href: settings_path) %>
    #   <% end %>
    def bui_drawer_nav_group(**options, &block)
      render BetterUi::Drawer::NavGroupComponent.new(**options), &block
    end

    # ============================================
    # Dialog Components
    # ============================================

    # Renders a dialog component.
    #
    # @param options [Hash] Options passed to Dialog::DialogComponent
    # @option options [Symbol] :size Dialog width (:sm, :md, :lg, :xl, :xxl, :full)
    # @option options [Boolean] :close_on_backdrop Close on backdrop click (default: true)
    # @option options [Boolean] :close_on_escape Close on Escape key (default: true)
    # @option options [Boolean] :open Initial open state (default: false)
    # @option options [Boolean] :show_close_button Show X close button (default: true)
    # @yield [dialog] Block with dialog slots
    # @yieldparam dialog [BetterUi::Dialog::DialogComponent] The dialog component
    # @return [String] Rendered HTML
    #
    # @example Dialog with trigger
    #   <%= bui_dialog(size: :md) do |d| %>
    #     <% d.with_trigger { bui_button(variant: :primary) { "Open" } } %>
    #     <% d.with_header { "Dialog Title" } %>
    #     <% d.with_body { "Dialog content" } %>
    #     <% d.with_footer { bui_button(variant: :primary) { "Save" } } %>
    #   <% end %>
    def bui_dialog(**options, &block)
      render BetterUi::Dialog::DialogComponent.new(**options), &block
    end

    # Renders an alert dialog component.
    #
    # @param options [Hash] Options passed to Dialog::AlertComponent
    # @option options [Symbol] :variant Color variant (:primary, :success, :danger, :warning, :info, etc.)
    # @option options [String, nil] :title Alert title
    # @option options [String, nil] :text Alert message text
    # @option options [Boolean] :icon Show icon (default: true)
    # @option options [String] :button_label OK button label (default: "OK")
    # @option options [Symbol] :size Dialog width (default: :sm)
    # @yield [alert] Block with alert slots
    # @return [String] Rendered HTML
    #
    # @example Success alert
    #   <%= bui_dialog_alert(variant: :success, title: "Saved!", text: "Your changes were saved.") do |a| %>
    #     <% a.with_trigger { bui_button(variant: :success) { "Save" } } %>
    #   <% end %>
    def bui_dialog_alert(**options, &block)
      render BetterUi::Dialog::AlertComponent.new(**options), &block
    end

    # Renders a confirm dialog component.
    #
    # @param options [Hash] Options passed to Dialog::ConfirmComponent
    # @option options [Symbol] :variant Color variant (default: :warning)
    # @option options [String, nil] :title Confirm title
    # @option options [String, nil] :text Confirm message text
    # @option options [Boolean] :icon Show icon (default: true)
    # @option options [String] :confirm_label Confirm button label (default: "Confirm")
    # @option options [String] :cancel_label Cancel button label (default: "Cancel")
    # @option options [Symbol] :size Dialog width (default: :sm)
    # @yield [confirm] Block with confirm slots
    # @return [String] Rendered HTML
    #
    # @example Danger confirm
    #   <%= bui_dialog_confirm(variant: :danger, title: "Delete?", text: "This cannot be undone.") do |c| %>
    #     <% c.with_trigger { bui_button(variant: :danger) { "Delete" } } %>
    #   <% end %>
    def bui_dialog_confirm(**options, &block)
      render BetterUi::Dialog::ConfirmComponent.new(**options), &block
    end

    # ============================================
    # Table Components
    # ============================================

    # Renders a table component.
    #
    # Supports two modes:
    # - **Slot-based**: Define header, rows, and cells manually using slots
    # - **Collection-based**: Pass a collection and column definitions
    #
    # @param options [Hash] Options passed to Table::TableComponent
    # @option options [Symbol] :variant Color variant (:primary, :secondary, etc.)
    # @option options [Symbol] :style Table style (:default, :bordered)
    # @option options [Symbol] :size Size (:xs, :sm, :md, :lg, :xl)
    # @option options [Boolean] :striped Alternating row backgrounds
    # @option options [Boolean] :hoverable Row hover effect
    # @option options [Boolean] :responsive Horizontal scroll wrapper (default: true)
    # @option options [String, nil] :caption Table caption text
    # @option options [Array, nil] :collection Data collection (triggers collection mode)
    # @option options [Proc, nil] :row_html Proc returning a Hash of HTML attributes for each <tr> in collection mode.
    #   Accepts 1-arg `(item)` or 2-arg `(item, index)`. Return nil for no-op. Classes are merged with built-in classes.
    # @yield [table] Block with table slots
    # @yieldparam table [BetterUi::Table::TableComponent] The table component
    # @return [String] Rendered HTML
    #
    # @example Slot-based table
    #   <%= bui_table(variant: :primary, striped: true) do |t| %>
    #     <% t.with_header do |h| %>
    #       <% h.with_cell(label: "Name") %>
    #       <% h.with_cell(label: "Email") %>
    #     <% end %>
    #     <% @users.each do |user| %>
    #       <% t.with_row do |r| %>
    #         <% r.with_cell { user.name } %>
    #         <% r.with_cell { user.email } %>
    #       <% end %>
    #     <% end %>
    #   <% end %>
    #
    # @example Collection-based table
    #   <%= bui_table(collection: @users, variant: :primary) do |t| %>
    #     <% t.with_column(key: :name, label: "Name") %>
    #     <% t.with_column(key: :email, label: "Email") %>
    #   <% end %>
    def bui_table(**options, &block)
      render BetterUi::Table::TableComponent.new(**options), &block
    end

    # ============================================
    # Tabs Components
    # ============================================

    # Renders a tabs container component.
    #
    # @param options [Hash] Options passed to Tabs::ContainerComponent
    # @option options [Symbol] :mode Operating mode (:js, :turbo)
    # @option options [Symbol] :style Visual style (:underline, :pills, :bordered)
    # @option options [Symbol] :variant Color variant (:primary, :secondary, etc.)
    # @option options [Symbol] :size Size (:xs, :sm, :md, :lg, :xl)
    # @option options [Symbol] :alignment Tab alignment (:start, :center, :end, :stretch)
    # @option options [Symbol] :position Tab list position (:top, :bottom, :left, :right)
    # @option options [String, nil] :frame_id Turbo Frame ID (required for turbo mode)
    # @option options [String, nil] :default_tab ID of the default active tab
    # @option options [Boolean] :persist Persist active tab state
    # @option options [String, nil] :persist_key localStorage key for persistence
    # @yield [tabs] Block with tabs slots
    # @yieldparam tabs [BetterUi::Tabs::ContainerComponent] The tabs container
    # @return [String] Rendered HTML
    #
    # @example JS mode tabs
    #   <%= bui_tabs(mode: :js, style: :underline) do |tabs| %>
    #     <% tabs.with_tab(id: "profile", label: "Profile", active: true) %>
    #     <% tabs.with_tab(id: "settings", label: "Settings") %>
    #     <% tabs.with_panel(id: "profile", active: true) { "Profile content" } %>
    #     <% tabs.with_panel(id: "settings") { "Settings content" } %>
    #   <% end %>
    #
    # @example Turbo mode tabs
    #   <%= bui_tabs(mode: :turbo, frame_id: "tab-content") do |tabs| %>
    #     <% tabs.with_tab(id: "profile", label: "Profile", href: profile_path, active: true) %>
    #     <% tabs.with_tab(id: "settings", label: "Settings", href: settings_path) %>
    #   <% end %>
    def bui_tabs(**options, &block)
      render BetterUi::Tabs::ContainerComponent.new(**options), &block
    end

    # Renders a standalone tab component (used outside container context).
    #
    # @param id [String] Unique identifier for this tab
    # @param label [String] Display text for the tab
    # @param options [Hash] Options passed to Tabs::TabComponent
    # @option options [String, nil] :href URL for Turbo mode navigation
    # @option options [Boolean] :active Whether this tab is initially active
    # @option options [Boolean] :disabled Whether this tab is disabled
    # @yield [tab] Block with tab slots
    # @return [String] Rendered HTML
    #
    # @example Tab with icon
    #   <%= bui_tab(id: "messages", label: "Messages") do |tab| %>
    #     <% tab.with_icon { icon_svg } %>
    #     <% tab.with_badge { "3" } %>
    #   <% end %>
    def bui_tab(id:, label:, **options, &block)
      render BetterUi::Tabs::TabComponent.new(id: id, label: label, **options), &block
    end

    # Renders a standalone tab panel component (used outside container context).
    #
    # @param id [String] Unique identifier matching the corresponding tab
    # @param options [Hash] Options passed to Tabs::PanelComponent
    # @option options [Boolean] :active Whether this panel is initially visible
    # @yield Panel content
    # @return [String] Rendered HTML
    #
    # @example Basic panel
    #   <%= bui_tab_panel(id: "profile", active: true) do %>
    #     <p>Profile content here</p>
    #   <% end %>
    def bui_tab_panel(id:, **options, &block)
      render BetterUi::Tabs::PanelComponent.new(id: id, **options), &block
    end

    # ============================================
    # Breadcrumb Components
    # ============================================

    # Renders a breadcrumb navigation component.
    #
    # @param options [Hash] Options passed to Breadcrumb::BreadcrumbComponent
    # @option options [Symbol] :separator Separator type (:slash, :chevron, :dot)
    # @option options [Symbol] :size Text size (:sm, :md, :lg)
    # @option options [String, nil] :container_classes Additional CSS classes for the nav element
    # @yield [breadcrumb] Block with breadcrumb item slots
    # @yieldparam breadcrumb [BetterUi::Breadcrumb::BreadcrumbComponent] The breadcrumb component
    # @return [String] Rendered HTML
    #
    # @example Basic breadcrumb
    #   <%= bui_breadcrumb(separator: :chevron) do |bc| %>
    #     <% bc.with_item(label: "Home", href: root_path) %>
    #     <% bc.with_item(label: "Products", href: products_path) %>
    #     <% bc.with_item(label: "Widget") %>
    #   <% end %>
    def bui_breadcrumb(**options, &block)
      render BetterUi::Breadcrumb::BreadcrumbComponent.new(**options), &block
    end

    # ============================================
    # Dropdown Components
    # ============================================

    # Renders a dropdown menu component for actions, navigation, or context menus.
    #
    # @param options [Hash] Options passed to Dropdown::DropdownComponent
    # @option options [Symbol] :size Menu width (:sm, :md, :lg)
    # @option options [Symbol] :placement Menu position (:bottom_start, :bottom_end, :top_start, :top_end)
    # @option options [Symbol, Boolean] :shadow Shadow size (:sm, :md, :lg, :xl, or false)
    # @option options [Boolean] :auto_close Close on click outside (default: true)
    # @option options [Boolean] :close_on_item_click Close on item click (default: true)
    # @option options [String, nil] :container_classes Additional CSS classes for root element
    # @option options [String, nil] :menu_classes Additional CSS classes for menu panel
    # @yield [dropdown] Block with dropdown slots
    # @yieldparam dropdown [BetterUi::Dropdown::DropdownComponent] The dropdown component
    # @return [String] Rendered HTML
    #
    # @example Action dropdown
    #   <%= bui_dropdown(placement: :bottom_start) do |d| %>
    #     <% d.with_trigger do %>
    #       <%= bui_button(variant: :primary) { "Options" } %>
    #     <% end %>
    #     <% d.with_header(text: "Actions") %>
    #     <% d.with_item(href: edit_path) { "Edit" } %>
    #     <% d.with_divider %>
    #     <% d.with_item(href: delete_path, variant: :danger) { "Delete" } %>
    #   <% end %>
    def bui_dropdown(**options, &block)
      render BetterUi::Dropdown::DropdownComponent.new(**options), &block
    end
  end
end
