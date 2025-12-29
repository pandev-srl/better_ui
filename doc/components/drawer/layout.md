# Drawer::LayoutComponent

A responsive layout component that composes header and sidebar with mobile drawer support. Provides a complete page layout with sticky header, responsive sidebar, and main content area.

## Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `sidebar_position` | Symbol | `:left` | Sidebar position: `:left`, `:right` |
| `sidebar_breakpoint` | Symbol | `:lg` | Desktop breakpoint: `:md`, `:lg`, `:xl` |
| `container_classes` | String | `nil` | Additional CSS classes for outer container |
| `main_classes` | String | `nil` | Additional CSS classes for main content area |
| `**options` | Hash | `{}` | Additional HTML attributes |

## Slots

- `header` - Renders a HeaderComponent for the top navigation
- `sidebar` - Renders a SidebarComponent for the side navigation
- `main` - Main content area

## Usage

### Helper Syntax

#### Basic Layout

```erb
<%= bui_drawer_layout do |layout| %>
  <% layout.with_header(sticky: true) do |header| %>
    <% header.with_logo { image_tag("logo.svg") } %>
    <% header.with_mobile_menu_button do %>
      <button data-action="click->better-ui--drawer--layout#toggle">
        <svg class="w-6 h-6"><!-- Menu icon --></svg>
      </button>
    <% end %>
  <% end %>

  <% layout.with_sidebar do |sidebar| %>
    <% sidebar.with_navigation { render "shared/nav" } %>
  <% end %>

  <% layout.with_main do %>
    <%= yield %>
  <% end %>
<% end %>
```

#### Right-Positioned Sidebar

```erb
<%= bui_drawer_layout(sidebar_position: :right) do |layout| %>
  <% layout.with_sidebar(position: :right) do |sidebar| %>
    <% sidebar.with_navigation { "Settings Panel" } %>
  <% end %>

  <% layout.with_main { "Content" } %>
<% end %>
```

#### With Different Breakpoint

```erb
<%= bui_drawer_layout(sidebar_breakpoint: :xl) do |layout| %>
  <%# Sidebar will become a drawer on screens smaller than xl (1280px) %>
  <% layout.with_header { ... } %>
  <% layout.with_sidebar { ... } %>
  <% layout.with_main { ... } %>
<% end %>
```

### Direct Render

```erb
<%= render BetterUi::Drawer::LayoutComponent.new do |layout| %>
  <% layout.with_header(sticky: true) do |header| %>
    <% header.with_logo { image_tag("logo.svg") } %>
    <% header.with_mobile_menu_button do %>
      <button data-action="click->better-ui--drawer--layout#toggle">
        <svg class="w-6 h-6"><!-- Menu icon --></svg>
      </button>
    <% end %>
  <% end %>

  <% layout.with_sidebar do |sidebar| %>
    <% sidebar.with_navigation { render "shared/nav" } %>
  <% end %>

  <% layout.with_main do %>
    <%= yield %>
  <% end %>
<% end %>
```

## Stimulus Controller

The layout component includes a `better-ui--drawer--layout` Stimulus controller that handles:
- Mobile drawer toggle (open/close)
- Overlay click to close
- Responsive behavior at breakpoints
- Body scroll lock when drawer is open

### Actions

- `toggle` - Toggles the drawer open/closed state

### Usage

```erb
<button data-action="click->better-ui--drawer--layout#toggle">
  Toggle Drawer
</button>
```

## Common Patterns

### Application Layout

```erb
<%# app/views/layouts/application.html.erb %>
<!DOCTYPE html>
<html>
  <head>
    <%= yield :head %>
  </head>
  <body>
    <%= bui_drawer_layout do |layout| %>
      <% layout.with_header(sticky: true, variant: :light) do |header| %>
        <% header.with_logo do %>
          <%= link_to root_path do %>
            <%= image_tag "logo.svg", class: "h-8" %>
          <% end %>
        <% end %>

        <% header.with_navigation do %>
          <nav class="hidden lg:flex gap-6">
            <%= link_to "Dashboard", dashboard_path %>
            <%= link_to "Projects", projects_path %>
          </nav>
        <% end %>

        <% header.with_mobile_menu_button do %>
          <button data-action="click->better-ui--drawer--layout#toggle" class="lg:hidden p-2">
            <svg class="w-6 h-6"><!-- Hamburger icon --></svg>
          </button>
        <% end %>

        <% header.with_actions do %>
          <%= render "shared/user_menu" %>
        <% end %>
      <% end %>

      <% layout.with_sidebar(variant: :light) do |sidebar| %>
        <% sidebar.with_navigation do %>
          <%= render "shared/sidebar_nav" %>
        <% end %>

        <% sidebar.with_footer do %>
          <%= render "shared/sidebar_footer" %>
        <% end %>
      <% end %>

      <% layout.with_main do %>
        <div class="p-6">
          <%= yield %>
        </div>
      <% end %>
    <% end %>
  </body>
</html>
```

### Admin Dashboard

```erb
<%= bui_drawer_layout(sidebar_breakpoint: :lg) do |layout| %>
  <% layout.with_header(variant: :dark, sticky: true) do |header| %>
    <% header.with_logo { "Admin Panel" } %>
    <% header.with_mobile_menu_button do %>
      <button data-action="click->better-ui--drawer--layout#toggle" class="text-white">
        <svg class="w-6 h-6"><!-- Menu --></svg>
      </button>
    <% end %>
  <% end %>

  <% layout.with_sidebar(variant: :dark, width: :md) do |sidebar| %>
    <% sidebar.with_navigation do %>
      <%= bui_drawer_nav_group(title: "Dashboard", variant: :dark) do |group| %>
        <% group.with_item(label: "Overview", href: admin_path, active: true) %>
        <% group.with_item(label: "Analytics", href: admin_analytics_path) %>
      <% end %>

      <%= bui_drawer_nav_group(title: "Management", variant: :dark) do |group| %>
        <% group.with_item(label: "Users", href: admin_users_path) %>
        <% group.with_item(label: "Settings", href: admin_settings_path) %>
      <% end %>
    <% end %>
  <% end %>

  <% layout.with_main do %>
    <div class="p-8">
      <%= yield %>
    </div>
  <% end %>
<% end %>
```

## Related

- [HeaderComponent](header.md) - Header section of the layout
- [SidebarComponent](sidebar.md) - Sidebar/drawer section
- [NavGroupComponent](nav_group.md) - Navigation groups for the sidebar
- [NavItemComponent](nav_item.md) - Individual navigation items
