# SelectComponent

Custom dropdown select with keyboard navigation, type-ahead search, and ARIA support.

## Helper

```erb
<%= bui_select("country", [["Italy", "it"], ["France", "fr"]], label: "Country") %>
```

## Parameters

| Parameter | Type | Default | Options | Description |
|-----------|------|---------|---------|-------------|
| `name` | String | Required | — | Input name attribute |
| `collection` | Array | Required | — | `[[label, value], ...]` or `[value, ...]` |
| `value` | String | `nil` | — | Pre-selected value |
| `label` | String | `nil` | — | Label text |
| `hint` | String | `nil` | — | Hint text below input |
| `placeholder` | String | `nil` | — | Placeholder text |
| `size` | Symbol | `:md` | `:xs`, `:sm`, `:md`, `:lg`, `:xl` | Input size |
| `disabled` | Boolean | `false` | — | Disable select |
| `readonly` | Boolean | `false` | — | Read-only mode |
| `required` | Boolean | `false` | — | Mark as required |
| `clearable` | Boolean | `false` | — | Show clear (X) button |
| `dropdown_classes` | String | `nil` | — | Custom dropdown CSS classes |
| `errors` | Array | `nil` | — | Error messages |

## Slots

| Slot | Type | Description |
|------|------|-------------|
| `prefix_icon` | Single | Icon before the input |

## Stimulus Controller

`better-ui--forms--select` - Handles dropdown toggle, keyboard navigation, type-ahead search, and selection.

## Usage

### Basic Select

```erb
<%= bui_select("country",
  [["Italy", "it"], ["France", "fr"], ["Germany", "de"]],
  label: "Country",
  placeholder: "Select a country"
) %>
```

### Clearable Select with Icon

```erb
<%= bui_select("country", [["Italy", "it"], ["France", "fr"]], clearable: true) do |s| %>
  <% s.with_prefix_icon { bui_fa_icon("globe", style: :solid, size: :sm) } %>
<% end %>
```

### With Form Builder

```erb
<%= form_with model: @user, builder: BetterUi::UiFormBuilder do |f| %>
  <%= f.bui_select :country, [["Italy", "it"], ["France", "fr"]] %>
<% end %>
```

### Pre-selected Value

```erb
<%= bui_select("status",
  [["Active", "active"], ["Inactive", "inactive"]],
  value: "active",
  label: "Status"
) %>
```
