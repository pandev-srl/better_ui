# Tabs::TabComponent

Individual tab with icon, badge, and disabled state support. Renders as a button (JS mode) or link (Turbo mode).

## Helper

```erb
<%= bui_tab(id: "profile", label: "Profile") %>
```

## Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `id` | String | Required | Unique tab identifier |
| `label` | String | Required | Display text |
| `href` | String | `nil` | URL for Turbo mode navigation |
| `active` | Boolean | `false` | Initially active state |
| `disabled` | Boolean | `false` | Disabled state |

## Slots

| Slot | Type | Description |
|------|------|-------------|
| `icon` | Single | Icon before the label |
| `badge` | Single | Badge after the label |

## Usage

Tabs are typically used inside a `bui_tabs` container. See [container.md](container.md) for complete examples.

```erb
<%= bui_tabs(mode: :js) do |tabs| %>
  <% tabs.with_tab(id: "messages", label: "Messages", active: true) do |tab| %>
    <% tab.with_icon { bui_fa_icon("envelope", style: :regular, size: :sm) } %>
    <% tab.with_badge { bui_badge(variant: :danger, counter: 3) } %>
  <% end %>
<% end %>
```
