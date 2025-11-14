# BetterUi Components API Reference

Complete documentation for all BetterUi components, their parameters, usage examples, and best practices.

## Table of Contents

- [ApplicationComponent (Base Class)](#applicationcomponent-base-class)
- [Core Components](#core-components)
  - [ButtonComponent](#buttoncomponent)
  - [CardComponent](#cardcomponent)
  - [ActionMessagesComponent](#actionmessagescomponent)
- [Form Components](#form-components)
  - [Forms::BaseComponent](#formsbasecomponent)
  - [Forms::TextInputComponent](#formstextinputcomponent)
  - [Forms::NumberInputComponent](#formsnumberinputcomponent)
  - [Forms::PasswordInputComponent](#formspasswordinputcomponent)
  - [Forms::TextareaComponent](#formstextareacomponent)
- [Form Builder](#form-builder)
  - [UiFormBuilder](#uiformbuilder)

## ApplicationComponent (Base Class)

The base component class that all BetterUi components inherit from.

### Constants

```ruby
VARIANTS = {
  primary: 600,      # Strong, trustworthy actions
  secondary: 500,    # Neutral, supporting elements
  accent: 500,       # Highlights and special features
  success: 600,      # Positive actions, confirmations
  danger: 600,       # Destructive actions, errors
  warning: 500,      # Caution, alerts
  info: 500,         # Informational, tips
  light: 100,        # Light backgrounds and light text
  dark: 900          # Dark backgrounds and dark text
}
```

### Helper Methods

- `css_classes(*classes)` - Intelligently merges CSS classes using TailwindMerge

## Core Components

### ButtonComponent

A versatile button component with multiple styles, sizes, and states.

#### Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `variant` | Symbol | `:primary` | Color variant from VARIANTS |
| `style` | Symbol | `:solid` | Visual style: `:solid`, `:outline`, `:ghost`, `:soft` |
| `size` | Symbol | `:md` | Size: `:xs`, `:sm`, `:md`, `:lg`, `:xl` |
| `show_loader` | Boolean | `false` | Shows loading spinner |
| `show_loader_on_click` | Boolean | `false` | Shows loader after click |
| `disabled` | Boolean | `false` | Disables the button |
| `type` | Symbol | `:button` | Type: `:button`, `:submit`, `:reset` |
| `container_classes` | String | `nil` | Additional CSS classes |

#### Slots

- `icon_before` - Icon before button text
- `icon_after` - Icon after button text

#### Examples

```erb
# Basic button
<%= render BetterUi::ButtonComponent.new(label: "Click me") %>

# Styled button with icon
<%= render BetterUi::ButtonComponent.new(
  label: "Save",
  variant: "success",
  style: "solid"
) do |c| %>
  <% c.with_icon_before { "💾" } %>
<% end %>

# Loading button
<%= render BetterUi::ButtonComponent.new(
  label: "Processing...",
  show_loader: true,
  disabled: true
) %>

# Auto-loading on submit
<%= render BetterUi::ButtonComponent.new(
  label: "Submit",
  type: "submit",
  show_loader_on_click: true
) %>
```

### CardComponent

A flexible container component with structured content areas.

#### Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `size` | Symbol | `:md` | Padding size: `:sm`, `:md`, `:lg`, `:xl` |
| `bordered` | Boolean | `true` | Shows border |
| `shadow` | Symbol/Boolean | `false` | Shadow: `false`, `:sm`, `:md`, `:lg`, `:xl` |
| `container_classes` | String | `nil` | Additional CSS classes |

#### Slots

- `header` - Card header
- `body` - Main content
- `footer` - Card footer

#### Examples

```erb
# Basic card
<%= render BetterUi::CardComponent.new do |c| %>
  <% c.with_body { "Card content" } %>
<% end %>

# Full card structure
<%= render BetterUi::CardComponent.new(size: "lg", shadow: "md") do |c| %>
  <% c.with_header { content_tag(:h3, "Card Title", class: "text-lg font-semibold") } %>
  <% c.with_body { "Main content area" } %>
  <% c.with_footer do %>
    <%= render BetterUi::ButtonComponent.new(label: "Action") %>
  <% end %>
<% end %>
```

### ActionMessagesComponent

Displays messages with customizable styles, perfect for notifications and alerts.

#### Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `messages` | Array<String> | `[]` | Messages to display |
| `variant` | Symbol | `:info` | Color variant |
| `style` | Symbol | `:soft` | Style: `:solid`, `:soft`, `:outline`, `:ghost` |
| `dismissible` | Boolean | `false` | Shows dismiss button |
| `auto_dismiss` | Integer/nil | `nil` | Auto-dismiss seconds |
| `title` | String/nil | `nil` | Optional title |
| `container_classes` | String | `nil` | Additional CSS classes |

#### Examples

```erb
# Basic message
<%= render BetterUi::ActionMessagesComponent.new(
  messages: ["Operation completed"]
) %>

# Form errors
<%= render BetterUi::ActionMessagesComponent.new(
  variant: "danger",
  title: "Please fix these errors:",
  messages: @model.errors.full_messages
) %>

# Auto-dismissing success
<%= render BetterUi::ActionMessagesComponent.new(
  variant: "success",
  messages: ["Saved successfully!"],
  dismissible: true,
  auto_dismiss: 5
) %>
```

## Form Components

### Forms::BaseComponent

Abstract base class for all form inputs. All form components inherit these common parameters:

#### Common Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `name` | String | Required | Field name attribute |
| `value` | Any | `nil` | Current value |
| `label` | String | `nil` | Label text |
| `hint` | String | `nil` | Help text |
| `placeholder` | String | `nil` | Placeholder |
| `size` | Symbol | `:md` | Size variant |
| `disabled` | Boolean | `false` | Disabled state |
| `readonly` | Boolean | `false` | Read-only state |
| `required` | Boolean | `false` | Required field |
| `errors` | Array | `[]` | Error messages |
| `container_classes` | String | `nil` | Container CSS |
| `label_classes` | String | `nil` | Label CSS |
| `input_classes` | String | `nil` | Input CSS |

#### Common Slots

- `prefix_icon` - Icon before input
- `suffix_icon` - Icon after input

### Forms::TextInputComponent

Standard text input field.

#### Examples

```erb
# Basic text input
<%= render BetterUi::Forms::TextInputComponent.new(
  name: "user[email]",
  label: "Email",
  placeholder: "you@example.com"
) %>

# With icon and hint
<%= render BetterUi::Forms::TextInputComponent.new(
  name: "user[username]",
  label: "Username",
  hint: "Choose a unique username"
) do |c| %>
  <% c.with_prefix_icon { "@" } %>
<% end %>

# With errors
<%= render BetterUi::Forms::TextInputComponent.new(
  name: "user[email]",
  value: "invalid",
  errors: ["Email is invalid"]
) %>
```

### Forms::NumberInputComponent

Numeric input with validation and optional spinners.

#### Additional Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `min` | Numeric | `nil` | Minimum value |
| `max` | Numeric | `nil` | Maximum value |
| `step` | Numeric | `nil` | Step increment |
| `show_spinner` | Boolean | `true` | Show arrows |

#### Examples

```erb
# Price input
<%= render BetterUi::Forms::NumberInputComponent.new(
  name: "product[price]",
  label: "Price",
  min: 0,
  step: 0.01
) do |c| %>
  <% c.with_prefix_icon { "$" } %>
<% end %>

# Age without spinners
<%= render BetterUi::Forms::NumberInputComponent.new(
  name: "user[age]",
  label: "Age",
  min: 0,
  max: 120,
  show_spinner: false
) %>
```

### Forms::PasswordInputComponent

Password field with visibility toggle.

#### Examples

```erb
# Password field
<%= render BetterUi::Forms::PasswordInputComponent.new(
  name: "user[password]",
  label: "Password",
  hint: "At least 8 characters",
  required: true
) %>

# Confirmation field
<%= render BetterUi::Forms::PasswordInputComponent.new(
  name: "user[password_confirmation]",
  label: "Confirm Password"
) %>
```

### Forms::TextareaComponent

Multi-line text input.

#### Additional Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `rows` | Integer | `4` | Visible rows |
| `cols` | Integer | `nil` | Width in chars |
| `maxlength` | Integer | `nil` | Max characters |
| `resize` | Symbol | `:vertical` | Resize: `:none`, `:vertical`, `:horizontal`, `:both` |

#### Examples

```erb
# Basic textarea
<%= render BetterUi::Forms::TextareaComponent.new(
  name: "post[content]",
  label: "Content",
  rows: 10,
  placeholder: "Write here..."
) %>

# Fixed size with limit
<%= render BetterUi::Forms::TextareaComponent.new(
  name: "user[bio]",
  label: "Bio",
  rows: 4,
  maxlength: 200,
  resize: "none",
  hint: "Max 200 characters"
) %>
```

## Form Builder

### UiFormBuilder

Custom Rails form builder for BetterUi components.

#### Setup

```erb
<%= form_with model: @model, builder: BetterUi::UiFormBuilder do |f| %>
  <!-- form fields -->
<% end %>
```

#### Available Methods

- `ui_text_input(attribute, options = {})`
- `ui_number_input(attribute, options = {})`
- `ui_password_input(attribute, options = {})`
- `ui_textarea(attribute, options = {})`

#### Complete Example

```erb
<%= form_with model: @user, builder: BetterUi::UiFormBuilder do |f| %>
  <div class="space-y-4">
    # Text input
    <%= f.ui_text_input :name %>

    # Email with icon
    <%= f.ui_text_input :email do |c| %>
      <% c.with_prefix_icon do %>
        <svg class="w-5 h-5"><!-- icon --></svg>
      <% end %>
    <% end %>

    # Password fields
    <%= f.ui_password_input :password %>
    <%= f.ui_password_input :password_confirmation %>

    # Number input
    <%= f.ui_number_input :age, min: 0, max: 120 %>

    # Textarea
    <%= f.ui_textarea :bio, rows: 4 %>

    # Submit button
    <%= render BetterUi::ButtonComponent.new(
      label: "Save",
      type: "submit",
      show_loader_on_click: true
    ) %>
  </div>
<% end %>
```

#### Automatic Features

The form builder automatically:
- Populates values from the model
- Displays validation errors
- Marks required fields based on validators
- Generates proper field names
- Handles nested attributes

## Stimulus Controllers

BetterUi includes JavaScript controllers for interactive behavior:

### Button Controller
- `better-ui--button` - Handles loading states and click events

### Password Controller
- Toggles password visibility
- Maintains cursor position

### Action Messages Controller
- Handles dismiss functionality
- Auto-dismiss timer
- Fade animations

## Best Practices

1. **Use semantic variants** - Match variant to intent (success for positive actions)
2. **Leverage slots** - Use ViewComponent slots for icons and custom content
3. **Let form builder handle errors** - Don't manually pass errors when using UiFormBuilder
4. **Test rendered output** - Test HTML output, not component internals
5. **Compose complex UIs** - Build complex interfaces from simple components
6. **Use container classes** - Customize styling via `*_classes` parameters

## Common Patterns

### Form with Validation

```erb
<%= form_with model: @user, builder: BetterUi::UiFormBuilder do |f| %>
  <% if @user.errors.any? %>
    <%= render BetterUi::ActionMessagesComponent.new(
      variant: "danger",
      title: "Please fix these errors:",
      messages: @user.errors.full_messages
    ) %>
  <% end %>

  <%= f.ui_text_input :email %>
  <%= f.ui_password_input :password %>

  <%= render BetterUi::ButtonComponent.new(
    label: "Sign Up",
    type: "submit"
  ) %>
<% end %>
```

### Modal Dialog

```erb
<%= render BetterUi::CardComponent.new(shadow: "xl") do |card| %>
  <% card.with_header do %>
    <h2 class="text-xl font-semibold">Confirm Action</h2>
  <% end %>

  <% card.with_body do %>
    <p>Are you sure you want to proceed?</p>
  <% end %>

  <% card.with_footer do %>
    <div class="flex justify-end gap-2">
      <%= render BetterUi::ButtonComponent.new(
        label: "Cancel",
        variant: "secondary",
        style: "ghost"
      ) %>
      <%= render BetterUi::ButtonComponent.new(
        label: "Confirm",
        variant: "danger"
      ) %>
    </div>
  <% end %>
<% end %>
```

### Flash Messages

```erb
<% flash.each do |type, message| %>
  <%= render BetterUi::ActionMessagesComponent.new(
    variant: type == "alert" ? "danger" : "info",
    messages: [message],
    dismissible: true,
    auto_dismiss: 5
  ) %>
<% end %>
```

## Troubleshooting

### Components not styled
Ensure `application.postcss.css` includes:
```css
@source "../../../vendor/bundle/**/*.{rb,erb}";
```

### Form builder not working
Verify: `builder: BetterUi::UiFormBuilder`

### Errors not showing
Check model has ActiveModel validations

### Stimulus not working
Verify importmap/bundler includes BetterUi controllers

## See Also

- [Installation Guide](INSTALLATION.md)
- [Customization Guide](CUSTOMIZATION.md)
- [Changelog](CHANGELOG.md)