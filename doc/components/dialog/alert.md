# Dialog::AlertComponent

A pre-built alert dialog that composes `DialogComponent` + `CardComponent` internally. Displays a centered icon, title, text, and a single OK button. Suitable for informational messages, success confirmations, and error notifications.

## Architecture

```
AlertComponent
  +-- DialogComponent (overlay, size, backdrop/escape)
        +-- CardComponent (style: :bordered, shadow: true)
              +-- body: icon + title + text (centered)
              +-- footer: OK button
```

The consumer only provides a trigger slot and configuration params -- the card layout is handled internally.

## Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `variant` | Symbol | `:info` | Color variant for icon and button (see below) |
| `title` | String/nil | `nil` | Alert title (rendered as `<h3>`) |
| `text` | String/nil | `nil` | Alert message body |
| `icon` | Boolean | `true` | Show variant-colored icon |
| `button_label` | String | `"OK"` | Label for the dismiss button |
| `size` | Symbol | `:sm` | Dialog width: `:sm`, `:md`, `:lg`, `:xl`, `:xxl`, `:full` |
| `close_on_backdrop` | Boolean | `true` | Close when clicking the backdrop |
| `close_on_escape` | Boolean | `true` | Close when pressing Escape |
| `**options` | Hash | `{}` | Additional HTML attributes (passed to DialogComponent) |

### Variant Reference

| Variant | Icon | Icon Colors |
|---------|------|-------------|
| `:success` | Check circle | `text-success-600 bg-success-100` |
| `:danger` | Exclamation circle | `text-danger-600 bg-danger-100` |
| `:warning` | Exclamation triangle | `text-warning-600 bg-warning-100` |
| `:info` | Information circle | `text-info-600 bg-info-100` |
| `:primary` | Information circle | `text-primary-600 bg-primary-100` |
| `:secondary` | Information circle | `text-secondary-600 bg-secondary-100` |
| `:accent` | Information circle | `text-accent-600 bg-accent-100` |
| `:light` | Information circle | `text-grayscale-600 bg-grayscale-100` |
| `:dark` | Information circle | `text-grayscale-800 bg-grayscale-200` |

## Slots

| Slot | Type | Description |
|------|------|-------------|
| `trigger` | Single | Element that opens the alert on click |

## Usage

### Helper Syntax

#### Basic Alert

```erb
<%= bui_dialog_alert(
  variant: :info,
  title: "Information",
  text: "Your session will expire in 5 minutes."
) do |a| %>
  <% a.with_trigger do %>
    <%= bui_button(variant: :info) { "Show Info" } %>
  <% end %>
<% end %>
```

#### Success Alert

```erb
<%= bui_dialog_alert(
  variant: :success,
  title: "Saved!",
  text: "Your changes have been saved successfully."
) do |a| %>
  <% a.with_trigger do %>
    <%= bui_button(variant: :success) { "Save" } %>
  <% end %>
<% end %>
```

#### Error Alert with Custom Button

```erb
<%= bui_dialog_alert(
  variant: :danger,
  title: "Error",
  text: "Something went wrong. Please try again.",
  button_label: "Got it"
) do |a| %>
  <% a.with_trigger do %>
    <%= bui_button(variant: :danger) { "Trigger Error" } %>
  <% end %>
<% end %>
```

#### Alert without Icon

```erb
<%= bui_dialog_alert(
  variant: :warning,
  title: "Warning",
  text: "This action has consequences.",
  icon: false
) do |a| %>
  <% a.with_trigger do %>
    <%= bui_button(variant: :warning) { "Show Warning" } %>
  <% end %>
<% end %>
```

### Direct Render

```erb
<%= render BetterUi::Dialog::AlertComponent.new(
  variant: :success,
  title: "Saved!",
  text: "Your changes have been saved."
) do |a| %>
  <% a.with_trigger do %>
    <%= render(BetterUi::ButtonComponent.new(variant: :success)) do %>Save<% end %>
  <% end %>
<% end %>
```

## Stimulus Events

The OK button triggers the `close` action on the dialog controller. The alert dispatches:

| Event | When |
|-------|------|
| `better-ui--dialog--dialog:closed` | After the alert is dismissed |

## Related

- [DialogComponent](dialog.md) -- The underlying overlay primitive
- [ConfirmComponent](confirm.md) -- Two-button variant (Cancel + Confirm)
- [CardComponent](../card.md) -- Used internally for content styling
