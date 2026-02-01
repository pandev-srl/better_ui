# Tabs::ContainerComponent

Flexible tabs container with JS mode (client-side) and Turbo mode (server-rendered via Turbo Frames).

## Helper

```erb
<%= bui_tabs(mode: :js, style: :underline) do |tabs| %>
  <% tabs.with_tab(id: "tab1", label: "Tab 1", active: true) %>
  <% tabs.with_tab(id: "tab2", label: "Tab 2") %>
  <% tabs.with_panel(id: "tab1", active: true) { "Content 1" } %>
  <% tabs.with_panel(id: "tab2") { "Content 2" } %>
<% end %>
```

## Parameters

| Parameter | Type | Default | Options | Description |
|-----------|------|---------|---------|-------------|
| `mode` | Symbol | `:js` | `:js`, `:turbo` | Operating mode |
| `style` | Symbol | `:underline` | `:underline`, `:pills`, `:bordered` | Visual style |
| `variant` | Symbol | `:primary` | All 9 variants | Color variant |
| `size` | Symbol | `:md` | `:xs`, `:sm`, `:md`, `:lg`, `:xl` | Tab size |
| `alignment` | Symbol | `:start` | `:start`, `:center`, `:end`, `:stretch` | Tab alignment |
| `position` | Symbol | `:top` | `:top`, `:bottom`, `:left`, `:right` | Tab list position |
| `frame_id` | String | `nil` | — | Turbo Frame ID (required for turbo mode) |
| `default_tab` | String | `nil` | — | ID of the default active tab |
| `persist` | Boolean | `false` | — | Persist active tab state |
| `persist_key` | String | `nil` | — | localStorage key for persistence |

## Slots

| Slot | Type | Description |
|------|------|-------------|
| `tabs` | Multiple | `TabComponent` instances |
| `panels` | Multiple | `PanelComponent` instances (JS mode only) |
| `loader` | Single | Custom loader content (Turbo mode) |

## Stimulus Controller

`better-ui--tabs--container` - Handles tab switching, keyboard navigation, Turbo Frame loading, and loader state management.

## Usage

### JS Mode

All content is rendered in the DOM and switched client-side.

```erb
<%= bui_tabs(mode: :js, style: :underline) do |tabs| %>
  <% tabs.with_tab(id: "profile", label: "Profile", active: true) %>
  <% tabs.with_tab(id: "settings", label: "Settings") %>
  <% tabs.with_panel(id: "profile", active: true) { "Profile content" } %>
  <% tabs.with_panel(id: "settings") { "Settings content" } %>
<% end %>
```

### Turbo Mode

Content is loaded via Turbo Frames when tabs are clicked.

```erb
<%= bui_tabs(mode: :turbo, frame_id: "tab-content") do |tabs| %>
  <% tabs.with_tab(id: "profile", label: "Profile", href: profile_path, active: true) %>
  <% tabs.with_tab(id: "settings", label: "Settings", href: settings_path) %>
<% end %>

<turbo-frame id="tab-content">
  <%# Server-rendered content loaded here %>
</turbo-frame>
```

### Pills Style

```erb
<%= bui_tabs(mode: :js, style: :pills, variant: :success) do |tabs| %>
  <% tabs.with_tab(id: "tab1", label: "First", active: true) %>
  <% tabs.with_tab(id: "tab2", label: "Second") %>
  <% tabs.with_panel(id: "tab1", active: true) { "First tab" } %>
  <% tabs.with_panel(id: "tab2") { "Second tab" } %>
<% end %>
```

### Vertical Tabs

```erb
<%= bui_tabs(mode: :js, position: :left) do |tabs| %>
  <% tabs.with_tab(id: "tab1", label: "First", active: true) %>
  <% tabs.with_tab(id: "tab2", label: "Second") %>
  <% tabs.with_panel(id: "tab1", active: true) { "Content" } %>
  <% tabs.with_panel(id: "tab2") { "Content" } %>
<% end %>
```

### Tabs with Icons and Badges

```erb
<%= bui_tabs(mode: :js, style: :pills) do |tabs| %>
  <% tabs.with_tab(id: "messages", label: "Messages", active: true) do |tab| %>
    <% tab.with_icon { bui_fa_icon("envelope", style: :regular, size: :sm) } %>
    <% tab.with_badge { bui_badge(variant: :danger, counter: 3) } %>
  <% end %>
  <% tabs.with_tab(id: "settings", label: "Settings") do |tab| %>
    <% tab.with_icon { bui_fa_icon("cog", style: :solid, size: :sm) } %>
  <% end %>
  <% tabs.with_panel(id: "messages", active: true) { "Messages list" } %>
  <% tabs.with_panel(id: "settings") { "Settings form" } %>
<% end %>
```
