# TooltipComponent

CSS-only hover tooltip with position and style.

## Helper

```erb
<%= bui_tooltip("Save changes") { bui_button(variant: :primary) { "Save" } } %>
```

## Parameters

| Parameter | Type | Default | Options | Description |
|-----------|------|---------|---------|-------------|
| `text` | String | Required | — | Tooltip content |
| `position` | Symbol | `:top` | `:top`, `:right`, `:bottom`, `:left` | Tooltip position |
| `variant` | Symbol | `:dark` | `:dark`, `:light` | Tooltip style |
| `size` | Symbol | `:sm` | `:sm`, `:md` | Tooltip text size |
| `container_classes` | String | `nil` | — | Additional CSS classes |

## Usage

### Simple Tooltip

```erb
<%= bui_tooltip("Save changes") do %>
  <%= bui_button(variant: :primary) { "Save" } %>
<% end %>
```

### Tooltip with Position

```erb
<%= bui_tooltip("Delete item", position: :bottom, variant: :light) do %>
  <%= bui_button(variant: :danger, style: :ghost) { "Delete" } %>
<% end %>
```

### Tooltip on Any Element

```erb
<%= bui_tooltip("Click to edit") do %>
  <span class="cursor-pointer underline">Edit</span>
<% end %>
```
