# TagComponent

Dismissible tag with link support and Stimulus controller.

## Helper

```erb
<%= bui_tag(variant: :success) { "Active" } %>
```

## Parameters

| Parameter | Type | Default | Options | Description |
|-----------|------|---------|---------|-------------|
| `variant` | Symbol | `:primary` | `:primary`, `:secondary`, `:accent`, `:success`, `:danger`, `:warning`, `:info`, `:light`, `:dark` | Color variant |
| `style` | Symbol | `:solid` | `:solid`, `:outline`, `:soft` | Tag style |
| `size` | Symbol | `:md` | `:xs`, `:sm`, `:md`, `:lg` | Tag size |
| `dismissible` | Boolean | `false` | — | Show dismiss (X) button |
| `href` | String | `nil` | — | Makes tag a clickable link |
| `container_classes` | String | `nil` | — | Additional CSS classes |

## Slots

| Slot | Type | Description |
|------|------|-------------|
| `icon_before` | Single | Icon before tag text |

## Stimulus Controller

`better-ui--tag` - Handles dismiss animation and removal.

## Usage

### Basic Tag

```erb
<%= bui_tag(variant: :success) { "Active" } %>
<%= bui_tag(variant: :danger, style: :outline) { "Expired" } %>
```

### Dismissible Tag

```erb
<%= bui_tag(variant: :info, dismissible: true) { "New" } %>
```

### Tag as Link

```erb
<%= bui_tag(variant: :primary, href: "/tags/ruby") { "Ruby" } %>
```

### Tag with Icon

```erb
<%= bui_tag(variant: :warning) do |t| %>
  <% t.with_icon_before { bui_fa_icon("exclamation-triangle", style: :solid, size: :xs) } %>
  Warning
<% end %>
```
