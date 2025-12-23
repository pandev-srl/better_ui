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
  end
end
