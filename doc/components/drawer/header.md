# Drawer::HeaderComponent

A flexible header component for drawer layouts with support for logo, navigation, and actions. Supports sticky positioning and multiple visual variants.

## Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `variant` | Symbol | `:light` | Visual variant: `:light`, `:dark`, `:transparent`, `:primary` |
| `sticky` | Boolean | `true` | Whether header is sticky at top |
| `height` | Symbol | `:md` | Height: `:sm` (48px), `:md` (64px), `:lg` (80px) |
| `container_classes` | String | `nil` | Additional CSS classes |
| `**options` | Hash | `{}` | Additional HTML attributes |

## Slots

- `logo` - Logo/brand section (left side)
- `navigation` - Main navigation (center, hidden on mobile)
- `actions` - Actions section (right side, user menu, etc.)
- `mobile_menu_button` - Mobile menu toggle (visible on mobile only)

## Usage

### Helper Syntax

#### Basic Header

```erb
<%= bui_drawer_header(sticky: true, variant: :light) do |header| %>
  <% header.with_logo do %>
    <%= image_tag "logo.svg", class: "h-8" %>
  <% end %>

  <% header.with_navigation do %>
    <nav class="flex gap-4">
      <%= link_to "Home", root_path %>
      <%= link_to "About", about_path %>
    </nav>
  <% end %>

  <% header.with_mobile_menu_button do %>
    <button class="p-2">
      <svg class="w-6 h-6"><!-- Menu icon --></svg>
    </button>
  <% end %>

  <% header.with_actions do %>
    <%= link_to "Sign In", sign_in_path %>
  <% end %>
<% end %>
```

#### Dark Header

```erb
<%= bui_drawer_header(variant: :dark, sticky: true) do |header| %>
  <% header.with_logo do %>
    <%= image_tag "logo-white.svg", class: "h-8" %>
  <% end %>

  <% header.with_actions do %>
    <div class="flex items-center gap-4 text-white">
      <%= link_to "Docs", docs_path %>
      <%= link_to "Login", login_path %>
    </div>
  <% end %>
<% end %>
```

#### Transparent Header (for hero sections)

```erb
<%= bui_drawer_header(variant: :transparent, sticky: false) do |header| %>
  <% header.with_logo { image_tag("logo.svg", class: "h-10") } %>

  <% header.with_navigation do %>
    <nav class="flex gap-6 text-white">
      <%= link_to "Features", "#features" %>
      <%= link_to "Pricing", "#pricing" %>
      <%= link_to "Contact", "#contact" %>
    </nav>
  <% end %>

  <% header.with_actions do %>
    <%= bui_button(variant: :light, style: :outline) { "Get Started" } %>
  <% end %>
<% end %>
```

#### Large Header

```erb
<%= bui_drawer_header(height: :lg) do |header| %>
  <% header.with_logo do %>
    <div class="flex items-center gap-3">
      <%= image_tag "logo.svg", class: "h-12" %>
      <span class="text-xl font-bold">My App</span>
    </div>
  <% end %>
<% end %>
```

### Direct Render

```erb
<%= render BetterUi::Drawer::HeaderComponent.new(
  sticky: true,
  variant: :light
) do |header| %>
  <% header.with_logo { image_tag("logo.svg", class: "h-8") } %>

  <% header.with_navigation do %>
    <nav class="flex gap-4">
      <%= link_to "Home", root_path %>
      <%= link_to "About", about_path %>
    </nav>
  <% end %>

  <% header.with_mobile_menu_button do %>
    <button class="p-2">
      <svg class="w-6 h-6"><!-- Menu icon --></svg>
    </button>
  <% end %>

  <% header.with_actions do %>
    <%= link_to "Sign In", sign_in_path %>
  <% end %>
<% end %>
```

## Common Patterns

### Header with User Dropdown

```erb
<%= bui_drawer_header do |header| %>
  <% header.with_logo { image_tag("logo.svg", class: "h-8") } %>

  <% header.with_actions do %>
    <div class="relative" data-controller="dropdown">
      <button data-action="click->dropdown#toggle" class="flex items-center gap-2">
        <%= image_tag current_user.avatar_url, class: "w-8 h-8 rounded-full" %>
        <span><%= current_user.name %></span>
        <svg class="w-4 h-4"><!-- Chevron down --></svg>
      </button>

      <div data-dropdown-target="menu" class="hidden absolute right-0 mt-2 w-48 bg-white rounded-lg shadow-lg">
        <%= link_to "Profile", profile_path, class: "block px-4 py-2" %>
        <%= link_to "Settings", settings_path, class: "block px-4 py-2" %>
        <%= button_to "Sign Out", logout_path, method: :delete, class: "block w-full text-left px-4 py-2" %>
      </div>
    </div>
  <% end %>
<% end %>
```

### Header with Search

```erb
<%= bui_drawer_header do |header| %>
  <% header.with_logo { image_tag("logo.svg", class: "h-8") } %>

  <% header.with_navigation do %>
    <div class="hidden md:block w-64">
      <%= bui_text_input("q",
        placeholder: "Search...",
        size: :sm
      ) do |c| %>
        <% c.with_prefix_icon do %>
          <svg class="w-4 h-4 text-gray-400"><!-- Search icon --></svg>
        <% end %>
      <% end %>
    </div>
  <% end %>

  <% header.with_actions { render "shared/user_menu" } %>
<% end %>
```

## Related

- [LayoutComponent](layout.md) - Parent layout component
- [SidebarComponent](sidebar.md) - Sidebar companion to header
