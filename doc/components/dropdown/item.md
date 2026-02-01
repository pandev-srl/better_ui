# Dropdown::ItemComponent

Individual menu item within a [DropdownComponent](dropdown.md). Renders as `<a>` when `href` is provided, otherwise `<button>`. Supports icons, disabled state, active highlighting, and danger variant.

## Helper

Used via the polymorphic `items` slot on `bui_dropdown`:

```erb
<%= bui_dropdown do |d| %>
  <% d.with_trigger { bui_button { "Menu" } } %>
  <% d.with_item(href: "/edit") { "Edit" } %>
  <% d.with_item(variant: :danger) { "Delete" } %>
<% end %>
```

## Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `href` | String | `nil` | Link URL; renders `<a>` if present, `<button>` otherwise |
| `disabled` | Boolean | `false` | Disable the item (opacity + pointer-events-none) |
| `method` | Symbol | `nil` | HTTP method for Turbo: `:get`, `:post`, `:put`, `:patch`, `:delete` |
| `active` | Boolean | `false` | Highlight item with grayscale background |
| `variant` | Symbol | `:default` | `:default` (grayscale-700) or `:danger` (danger-600 with red hover) |
| `container_classes` | String | `nil` | Additional CSS classes |

## Slots

| Slot | Type | Description |
|------|------|-------------|
| `icon` | Single | Icon displayed before item text |

## Usage

### Link Item

```erb
<% d.with_item(href: edit_user_path(@user)) { "Edit Profile" } %>
```

### Button Item (No href)

```erb
<% d.with_item { "Copy to Clipboard" } %>
```

### Item with Icon

```erb
<% d.with_item(href: settings_path) do |item| %>
  <% item.with_icon { bui_fa_icon("cog", style: :solid, size: :sm) } %>
  Settings
<% end %>
```

### Danger Item with Turbo Method

```erb
<% d.with_item(href: logout_path, variant: :danger, method: :delete) do |item| %>
  <% item.with_icon { bui_fa_icon("sign-out-alt", style: :solid, size: :sm) } %>
  Sign Out
<% end %>
```

### Active and Disabled Items

```erb
<% d.with_item(active: true) { "Current Page" } %>
<% d.with_item(disabled: true) { "Coming Soon" } %>
```

## Related

- [DropdownComponent](dropdown.md) -- Parent container
- [HeaderComponent](header.md) -- Section title
- [DividerComponent](divider.md) -- Visual separator
