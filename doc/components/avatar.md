# AvatarComponent

User avatar with image, initials fallback, and status indicator.

## Helper

```erb
<%= bui_avatar(src: user.avatar_url, alt: user.name) %>
```

## Parameters

| Parameter | Type | Default | Options | Description |
|-----------|------|---------|---------|-------------|
| `src` | String | `nil` | — | Image URL |
| `alt` | String | `nil` | — | Alt text (falls back to name) |
| `name` | String | `nil` | — | Full name for generating initials |
| `variant` | Symbol | `:primary` | `:primary`, `:secondary`, `:accent`, `:success`, `:danger`, `:warning`, `:info`, `:light`, `:dark` | Color variant for initials background |
| `size` | Symbol | `:md` | `:xs`, `:sm`, `:md`, `:lg`, `:xl` | Avatar size |
| `shape` | Symbol | `:circle` | `:circle`, `:square`, `:rounded` | Avatar shape |
| `status` | Symbol | `nil` | `:online`, `:offline`, `:busy`, `:away` | Status indicator dot |
| `container_classes` | String | `nil` | — | Additional CSS classes |

## Slots

| Slot | Type | Description |
|------|------|-------------|
| `badge` | Single | Badge overlay at top-right corner |

## Usage

### Avatar with Image

```erb
<%= bui_avatar(src: user.avatar_url, alt: user.name, size: :lg) %>
```

### Avatar with Initials

When no `src` is provided but `name` is, the component displays initials (first letter of first and last name).

```erb
<%= bui_avatar(name: "John Doe", variant: :primary) %>
```

### Avatar with Status Indicator

```erb
<%= bui_avatar(name: "John Doe", variant: :success, status: :online) %>
<%= bui_avatar(name: "Jane Smith", variant: :secondary, status: :busy) %>
<%= bui_avatar(name: "Bob Wilson", variant: :warning, status: :away) %>
```

### Avatar with Badge

```erb
<%= bui_avatar(name: "John Doe", size: :lg) do |a| %>
  <% a.with_badge { bui_badge(variant: :danger, counter: 3) } %>
<% end %>
```

### Shapes

```erb
<%= bui_avatar(name: "JD", shape: :circle) %>
<%= bui_avatar(name: "JD", shape: :square) %>
<%= bui_avatar(name: "JD", shape: :rounded) %>
```

### Sizes

```erb
<%= bui_avatar(name: "JD", size: :xs) %>
<%= bui_avatar(name: "JD", size: :sm) %>
<%= bui_avatar(name: "JD", size: :md) %>
<%= bui_avatar(name: "JD", size: :lg) %>
<%= bui_avatar(name: "JD", size: :xl) %>
```
