# CardComponent

A flexible container component that provides structured content areas with consistent padding, borders, and optional shadow effects.

## Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `variant` | Symbol | `:primary` | Color variant (see VARIANTS constant) |
| `style` | Symbol | `:solid` | Visual style: `:solid`, `:outline`, `:ghost`, `:soft`, `:bordered` |
| `size` | Symbol | `:md` | Size variant: `:xs`, `:sm`, `:md`, `:lg`, `:xl` |
| `shadow` | Boolean | `true` | Whether to apply shadow effect |
| `header_padding` | Boolean | `true` | Whether to apply padding to header section |
| `body_padding` | Boolean | `true` | Whether to apply padding to body section |
| `footer_padding` | Boolean | `true` | Whether to apply padding to footer section |
| `container_classes` | String | `nil` | Additional CSS classes for the outer wrapper |
| `header_classes` | String | `nil` | Additional CSS classes for the header section |
| `body_classes` | String | `nil` | Additional CSS classes for the body section |
| `footer_classes` | String | `nil` | Additional CSS classes for the footer section |
| `**options` | Hash | `{}` | Additional HTML attributes |

## Style Options

| Style | Description |
|-------|-------------|
| `:solid` | Light colored background with subtle border (default) |
| `:outline` | White background with prominent colored border |
| `:ghost` | Transparent background, colored text only |
| `:soft` | Very light background with minimal border |
| `:bordered` | Neutral white background with gray border (variant-agnostic) |

## Slots

- `header` - Top section of the card (separated from body with divider)
- `body` - Main content area
- `footer` - Bottom section of the card (separated from body with divider)

## Usage

### Helper Syntax

#### Basic Card

```erb
<%= bui_card do |c| %>
  <% c.with_body do %>
    <p>Card content goes here</p>
  <% end %>
<% end %>
```

#### Full Card Structure

```erb
<%= bui_card(size: :lg, shadow: true) do |c| %>
  <% c.with_header do %>
    <h3 class="text-lg font-semibold">Card Title</h3>
  <% end %>

  <% c.with_body do %>
    <p>Main content area with automatic padding based on size.</p>
  <% end %>

  <% c.with_footer do %>
    <div class="flex justify-end gap-2">
      <%= bui_button(style: :ghost) { "Cancel" } %>
      <%= bui_button { "Save" } %>
    </div>
  <% end %>
<% end %>
```

#### Styled Cards

```erb
<%# Outlined card %>
<%= bui_card(variant: :primary, style: :outline) do |c| %>
  <% c.with_body { "Outlined primary card" } %>
<% end %>

<%# Soft card %>
<%= bui_card(variant: :success, style: :soft) do |c| %>
  <% c.with_body { "Soft success card" } %>
<% end %>

<%# Bordered card (variant-agnostic) %>
<%= bui_card(style: :bordered) do |c| %>
  <% c.with_body { "Neutral bordered card" } %>
<% end %>
```

#### Card without Shadow

```erb
<%= bui_card(shadow: false) do |c| %>
  <% c.with_body { "Shadow-free card" } %>
<% end %>
```

### Common Patterns

#### Profile Card

```erb
<%= bui_card do |c| %>
  <% c.with_body do %>
    <div class="flex items-center gap-4">
      <img src="avatar.jpg" class="w-16 h-16 rounded-full">
      <div>
        <h3 class="font-semibold">John Doe</h3>
        <p class="text-gray-600">Software Developer</p>
      </div>
    </div>
  <% end %>
<% end %>
```

#### Dashboard Stats Card

```erb
<%= bui_card(variant: :info, style: :soft) do |c| %>
  <% c.with_body do %>
    <div class="text-center">
      <p class="text-3xl font-bold">1,234</p>
      <p class="text-sm text-gray-500">Total Users</p>
    </div>
  <% end %>
<% end %>
```

### Direct Render

```erb
<%= render BetterUi::CardComponent.new do |c| %>
  <% c.with_body do %>
    <p>Card content goes here</p>
  <% end %>
<% end %>
```

```erb
<%= render BetterUi::CardComponent.new(size: :lg, shadow: true) do |c| %>
  <% c.with_header do %>
    <h3 class="text-lg font-semibold">Card Title</h3>
  <% end %>

  <% c.with_body do %>
    <p>Main content area with automatic padding based on size.</p>
  <% end %>

  <% c.with_footer do %>
    <div class="flex justify-end gap-2">
      <%= render BetterUi::ButtonComponent.new(label: "Cancel", style: :ghost) %>
      <%= render BetterUi::ButtonComponent.new(label: "Save") %>
    </div>
  <% end %>
<% end %>
```

## Related

- [ButtonComponent](button.md) - Often used in card footers for actions
- [ActionMessagesComponent](action_messages.md) - Can be placed inside cards for contextual feedback
