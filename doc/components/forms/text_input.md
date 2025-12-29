# TextInputComponent

Standard text input field with full validation and icon support.

## Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `name` | String | Required | Input field name attribute |
| `value` | Any | `nil` | Current field value |
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

## Slots

- `prefix_icon` - Icon before the input field
- `suffix_icon` - Icon after the input field

## Usage

### With Form Builder (Recommended)

```erb
<%= form_with model: @user, builder: BetterUi::UiFormBuilder do |f| %>
  <%= f.bui_text_input :email,
    hint: "We'll never share your email",
    placeholder: "you@example.com" %>
<% end %>
```

#### With Icons

```erb
<%= form_with model: @user, builder: BetterUi::UiFormBuilder do |f| %>
  <%= f.bui_text_input :email do |c| %>
    <% c.with_prefix_icon do %>
      <svg class="w-5 h-5 text-gray-400"><!-- Email icon --></svg>
    <% end %>
  <% end %>
<% end %>
```

#### With Validation (Automatic)

The form builder automatically:
- Populates field values from the model
- Displays validation errors
- Marks required fields based on presence validators

```erb
<%= form_with model: @user, builder: BetterUi::UiFormBuilder do |f| %>
  <%# Errors display automatically if @user.errors[:email].any? %>
  <%= f.bui_text_input :email %>
<% end %>
```

### Standalone Helper

```erb
<%= bui_text_input("email",
  label: "Email Address",
  hint: "We'll never share your email",
  placeholder: "you@example.com",
  required: true
) %>
```

#### With Icons

```erb
<%= bui_text_input("user[username]", label: "Username") do |c| %>
  <% c.with_prefix_icon { "@" } %>
<% end %>
```

#### With Errors

```erb
<%= bui_text_input("user[email]",
  label: "Email",
  value: "invalid-email",
  errors: ["Email is invalid", "Email has already been taken"]
) %>
```

### Direct Render

```erb
<%= render BetterUi::Forms::TextInputComponent.new(
  name: "user[email]",
  label: "Email Address",
  hint: "We'll never share your email",
  placeholder: "you@example.com",
  required: true
) %>
```

```erb
<%= render BetterUi::Forms::TextInputComponent.new(
  name: "user[username]",
  label: "Username"
) do |c| %>
  <% c.with_prefix_icon { "@" } %>
<% end %>
```

```erb
<%= render BetterUi::Forms::TextInputComponent.new(
  name: "user[email]",
  label: "Email",
  value: "invalid-email",
  errors: ["Email is invalid", "Email has already been taken"]
) %>
```

## Common Patterns

### Search Input

```erb
<%= bui_text_input("q",
  placeholder: "Search...",
  size: :sm
) do |c| %>
  <% c.with_prefix_icon do %>
    <svg class="w-4 h-4 text-gray-400"><!-- Search icon --></svg>
  <% end %>
<% end %>
```

### Input with Clear Button

```erb
<%= bui_text_input("search",
  placeholder: "Search..."
) do |c| %>
  <% c.with_suffix_icon do %>
    <button type="button" class="text-gray-400 hover:text-gray-600">
      <svg class="w-4 h-4"><!-- X icon --></svg>
    </button>
  <% end %>
<% end %>
```

## Related

- [NumberInputComponent](number_input.md) - For numeric values
- [PasswordInputComponent](password_input.md) - For password fields
- [TextareaComponent](textarea.md) - For multi-line text
