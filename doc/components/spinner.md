# SpinnerComponent

Loading indicator with color and size variants.

## Helper

```erb
<%= bui_spinner %>
```

## Parameters

| Parameter | Type | Default | Options | Description |
|-----------|------|---------|---------|-------------|
| `variant` | Symbol | `:primary` | `:primary`, `:secondary`, `:accent`, `:success`, `:danger`, `:warning`, `:info`, `:light`, `:dark` | Color variant |
| `size` | Symbol | `:md` | `:xs`, `:sm`, `:md`, `:lg`, `:xl` | Spinner size |
| `label` | String | `nil` | — | Accessible sr-only label text |
| `container_classes` | String | `nil` | — | Additional CSS classes |

## Usage

### Default Spinner

```erb
<%= bui_spinner %>
```

### Colored Spinner

```erb
<%= bui_spinner(variant: :success) %>
<%= bui_spinner(variant: :danger) %>
```

### Large Spinner with Label

```erb
<%= bui_spinner(variant: :primary, size: :lg, label: "Loading...") %>
```
