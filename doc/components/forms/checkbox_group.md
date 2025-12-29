# CheckboxGroupComponent

A checkbox group component for selecting multiple options from a collection. Renders a group of checkboxes within a fieldset, supporting both vertical and horizontal orientations.

## Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `name` | String | Required | Base name attribute for the checkboxes |
| `collection` | Array | `[]` | Options array (see Collection Format) |
| `selected` | Array/String | `[]` | Currently selected value(s) |
| `legend` | String | `nil` | Legend text for the fieldset |
| `hint` | String | `nil` | Hint text below the checkboxes |
| `variant` | Symbol | `:primary` | Color variant for all checkboxes |
| `size` | Symbol | `:md` | Size: `:xs`, `:sm`, `:md`, `:lg`, `:xl` |
| `orientation` | Symbol | `:vertical` | Layout: `:vertical`, `:horizontal` |
| `disabled` | Boolean | `false` | Disables all checkboxes |
| `required` | Boolean | `false` | Marks field as required |
| `errors` | Array<String> | `[]` | Validation error messages |
| `container_classes` | String | `nil` | Container CSS classes |
| `legend_classes` | String | `nil` | Legend CSS classes |
| `items_classes` | String | `nil` | Items container CSS classes |
| `hint_classes` | String | `nil` | Hint text CSS classes |
| `error_classes` | String | `nil` | Error message CSS classes |
| `**options` | Hash | `{}` | Additional HTML attributes |

## Collection Format

The `collection` parameter accepts two formats:

```ruby
# Simple array of values (label = value)
["Admin", "Editor", "Viewer"]

# Array of [label, value] pairs
[["Admin User", "admin"], ["Editor", "editor"], ["Viewer", "viewer"]]
```

## Usage

### With Form Builder (Recommended)

```erb
<%= form_with model: @user, builder: BetterUi::UiFormBuilder do |f| %>
  <%= f.bui_checkbox_group :roles,
    [["Admin", "admin"], ["Editor", "editor"], ["Viewer", "viewer"]],
    legend: "User Roles",
    selected: @user.roles %>
<% end %>
```

#### Simple Collection

```erb
<%= form_with model: @user, builder: BetterUi::UiFormBuilder do |f| %>
  <%= f.bui_checkbox_group :interests,
    ["Sports", "Music", "Art", "Travel"],
    legend: "Interests" %>
<% end %>
```

#### Horizontal Layout

```erb
<%= form_with model: @settings, builder: BetterUi::UiFormBuilder do |f| %>
  <%= f.bui_checkbox_group :days,
    ["Mon", "Tue", "Wed", "Thu", "Fri"],
    legend: "Working Days",
    orientation: :horizontal %>
<% end %>
```

### Standalone Helper

```erb
<%= bui_checkbox_group("user[roles]",
  ["Admin", "Editor", "Viewer"],
  legend: "User Roles"
) %>
```

#### With Label/Value Pairs and Pre-selected Values

```erb
<%= bui_checkbox_group("user[permissions]",
  [["Read", "read"], ["Write", "write"], ["Delete", "delete"]],
  selected: ["read", "write"],
  legend: "Permissions"
) %>
```

#### Horizontal Orientation

```erb
<%= bui_checkbox_group("options",
  ["Option A", "Option B", "Option C"],
  orientation: :horizontal
) %>
```

#### With Validation Errors

```erb
<%= bui_checkbox_group("user[interests]",
  ["Sports", "Music", "Art"],
  errors: ["Please select at least one interest"]
) %>
```

#### Different Variant

```erb
<%= bui_checkbox_group("features",
  ["Dark Mode", "Notifications", "Auto-save"],
  variant: :success,
  legend: "Features"
) %>
```

### Direct Render

```erb
<%= render BetterUi::Forms::CheckboxGroupComponent.new(
  name: "user[roles]",
  collection: ["Admin", "Editor", "Viewer"],
  legend: "User Roles"
) %>
```

```erb
<%= render BetterUi::Forms::CheckboxGroupComponent.new(
  name: "user[permissions]",
  collection: [["Read", "read"], ["Write", "write"], ["Delete", "delete"]],
  selected: ["read", "write"],
  legend: "Permissions"
) %>
```

```erb
<%= render BetterUi::Forms::CheckboxGroupComponent.new(
  name: "options",
  collection: ["Option A", "Option B", "Option C"],
  orientation: :horizontal
) %>
```

## Common Patterns

### User Roles Assignment

```erb
<%= form_with model: @user, builder: BetterUi::UiFormBuilder do |f| %>
  <%= f.bui_checkbox_group :roles,
    Role.all.map { |r| [r.name, r.id] },
    legend: "Assign Roles",
    selected: @user.role_ids,
    hint: "User will have permissions from all selected roles" %>

  <%= bui_button(type: :submit) { "Update Roles" } %>
<% end %>
```

### Category Selection

```erb
<%= form_with model: @post, builder: BetterUi::UiFormBuilder do |f| %>
  <%= f.bui_checkbox_group :category_ids,
    Category.all.pluck(:name, :id),
    legend: "Categories",
    required: true,
    hint: "Select at least one category" %>
<% end %>
```

### Feature Toggles

```erb
<%= form_with model: @settings, builder: BetterUi::UiFormBuilder do |f| %>
  <%= f.bui_checkbox_group :features,
    [
      ["Email Notifications", "email"],
      ["Push Notifications", "push"],
      ["SMS Alerts", "sms"],
      ["Weekly Digest", "digest"]
    ],
    legend: "Notification Settings",
    selected: @settings.enabled_features,
    variant: :success %>

  <%= bui_button(type: :submit) { "Save Settings" } %>
<% end %>
```

### Days of Week Selector

```erb
<%= bui_checkbox_group("schedule[days]",
  [
    ["Monday", "mon"],
    ["Tuesday", "tue"],
    ["Wednesday", "wed"],
    ["Thursday", "thu"],
    ["Friday", "fri"],
    ["Saturday", "sat"],
    ["Sunday", "sun"]
  ],
  legend: "Available Days",
  orientation: :horizontal,
  selected: @schedule.days
) %>
```

### Skills Selection

```erb
<%= form_with model: @profile, builder: BetterUi::UiFormBuilder do |f| %>
  <%= f.bui_checkbox_group :skills,
    Skill.all.pluck(:name, :id),
    legend: "Skills",
    hint: "Select all skills that apply",
    size: :sm %>
<% end %>
```

## Related

- [CheckboxComponent](checkbox.md) - For single checkboxes
- [ButtonComponent](../button.md) - For form submission
