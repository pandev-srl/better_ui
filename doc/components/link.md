# LinkComponent

Styled link with variants, icons, and sizes.

## Helper

```erb
<%= bui_link("/users", variant: :primary) { "View Users" } %>
```

## Parameters

| Parameter | Type | Default | Options | Description |
|-----------|------|---------|---------|-------------|
| `href` | String | Required | — | Link URL |
| `variant` | Symbol | `:primary` | `:primary`, `:secondary`, `:accent`, `:success`, `:danger`, `:warning`, `:info`, `:light`, `:dark` | Color variant |
| `style` | Symbol | `:default` | `:default`, `:underline`, `:ghost` | Link style |
| `size` | Symbol | `:md` | `:xs`, `:sm`, `:md`, `:lg`, `:xl` | Text size |
| `target` | String | `nil` | — | Link target (`_blank`, `_self`, etc.) |
| `rel` | String | `nil` | — | Rel attribute (auto-set for `_blank`) |
| `disabled` | Boolean | `false` | — | Disable the link |
| `container_classes` | String | `nil` | — | Additional CSS classes |

## Slots

| Slot | Type | Description |
|------|------|-------------|
| `icon_before` | Single | Icon before text |
| `icon_after` | Single | Icon after text |

## Usage

### Basic Link

```erb
<%= bui_link("/users", variant: :primary) { "View Users" } %>
```

### External Link

```erb
<%= bui_link("https://example.com", target: "_blank", style: :underline) { "External Link" } %>
```

### Link with Icon

```erb
<%= bui_link("/settings", variant: :secondary) do |link| %>
  <% link.with_icon_before { bui_fa_icon("cog", style: :solid, size: :sm) } %>
  Settings
<% end %>
```

### Ghost Link

```erb
<%= bui_link("/cancel", variant: :secondary, style: :ghost) { "Cancel" } %>
```
