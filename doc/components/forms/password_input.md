# PasswordInputComponent

Password input field with built-in visibility toggle functionality.

## Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `name` | String | Required | Input field name attribute |
| `value` | String | `nil` | Current field value |
| `label` | String | `nil` | Label text |
| `hint` | String | `nil` | Hint text below input |
| `placeholder` | String | `nil` | Placeholder text |
| `size` | Symbol | `:md` | Size: `:xs`, `:sm`, `:md`, `:lg`, `:xl` |
| `disabled` | Boolean | `false` | Disables the input |
| `readonly` | Boolean | `false` | Makes input read-only |
| `required` | Boolean | `false` | Marks field as required |
| `errors` | Array<String> | `[]` | Validation error messages |
| `container_classes` | String | `nil` | Container CSS classes |
| `label_classes` | String | `nil` | Label CSS classes |
| `input_classes` | String | `nil` | Input field CSS classes |
| `hint_classes` | String | `nil` | Hint text CSS classes |
| `error_classes` | String | `nil` | Error message CSS classes |

## Features

- Built-in visibility toggle button (show/hide password)
- Automatically includes Stimulus controller for toggle behavior
- Eye icon updates to reflect current visibility state
- Maintains cursor position when toggling

## Usage

### With Form Builder (Recommended)

```erb
<%= form_with model: @user, builder: BetterUi::UiFormBuilder do |f| %>
  <%= f.bui_password_input :password,
    hint: "Must be at least 8 characters" %>
<% end %>
```

#### Password Confirmation

```erb
<%= form_with model: @user, builder: BetterUi::UiFormBuilder do |f| %>
  <%= f.bui_password_input :password,
    label: "Password",
    hint: "Must be at least 8 characters" %>

  <%= f.bui_password_input :password_confirmation,
    label: "Confirm Password" %>
<% end %>
```

#### Required Password

```erb
<%= form_with model: @user, builder: BetterUi::UiFormBuilder do |f| %>
  <%= f.bui_password_input :password,
    required: true %>
<% end %>
```

### Standalone Helper

```erb
<%= bui_password_input("password",
  label: "Password",
  hint: "Min 8 characters",
  required: true
) %>
```

#### Login Form

```erb
<%= bui_text_input("email",
  label: "Email",
  placeholder: "you@example.com",
  required: true
) %>

<%= bui_password_input("password",
  label: "Password",
  required: true
) %>
```

### Direct Render

```erb
<%= render BetterUi::Forms::PasswordInputComponent.new(
  name: "user[password]",
  label: "Password",
  hint: "Must be at least 8 characters",
  required: true
) %>
```

```erb
<%= render BetterUi::Forms::PasswordInputComponent.new(
  name: "user[password]",
  label: "Password"
) %>

<%= render BetterUi::Forms::PasswordInputComponent.new(
  name: "user[password_confirmation]",
  label: "Confirm Password"
) %>
```

## Stimulus Controller

The password component includes a visibility toggle controller that:
- Shows/hides password text on button click
- Updates toggle icon (eye/eye-off)
- Maintains cursor position during toggle

The controller is automatically registered as `better-ui--forms--password-input`.

## Common Patterns

### Registration Form

```erb
<%= form_with model: @user, builder: BetterUi::UiFormBuilder do |f| %>
  <%= f.bui_text_input :email %>

  <%= f.bui_password_input :password,
    hint: "Use at least 8 characters with a mix of letters, numbers, and symbols" %>

  <%= f.bui_password_input :password_confirmation %>

  <%= bui_button(type: :submit) { "Create Account" } %>
<% end %>
```

### Change Password Form

```erb
<%= form_with model: @user, builder: BetterUi::UiFormBuilder do |f| %>
  <%= f.bui_password_input :current_password,
    label: "Current Password" %>

  <%= f.bui_password_input :password,
    label: "New Password",
    hint: "Must be different from current password" %>

  <%= f.bui_password_input :password_confirmation,
    label: "Confirm New Password" %>

  <%= bui_button(type: :submit) { "Update Password" } %>
<% end %>
```

## Related

- [TextInputComponent](text_input.md) - For regular text fields
- [ButtonComponent](../button.md) - For form submission
