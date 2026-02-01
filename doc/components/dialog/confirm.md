# Dialog::ConfirmComponent

A pre-built confirmation dialog that composes `DialogComponent` + `CardComponent` internally. Displays a centered icon, title, text, and two action buttons (Cancel + Confirm). Suitable for destructive actions, irreversible operations, and important decisions.

## Architecture

```
ConfirmComponent
  +-- DialogComponent (overlay, size, backdrop/escape)
        +-- CardComponent (style: :bordered, shadow: true)
              +-- body: icon + title + text (centered)
              +-- footer: Cancel button + Confirm button
```

The consumer only provides a trigger slot and configuration params -- the card layout is handled internally.

## Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `variant` | Symbol | `:warning` | Color variant for icon and confirm button |
| `title` | String/nil | `nil` | Confirm title (rendered as `<h3>`) |
| `text` | String/nil | `nil` | Confirm message body |
| `icon` | Boolean | `true` | Show variant-colored icon |
| `confirm_label` | String | `"Confirm"` | Label for the confirm button |
| `cancel_label` | String | `"Cancel"` | Label for the cancel button |
| `size` | Symbol | `:sm` | Dialog width: `:sm`, `:md`, `:lg`, `:xl`, `:xxl`, `:full` |
| `close_on_backdrop` | Boolean | `false` | Close when clicking the backdrop |
| `close_on_escape` | Boolean | `false` | Close when pressing Escape |
| `**options` | Hash | `{}` | Additional HTML attributes (passed to DialogComponent) |

> **Note:** `close_on_backdrop` and `close_on_escape` default to `false` for confirms, forcing the user to make an explicit choice.

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
| `trigger` | Single | Element that opens the confirm on click |

## Usage

### Helper Syntax

#### Delete Confirmation

```erb
<%= bui_dialog_confirm(
  variant: :danger,
  title: "Delete Item?",
  text: "This action cannot be undone. All associated data will be permanently removed.",
  confirm_label: "Yes, delete it",
  cancel_label: "No, keep it"
) do |c| %>
  <% c.with_trigger do %>
    <%= bui_button(variant: :danger) { "Delete" } %>
  <% end %>
<% end %>
```

#### Publish Confirmation

```erb
<%= bui_dialog_confirm(
  variant: :primary,
  title: "Publish Article?",
  text: "This will make the article visible to all users.",
  confirm_label: "Publish Now",
  cancel_label: "Save as Draft"
) do |c| %>
  <% c.with_trigger do %>
    <%= bui_button(variant: :primary) { "Publish" } %>
  <% end %>
<% end %>
```

#### Simple Confirmation

```erb
<%= bui_dialog_confirm(
  variant: :warning,
  title: "Confirm Action",
  text: "Are you sure you want to proceed?"
) do |c| %>
  <% c.with_trigger do %>
    <%= bui_button(variant: :warning) { "Proceed" } %>
  <% end %>
<% end %>
```

#### Confirmation without Icon

```erb
<%= bui_dialog_confirm(
  variant: :danger,
  title: "Remove User?",
  text: "The user will lose access to the organization.",
  icon: false
) do |c| %>
  <% c.with_trigger do %>
    <%= bui_button(variant: :danger, style: :outline) { "Remove" } %>
  <% end %>
<% end %>
```

### Direct Render

```erb
<%= bui_dialog_confirm(
  variant: :danger,
  title: "Delete?",
  text: "This cannot be undone.",
  confirm_label: "Delete",
  cancel_label: "Keep"
) do |c| %>
  <% c.with_trigger do %>
    <%= bui_button(variant: :danger) { "Delete" } %>
  <% end %>
<% end %>
```

## Stimulus Events

The Cancel button triggers `cancel` and the Confirm button triggers `confirm` on the dialog controller.

| Event | Bubbles | Cancelable | Description |
|-------|---------|------------|-------------|
| `better-ui--dialog--dialog:confirmed` | Yes | Yes | Fired when confirm is clicked |
| `better-ui--dialog--dialog:cancelled` | Yes | No | Fired when cancel is clicked |
| `better-ui--dialog--dialog:closed` | Yes | No | Fired after the dialog closes |

### Handling Confirm/Cancel in a Parent Controller

```erb
<div data-controller="my-list"
     data-action="better-ui--dialog--dialog:confirmed->my-list#deleteItem
                  better-ui--dialog--dialog:cancelled->my-list#cancelDelete">

  <%= bui_dialog_confirm(
    variant: :danger,
    title: "Delete?",
    text: "Cannot undo."
  ) do |c| %>
    <% c.with_trigger do %>
      <%= bui_button(variant: :danger) { "Delete" } %>
    <% end %>
  <% end %>
</div>
```

### Preventing Close on Confirm (Async Operations)

Call `preventDefault()` on the `confirmed` event to keep the dialog open while an async operation runs:

```javascript
// my_list_controller.js
deleteItem(event) {
  event.preventDefault() // dialog stays open

  fetch(`/items/${this.itemId}`, { method: "DELETE" })
    .then(response => {
      if (response.ok) {
        // manually close after success
        const dialog = event.target.closest("[data-controller*='better-ui--dialog--dialog']")
        const ctrl = this.application.getControllerForElementAndIdentifier(
          dialog, "better-ui--dialog--dialog"
        )
        ctrl.close()
        // update UI...
      }
    })
}
```

## Related

- [DialogComponent](dialog.md) -- The underlying overlay primitive
- [AlertComponent](alert.md) -- Single-button variant (OK only)
- [CardComponent](../card.md) -- Used internally for content styling
