# FaIconComponent

FontAwesome icon wrapper with styles, animations, and transformations.

## Helper

```erb
<%= bui_fa_icon("user") %>
```

## Parameters

| Parameter | Type | Default | Options | Description |
|-----------|------|---------|---------|-------------|
| `name` | String | Required | — | FontAwesome icon name (e.g., "user", "check") |
| `style` | Symbol | `:regular` | `:regular`, `:solid`, `:light`, `:thin`, `:brands` | FontAwesome style |
| `variant` | Symbol | `nil` | `:primary`, `:secondary`, etc. or `nil` | Color variant (`nil` = inherit) |
| `size` | Symbol | `:md` | `:xs`, `:sm`, `:md`, `:lg`, `:xl`, `:"2xl"` | Icon size |
| `spin` | Boolean | `false` | — | Continuous spin animation |
| `pulse` | Boolean | `false` | — | Pulse animation |
| `flip` | Symbol | `nil` | `:horizontal`, `:vertical`, `:both` | Flip transformation |
| `rotate` | Integer | `nil` | `90`, `180`, `270` | Rotation angle |
| `fixed_width` | Boolean | `false` | — | Fixed width for alignment |
| `container_classes` | String | `nil` | — | Additional CSS classes |

## Usage

### Basic Icon

```erb
<%= bui_fa_icon("user") %>
```

### Solid Icon with Color

```erb
<%= bui_fa_icon("heart", style: :solid, variant: :danger, size: :lg) %>
```

### Spinning Icon

```erb
<%= bui_fa_icon("spinner", style: :solid, spin: true) %>
```

### Brand Icon

```erb
<%= bui_fa_icon("github", style: :brands, size: :xl) %>
```

### Flipped and Rotated

```erb
<%= bui_fa_icon("arrow-right", style: :solid, flip: :horizontal) %>
<%= bui_fa_icon("arrow-up", style: :solid, rotate: 90) %>
```

### Fixed Width for Menus

```erb
<%= bui_fa_icon("home", style: :solid, fixed_width: true) %> Home
<%= bui_fa_icon("cog", style: :solid, fixed_width: true) %> Settings
<%= bui_fa_icon("user", style: :solid, fixed_width: true) %> Profile
```
