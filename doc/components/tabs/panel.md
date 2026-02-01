# Tabs::PanelComponent

Tab panel containing content for a single tab in JS mode.

## Helper

```erb
<%= bui_tab_panel(id: "profile", active: true) { "Profile content" } %>
```

## Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `id` | String | Required | Unique identifier matching the corresponding tab |
| `active` | Boolean | `false` | Initially visible state |

## Usage

Panels are used inside a `bui_tabs` container in JS mode. The `id` must match the corresponding tab's `id`.

```erb
<%= bui_tabs(mode: :js) do |tabs| %>
  <% tabs.with_tab(id: "profile", label: "Profile", active: true) %>
  <% tabs.with_tab(id: "settings", label: "Settings") %>
  <% tabs.with_panel(id: "profile", active: true) do %>
    <h2>Profile</h2>
    <p>Profile content goes here.</p>
  <% end %>
  <% tabs.with_panel(id: "settings") do %>
    <h2>Settings</h2>
    <p>Settings content goes here.</p>
  <% end %>
<% end %>
```
