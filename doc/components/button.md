# ButtonComponent

A versatile button component with multiple styles, sizes, variants, and interactive states. Supports loading indicators, icons, and Stimulus controller integration for dynamic behavior.

## Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `variant` | Symbol | `:primary` | Color variant (see VARIANTS constant) |
| `style` | Symbol | `:solid` | Visual style: `:solid`, `:outline`, `:ghost`, `:soft` |
| `size` | Symbol | `:md` | Size: `:xs`, `:sm`, `:md`, `:lg`, `:xl` |
| `show_loader` | Boolean | `false` | Shows loading spinner when true |
| `show_loader_on_click` | Boolean | `false` | Shows loader after click (via Stimulus) |
| `disabled` | Boolean | `false` | Disables the button |
| `type` | Symbol | `:button` | Button type: `:button`, `:submit`, `:reset` |
| `href` | String | `nil` | URL - renders as `<a>` tag when provided |
| `target` | String | `nil` | Link target: `_blank`, `_self`, etc. |
| `rel` | String | auto | Link relationship (auto-set to `noopener noreferrer` for `_blank`) |
| `method` | Symbol | `nil` | HTTP method via `data-turbo-method` |
| `container_classes` | String | `nil` | Additional CSS classes |
| `**options` | Hash | `{}` | Additional HTML attributes |

## Slots

- `icon_before` - Icon rendered before the button text
- `icon_after` - Icon rendered after the button text

## Size Configurations

```ruby
SIZES = {
  xs: { padding: "px-2 py-1", text: "text-xs", icon: "w-3 h-3", gap: "gap-1" },
  sm: { padding: "px-3 py-1.5", text: "text-sm", icon: "w-4 h-4", gap: "gap-1.5" },
  md: { padding: "px-4 py-2", text: "text-base", icon: "w-5 h-5", gap: "gap-2" },
  lg: { padding: "px-5 py-2.5", text: "text-lg", icon: "w-6 h-6", gap: "gap-2.5" },
  xl: { padding: "px-6 py-3", text: "text-xl", icon: "w-7 h-7", gap: "gap-3" }
}
```

## Usage

### Helper Syntax

#### Basic Button

```erb
<%= bui_button(variant: :primary) { "Click me" } %>
```

#### Styled Submit Button

```erb
<%= bui_button(
  variant: :success,
  style: :solid,
  type: :submit,
  size: :lg
) { "Submit Form" } %>
```

#### Button with Icons

```erb
<%= bui_button(variant: :primary) do |c| %>
  <% c.with_icon_before do %>
    <svg class="w-5 h-5"><!-- Download icon --></svg>
  <% end %>
  Download
<% end %>
```

#### Loading Button

```erb
<%= bui_button(show_loader: true, disabled: true) { "Processing..." } %>
```

#### Auto-Loading on Click

```erb
<%= bui_button(
  show_loader_on_click: true,
  type: :submit
) { "Save Changes" } %>
```

#### Danger Confirmation Button

```erb
<%= bui_button(
  variant: :danger,
  style: :outline,
  data: {
    turbo_confirm: "Are you sure?",
    turbo_method: "delete"
  }
) { "Delete" } %>
```

#### Button Group

```erb
<div class="flex gap-2">
  <%= bui_button(variant: :secondary, style: :ghost) { "Cancel" } %>
  <%= bui_button(variant: :primary) { "Save" } %>
</div>
```

### Link Mode

When the `href` parameter is provided, the component renders as an `<a>` tag instead of `<button>`:

#### Basic Link Button

```erb
<%= bui_button(href: users_path) { "View Users" } %>
```

#### External Link (New Tab)

```erb
<%= bui_button(
  href: "https://example.com",
  target: "_blank"
) { "Visit Site" } %>
```

Note: `rel="noopener noreferrer"` is automatically added for security when `target="_blank"` is used.

#### Destructive Action Link

```erb
<%= bui_button(
  href: user_path(@user),
  method: :delete,
  variant: :danger,
  style: :outline,
  data: { turbo_confirm: "Are you sure?" }
) { "Delete User" } %>
```

#### Disabled Link

```erb
<%= bui_button(
  href: "/",
  disabled: true
) { "Coming Soon" } %>
```

Disabled links use `aria-disabled="true"`, remove the `href`, and add `pointer-events: none` for accessibility.

#### Link with Loading State

```erb
<%= bui_button(
  href: "/process",
  show_loader_on_click: true
) { "Process" } %>
```

### Direct Render

```erb
<%= render BetterUi::ButtonComponent.new(
  label: "Click me",
  variant: :primary
) %>
```

```erb
<%= render BetterUi::ButtonComponent.new(
  label: "Submit Form",
  variant: :success,
  style: :solid,
  type: :submit,
  size: :lg
) %>
```

```erb
<%= render BetterUi::ButtonComponent.new(
  label: "Download"
) do |c| %>
  <% c.with_icon_before do %>
    <svg class="w-5 h-5"><!-- Download icon --></svg>
  <% end %>
<% end %>
```

## Stimulus Controller

The button component includes a `better-ui--button` Stimulus controller that handles:
- Click events
- Auto-loading state on click
- Dynamic state management

## Related

- [CardComponent](card.md) - Container component often used with buttons
- [ActionMessagesComponent](action_messages.md) - Feedback messages after button actions
