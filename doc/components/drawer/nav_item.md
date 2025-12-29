# Drawer::NavItemComponent

A navigation item component for sidebar menus with icon, label, and badge support.

## Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `label` | String | Required | Link text |
| `href` | String | Required | Link URL |
| `active` | Boolean | `false` | Whether item is currently active |
| `method` | Symbol | `nil` | HTTP method: `:get`, `:post`, `:put`, `:patch`, `:delete` |
| `variant` | Symbol | `:light` | Color variant: `:light`, `:dark`, `:primary` |
| `container_classes` | String | `nil` | Additional CSS classes |
| `**options` | Hash | `{}` | Additional HTML attributes |

## Slots

- `icon` - Icon displayed before the label
- `badge` - Badge/counter displayed after the label

## Usage

### Helper Syntax

#### Basic Nav Item

```erb
<%= bui_drawer_nav_item("Dashboard", dashboard_path) %>
```

#### Active State

```erb
<%= bui_drawer_nav_item("Dashboard", dashboard_path, active: true) %>
```

#### With Dynamic Active State

```erb
<%= bui_drawer_nav_item("Dashboard", dashboard_path, active: current_page?(dashboard_path)) %>
```

#### With Icon

```erb
<%= bui_drawer_nav_item("Dashboard", dashboard_path, active: true) do |item| %>
  <% item.with_icon do %>
    <svg class="w-5 h-5"><!-- Dashboard icon --></svg>
  <% end %>
<% end %>
```

#### With Badge

```erb
<%= bui_drawer_nav_item("Messages", messages_path) do |item| %>
  <% item.with_icon { "📧" } %>
  <% item.with_badge { "5" } %>
<% end %>
```

#### With Icon and Badge

```erb
<%= bui_drawer_nav_item("Notifications", notifications_path) do |item| %>
  <% item.with_icon do %>
    <svg class="w-5 h-5"><!-- Bell icon --></svg>
  <% end %>
  <% item.with_badge do %>
    <span class="bg-red-500 text-white text-xs px-2 py-0.5 rounded-full">3</span>
  <% end %>
<% end %>
```

#### Logout with HTTP Method

```erb
<%= bui_drawer_nav_item("Logout", logout_path, method: :delete) do |item| %>
  <% item.with_icon do %>
    <svg class="w-5 h-5"><!-- Logout icon --></svg>
  <% end %>
<% end %>
```

#### Dark Variant

```erb
<%= bui_drawer_nav_item("Dashboard", dashboard_path, variant: :dark, active: true) do |item| %>
  <% item.with_icon do %>
    <svg class="w-5 h-5"><!-- Icon --></svg>
  <% end %>
<% end %>
```

### Direct Render

```erb
<%= render BetterUi::Drawer::NavItemComponent.new(
  label: "Dashboard",
  href: dashboard_path
) %>
```

```erb
<%= render BetterUi::Drawer::NavItemComponent.new(
  label: "Dashboard",
  href: dashboard_path,
  active: true
) do |item| %>
  <% item.with_icon do %>
    <svg class="w-5 h-5"><!-- icon --></svg>
  <% end %>
<% end %>
```

```erb
<%= render BetterUi::Drawer::NavItemComponent.new(
  label: "Messages",
  href: messages_path
) do |item| %>
  <% item.with_icon { "📧" } %>
  <% item.with_badge { "5" } %>
<% end %>
```

```erb
<%= render BetterUi::Drawer::NavItemComponent.new(
  label: "Logout",
  href: logout_path,
  method: :delete
) %>
```

## Common Patterns

### Navigation with Active State Detection

```erb
<% nav_items = [
  { label: "Dashboard", href: dashboard_path, icon: "home" },
  { label: "Projects", href: projects_path, icon: "folder" },
  { label: "Team", href: team_path, icon: "users" },
  { label: "Settings", href: settings_path, icon: "cog" }
] %>

<% nav_items.each do |item| %>
  <%= bui_drawer_nav_item(item[:label], item[:href], active: current_page?(item[:href])) do |nav| %>
    <% nav.with_icon { render "icons/#{item[:icon]}" } %>
  <% end %>
<% end %>
```

### Nav Items with Counts

```erb
<%= bui_drawer_nav_item("Inbox", inbox_path) do |item| %>
  <% item.with_icon do %>
    <svg class="w-5 h-5"><!-- Inbox icon --></svg>
  <% end %>
  <% item.with_badge do %>
    <span class="bg-primary-500 text-white text-xs px-2 py-0.5 rounded-full">
      <%= current_user.unread_messages_count %>
    </span>
  <% end %>
<% end %>

<%= bui_drawer_nav_item("Tasks", tasks_path) do |item| %>
  <% item.with_icon do %>
    <svg class="w-5 h-5"><!-- Tasks icon --></svg>
  <% end %>
  <% if current_user.pending_tasks_count > 0 %>
    <% item.with_badge do %>
      <span class="bg-warning-500 text-white text-xs px-2 py-0.5 rounded-full">
        <%= current_user.pending_tasks_count %>
      </span>
    <% end %>
  <% end %>
<% end %>
```

## Related

- [NavGroupComponent](nav_group.md) - Groups navigation items together
- [SidebarComponent](sidebar.md) - Contains navigation items
- [LayoutComponent](layout.md) - Full layout with sidebar
