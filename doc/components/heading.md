# HeadingComponent

Semantic heading (h1-h6) with optional subtitle, actions, and divider.

## Helper

```erb
<%= bui_heading(level: :h1, variant: :primary) { "Page Title" } %>
```

## Parameters

| Parameter | Type | Default | Options | Description |
|-----------|------|---------|---------|-------------|
| `level` | Symbol | `:h2` | `:h1`, `:h2`, `:h3`, `:h4`, `:h5`, `:h6` | Heading level |
| `subtitle` | String | `nil` | — | Subtitle text below heading |
| `divider` | Boolean | `false` | — | Show divider line below |
| `variant` | Symbol | `nil` | `:primary`, `:secondary`, etc. or `nil` | Color variant (`nil` = inherit) |
| `align` | Symbol | `:left` | `:left`, `:center`, `:right` | Text alignment |
| `container_classes` | String | `nil` | — | Additional CSS classes |

## Slots

| Slot | Type | Description |
|------|------|-------------|
| `subtitle` | Single | Rich subtitle content (overrides subtitle param) |
| `actions` | Single | Action buttons or controls |

## Usage

### Simple Heading

```erb
<%= bui_heading(level: :h1, variant: :primary) { "Page Title" } %>
```

### With Subtitle

```erb
<%= bui_heading(level: :h2, subtitle: "Manage your account settings") { "Settings" } %>
```

### With Actions and Divider

```erb
<%= bui_heading(level: :h2, divider: true) do |h| %>
  <% h.with_actions { bui_button(variant: :primary, size: :sm) { "Add New" } } %>
  Users
<% end %>
```

### Centered Heading

```erb
<%= bui_heading(level: :h1, align: :center, variant: :primary) { "Welcome" } %>
```
