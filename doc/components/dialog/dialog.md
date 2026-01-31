# Dialog::DialogComponent

An overlay-only modal dialog that provides backdrop, centering, size constraints, focus trap, and open/close animation. The dialog itself carries **no visual styling** (no background, border, shadow, or padding) -- content styling is delegated to whatever the consumer renders inside the block, typically a `CardComponent`.

## Architecture

```
DialogComponent (overlay + backdrop + centering + size constraint)
  +-- [trigger slot]  -- button/link that opens the dialog
  +-- [block content] -- consumer renders whatever they want here
```

`DialogComponent` is the low-level primitive. For common patterns see the higher-level [AlertComponent](alert.md) and [ConfirmComponent](confirm.md), which compose Dialog + Card internally.

## Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `size` | Symbol | `:md` | Panel max-width: `:sm`, `:md`, `:lg`, `:xl`, `:xxl`, `:full` |
| `close_on_backdrop` | Boolean | `true` | Close when clicking the backdrop |
| `close_on_escape` | Boolean | `true` | Close when pressing Escape |
| `open` | Boolean | `false` | Initial open state |
| `show_close_button` | Boolean | `true` | Show X close button (absolute top-right) |
| `container_classes` | String | `nil` | Additional CSS classes for the panel wrapper |
| `**options` | Hash | `{}` | Additional HTML attributes (e.g. `id:`) |

### Size Reference

| Size | Max-width | Typical Use |
|------|-----------|-------------|
| `:sm` | `max-w-sm` (384px) | Alerts, confirms, simple messages |
| `:md` | `max-w-md` (448px) | Short forms, detail views |
| `:lg` | `max-w-lg` (512px) | Medium forms, content previews |
| `:xl` | `max-w-xl` (576px) | Complex forms, multi-step wizards |
| `:xxl` | `max-w-2xl` (672px) | Wide content, tables, comparisons |
| `:full` | `max-w-full` | Full-width with 1rem margin |

## Slots

| Slot | Type | Description |
|------|------|-------------|
| `trigger` | Single | Element that opens the dialog on click |

The dialog body is rendered via the **block content** (not a slot).

## Usage

### Helper Syntax

#### Basic Dialog with Card

```erb
<%= bui_dialog(size: :md) do |d| %>
  <% d.with_trigger do %>
    <%= bui_button(variant: :primary) { "Open Dialog" } %>
  <% end %>

  <%= bui_card(style: :bordered, shadow: true) do |card| %>
    <% card.with_header do %>
      <h3 class="text-lg font-semibold">Edit Profile</h3>
    <% end %>

    <% card.with_body do %>
      <p>Form fields here...</p>
    <% end %>

    <% card.with_footer do %>
      <div class="flex justify-end gap-3">
        <%= bui_button(variant: :secondary, style: :outline,
              data: { action: "click->better-ui--dialog--dialog#close" }) { "Cancel" } %>
        <%= bui_button(variant: :primary,
              data: { action: "click->better-ui--dialog--dialog#close" }) { "Save" } %>
      </div>
    <% end %>
  <% end %>
<% end %>
```

#### Dialog without Close Button

```erb
<%= bui_dialog(size: :sm, show_close_button: false) do |d| %>
  <% d.with_trigger do %>
    <%= bui_button(variant: :warning) { "Open" } %>
  <% end %>

  <%= bui_card(style: :bordered, shadow: true) do |card| %>
    <% card.with_body { "You must use the button below to close." } %>
    <% card.with_footer do %>
      <%= bui_button(variant: :primary,
            data: { action: "click->better-ui--dialog--dialog#close" }) { "Close" } %>
    <% end %>
  <% end %>
<% end %>
```

#### Initially Open Dialog

```erb
<%= bui_dialog(size: :md, open: true) do %>
  <%= bui_card(style: :bordered, shadow: true) do |card| %>
    <% card.with_body { "This dialog opens automatically on page load." } %>
  <% end %>
<% end %>
```

### Direct Render

```erb
<%= render BetterUi::Dialog::DialogComponent.new(size: :lg) do |d| %>
  <% d.with_trigger do %>
    <%= render(BetterUi::ButtonComponent.new(variant: :primary)) do %>Open<% end %>
  <% end %>

  <%= render BetterUi::CardComponent.new(style: :bordered, shadow: true) do |card| %>
    <% card.with_body { "Content here" } %>
  <% end %>
<% end %>
```

## Stimulus Controller

The dialog ships a Stimulus controller (`better-ui--dialog--dialog`) that manages:

- **Open/close** with CSS transitions (fade + scale)
- **Backdrop click** to close (configurable)
- **Escape key** to close (configurable)
- **Focus trap** -- Tab/Shift+Tab cycles within the panel
- **Body scroll lock** -- prevents background scrolling while open
- **Focus restore** -- returns focus to the trigger element on close

### Stimulus Values

| Value | Type | Default | Description |
|-------|------|---------|-------------|
| `open` | Boolean | `false` | Current open state |
| `closeOnBackdrop` | Boolean | `true` | Close on backdrop click |
| `closeOnEscape` | Boolean | `true` | Close on Escape key |

### Stimulus Targets

