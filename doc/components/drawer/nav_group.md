# Drawer::NavGroupComponent

A navigation group component for sidebar menus with a title and collection of items. Groups related navigation items together.

## Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `title` | String | `nil` | Group title (optional) |
| `variant` | Symbol | `:light` | Color variant: `:light`, `:dark`, `:primary` |
| `container_classes` | String | `nil` | Additional CSS classes |
| `**options` | Hash | `{}` | Additional HTML attributes |

## Slots

- `items` - Navigation items (renders NavItemComponent)

The `items` slot accepts the same parameters as `NavItemComponent`:
- `label` - Item label (required)
- `href` - Item URL (required)
- `active` - Whether item is active
- `method` - HTTP method

## Usage

### Helper Syntax

#### Basic Nav Group

```erb
<%= bui_drawer_nav_group(title: "Main") do |group| %>
  <% group.with_item(label: "Dashboard", href: dashboard_path, active: true) do |item| %>
    <% item.with_icon { "🏠" } %>
  <% end %>

  <% group.with_item(label: "Settings", href: settings_path) do |item| %>
    <% item.with_icon { "⚙️" } %>
  <% end %>
<% end %>
```

#### Without Title

```erb
<%= bui_drawer_nav_group do |group| %>
  <% group.with_item(label: "Home", href: root_path) %>
  <% group.with_item(label: "Profile", href: profile_path) %>
<% end %>
```

#### Dark Variant

```erb
<%= bui_drawer_nav_group(title: "Menu", variant: :dark) do |group| %>
  <% group.with_item(label: "Dashboard", href: "/") %>
  <% group.with_item(label: "Analytics", href: "/analytics") %>
<% end %>
```

#### Multiple Groups

```erb
<%= bui_drawer_nav_group(title: "Overview") do |group| %>
  <% group.with_item(label: "Dashboard", href: dashboard_path, active: current_page?(dashboard_path)) %>
  <% group.with_item(label: "Analytics", href: analytics_path, active: current_page?(analytics_path)) %>
<% end %>

<%= bui_drawer_nav_group(title: "Management") do |group| %>
  <% group.with_item(label: "Users", href: users_path, active: current_page?(users_path)) %>
  <% group.with_item(label: "Teams", href: teams_path, active: current_page?(teams_path)) %>
  <% group.with_item(label: "Projects", href: projects_path, active: current_page?(projects_path)) %>
<% end %>

<%= bui_drawer_nav_group(title: "Settings") do |group| %>
  <% group.with_item(label: "Account", href: account_path) %>
  <% group.with_item(label: "Security", href: security_path) %>
<% end %>
```

### Direct Render

```erb
<%= render BetterUi::Drawer::NavGroupComponent.new(title: "Main") do |group| %>
  <% group.with_item(label: "Dashboard", href: dashboard_path, active: true) do |item| %>
    <% item.with_icon { "🏠" } %>
  <% end %>
  <% group.with_item(label: "Settings", href: settings_path) do |item| %>
    <% item.with_icon { "⚙️" } %>
  <% end %>
<% end %>
```

```erb
<%= render BetterUi::Drawer::NavGroupComponent.new do |group| %>
  <% group.with_item(label: "Home", href: root_path) %>
  <% group.with_item(label: "Profile", href: profile_path) %>
<% end %>
```

```erb
<%= render BetterUi::Drawer::NavGroupComponent.new(
  title: "Menu",
  variant: :dark
) do |group| %>
  <% group.with_item(label: "Dashboard", href: "/") %>
<% end %>
```

## Common Patterns

### Complete Sidebar Navigation

