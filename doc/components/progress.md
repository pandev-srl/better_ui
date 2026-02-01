# ProgressComponent

Progress bar with label and animation.

## Helper

```erb
<%= bui_progress(value: 50) %>
```

## Parameters

| Parameter | Type | Default | Options | Description |
|-----------|------|---------|---------|-------------|
| `value` | Numeric | `0` | — | Current progress value |
| `max` | Numeric | `100` | — | Maximum value |
| `variant` | Symbol | `:primary` | `:primary`, `:secondary`, `:accent`, `:success`, `:danger`, `:warning`, `:info`, `:light`, `:dark` | Color variant |
| `size` | Symbol | `:md` | `:xs`, `:sm`, `:md`, `:lg` | Bar height |
| `label` | String | `nil` | — | Text above the bar |
| `show_value` | Boolean | `false` | — | Show percentage text |
| `animated` | Boolean | `false` | — | Striped animation effect |
| `container_classes` | String | `nil` | — | Additional CSS classes |

## Usage

### Default Progress

```erb
<%= bui_progress(value: 50) %>
```

### With Label and Value Display

```erb
<%= bui_progress(value: 75, label: "Upload progress", show_value: true, variant: :success) %>
```

### Animated Progress

```erb
<%= bui_progress(value: 60, animated: true, variant: :info) %>
```

### Custom Max Value

```erb
<%= bui_progress(value: 30, max: 50, show_value: true) %>
```
