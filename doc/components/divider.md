# DividerComponent

Visual separator with label and orientation.

## Helper

```erb
<%= bui_divider %>
```

## Parameters

| Parameter | Type | Default | Options | Description |
|-----------|------|---------|---------|-------------|
| `orientation` | Symbol | `:horizontal` | `:horizontal`, `:vertical` | Divider direction |
| `style` | Symbol | `:solid` | `:solid`, `:dashed`, `:dotted` | Border style |
| `variant` | Symbol | `nil` | `:primary`, `:secondary`, etc. or `nil` | Color variant (`nil` = gray) |
| `size` | Symbol | `:md` | `:xs`, `:sm`, `:md` | Border thickness |
| `label` | String | `nil` | — | Centered text label (horizontal only) |
| `label_position` | Symbol | `:center` | `:left`, `:center`, `:right` | Label alignment |
| `spacing` | Symbol | `:md` | `:xs`, `:sm`, `:md`, `:lg`, `:xl` | Outer margins |
| `container_classes` | String | `nil` | — | Additional CSS classes |

## Usage

### Basic Divider

```erb
<%= bui_divider %>
```

### Dashed Divider with Label

```erb
<%= bui_divider(style: :dashed, label: "OR", variant: :primary) %>
```

### Vertical Divider

Use inside a flex container:

```erb
<div class="flex items-center gap-4">
  <span>Left</span>
  <%= bui_divider(orientation: :vertical) %>
  <span>Right</span>
</div>
```

### Labeled Divider with Position

```erb
<%= bui_divider(label: "Section", label_position: :left) %>
```
