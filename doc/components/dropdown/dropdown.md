# Dropdown::DropdownComponent

Composable dropdown menu with trigger, polymorphic items (item/divider/header), keyboard navigation, and auto-close. Uses a Stimulus controller (`better-ui--dropdown--dropdown`) for toggle behavior, click-outside detection, and full ARIA support.

## Architecture

```
DropdownComponent (relative container + Stimulus controller)
  +-- [trigger slot]  -- button/element that toggles the menu
  +-- [items slot]    -- polymorphic: item | divider | header
```

## Helper

```erb
<%= bui_dropdown(placement: :bottom_start) do |d| %>
  <% d.with_trigger { bui_button(variant: :primary) { "Options" } } %>
  <% d.with_item(href: edit_path) { "Edit" } %>
  <% d.with_divider %>
  <% d.with_item(href: delete_path, variant: :danger) { "Delete" } %>
<% end %>
```

## Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `size` | Symbol | `:md` | Menu width: `:sm` (w-40), `:md` (w-56), `:lg` (w-72) |
| `placement` | Symbol | `:bottom_start` | `:bottom_start`, `:bottom_end`, `:top_start`, `:top_end` |
| `shadow` | Symbol | `:lg` | Shadow size: `:sm`, `:md`, `:lg`, `:xl`, or `false` |
| `auto_close` | Boolean | `true` | Close on click outside |
| `close_on_item_click` | Boolean | `true` | Close menu after item click |
| `container_classes` | String | `nil` | Additional CSS classes for root element |
| `menu_classes` | String | `nil` | Additional CSS classes for menu panel |

## Slots

| Slot | Type | Description |
|------|------|-------------|
| `trigger` | Single | Element that toggles the dropdown on click |
| `items` | Multiple (polymorphic) | Menu entries: `item`, `divider`, or `header` |

### Item Types

Use the polymorphic `items` slot to compose menu content:

- `d.with_item(**args) { "Label" }` → [ItemComponent](item.md) - Clickable menu item
- `d.with_divider(**args)` → [DividerComponent](divider.md) - Visual separator
- `d.with_header(**args)` → [HeaderComponent](header.md) - Section title

## Usage

### Basic Dropdown

```erb
<%= bui_dropdown do |d| %>
  <% d.with_trigger do %>
    <%= bui_button(variant: :primary) { "Options" } %>
  <% end %>
  <% d.with_item(href: edit_path) { "Edit" } %>
  <% d.with_item(href: show_path) { "View" } %>
<% end %>
```

### Dropdown with Headers, Dividers, Icons, and Danger Item

```erb
<%= bui_dropdown(size: :lg, placement: :bottom_end) do |d| %>
  <% d.with_trigger do %>
    <%= bui_button(variant: :secondary, style: :outline) { "Actions" } %>
  <% end %>
  <% d.with_header(text: "Navigation") %>
  <% d.with_item(href: dashboard_path) do |item| %>
    <% item.with_icon { bui_fa_icon("home", style: :solid, size: :sm) } %>
    Dashboard
  <% end %>
  <% d.with_item(href: settings_path) do |item| %>
    <% item.with_icon { bui_fa_icon("cog", style: :solid, size: :sm) } %>
    Settings
  <% end %>
  <% d.with_divider %>
  <% d.with_item(href: logout_path, variant: :danger, method: :delete) do |item| %>
    <% item.with_icon { bui_fa_icon("sign-out-alt", style: :solid, size: :sm) } %>
    Sign Out
  <% end %>
<% end %>
```

### Dropdown with Active and Disabled Items

```erb
<%= bui_dropdown do |d| %>
  <% d.with_trigger do %>
    <%= bui_button(variant: :primary) { "Menu" } %>
  <% end %>
  <% d.with_item(active: true) { "Current Page" } %>
  <% d.with_item(href: other_path) { "Other Page" } %>
  <% d.with_item(disabled: true) { "Coming Soon" } %>
<% end %>
```

### Top-Aligned Dropdown

```erb
<%= bui_dropdown(placement: :top_end, size: :sm) do |d| %>
  <% d.with_trigger do %>
    <%= bui_button(variant: :secondary, size: :sm) { "More" } %>
  <% end %>
  <% d.with_item(href: "#") { "Option A" } %>
  <% d.with_item(href: "#") { "Option B" } %>
<% end %>
```

## Stimulus Controller

The dropdown ships a Stimulus controller (`better-ui--dropdown--dropdown`) that manages:

- **Toggle** with scale + opacity CSS animation
- **Click-outside** detection to close (configurable via `auto_close`)
- **Keyboard navigation**: ArrowDown/Up, Home/End, Enter/Space, Escape, Tab
- **Disabled item skipping** in keyboard navigation
- **ARIA state management** (`aria-expanded` on trigger)
- **Focus return** to trigger on close
- **Close-all** coordination: opening one dropdown closes all others

### Stimulus Values

| Value | Type | Default | Description |
|-------|------|---------|-------------|
| `autoClose` | Boolean | `true` | Close on click outside |
| `closeOnItemClick` | Boolean | `true` | Close on item click |

### Stimulus Targets

| Target | Description |
|--------|-------------|
| `trigger` | The trigger wrapper element |
| `menu` | The dropdown menu panel |
| `item` | Individual menu items (`role="menuitem"`) |

### Custom Events

| Event | Bubbles | Description |
|-------|---------|-------------|
| `better-ui--dropdown--dropdown:opened` | Yes | Fired when dropdown opens |
| `better-ui--dropdown--dropdown:closed` | Yes | Fired when dropdown closes |
| `better-ui--dropdown--dropdown:item-selected` | Yes | Fired when an item is selected (includes `detail.item`) |

## Related

- [ItemComponent](item.md) -- Clickable menu item with icon and variant support
- [HeaderComponent](header.md) -- Section title within dropdown
- [DividerComponent](divider.md) -- Visual separator between items
- [ButtonComponent](../button.md) -- Commonly used as trigger
