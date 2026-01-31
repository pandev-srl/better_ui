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
  end
end
