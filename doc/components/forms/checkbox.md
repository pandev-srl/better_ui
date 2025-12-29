# CheckboxComponent

A checkbox input component with support for labels, hints, errors, and color variants. Unlike text inputs, the label appears inline (left or right) with the checkbox.

## Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `name` | String | Required | Input field name attribute |
| `value` | String | `"1"` | Value submitted when checkbox is checked |
| `checked` | Boolean | `false` | Whether checkbox is initially checked |
| `label` | String | `nil` | Label text displayed next to checkbox |
| `hint` | String | `nil` | Hint text below the checkbox |
| `variant` | Symbol | `:primary` | Color variant (see VARIANTS) |
| `size` | Symbol | `:md` | Size: `:xs`, `:sm`, `:md`, `:lg`, `:xl` |
| `label_position` | Symbol | `:right` | Label position: `:left`, `:right` |
| `disabled` | Boolean | `false` | Disables the checkbox |
| `readonly` | Boolean | `false` | Makes checkbox read-only |
| `required` | Boolean | `false` | Marks field as required |
| `errors` | Array<String> | `[]` | Validation error messages |
| `container_classes` | String | `nil` | Container CSS classes |
| `label_classes` | String | `nil` | Label CSS classes |
| `checkbox_classes` | String | `nil` | Checkbox element CSS classes |
| `hint_classes` | String | `nil` | Hint text CSS classes |
| `error_classes` | String | `nil` | Error message CSS classes |
| `**options` | Hash | `{}` | Additional HTML attributes |

## Usage

### With Form Builder (Recommended)

```erb
<%= form_with model: @user, builder: BetterUi::UiFormBuilder do |f| %>
  <%= f.bui_checkbox :newsletter,
    label: "Subscribe to newsletter" %>
<% end %>
```

#### Terms Agreement

```erb
<%= form_with model: @user, builder: BetterUi::UiFormBuilder do |f| %>
  <%= f.bui_checkbox :terms,
    label: "I agree to the terms and conditions",
    required: true %>
<% end %>
```

#### With Different Variant

```erb
<%= form_with model: @settings, builder: BetterUi::UiFormBuilder do |f| %>
  <%= f.bui_checkbox :notifications,
    label: "Enable notifications",
    variant: :success,
    checked: true %>
<% end %>
```

### Standalone Helper

```erb
<%= bui_checkbox("user[terms]",
  label: "I agree to the terms and conditions"
) %>
```

#### Pre-checked Checkbox

```erb
<%= bui_checkbox("settings[notifications]",
  label: "Enable notifications",
  variant: :success,
  checked: true
) %>
```

#### Label on Left

```erb
<%= bui_checkbox("user[active]",
  label: "Active",
  label_position: :left
) %>
```

#### With Validation Errors

```erb
<%= bui_checkbox("user[terms]",
  label: "I agree to the terms",
  errors: ["You must agree to the terms"]
) %>
```

#### Different Sizes

```erb
<%= bui_checkbox("small", label: "Small checkbox", size: :sm) %>
<%= bui_checkbox("medium", label: "Medium checkbox", size: :md) %>
<%= bui_checkbox("large", label: "Large checkbox", size: :lg) %>
```

### Direct Render

```erb
<%= render BetterUi::Forms::CheckboxComponent.new(
  name: "user[terms]",
  label: "I agree to the terms and conditions"
) %>
```

```erb
<%= render BetterUi::Forms::CheckboxComponent.new(
  name: "settings[notifications]",
  label: "Enable notifications",
  variant: :success,
  checked: true
) %>
```

```erb
<%= render BetterUi::Forms::CheckboxComponent.new(
  name: "user[active]",
  label: "Active",
  label_position: :left
) %>
```

## Common Patterns

### Settings Form

```erb
<%= form_with model: @settings, builder: BetterUi::UiFormBuilder do |f| %>
  <fieldset class="space-y-4">
    <legend class="text-lg font-semibold">Notification Preferences</legend>

    <%= f.bui_checkbox :email_notifications,
      label: "Email notifications",
      hint: "Receive updates via email" %>

    <%= f.bui_checkbox :push_notifications,
      label: "Push notifications",
      hint: "Receive browser push notifications" %>

    <%= f.bui_checkbox :sms_notifications,
      label: "SMS notifications",
      hint: "Receive text messages" %>
  </fieldset>

  <%= bui_button(type: :submit) { "Save Preferences" } %>
<% end %>
```

### Registration Form with Terms

```erb
<%= form_with model: @user, builder: BetterUi::UiFormBuilder do |f| %>
  <%= f.bui_text_input :email %>
  <%= f.bui_password_input :password %>

  <div class="space-y-3 mt-4">
    <%= f.bui_checkbox :terms,
      label: "I agree to the Terms of Service",
      required: true %>

    <%= f.bui_checkbox :newsletter,
      label: "Subscribe to our newsletter",
      hint: "Get weekly updates on new features" %>
  </div>

  <%= bui_button(type: :submit) { "Create Account" } %>
<% end %>
```

### Toggle-style Options

```erb
<div class="space-y-2">
  <%= bui_checkbox("features[dark_mode]",
    label: "Dark mode",
    checked: @user.dark_mode?,
    variant: :dark
  ) %>

  <%= bui_checkbox("features[compact_view]",
    label: "Compact view",
    checked: @user.compact_view?
  ) %>
</div>
```

## Related

- [CheckboxGroupComponent](checkbox_group.md) - For multiple related checkboxes
- [ButtonComponent](../button.md) - For form submission
