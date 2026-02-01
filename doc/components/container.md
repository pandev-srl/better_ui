# ContainerComponent

Responsive max-width content wrapper.

## Helper

```erb
<%= bui_container { "Page content" } %>
```

## Parameters

| Parameter | Type | Default | Options | Description |
|-----------|------|---------|---------|-------------|
| `size` | Symbol | `:lg` | `:sm`, `:md`, `:lg`, `:xl`, `:full` | Max-width size |
| `padding` | Boolean | `true` | — | Apply horizontal padding |
| `centered` | Boolean | `true` | — | Center with mx-auto |
| `container_classes` | String | `nil` | — | Additional CSS classes |

## Usage

### Default Container

```erb
<%= bui_container do %>
  <h1>Page Title</h1>
  <p>Page content constrained to a readable width.</p>
<% end %>
```

### Full-Width Container

```erb
<%= bui_container(size: :full, padding: false) { "Edge-to-edge content" } %>
```

### Small Container

```erb
<%= bui_container(size: :sm) { "Narrow content area" } %>
```
