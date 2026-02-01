# Dropdown::HeaderComponent

Non-interactive section title within a [DropdownComponent](dropdown.md). Renders as a styled `<div>` with `role="presentation"`. Useful for grouping related items under a label.

## Helper

Used via the polymorphic `items` slot on `bui_dropdown`:

```erb
<%= bui_dropdown do |d| %>
  <% d.with_trigger { bui_button { "Menu" } } %>
  <% d.with_header(text: "Account") %>
  <% d.with_item(href: profile_path) { "Profile" } %>
  <% d.with_item(href: settings_path) { "Settings" } %>
<% end %>
```

## Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `text` | String | `nil` | Header text (alternative: pass block content) |
| `container_classes` | String | `nil` | Additional CSS classes |

## Usage

### Using text Parameter

```erb
<% d.with_header(text: "Navigation") %>
```

### Using Block Content

```erb
<% d.with_header { "Navigation" } %>
```

## Related

- [DropdownComponent](dropdown.md) -- Parent container
- [ItemComponent](item.md) -- Clickable menu item
- [DividerComponent](divider.md) -- Visual separator