| Target | Description |
|--------|-------------|
| `backdrop` | The backdrop overlay |
| `panel` | The dialog panel (receives animations) |

### Stimulus Actions

| Action | Description |
|--------|-------------|
| `open` | Open the dialog |
| `close` | Close the dialog, dispatches `better-ui--dialog--dialog:closed` |
| `toggle` | Toggle open/closed |
| `backdropClick` | Handle backdrop click (closes if `closeOnBackdrop` is true) |
| `confirm` | Dispatch `better-ui--dialog--dialog:confirmed` (cancelable), then close |
| `cancel` | Dispatch `better-ui--dialog--dialog:cancelled`, then close |

### Custom Events

| Event | Bubbles | Cancelable | Description |
|-------|---------|------------|-------------|
| `better-ui--dialog--dialog:closed` | Yes | No | Fired after the dialog closes |
| `better-ui--dialog--dialog:confirmed` | Yes | Yes | Fired on confirm action; call `preventDefault()` to keep dialog open |
| `better-ui--dialog--dialog:cancelled` | Yes | No | Fired on cancel action |

### Closing from Inside the Dialog

Any element inside the dialog can trigger close via a Stimulus action:

```erb
<button data-action="click->better-ui--dialog--dialog#close">Close</button>
```

## Advanced Patterns

### Remote Trigger (Dialog in a Different DOM Location)

When the trigger button and the dialog are in different parts of the DOM (e.g. a button in a table row opens a dialog in the layout), use a small app-side Stimulus controller:

```javascript
// app/javascript/controllers/dialog_trigger_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { dialogId: String, src: String }

  open() {
    const wrapper = document.getElementById(this.dialogIdValue)
    const controller = this.application.getControllerForElementAndIdentifier(
      wrapper, "better-ui--dialog--dialog"
    )

    // Optionally set turbo-frame src before opening
    if (this.hasSrcValue) {
      const frame = wrapper.querySelector("turbo-frame")
      if (frame) frame.src = this.srcValue
    }

    controller.open()
  }
}
```

The dialog somewhere in the layout:

```erb
<%= bui_dialog(size: :lg, id: "edit-dialog") do %>
  <%= bui_card(style: :bordered, shadow: true) do |card| %>
    <% card.with_body do %>
      <turbo-frame id="dialog-content"></turbo-frame>
    <% end %>
  <% end %>
<% end %>
```

Buttons anywhere in the page:

```erb
<% @items.each do |item| %>
  <tr>
    <td><%= item.name %></td>
    <td>
      <button data-controller="dialog-trigger"
              data-dialog-trigger-dialog-id-value="edit-dialog"
              data-dialog-trigger-src-value="<%= edit_item_path(item) %>"
              data-action="click->dialog-trigger#open">
        Edit
      </button>
    </td>
  </tr>
<% end %>
```

The server action renders content inside a matching turbo-frame:

```erb
<%# edit.html.erb %>
<turbo-frame id="dialog-content">
  <h3>Edit <%= @item.name %></h3>
  <%= form_with(model: @item) do |f| %>
    <%# form fields... %>
  <% end %>
</turbo-frame>
```

### Turbo Frame Inside a Dialog

Load content lazily into the dialog using a `<turbo-frame>` with `loading="lazy"`:

```erb
<%= bui_dialog(size: :lg, id: "details-dialog") do %>
  <%= bui_card(style: :bordered, shadow: true) do |card| %>
    <% card.with_body do %>
      <turbo-frame id="detail-content" src="" loading="lazy">
        <p class="text-grayscale-400 text-center py-8">Loading...</p>
      </turbo-frame>
    <% end %>
  <% end %>
<% end %>
```

### Listening for Confirm/Cancel Events

```erb
<div data-action="better-ui--dialog--dialog:confirmed->my-controller#handleConfirm
                   better-ui--dialog--dialog:cancelled->my-controller#handleCancel">
  <%= bui_dialog_confirm(variant: :danger, title: "Delete?", text: "Cannot undo.") do |c| %>
    <% c.with_trigger do %>
      <%= bui_button(variant: :danger) { "Delete" } %>
    <% end %>
  <% end %>
</div>
```

### Preventing Close on Confirm

Use `preventDefault()` on the `confirmed` event to keep the dialog open (e.g. while an async operation runs):

```javascript
// my_controller.js
handleConfirm(event) {
  event.preventDefault() // keeps dialog open

  fetch("/api/delete", { method: "DELETE" })
    .then(() => {
      // manually close after success
      const dialog = event.target.closest("[data-controller*='better-ui--dialog--dialog']")
      const ctrl = this.application.getControllerForElementAndIdentifier(
        dialog, "better-ui--dialog--dialog"
      )
      ctrl.close()
    })
}
```

## Related

- [AlertComponent](alert.md) -- Pre-built alert dialog (Dialog + Card + icon + OK button)
- [ConfirmComponent](confirm.md) -- Pre-built confirm dialog (Dialog + Card + icon + Cancel/Confirm)
- [CardComponent](../card.md) -- Used inside Dialog for content styling
- [ButtonComponent](../button.md) -- Used for triggers and dialog actions
