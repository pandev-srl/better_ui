# ActionMessagesComponent

Displays a list of messages with customizable styles and variants. Perfect for form validation errors, flash notifications, success messages, and warnings. Supports dismissible functionality and auto-dismiss timers.

## Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `messages` | Array<String> | `[]` | List of messages to display |
| `variant` | Symbol | `:info` | Color variant (see VARIANTS) |
| `style` | Symbol | `:soft` | Visual style: `:solid`, `:soft`, `:outline`, `:ghost` |
| `dismissible` | Boolean | `false` | Shows dismiss button |
| `auto_dismiss` | Integer/Float/nil | `nil` | Auto-dismiss after N seconds |
| `title` | String/nil | `nil` | Optional title/heading |
| `container_classes` | String/nil | `nil` | Additional CSS classes |

## Usage

### Helper Syntax

#### Basic Message

```erb
<%= bui_action_messages(["Operation completed successfully"]) %>
```

#### Form Validation Errors

```erb
<%= bui_action_messages(
  @user.errors.full_messages,
  variant: :danger,
  title: "Please correct the following errors:"
) %>
```

#### Success Notification with Auto-Dismiss

```erb
<%= bui_action_messages(
  ["Your changes have been saved."],
  variant: :success,
  style: :solid,
  dismissible: true,
  auto_dismiss: 5
) %>
```

#### Warning Alert

```erb
<%= bui_action_messages(
  ["This action cannot be undone", "Please confirm before proceeding"],
  variant: :warning,
  style: :outline,
  title: "Warning",
  dismissible: true
) %>
```

#### Info Message

```erb
<%= bui_action_messages(
  ["Your session will expire in 5 minutes"],
  variant: :info,
  dismissible: true
) %>
```

### Common Patterns

#### Flash Messages Helper

Create a helper to convert Rails flash types to BetterUi variants:

```ruby
# app/helpers/application_helper.rb
def flash_variant(type)
  case type.to_sym
  when :notice, :success then :success
  when :alert, :error then :danger
  when :warning then :warning
  else :info
  end
end
```

```erb
<%# In your layout or view %>
<% if flash.any? %>
  <% flash.each do |type, message| %>
    <%= bui_action_messages(
      [message],
      variant: flash_variant(type),
      dismissible: true,
      auto_dismiss: 5
    ) %>
  <% end %>
<% end %>
```

#### Inline Form Errors

```erb
<%= form_with model: @user, builder: BetterUi::UiFormBuilder do |f| %>
  <% if @user.errors.any? %>
    <%= bui_action_messages(
      @user.errors.full_messages,
      variant: :danger,
      title: "#{@user.errors.count} error(s) prevented saving:"
    ) %>
  <% end %>

  <%= f.bui_text_input :name %>
  <%= f.bui_text_input :email %>
  <%= bui_button(type: :submit) { "Save" } %>
<% end %>
```

### Direct Render

```erb
<%= render BetterUi::ActionMessagesComponent.new(
  messages: ["Operation completed successfully"]
) %>
```

```erb
<%= render BetterUi::ActionMessagesComponent.new(
  variant: :danger,
  title: "Please correct the following errors:",
  messages: @user.errors.full_messages
) %>
```

```erb
<%= render BetterUi::ActionMessagesComponent.new(
  variant: :success,
  style: :solid,
  dismissible: true,
  auto_dismiss: 5,
  messages: ["Your changes have been saved."]
) %>
```

## Stimulus Controller

Includes an action messages controller that handles:
- Dismiss functionality (click to close)
- Auto-dismiss timer
- Fade out animation

## Related

- [ButtonComponent](button.md) - Often triggers actions that result in messages
- [CardComponent](card.md) - Messages can be placed inside cards
- [Form Components](forms/) - Used to display validation errors
