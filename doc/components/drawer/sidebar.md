# Drawer::SidebarComponent

A flexible sidebar component for drawer layouts with support for header, navigation, and footer sections. Configurable width and visual variants.

## Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `variant` | Symbol | `:light` | Visual variant: `:light`, `:dark`, `:primary` |
| `position` | Symbol | `:left` | Position: `:left`, `:right` |
| `width` | Symbol | `:md` | Width: `:sm` (64px), `:md` (256px), `:lg` (320px) |
| `collapsible` | Boolean | `true` | Whether sidebar can be collapsed |
| `container_classes` | String | `nil` | Additional CSS classes for container |
| `header_classes` | String | `nil` | Additional CSS classes for header section |
| `navigation_classes` | String | `nil` | Additional CSS classes for navigation |
| `footer_classes` | String | `nil` | Additional CSS classes for footer section |
| `**options` | Hash | `{}` | Additional HTML attributes |

## Slots

- `header` - Sidebar header section (logo, brand)
- `navigation` - Main navigation content
- `footer` - Footer section (user info, settings)

## Usage

### Helper Syntax

#### Basic Sidebar

```erb
<%= bui_drawer_sidebar(variant: :light, width: :md) do |sidebar| %>
  <% sidebar.with_header { image_tag("logo.svg") } %>

  <% sidebar.with_navigation do %>
    <%= bui_drawer_nav_group(title: "Main") do |group| %>
      <% group.with_item(label: "Dashboard", href: dashboard_path, active: true) %>
      <% group.with_item(label: "Settings", href: settings_path) %>
    <% end %>
  <% end %>

  <% sidebar.with_footer { "User Info" } %>
<% end %>
```

#### Dark Sidebar

```erb
<%= bui_drawer_sidebar(variant: :dark) do |sidebar| %>
  <% sidebar.with_header do %>
    <div class="flex items-center gap-2 text-white">
      <%= image_tag "logo-white.svg", class: "h-8" %>
      <span class="font-bold">Admin</span>
    </div>
  <% end %>

  <% sidebar.with_navigation do %>
    <%= bui_drawer_nav_group(title: "Menu", variant: :dark) do |group| %>
      <% group.with_item(label: "Dashboard", href: "/") %>
      <% group.with_item(label: "Users", href: "/users") %>
    <% end %>
  <% end %>
<% end %>
```

#### Wide Sidebar

```erb
<%= bui_drawer_sidebar(width: :lg) do |sidebar| %>
  <% sidebar.with_navigation do %>
    <%# More space for detailed navigation %>
  <% end %>
<% end %>
```

#### Right-Positioned Sidebar

```erb
<%= bui_drawer_sidebar(position: :right, width: :md) do |sidebar| %>
  <% sidebar.with_header { "Settings" } %>
  <% sidebar.with_navigation { render "settings_nav" } %>
<% end %>
```

### Direct Render

```erb
<%= render BetterUi::Drawer::SidebarComponent.new(
  variant: :light,
  width: :md
) do |sidebar| %>
  <% sidebar.with_header { image_tag("logo.svg") } %>

  <% sidebar.with_navigation do %>
    <%= render BetterUi::Drawer::NavGroupComponent.new(title: "Main") do |group| %>
      <% group.with_item(label: "Dashboard", href: dashboard_path, active: true) %>
      <% group.with_item(label: "Settings", href: settings_path) %>
    <% end %>
  <% end %>

  <% sidebar.with_footer { "User Info" } %>
<% end %>
```

## Common Patterns

### Full Sidebar with All Sections

```erb
<%= bui_drawer_sidebar(variant: :light) do |sidebar| %>
  <% sidebar.with_header do %>
    <div class="flex items-center gap-3 px-4">
      <%= image_tag "logo.svg", class: "h-10" %>
      <span class="text-lg font-semibold">My App</span>
    </div>
  <% end %>

  <% sidebar.with_navigation do %>
    <%= bui_drawer_nav_group(title: "Overview") do |group| %>
      <% group.with_item(label: "Dashboard", href: dashboard_path, active: current_page?(dashboard_path)) do |item| %>
        <% item.with_icon do %>
          <svg class="w-5 h-5"><!-- Home icon --></svg>
        <% end %>
      <% end %>

      <% group.with_item(label: "Analytics", href: analytics_path) do |item| %>
        <% item.with_icon do %>
          <svg class="w-5 h-5"><!-- Chart icon --></svg>
        <% end %>
      <% end %>
    <% end %>

    <%= bui_drawer_nav_group(title: "Management") do |group| %>
      <% group.with_item(label: "Users", href: users_path) do |item| %>
        <% item.with_icon do %>
          <svg class="w-5 h-5"><!-- Users icon --></svg>
        <% end %>
        <% item.with_badge { User.count } %>
      <% end %>

      <% group.with_item(label: "Settings", href: settings_path) do |item| %>
        <% item.with_icon do %>
          <svg class="w-5 h-5"><!-- Cog icon --></svg>
        <% end %>
      <% end %>
    <% end %>
  <% end %>

  <% sidebar.with_footer do %>
    <div class="flex items-center gap-3 px-4 py-3 border-t">
      <%= image_tag current_user.avatar_url, class: "w-10 h-10 rounded-full" %>
      <div>
        <p class="font-medium"><%= current_user.name %></p>
        <p class="text-sm text-gray-500"><%= current_user.email %></p>
      </div>
    </div>
  <% end %>
<% end %>
```

### Settings Panel Sidebar

```erb
<%= bui_drawer_sidebar(position: :right, variant: :light) do |sidebar| %>
  <% sidebar.with_header do %>
    <div class="flex items-center justify-between px-4 py-3">
      <h2 class="text-lg font-semibold">Settings</h2>
      <button data-action="click->better-ui--drawer--layout#toggle">
        <svg class="w-5 h-5"><!-- Close icon --></svg>
      </button>
    </div>
  <% end %>

  <% sidebar.with_navigation do %>
    <div class="px-4 space-y-6">
      <section>
        <h3 class="font-medium mb-3">Appearance</h3>
        <%= bui_checkbox("dark_mode", label: "Dark mode") %>
        <%= bui_checkbox("compact_view", label: "Compact view") %>
      </section>

      <section>
        <h3 class="font-medium mb-3">Notifications</h3>
        <%= bui_checkbox("email_notifs", label: "Email notifications") %>
        <%= bui_checkbox("push_notifs", label: "Push notifications") %>
      </section>
    </div>
  <% end %>
<% end %>
```

## Related

- [LayoutComponent](layout.md) - Parent layout that contains sidebar
- [HeaderComponent](header.md) - Header companion to sidebar
- [NavGroupComponent](nav_group.md) - Navigation groups for sidebar
- [NavItemComponent](nav_item.md) - Individual navigation items
