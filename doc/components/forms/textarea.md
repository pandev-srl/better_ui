# TextareaComponent

Multi-line text input with adjustable rows and resize behavior.

## Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `name` | String | Required | Input field name attribute |
| `value` | String | `nil` | Current field value |
| `label` | String | `nil` | Label text |
| `hint` | String | `nil` | Hint text below input |
| `placeholder` | String | `nil` | Placeholder text |
| `rows` | Integer | `4` | Number of visible text lines |
| `cols` | Integer | `nil` | Width in characters |
| `maxlength` | Integer | `nil` | Maximum character count |
| `resize` | Symbol | `:vertical` | Resize behavior: `:none`, `:vertical`, `:horizontal`, `:both` |
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

## Usage

### With Form Builder (Recommended)

```erb
<%= form_with model: @post, builder: BetterUi::UiFormBuilder do |f| %>
  <%= f.bui_textarea :content,
    rows: 10,
    placeholder: "Write your content here...",
    maxlength: 5000,
    hint: "Maximum 5000 characters" %>
<% end %>
```

#### Fixed Size Textarea

```erb
<%= form_with model: @user, builder: BetterUi::UiFormBuilder do |f| %>
  <%= f.bui_textarea :bio,
    rows: 6,
    resize: :none %>
<% end %>
```

#### With Character Limit

```erb
<%= form_with model: @post, builder: BetterUi::UiFormBuilder do |f| %>
  <%= f.bui_textarea :summary,
    rows: 3,
    maxlength: 280,
    hint: "Maximum 280 characters" %>
<% end %>
```

### Standalone Helper

```erb
<%= bui_textarea("post[content]",
  label: "Content",
  rows: 10,
  placeholder: "Write your content here...",
  maxlength: 5000,
  hint: "Maximum 5000 characters"
) %>
```

#### Short Description

```erb
<%= bui_textarea("product[description]",
  label: "Short Description",
  rows: 3,
  maxlength: 200
) %>
```

#### Fixed Size

```erb
<%= bui_textarea("user[bio]",
  label: "Bio",
  rows: 6,
  resize: :none
) %>
```

### Direct Render

```erb
<%= render BetterUi::Forms::TextareaComponent.new(
  name: "post[content]",
  label: "Content",
  rows: 10,
  placeholder: "Write your content here...",
  maxlength: 5000,
  hint: "Maximum 5000 characters"
) %>
```

```erb
<%= render BetterUi::Forms::TextareaComponent.new(
  name: "user[bio]",
  label: "Bio",
  rows: 6,
  resize: :none
) %>
```

## Resize Options

| Value | Description |
|-------|-------------|
| `:none` | Cannot be resized |
| `:vertical` | Can be resized vertically only (default) |
| `:horizontal` | Can be resized horizontally only |
| `:both` | Can be resized in both directions |

## Common Patterns

### Blog Post Editor

```erb
<%= form_with model: @post, builder: BetterUi::UiFormBuilder do |f| %>
  <%= f.bui_text_input :title %>

  <%= f.bui_textarea :excerpt,
    label: "Excerpt",
    rows: 3,
    maxlength: 300,
    hint: "Brief summary shown in listings" %>

  <%= f.bui_textarea :content,
    label: "Content",
    rows: 20,
    placeholder: "Write your post..." %>

  <%= bui_button(type: :submit) { "Publish" } %>
<% end %>
```

### Comment Form

```erb
<%= form_with model: @comment, builder: BetterUi::UiFormBuilder do |f| %>
  <%= f.bui_textarea :body,
    label: "Comment",
    rows: 4,
    maxlength: 1000,
    placeholder: "Share your thoughts...",
    required: true %>

  <%= bui_button(type: :submit, size: :sm) { "Post Comment" } %>
<% end %>
```

### Contact Form Message

```erb
<%= bui_textarea("message",
  label: "Message",
  rows: 6,
  required: true,
  placeholder: "How can we help you?"
) %>
```

## Related

- [TextInputComponent](text_input.md) - For single-line text
- [PasswordInputComponent](password_input.md) - For password fields
