# Dropdown::DividerComponent

Visual separator line between items within a [DropdownComponent](dropdown.md). Renders as a `<div>` with `role="separator"` and a top border.

## Helper

Used via the polymorphic `items` slot on `bui_dropdown`:

```erb
<%= bui_dropdown do |d| %>
  <% d.with_trigger { bui_button { "Menu" } } %>
  <% d.with_item(href: edit_path) { "Edit" } %>
  <% d.with_divider %>
  <% d.with_item(href: delete_path, variant: :danger) { "Delete" } %>
<% end %>
```

## Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `container_classes` | String | `nil` | Additional CSS classes |

## Usage

```erb
<% d.with_divider %>
```

## Related

- [DropdownComponent](dropdown.md) -- Parent container
- [ItemComponent](item.md) -- Clickable menu item
- [HeaderComponent](header.md) -- Section title