```erb
<%= bui_drawer_sidebar(variant: :light) do |sidebar| %>
  <% sidebar.with_navigation do %>
    <%= bui_drawer_nav_group(title: "Overview") do |group| %>
      <% group.with_item(label: "Dashboard", href: dashboard_path, active: controller_name == "dashboard") do |item| %>
        <% item.with_icon { render "icons/home" } %>
      <% end %>
      <% group.with_item(label: "Analytics", href: analytics_path, active: controller_name == "analytics") do |item| %>
        <% item.with_icon { render "icons/chart" } %>
      <% end %>
    <% end %>

    <%= bui_drawer_nav_group(title: "Content") do |group| %>
      <% group.with_item(label: "Posts", href: posts_path, active: controller_name == "posts") do |item| %>
        <% item.with_icon { render "icons/document" } %>
        <% item.with_badge { Post.draft.count } if Post.draft.any? %>
      <% end %>
      <% group.with_item(label: "Media", href: media_path, active: controller_name == "media") do |item| %>
        <% item.with_icon { render "icons/image" } %>
      <% end %>
    <% end %>

    <%= bui_drawer_nav_group(title: "Users") do |group| %>
      <% group.with_item(label: "All Users", href: users_path, active: controller_name == "users") do |item| %>
        <% item.with_icon { render "icons/users" } %>
      <% end %>
      <% group.with_item(label: "Roles", href: roles_path, active: controller_name == "roles") do |item| %>
        <% item.with_icon { render "icons/shield" } %>
      <% end %>
    <% end %>

    <%# Ungrouped items at the bottom %>
    <%= bui_drawer_nav_group do |group| %>
      <% group.with_item(label: "Settings", href: settings_path) do |item| %>
        <% item.with_icon { render "icons/cog" } %>
      <% end %>
      <% group.with_item(label: "Help", href: help_path) do |item| %>
        <% item.with_icon { render "icons/question" } %>
      <% end %>
      <% group.with_item(label: "Logout", href: logout_path, method: :delete) do |item| %>
        <% item.with_icon { render "icons/logout" } %>
      <% end %>
    <% end %>
  <% end %>
<% end %>
```

### Admin Panel Navigation

```erb
<%# For dark admin sidebars %>
<%= bui_drawer_nav_group(title: "Administration", variant: :dark) do |group| %>
  <% group.with_item(label: "Dashboard", href: admin_path, active: current_page?(admin_path)) do |item| %>
    <% item.with_icon { render "icons/dashboard" } %>
  <% end %>

  <% group.with_item(label: "Users", href: admin_users_path) do |item| %>
    <% item.with_icon { render "icons/users" } %>
    <% item.with_badge { User.count } %>
  <% end %>

  <% group.with_item(label: "System", href: admin_system_path) do |item| %>
    <% item.with_icon { render "icons/server" } %>
  <% end %>
<% end %>

<%= bui_drawer_nav_group(title: "Reports", variant: :dark) do |group| %>
  <% group.with_item(label: "Sales", href: admin_sales_path) do |item| %>
    <% item.with_icon { render "icons/chart" } %>
  <% end %>

  <% group.with_item(label: "Traffic", href: admin_traffic_path) do |item| %>
    <% item.with_icon { render "icons/globe" } %>
  <% end %>
<% end %>
```

### Dynamic Navigation from Config

```erb
<%
navigation_config = [
  {
    title: "Main",
    items: [
      { label: "Dashboard", href: dashboard_path, icon: "home" },
      { label: "Projects", href: projects_path, icon: "folder" }
    ]
  },
  {
    title: "Account",
    items: [
      { label: "Profile", href: profile_path, icon: "user" },
      { label: "Settings", href: settings_path, icon: "cog" }
    ]
  }
]
%>

<% navigation_config.each do |section| %>
  <%= bui_drawer_nav_group(title: section[:title]) do |group| %>
    <% section[:items].each do |item| %>
      <% group.with_item(label: item[:label], href: item[:href], active: current_page?(item[:href])) do |nav| %>
        <% nav.with_icon { render "icons/#{item[:icon]}" } %>
      <% end %>
    <% end %>
  <% end %>
<% end %>
```

## Related

- [NavItemComponent](nav_item.md) - Individual navigation items
- [SidebarComponent](sidebar.md) - Contains navigation groups
- [LayoutComponent](layout.md) - Full layout with sidebar
