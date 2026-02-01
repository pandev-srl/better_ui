# BadgeComponent

Label badge with dot, counter, and pill modes.

## Helper

```erb
<%= bui_badge(variant: :success) { "Active" } %>
```

## Parameters

| Parameter | Type | Default | Options | Description |
|-----------|------|---------|---------|-------------|
| `variant` | Symbol | `:primary` | `:primary`, `:secondary`, `:accent`, `:success`, `:danger`, `:warning`, `:info`, `:light`, `:dark` | Color variant |
| `style` | Symbol | `:solid` | `:solid`, `:outline`, `:soft`, `:ghost` | Badge style |
| `size` | Symbol | `:md` | `:xs`, `:sm`, `:md`, `:lg` | Badge size |
| `pill` | Boolean | `true` | — | Pill shape (rounded-full) |
| `dot` | Boolean | `false` | — | Show dot indicator |
| `counter` | Integer | `nil` | — | Show numeric counter |
| `container_classes` | String | `nil` | — | Additional CSS classes |

## Slots

| Slot | Type | Description |
|------|------|-------------|
| `icon_before` | Single | Icon before badge text |

## Usage

### Text Badge

```erb
<%= bui_badge(variant: :success) { "Active" } %>
<%= bui_badge(variant: :danger, style: :outline) { "Expired" } %>
<%= bui_badge(variant: :info, style: :soft) { "New" } %>
```

### Counter Badge

```erb
<%= bui_badge(variant: :danger, counter: 5) %>
<%= bui_badge(variant: :primary, counter: 99) %>
```

### Dot Badge

```erb
<%= bui_badge(variant: :success, dot: true) %>
```

### With Icon

```erb
<%= bui_badge(variant: :warning) do |b| %>
  <% b.with_icon_before { bui_fa_icon("exclamation-triangle", style: :solid, size: :xs) } %>
  Warning
<% end %>
```

### Non-Pill Badge

```erb
<%= bui_badge(variant: :primary, pill: false) { "Tag" } %>
```
