# NumberInputComponent

Numeric input field with min/max validation and optional spinner controls.

## Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `name` | String | Required | Input field name attribute |
| `value` | Numeric | `nil` | Current field value |
| `label` | String | `nil` | Label text |
| `hint` | String | `nil` | Hint text below input |
| `placeholder` | String | `nil` | Placeholder text |
| `min` | Numeric | `nil` | Minimum value |
| `max` | Numeric | `nil` | Maximum value |
| `step` | Numeric | `nil` | Step increment |
| `show_spinner` | Boolean | `true` | Shows up/down arrows |
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
<%= form_with model: @product, builder: BetterUi::UiFormBuilder do |f| %>
  <%= f.bui_number_input :quantity,
    min: 1,
    max: 100,
    label: "Quantity" %>
<% end %>
```

#### Price Input with Currency Icon

```erb
<%= form_with model: @product, builder: BetterUi::UiFormBuilder do |f| %>
  <%= f.bui_number_input :price,
    min: 0,
    step: 0.01,
    placeholder: "0.00" do |c| %>
    <% c.with_prefix_icon { "$" } %>
  <% end %>
<% end %>
```

#### Without Spinners

```erb
<%= form_with model: @user, builder: BetterUi::UiFormBuilder do |f| %>
  <%= f.bui_number_input :age,
    min: 0,
    max: 120,
    show_spinner: false %>
<% end %>
```

### Standalone Helper

```erb
<%= bui_number_input("product[price]",
  label: "Price",
  min: 0,
  max: 99999,
  step: 0.01,
  placeholder: "0.00"
) do |c| %>
  <% c.with_prefix_icon { "$" } %>
<% end %>
```

#### Quantity Input

```erb
<%= bui_number_input("quantity",
  label: "Quantity",
  min: 1,
  max: 10,
  value: 1
) %>
```

#### Without Spinners

```erb
<%= bui_number_input("user[age]",
  label: "Age",
  min: 0,
  max: 120,
  show_spinner: false
) %>
```

### Direct Render

```erb
<%= render BetterUi::Forms::NumberInputComponent.new(
  name: "product[price]",
  label: "Price",
  min: 0,
  max: 99999,
  step: 0.01,
  placeholder: "0.00"
) do |c| %>
  <% c.with_prefix_icon { "$" } %>
<% end %>
```

```erb
<%= render BetterUi::Forms::NumberInputComponent.new(
  name: "user[age]",
  label: "Age",
  min: 0,
  max: 120,
  show_spinner: false
) %>
```

## Common Patterns

### Percentage Input

```erb
<%= bui_number_input("discount",
  label: "Discount",
  min: 0,
  max: 100,
  step: 1
) do |c| %>
  <% c.with_suffix_icon { "%" } %>
<% end %>
```

### Rating Input

```erb
<%= bui_number_input("rating",
  label: "Rating",
  min: 1,
  max: 5,
  step: 1,
  hint: "Rate from 1 to 5 stars"
) %>
```

## Related

- [TextInputComponent](text_input.md) - For text values
- [TextareaComponent](textarea.md) - For multi-line text
