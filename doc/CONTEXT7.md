# BetterUi Documentation (Context7 Optimized)

BetterUi is a Rails 8.1+ UI component library built with ViewComponent and Tailwind CSS v4. It provides production-ready, accessible components with full theme customization via OKLCH colors.

## Installation

### Step 1: Add Gem and npm Package

```ruby
# Gemfile
gem "better_ui"
```

```bash
bundle install
yarn add @pandev-srl/better-ui
```

### Step 2: Configure JavaScript

```javascript
// app/javascript/application.js
import { Application } from "@hotwired/stimulus"
import { registerControllers } from "@pandev-srl/better-ui"

const application = Application.start()
registerControllers(application)
```

### Step 3: Configure CSS

```css
/* app/assets/stylesheets/application.css */
@import "@pandev-srl/better-ui/css";
@source "../../../vendor/bundle/**/*.{rb,erb}";
```

Or import individual modules:

```css
@import "tailwindcss";
@import "@pandev-srl/better-ui/theme";
@import "@pandev-srl/better-ui/typography";
@import "@pandev-srl/better-ui/utilities";
@source "../../../vendor/bundle/**/*.{rb,erb}";
```

---

## Color Variants

All components support 9 semantic color variants:

| Variant | Purpose | Default Shade |
|---------|---------|---------------|
| `primary` | Main brand color | 600 |
| `secondary` | Supporting elements | 500 |
| `accent` | Highlights | 500 |
| `success` | Positive actions | 600 |
| `danger` | Destructive/errors | 600 |
| `warning` | Caution alerts | 500 |
| `info` | Informational | 500 |
| `light` | Light backgrounds | 100 |
| `dark` | Dark elements | 900 |

---

## ButtonComponent

Versatile button with multiple styles, sizes, and states. Supports loading indicators and icons.

### Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `variant` | Symbol | `:primary` | Color variant |
| `style` | Symbol | `:solid` | `:solid`, `:outline`, `:ghost`, `:soft` |
| `size` | Symbol | `:md` | `:xs`, `:sm`, `:md`, `:lg`, `:xl` |
| `show_loader` | Boolean | `false` | Show loading spinner |
| `show_loader_on_click` | Boolean | `false` | Show loader after click |
| `disabled` | Boolean | `false` | Disable button |
| `type` | Symbol | `:button` | `:button`, `:submit`, `:reset` |
| `href` | String | `nil` | Renders as `<a>` tag |
| `target` | String | `nil` | Link target |
| `container_classes` | String | `nil` | Additional CSS classes |

### Slots

- `icon_before` - Icon before button text
- `icon_after` - Icon after button text

### Usage

```erb
<%# Basic button %>
<%= bui_button(variant: :primary) { "Click me" } %>

<%# Submit button with loader %>
<%= bui_button(type: :submit, variant: :success, show_loader_on_click: true) { "Save Changes" } %>

<%# Button with icon %>
<%= bui_button(variant: :primary) do |c| %>
  <% c.with_icon_before do %>
    <%= bui_fa_icon("download", style: :solid, size: :sm) %>
  <% end %>
  Download
<% end %>

<%# Link button %>
<%= bui_button(href: users_path, variant: :info) { "View Users" } %>

<%# Danger button %>
<%= bui_button(variant: :danger, style: :outline) { "Delete" } %>

<%# Ghost button %>
<%= bui_button(variant: :secondary, style: :ghost) { "Cancel" } %>

<%# All sizes %>
<%= bui_button(size: :xs) { "XS" } %>
<%= bui_button(size: :sm) { "SM" } %>
<%= bui_button(size: :md) { "MD" } %>
<%= bui_button(size: :lg) { "LG" } %>
<%= bui_button(size: :xl) { "XL" } %>
```

---

## LinkComponent

Styled link with variants, icons, and sizes.

### Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `href` | String | Required | Link URL |
| `variant` | Symbol | `:primary` | Color variant |
| `style` | Symbol | `:default` | `:default`, `:underline`, `:ghost` |
| `size` | Symbol | `:md` | `:xs`, `:sm`, `:md`, `:lg`, `:xl` |
| `target` | String | `nil` | Link target |
| `rel` | String | `nil` | Rel attribute (auto-set for `_blank`) |
| `disabled` | Boolean | `false` | Disable link |
| `container_classes` | String | `nil` | Additional CSS classes |

### Slots

- `icon_before` - Icon before text
- `icon_after` - Icon after text

### Usage

```erb
<%= bui_link("/users", variant: :primary) { "View Users" } %>

<%= bui_link("https://example.com", target: "_blank", style: :underline) { "External Link" } %>

<%= bui_link("/settings", variant: :secondary) do |link| %>
  <% link.with_icon_before { bui_fa_icon("cog", style: :solid, size: :sm) } %>
  Settings
<% end %>
```

---

## CardComponent

Flexible container with header, body, and footer slots.

### Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `variant` | Symbol | `:primary` | Color variant |
| `style` | Symbol | `:solid` | `:solid`, `:outline`, `:ghost`, `:soft`, `:bordered` |
| `size` | Symbol | `:md` | `:xs`, `:sm`, `:md`, `:lg`, `:xl` |
| `shadow` | Boolean | `true` | Apply shadow |
| `header_padding` | Boolean | `true` | Padding on header |
| `body_padding` | Boolean | `true` | Padding on body |
| `footer_padding` | Boolean | `true` | Padding on footer |
| `container_classes` | String | `nil` | Container CSS classes |

### Slots

- `header` - Top section
- `body` - Main content
- `footer` - Bottom section

### Usage

```erb
<%# Basic card %>
<%= bui_card do |c| %>
  <% c.with_body { "Card content goes here" } %>
<% end %>

<%# Full card structure %>
<%= bui_card(size: :lg, shadow: true) do |c| %>
  <% c.with_header do %>
    <h3 class="text-lg font-semibold">Card Title</h3>
  <% end %>
  <% c.with_body do %>
    <p>Main content area.</p>
  <% end %>
  <% c.with_footer do %>
    <div class="flex justify-end gap-2">
      <%= bui_button(variant: :secondary, style: :ghost) { "Cancel" } %>
      <%= bui_button(variant: :primary) { "Save" } %>
    </div>
  <% end %>
<% end %>

<%# Outlined card %>
<%= bui_card(variant: :primary, style: :outline) do |c| %>
  <% c.with_body { "Outlined primary card" } %>
<% end %>

<%# Bordered card (variant-agnostic) %>
<%= bui_card(style: :bordered) do |c| %>
  <% c.with_body { "Neutral bordered card" } %>
<% end %>
```

---

## ActionMessagesComponent

Display flash messages, alerts, and validation errors.

### Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `variant` | Symbol | `:info` | Color variant |
| `style` | Symbol | `:soft` | `:solid`, `:soft`, `:outline`, `:ghost` |
| `title` | String | `nil` | Alert title |
| `messages` | Array | `[]` | Array of message strings |
| `dismissible` | Boolean | `true` | Show close button |
| `auto_dismiss` | Integer | `nil` | Seconds before auto-dismiss |
| `container_classes` | String | `nil` | Additional CSS classes |

### Usage

```erb
<%# Success message %>
<%= bui_action_messages(["Your changes have been saved."], variant: :success) %>

<%# Error messages with title %>
<%= bui_action_messages(@model.errors.full_messages, variant: :danger, title: "Validation Errors") %>

<%# Auto-dismissing alert %>
<%= bui_action_messages(["This will disappear in 5 seconds."], variant: :info, auto_dismiss: 5) %>

<%# Flash messages %>
<% flash.each do |type, message| %>
  <% variant = { notice: :success, alert: :danger, warning: :warning }[type.to_sym] || :info %>
  <%= bui_action_messages([message], variant: variant, auto_dismiss: 5) %>
<% end %>
```

---

## AvatarComponent

User avatar with image, initials fallback, and status indicator.

### Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `src` | String | `nil` | Image URL |
| `alt` | String | `nil` | Alt text (falls back to name) |
| `name` | String | `nil` | Full name for generating initials |
| `variant` | Symbol | `:primary` | Color variant for initials background |
| `size` | Symbol | `:md` | `:xs`, `:sm`, `:md`, `:lg`, `:xl` |
| `shape` | Symbol | `:circle` | `:circle`, `:square`, `:rounded` |
| `status` | Symbol | `nil` | `:online`, `:offline`, `:busy`, `:away` |
| `container_classes` | String | `nil` | Additional CSS classes |

### Slots

- `badge` - Badge overlay at top-right

### Usage

```erb
<%# Avatar with image %>
<%= bui_avatar(src: user.avatar_url, alt: user.name) %>

<%# Avatar with initials and status %>
<%= bui_avatar(name: "John Doe", variant: :primary, status: :online) %>

<%# Square avatar with badge %>
<%= bui_avatar(name: "Jane", shape: :square, size: :lg) do |a| %>
  <% a.with_badge { bui_badge(variant: :danger, counter: 3) } %>
<% end %>
```

---

## BadgeComponent

Label badge with dot, counter, and pill modes.

### Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `variant` | Symbol | `:primary` | Color variant |
| `style` | Symbol | `:solid` | `:solid`, `:outline`, `:soft`, `:ghost` |
| `size` | Symbol | `:md` | `:xs`, `:sm`, `:md`, `:lg` |
| `pill` | Boolean | `true` | Pill shape (rounded-full) |
| `dot` | Boolean | `false` | Show dot indicator |
| `counter` | Integer | `nil` | Show numeric counter |
| `container_classes` | String | `nil` | Additional CSS classes |

### Slots

- `icon_before` - Icon before badge text

### Usage

```erb
<%# Simple badge %>
<%= bui_badge(variant: :success) { "Active" } %>

<%# Counter badge %>
<%= bui_badge(variant: :danger, counter: 5) %>

<%# Dot badge %>
<%= bui_badge(variant: :success, dot: true) %>

<%# Outline badge %>
<%= bui_badge(variant: :info, style: :outline) { "New" } %>
```

---

## TagComponent

Dismissible tag with link support and Stimulus controller.

### Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `variant` | Symbol | `:primary` | Color variant |
| `style` | Symbol | `:solid` | `:solid`, `:outline`, `:soft` |
| `size` | Symbol | `:md` | `:xs`, `:sm`, `:md`, `:lg` |
| `dismissible` | Boolean | `false` | Show dismiss button |
| `href` | String | `nil` | Makes tag clickable (renders as `<a>`) |
| `container_classes` | String | `nil` | Additional CSS classes |

### Slots

- `icon_before` - Icon before tag text

### Usage

```erb
<%# Simple tag %>
<%= bui_tag(variant: :success) { "Active" } %>

<%# Dismissible tag %>
<%= bui_tag(variant: :info, dismissible: true) { "New" } %>

<%# Tag as link %>
<%= bui_tag(variant: :primary, href: "/tags/ruby") { "Ruby" } %>

<%# Tag with icon %>
<%= bui_tag(variant: :warning) do |t| %>
  <% t.with_icon_before { bui_fa_icon("exclamation-triangle", style: :solid, size: :xs) } %>
  Warning
<% end %>
```

---

## HeadingComponent

Semantic heading (h1-h6) with optional subtitle, actions, and divider.

### Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `level` | Symbol | `:h2` | `:h1`, `:h2`, `:h3`, `:h4`, `:h5`, `:h6` |
| `subtitle` | String | `nil` | Subtitle text |
| `divider` | Boolean | `false` | Show divider line below |
| `variant` | Symbol | `nil` | Color variant (`nil` for inherit) |
| `align` | Symbol | `:left` | `:left`, `:center`, `:right` |
| `container_classes` | String | `nil` | Additional CSS classes |

### Slots

- `subtitle` - Rich subtitle content (overrides subtitle param)
- `actions` - Action buttons or controls

### Usage

```erb
<%# Simple heading %>
<%= bui_heading(level: :h1, variant: :primary) { "Page Title" } %>

<%# Heading with subtitle %>
<%= bui_heading(level: :h2, subtitle: "Manage your account settings") { "Settings" } %>

<%# Heading with actions %>
<%= bui_heading(level: :h2, divider: true) do |h| %>
  <% h.with_actions { bui_button(variant: :primary, size: :sm) { "Add New" } } %>
  Users
<% end %>
```

---

## SpinnerComponent

Loading indicator with color and size variants.

### Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `variant` | Symbol | `:primary` | Color variant |
| `size` | Symbol | `:md` | `:xs`, `:sm`, `:md`, `:lg`, `:xl` |
| `label` | String | `nil` | Accessible sr-only label |
| `container_classes` | String | `nil` | Additional CSS classes |

### Usage

```erb
<%# Default spinner %>
<%= bui_spinner %>

<%# Large success spinner %>
<%= bui_spinner(variant: :success, size: :lg, label: "Saving...") %>
```

---

## ProgressComponent

Progress bar with label and animation.

### Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `value` | Numeric | `0` | Current value |
| `max` | Numeric | `100` | Maximum value |
| `variant` | Symbol | `:primary` | Color variant |
| `size` | Symbol | `:md` | `:xs`, `:sm`, `:md`, `:lg` |
| `label` | String | `nil` | Text above the bar |
| `show_value` | Boolean | `false` | Show percentage text |
| `animated` | Boolean | `false` | Striped animation |
| `container_classes` | String | `nil` | Additional CSS classes |

### Usage

```erb
<%# Default progress %>
<%= bui_progress(value: 50) %>

<%# With label and value display %>
<%= bui_progress(value: 75, label: "Upload progress", show_value: true, variant: :success) %>

<%# Animated progress %>
<%= bui_progress(value: 60, animated: true, variant: :info) %>
```

---

## DividerComponent

Visual separator with label and orientation.

### Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `orientation` | Symbol | `:horizontal` | `:horizontal`, `:vertical` |
| `style` | Symbol | `:solid` | `:solid`, `:dashed`, `:dotted` |
| `variant` | Symbol | `nil` | Color variant (`nil` for gray) |
| `size` | Symbol | `:md` | `:xs`, `:sm`, `:md` |
| `label` | String | `nil` | Centered text label |
| `label_position` | Symbol | `:center` | `:left`, `:center`, `:right` |
| `spacing` | Symbol | `:md` | `:xs`, `:sm`, `:md`, `:lg`, `:xl` |
| `container_classes` | String | `nil` | Additional CSS classes |

### Usage

```erb
<%# Basic divider %>
<%= bui_divider %>

<%# Dashed divider with label %>
<%= bui_divider(style: :dashed, label: "OR", variant: :primary) %>

<%# Vertical divider (use inside a flex container) %>
<%= bui_divider(orientation: :vertical) %>
```

---

## TooltipComponent

Stimulus-powered tooltip with fixed positioning that escapes overflow clipping. Supports position and style variants.

### Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `text` | String | Required | Tooltip content |
| `position` | Symbol | `:top` | `:top`, `:right`, `:bottom`, `:left` |
| `variant` | Symbol | `:dark` | `:dark`, `:light` |
| `size` | Symbol | `:sm` | `:sm`, `:md` |
| `container_classes` | String | `nil` | Additional CSS classes |

### Usage

```erb
<%# Simple tooltip %>
<%= bui_tooltip("Save changes") do %>
  <%= bui_button(variant: :primary) { "Save" } %>
<% end %>

<%# Tooltip with position %>
<%= bui_tooltip("Delete item", position: :bottom, variant: :light) do %>
  <%= bui_button(variant: :danger, style: :ghost) { "Delete" } %>
<% end %>
```

---

## ContainerComponent

Responsive max-width content wrapper.

### Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `size` | Symbol | `:lg` | `:sm`, `:md`, `:lg`, `:xl`, `:full` |
| `padding` | Boolean | `true` | Apply horizontal padding |
| `centered` | Boolean | `true` | Center with mx-auto |
| `container_classes` | String | `nil` | Additional CSS classes |

### Usage

```erb
<%# Default container %>
<%= bui_container { "Page content" } %>

<%# Full-width container without padding %>
<%= bui_container(size: :full, padding: false) { "Edge-to-edge content" } %>
```

---

## FaIconComponent

FontAwesome icon wrapper with styles, animations, and transformations.

### Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `name` | String | Required | FontAwesome icon name (e.g., "user", "check") |
| `style` | Symbol | `:regular` | `:regular`, `:solid`, `:light`, `:thin`, `:brands` |
| `variant` | Symbol | `nil` | Color variant (`nil` = inherit) |
| `size` | Symbol | `:md` | `:xs`, `:sm`, `:md`, `:lg`, `:xl`, `:"2xl"` |
| `spin` | Boolean | `false` | Spin animation |
| `pulse` | Boolean | `false` | Pulse animation |
| `flip` | Symbol | `nil` | `:horizontal`, `:vertical`, `:both` |
| `rotate` | Integer | `nil` | `90`, `180`, `270` |
| `fixed_width` | Boolean | `false` | Fixed width |
| `container_classes` | String | `nil` | Additional CSS classes |

### Usage

```erb
<%# Default icon %>
<%= bui_fa_icon("user") %>

<%# Solid icon with color and size %>
<%= bui_fa_icon("heart", style: :solid, variant: :danger, size: :lg) %>

<%# Spinning icon %>
<%= bui_fa_icon("spinner", style: :solid, spin: true) %>

<%# Brand icon %>
<%= bui_fa_icon("github", style: :brands, size: :xl) %>
```

---

## Breadcrumb

Breadcrumb navigation with configurable separators.

### Parameters (BreadcrumbComponent)

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `separator` | Symbol | `:slash` | `:slash`, `:chevron`, `:dot` |
| `size` | Symbol | `:md` | `:sm`, `:md`, `:lg` |
| `container_classes` | String | `nil` | Additional CSS classes |

### Slots

- `items` (multiple) - `Breadcrumb::ItemComponent` instances
  - `label` (String, required) - Item text
  - `href` (String, nil) - Link URL (`nil` = current page)
  - `icon_before` slot - Optional icon

### Usage

```erb
<%= bui_breadcrumb(separator: :chevron) do |bc| %>
  <% bc.with_item(label: "Home", href: root_path) %>
  <% bc.with_item(label: "Products", href: products_path) %>
  <% bc.with_item(label: "Widget") %>
<% end %>
```

---

## Form Components

All form components support standalone usage and Rails form builder integration.

### UiFormBuilder Setup

```erb
<%= form_with model: @user, builder: BetterUi::UiFormBuilder do |f| %>
  <%= f.bui_text_input :email %>
  <%= f.bui_password_input :password %>
  <%= f.bui_textarea :bio %>
  <%= f.bui_number_input :age %>
  <%= f.bui_checkbox :terms %>
  <%= f.bui_select :country, [["Italy", "it"], ["France", "fr"]] %>
  <%= bui_button(type: :submit) { "Submit" } %>
<% end %>
```

---

## TextInputComponent

Standard text input with validation and icon support.

### Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `name` | String | Required | Field name |
| `value` | Any | `nil` | Field value |
| `label` | String | `nil` | Label text |
| `hint` | String | `nil` | Hint text |
| `placeholder` | String | `nil` | Placeholder |
| `size` | Symbol | `:md` | Input size |
| `disabled` | Boolean | `false` | Disable input |
| `readonly` | Boolean | `false` | Read-only mode |
| `required` | Boolean | `false` | Mark required |
| `errors` | Array | `[]` | Error messages |

### Slots

- `prefix_icon` - Icon before input
- `suffix_icon` - Icon after input

### Usage

```erb
<%# With form builder %>
<%= form_with model: @user, builder: BetterUi::UiFormBuilder do |f| %>
  <%= f.bui_text_input :email,
    hint: "We'll never share your email",
    placeholder: "you@example.com" %>
<% end %>

<%# With form builder and icon %>
<%= form_with model: @user, builder: BetterUi::UiFormBuilder do |f| %>
  <%= f.bui_text_input :email do |c| %>
    <% c.with_prefix_icon { bui_fa_icon("envelope", style: :regular, size: :sm) } %>
  <% end %>
<% end %>

<%# Standalone %>
<%= bui_text_input("user[email]", label: "Email", placeholder: "you@example.com", required: true) %>

<%# Email input shorthand %>
<%= bui_email_input("email", label: "Email", placeholder: "you@example.com") %>

<%# Date input shorthand %>
<%= bui_date_input("birthday", label: "Date of Birth") %>
```

---

## NumberInputComponent

Numeric input with min/max validation.

### Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `name` | String | Required | Field name |
| `value` | Numeric | `nil` | Field value |
| `label` | String | `nil` | Label text |
| `hint` | String | `nil` | Hint text |
| `min` | Numeric | `nil` | Minimum value |
| `max` | Numeric | `nil` | Maximum value |
| `step` | Numeric | `1` | Step increment |
| `show_spinner` | Boolean | `true` | Show spinner buttons |
| `size` | Symbol | `:md` | Input size |
| `disabled` | Boolean | `false` | Disable input |
| `required` | Boolean | `false` | Mark required |
| `errors` | Array | `[]` | Error messages |

### Slots

- `prefix_icon` - Icon before input
- `suffix_icon` - Icon after input

### Usage

```erb
<%# With form builder %>
<%= form_with model: @product, builder: BetterUi::UiFormBuilder do |f| %>
  <%= f.bui_number_input :price, min: 0, step: 0.01, hint: "Enter price in dollars" %>
<% end %>

<%# Standalone with prefix icon %>
<%= bui_number_input("product[price]", label: "Price", min: 0, step: 0.01) do |c| %>
  <% c.with_prefix_icon { "$" } %>
<% end %>

<%# Quantity input %>
<%= bui_number_input("quantity", label: "Quantity", min: 1, max: 100, value: 1) %>
```

---

## PasswordInputComponent

Password input with visibility toggle via Stimulus controller.

### Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `name` | String | Required | Field name |
| `value` | String | `nil` | Field value |
| `label` | String | `nil` | Label text |
| `hint` | String | `nil` | Hint text |
| `placeholder` | String | `nil` | Placeholder |
| `size` | Symbol | `:md` | Input size |
| `disabled` | Boolean | `false` | Disable input |
| `required` | Boolean | `false` | Mark required |
| `errors` | Array | `[]` | Error messages |

### Usage

```erb
<%# With form builder %>
<%= form_with model: @user, builder: BetterUi::UiFormBuilder do |f| %>
  <%= f.bui_password_input :password, hint: "Minimum 8 characters" %>
<% end %>

<%# Standalone %>
<%= bui_password_input("user[password]", label: "Password", hint: "Minimum 8 characters", required: true) %>
```

---

## TextareaComponent

Multi-line text input with resizing options.

### Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `name` | String | Required | Field name |
| `value` | String | `nil` | Field value |
| `label` | String | `nil` | Label text |
| `hint` | String | `nil` | Hint text |
| `placeholder` | String | `nil` | Placeholder |
| `rows` | Integer | `4` | Number of rows |
| `resize` | Symbol | `:vertical` | `:none`, `:vertical`, `:horizontal`, `:both` |
| `maxlength` | Integer | `nil` | Max character length |
| `size` | Symbol | `:md` | Input size |
| `disabled` | Boolean | `false` | Disable input |
| `required` | Boolean | `false` | Mark required |
| `errors` | Array | `[]` | Error messages |

### Usage

```erb
<%# With form builder %>
<%= form_with model: @post, builder: BetterUi::UiFormBuilder do |f| %>
  <%= f.bui_textarea :content, rows: 6, hint: "Write your content here" %>
<% end %>

<%# Standalone %>
<%= bui_textarea("post[content]", label: "Content", rows: 6, resize: :vertical, maxlength: 1000) %>
```

---

## CheckboxComponent

Single checkbox with label and variants.

### Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `name` | String | Required | Field name |
| `checked` | Boolean | `false` | Checked state |
| `label` | String | `nil` | Label text |
| `hint` | String | `nil` | Hint text |
| `variant` | Symbol | `:primary` | Color variant |
| `size` | Symbol | `:md` | Checkbox size |
| `disabled` | Boolean | `false` | Disable checkbox |
| `required` | Boolean | `false` | Mark required |
| `value` | String | `"1"` | Checkbox value |
| `errors` | Array | `[]` | Error messages |

### Usage

```erb
<%# With form builder %>
<%= form_with model: @user, builder: BetterUi::UiFormBuilder do |f| %>
  <%= f.bui_checkbox :terms, label: "I agree to the terms and conditions", required: true %>
<% end %>

<%# Standalone %>
<%= bui_checkbox("newsletter", label: "Subscribe to newsletter", variant: :primary) %>
```

---

## CheckboxGroupComponent

Multiple checkboxes for multi-select options.

### Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `name` | String | Required | Field name |
| `collection` | Array | Required | `[[label, value], ...]` |
| `selected` | Array | `[]` | Pre-selected values |
| `legend` | String | `nil` | Fieldset legend |
| `hint` | String | `nil` | Hint text |
| `variant` | Symbol | `:primary` | Color variant |
| `orientation` | Symbol | `:vertical` | `:vertical`, `:horizontal` |
| `disabled` | Boolean | `false` | Disable all checkboxes |
| `errors` | Array | `[]` | Error messages |

### Usage

```erb
<%# With form builder %>
<%= form_with model: @user, builder: BetterUi::UiFormBuilder do |f| %>
  <%= f.bui_checkbox_group :roles,
    [["Admin", "admin"], ["Editor", "editor"], ["Viewer", "viewer"]],
    legend: "User Roles" %>
<% end %>

<%# Standalone horizontal layout %>
<%= bui_checkbox_group("features",
  [["Feature A", "a"], ["Feature B", "b"]],
  orientation: :horizontal
) %>
```

---

## SelectComponent

Custom dropdown select with keyboard navigation, type-ahead search, and ARIA support.

### Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `name` | String | Required | Field name |
| `collection` | Array | Required | `[[label, value], ...]` or `[value, ...]` |
| `value` | String | `nil` | Selected value |
| `label` | String | `nil` | Label text |
| `hint` | String | `nil` | Hint text |
| `placeholder` | String | `nil` | Placeholder text |
| `size` | Symbol | `:md` | Input size |
| `disabled` | Boolean | `false` | Disable select |
| `required` | Boolean | `false` | Mark required |
| `clearable` | Boolean | `false` | Show clear button |
| `dropdown_classes` | String | `nil` | Custom dropdown CSS classes |
| `errors` | Array | `[]` | Error messages |

### Slots

- `prefix_icon` - Icon before the input

### Usage

```erb
<%# Standalone %>
<%= bui_select("country",
  [["Italy", "it"], ["France", "fr"], ["Germany", "de"]],
  label: "Country",
  placeholder: "Select a country"
) %>

<%# Clearable with icon %>
<%= bui_select("country", [["Italy", "it"], ["France", "fr"]], clearable: true) do |s| %>
  <% s.with_prefix_icon { bui_fa_icon("globe", style: :solid, size: :sm) } %>
<% end %>

<%# With form builder %>
<%= form_with model: @user, builder: BetterUi::UiFormBuilder do |f| %>
  <%= f.bui_select :country, [["Italy", "it"], ["France", "fr"]] %>
<% end %>
```

---

## TableComponent

Flexible data table supporting two modes: **slot-based** (manual rows/cells) and **collection-based** (automatic rendering from data).

### Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `variant` | Symbol | `:primary` | Color variant |
| `style` | Symbol | `:default` | `:default`, `:bordered` |
| `size` | Symbol | `:md` | `:xs`, `:sm`, `:md`, `:lg`, `:xl` |
| `rounded` | Symbol | `:md` | `:none`, `:sm`, `:md`, `:lg`, `:xl`, `:full` |
| `striped` | Boolean | `false` | Alternate row backgrounds |
| `hoverable` | Boolean | `false` | Hover highlight on rows |
| `responsive` | Boolean | `true` | Horizontal scroll wrapper |
| `shadow` | Symbol | `:sm` | `:none`, `:sm`, `:md`, `:lg`, `:xl` |
| `caption` | String | `nil` | Table caption text |
| `collection` | Array | `nil` | Data collection (activates collection mode) |
| `row_highlighted` | Proc | `nil` | Lambda `(item) -> bool` for row highlighting |
| `body_row_partial` | String | `nil` | Partial path for custom row rendering |
| `header_partial` | String | `nil` | Partial path for custom header |
| `footer_partial` | String | `nil` | Partial path for custom footer |
| `sort_column` | Symbol | `nil` | Currently sorted column key (auto-derives `sorted` per column) |
| `sort_direction` | Symbol | `nil` | Current sort direction (`:asc` or `:desc`) |
| `sort_url` | Proc | `nil` | Lambda `(key, direction) -> url` for generating sort links |
| `sort_html` | Hash | `{}` | HTML attributes for sort links (e.g. `data-turbo-frame`) |
| `container_classes` | String | `nil` | Wrapper div CSS classes |

### Slot-Based Usage

```erb
<%= bui_table(variant: :primary, striped: true, hoverable: true) do |t| %>
  <% t.with_header do |h| %>
    <% h.with_cell(label: "Name") %>
    <% h.with_cell(label: "Email") %>
    <% h.with_cell(label: "Actions", align: :right) %>
  <% end %>

  <% @users.each do |user| %>
    <% t.with_row do |r| %>
      <% r.with_cell { user.name } %>
      <% r.with_cell { user.email } %>
      <% r.with_cell(align: :right) { bui_link(edit_user_path(user)) { "Edit" } } %>
    <% end %>
  <% end %>

  <% t.with_empty_state { "No users found." } %>
<% end %>
```

### Collection-Based Usage

```erb
<%= bui_table(collection: @users, variant: :primary, striped: true) do |t| %>
  <% t.with_column(key: :name, label: "Name") %>
  <% t.with_column(key: :email, label: "Email") %>
  <% t.with_column(key: :role, label: "Role") { |user| user.role.humanize } %>
  <% t.with_column(key: :actions, label: "Actions", align: :right) { |user| bui_link(edit_user_path(user)) { "Edit" } } %>
  <% t.with_empty_state { "No users found." } %>
<% end %>
```

### Highlighted Rows (Collection Mode)

```erb
<%= bui_table(
  collection: @users,
  variant: :warning,
  row_highlighted: ->(user) { user.flagged? }
) do |t| %>
  <% t.with_column(key: :name, label: "Name") %>
<% end %>
```

### Sortable Headers

#### Sort Indicators (No Links)

Sortable columns display directional SVG chevron icons. Without `sort_url`, headers render as non-clickable spans.

```erb
<%# Slot mode %>
<%= bui_table(variant: :primary) do |t| %>
  <% t.with_header do |h| %>
    <% h.with_cell(label: "Name", sortable: true, sorted: true, sort_direction: :asc) %>
    <% h.with_cell(label: "Email", sortable: true) %>
    <% h.with_cell(label: "Role") %>
  <% end %>
  <%# ... rows ... %>
<% end %>

<%# Collection mode %>
<%= bui_table(collection: @users) do |t| %>
  <% t.with_column(key: :name, label: "Name", sortable: true, sorted: true, sort_direction: :asc) %>
  <% t.with_column(key: :email, label: "Email", sortable: true) %>
  <% t.with_column(key: :role, label: "Role") %>
<% end %>
```

#### Sort Links (Table-Level)

Use `sort_column`, `sort_direction`, `sort_url`, and `sort_html` on the table to auto-generate sort links for all sortable columns. `sort_column` auto-derives the `sorted` state per column, eliminating per-column `sorted:`/`sort_direction:` boilerplate. Clicking a sorted column toggles asc/desc; unsorted columns default to asc.

```erb
<%= bui_table(
  collection: @users,
  variant: :accent,
  sort_column: params[:sort]&.to_sym,
  sort_direction: params[:direction]&.to_sym || :asc,
  sort_url: ->(key, dir) { users_path(sort: key, direction: dir) },
  sort_html: { data: { turbo_frame: "_top" } }
) do |t| %>
  <% t.with_column(key: :name, label: "Name", sortable: true) %>
  <% t.with_column(key: :email, label: "Email", sortable: true) %>
  <% t.with_column(key: :role, label: "Role") %>
  <% t.with_column(key: :joined, label: "Joined", sortable: true) %>
<% end %>
```

#### Sort Links (Column-Level)

Individual columns can specify `sort_url` (String) and `sort_html` (Hash) to override the table-level sort URL or provide per-column links. This also works in slot mode via `HeaderCellComponent`.

```erb
<%# Collection mode: per-column sort_url %>
<%= bui_table(collection: @users) do |t| %>
  <% t.with_column(key: :name, label: "Name", sortable: true,
                   sort_url: users_path(sort: :name, direction: :asc),
                   sort_html: { data: { turbo_frame: "users" } }) %>
  <% t.with_column(key: :email, label: "Email", sortable: true,
                   sort_url: users_path(sort: :email, direction: :asc)) %>
<% end %>

<%# Slot mode: sort_url on HeaderCellComponent %>
<%= bui_table(variant: :success) do |t| %>
  <% t.with_header do |h| %>
    <% h.with_cell(label: "Name", sortable: true, sorted: true, sort_direction: :asc,
                   sort_url: "?sort=name&direction=desc",
                   sort_html: { data: { turbo_frame: "_top" } }) %>
    <% h.with_cell(label: "Email", sortable: true,
                   sort_url: "?sort=email&direction=asc") %>
  <% end %>
  <%# ... rows ... %>
<% end %>
```

**ColumnComponent sort parameters:**

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `sort_url` | String | `nil` | URL for this column's sort link (overrides table-level `sort_url`) |
| `sort_html` | Hash | `{}` | HTML attributes merged over table-level `sort_html` |

**HeaderCellComponent sort parameters:**

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `sort_url` | String | `nil` | URL for this header's sort link |
| `sort_html` | Hash | `{}` | HTML attributes for the sort link |

---

## Dialog Components

### DialogComponent

Modal overlay with configurable size, backdrop, and close behavior.

#### Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `size` | Symbol | `:md` | `:sm`, `:md`, `:lg`, `:xl`, `:xxl`, `:full` |
| `close_on_backdrop` | Boolean | `true` | Close on backdrop click |
| `close_on_escape` | Boolean | `true` | Close on Escape key |
| `open` | Boolean | `false` | Initially open |
| `show_close_button` | Boolean | `true` | Show X close button |
| `container_classes` | String | `nil` | Additional CSS classes |

#### Slots

- `trigger` - Trigger element to open dialog

#### Usage

```erb
<%= bui_dialog(size: :md) do |d| %>
  <% d.with_trigger { bui_button(variant: :primary) { "Open Dialog" } } %>
  <% d.with_header { "Dialog Title" } %>
  <% d.with_body { "Dialog content goes here." } %>
  <% d.with_footer do %>
    <%= bui_button(variant: :secondary, style: :ghost) { "Cancel" } %>
    <%= bui_button(variant: :primary) { "Save" } %>
  <% end %>
<% end %>
```

### AlertComponent

Alert dialog with icon, message, and OK button.

#### Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `variant` | Symbol | `:info` | Color variant |
| `title` | String | `nil` | Alert title |
| `text` | String | `nil` | Alert message |
| `icon` | Boolean | `true` | Show icon |
| `button_label` | String | `"OK"` | OK button label |
| `size` | Symbol | `:sm` | Dialog size |

#### Usage

```erb
<%= bui_dialog_alert(variant: :success, title: "Saved!", text: "Your changes were saved.") do |a| %>
  <% a.with_trigger { bui_button(variant: :success) { "Save" } } %>
<% end %>
```

### ConfirmComponent

Confirm dialog with Cancel and Confirm buttons.

#### Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `variant` | Symbol | `:warning` | Color variant |
| `title` | String | `nil` | Confirm title |
| `text` | String | `nil` | Confirm message |
| `icon` | Boolean | `true` | Show icon |
| `confirm_label` | String | `"Confirm"` | Confirm button label |
| `cancel_label` | String | `"Cancel"` | Cancel button label |
| `size` | Symbol | `:sm` | Dialog size |
| `close_on_backdrop` | Boolean | `false` | Close on backdrop click |
| `close_on_escape` | Boolean | `false` | Close on Escape key |

#### Usage

```erb
<%= bui_dialog_confirm(variant: :danger, title: "Delete?", text: "This action cannot be undone.") do |c| %>
  <% c.with_trigger { bui_button(variant: :danger) { "Delete" } } %>
<% end %>
```

---

## Tabs Components

### ContainerComponent

Tabs container supporting JS mode (client-side) and Turbo mode (server-rendered via Turbo Frames).

#### Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `mode` | Symbol | `:js` | `:js`, `:turbo` |
| `style` | Symbol | `:underline` | `:underline`, `:pills`, `:bordered` |
| `variant` | Symbol | `:primary` | Color variant |
| `size` | Symbol | `:md` | `:xs`, `:sm`, `:md`, `:lg`, `:xl` |
| `alignment` | Symbol | `:start` | `:start`, `:center`, `:end`, `:stretch` |
| `position` | Symbol | `:top` | `:top`, `:bottom`, `:left`, `:right` |
| `frame_id` | String | `nil` | Turbo Frame ID (required for turbo mode) |
| `default_tab` | String | `nil` | ID of the default active tab |
| `persist` | Boolean | `false` | Persist active tab state |
| `persist_key` | String | `nil` | localStorage key for persistence |

#### Slots

- `tabs` (multiple) - `TabComponent` instances
- `panels` (multiple) - `PanelComponent` instances (JS mode)
- `loader` - Custom loader (Turbo mode)

#### Usage (JS Mode)

```erb
<%= bui_tabs(mode: :js, style: :underline) do |tabs| %>
  <% tabs.with_tab(id: "profile", label: "Profile", active: true) %>
  <% tabs.with_tab(id: "settings", label: "Settings") %>
  <% tabs.with_panel(id: "profile", active: true) { "Profile content" } %>
  <% tabs.with_panel(id: "settings") { "Settings content" } %>
<% end %>
```

#### Usage (Turbo Mode)

```erb
<%= bui_tabs(mode: :turbo, frame_id: "tab-content") do |tabs| %>
  <% tabs.with_tab(id: "profile", label: "Profile", href: profile_path, active: true) %>
  <% tabs.with_tab(id: "settings", label: "Settings", href: settings_path) %>
<% end %>

<turbo-frame id="tab-content">
  <%# Content loaded here %>
</turbo-frame>
```

#### Usage (Tabs with Icons and Badges)

```erb
<%= bui_tabs(mode: :js, style: :pills) do |tabs| %>
  <% tabs.with_tab(id: "messages", label: "Messages", active: true) do |tab| %>
    <% tab.with_icon { bui_fa_icon("envelope", style: :regular, size: :sm) } %>
    <% tab.with_badge { bui_badge(variant: :danger, counter: 3) } %>
  <% end %>
  <% tabs.with_tab(id: "settings", label: "Settings") do |tab| %>
    <% tab.with_icon { bui_fa_icon("cog", style: :solid, size: :sm) } %>
  <% end %>
  <% tabs.with_panel(id: "messages", active: true) { "Messages list" } %>
  <% tabs.with_panel(id: "settings") { "Settings form" } %>
<% end %>
```

---

## Dropdown Components

### DropdownComponent

Composable dropdown menu with trigger, items (item/divider/header), keyboard navigation, and auto-close. Uses Stimulus controller for toggle, click-outside detection, and full ARIA support.

#### Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `size` | Symbol | `:md` | Menu width: `:sm` (w-40), `:md` (w-56), `:lg` (w-72) |
| `placement` | Symbol | `:bottom_start` | `:bottom_start`, `:bottom_end`, `:top_start`, `:top_end` |
| `shadow` | Symbol | `:lg` | Shadow size: `:sm`, `:md`, `:lg`, `:xl`, or `false` |
| `auto_close` | Boolean | `true` | Close on click outside |
| `close_on_item_click` | Boolean | `true` | Close menu after item click |
| `container_classes` | String | `nil` | Additional CSS classes for root element |
| `menu_classes` | String | `nil` | Additional CSS classes for menu panel |

#### Slots

- `trigger` (single) - Element that toggles the dropdown (typically a button)
- `items` (polymorphic, multiple) - Menu entries, one of three types:
  - `item` → `ItemComponent` - Clickable menu item
  - `divider` → `DividerComponent` - Visual separator
  - `header` → `HeaderComponent` - Section title

#### Usage

```erb
<%# Basic dropdown %>
<%= bui_dropdown(placement: :bottom_start) do |d| %>
  <% d.with_trigger do %>
    <%= bui_button(variant: :primary) { "Options" } %>
  <% end %>
  <% d.with_item(href: edit_path) { "Edit" } %>
  <% d.with_item(href: show_path) { "View" } %>
<% end %>

<%# Dropdown with headers, dividers, icons, and danger item %>
<%= bui_dropdown(size: :lg, placement: :bottom_end) do |d| %>
  <% d.with_trigger do %>
    <%= bui_button(variant: :secondary, style: :outline) { "Actions" } %>
  <% end %>
  <% d.with_header(text: "Navigation") %>
  <% d.with_item(href: dashboard_path) do |item| %>
    <% item.with_icon { bui_fa_icon("home", style: :solid, size: :sm) } %>
    Dashboard
  <% end %>
  <% d.with_item(href: settings_path) do |item| %>
    <% item.with_icon { bui_fa_icon("cog", style: :solid, size: :sm) } %>
    Settings
  <% end %>
  <% d.with_divider %>
  <% d.with_item(href: logout_path, variant: :danger, method: :delete) do |item| %>
    <% item.with_icon { bui_fa_icon("sign-out-alt", style: :solid, size: :sm) } %>
    Sign Out
  <% end %>
<% end %>

<%# Dropdown with active and disabled items %>
<%= bui_dropdown do |d| %>
  <% d.with_trigger do %>
    <%= bui_button(variant: :primary) { "Menu" } %>
  <% end %>
  <% d.with_item(active: true) { "Current Page" } %>
  <% d.with_item(href: other_path) { "Other Page" } %>
  <% d.with_item(disabled: true) { "Coming Soon" } %>
<% end %>
```

### Dropdown::ItemComponent

Individual menu item rendered as `<a>` (when `href` is set) or `<button>`.

#### Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `href` | String | `nil` | Link URL (renders `<a>` if present, `<button>` otherwise) |
| `disabled` | Boolean | `false` | Disable the item |
| `method` | Symbol | `nil` | HTTP method for Turbo (`:get`, `:post`, `:put`, `:patch`, `:delete`) |
| `active` | Boolean | `false` | Highlight item with background |
| `variant` | Symbol | `:default` | `:default` (grayscale) or `:danger` (red text/hover) |
| `container_classes` | String | `nil` | Additional CSS classes |

#### Slots

- `icon` - Icon displayed before item text

### Dropdown::HeaderComponent

Non-interactive section title within the dropdown menu.

#### Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `text` | String | `nil` | Header text (can also use block content) |
| `container_classes` | String | `nil` | Additional CSS classes |

### Dropdown::DividerComponent

Visual separator line between dropdown items.

#### Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `container_classes` | String | `nil` | Additional CSS classes |

---

## Drawer Layout Components

Complete responsive layout system for admin dashboards.

### LayoutComponent

Main layout wrapper with header, sidebar, and content.

#### Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `sidebar_position` | Symbol | `:left` | `:left`, `:right` |
| `sidebar_breakpoint` | Symbol | `:lg` | `:md`, `:lg`, `:xl` |
| `container_classes` | String | `nil` | Container CSS |
| `main_classes` | String | `nil` | Main content CSS |

#### Slots

- `header` - HeaderComponent
- `sidebar` - SidebarComponent
- `main` - Main content

### Complete Admin Layout Example

```erb
<%= bui_drawer_layout(sidebar_breakpoint: :lg) do |layout| %>
  <% layout.with_header(variant: :dark, sticky: true) do |header| %>
    <% header.with_logo { "Admin Panel" } %>
    <% header.with_mobile_menu_button do %>
      <button data-action="click->better-ui--drawer--layout#toggle" class="text-white p-2">
        <%= bui_fa_icon("bars", style: :solid) %>
      </button>
    <% end %>
    <% header.with_actions do %>
      <%= bui_avatar(name: current_user.name, size: :sm, status: :online) %>
    <% end %>
  <% end %>

  <% layout.with_sidebar(variant: :dark, width: :md) do |sidebar| %>
    <% sidebar.with_navigation do %>
      <%= bui_drawer_nav_group(title: "Dashboard", variant: :dark) do |group| %>
        <% group.with_item(label: "Overview", href: admin_path, active: true) %>
        <% group.with_item(label: "Analytics", href: admin_analytics_path) %>
      <% end %>

      <%= bui_drawer_nav_group(title: "Management", variant: :dark) do |group| %>
        <% group.with_item(label: "Users", href: admin_users_path, badge: "12", badge_variant: :danger) %>
        <% group.with_item(label: "Settings", href: admin_settings_path) %>
      <% end %>
    <% end %>

    <% sidebar.with_footer do %>
      <p class="text-sm text-gray-400">v1.0.0</p>
    <% end %>
  <% end %>

  <% layout.with_main do %>
    <div class="p-8">
      <%= yield %>
    </div>
  <% end %>
<% end %>
```

---

## Theme Customization

BetterUi uses OKLCH color space for perceptually uniform colors.

### OKLCH Format

```css
oklch(lightness chroma hue)
```

- **Lightness (L)**: 0-1 (0 = black, 1 = white)
- **Chroma (C)**: 0-0.4 (0 = grayscale, 0.4 = max saturation)
- **Hue (H)**: 0-360 degrees

### Customizing Primary Color

```css
@import "tailwindcss";
@import "@pandev-srl/better-ui/theme";
@import "@pandev-srl/better-ui/typography";
@import "@pandev-srl/better-ui/utilities";

@theme inline {
  --color-primary-50: oklch(0.97 0.01 220);
  --color-primary-100: oklch(0.94 0.03 220);
  --color-primary-200: oklch(0.88 0.06 220);
  --color-primary-300: oklch(0.80 0.12 220);
  --color-primary-400: oklch(0.70 0.18 220);
  --color-primary-500: oklch(0.60 0.24 220);
  --color-primary-600: oklch(0.50 0.26 220);
  --color-primary-700: oklch(0.42 0.24 220);
  --color-primary-800: oklch(0.34 0.20 220);
  --color-primary-900: oklch(0.28 0.14 220);
  --color-primary-950: oklch(0.18 0.10 220);
}

@source "../../../vendor/bundle/**/*.{rb,erb}";
```

---

## Stimulus Controllers

BetterUi provides these Stimulus controllers:

| Controller | Purpose |
|------------|---------|
| `better-ui--button` | Loading states, click handling |
| `better-ui--action-messages` | Dismissible alerts, auto-dismiss |
| `better-ui--tag` | Dismissible tags |
| `better-ui--tooltip` | Fixed-position tooltip with viewport flipping |
| `better-ui--forms--password-input` | Password visibility toggle |
| `better-ui--forms--select` | Custom select dropdown, keyboard navigation |
| `better-ui--drawer--layout` | Mobile drawer toggle |
| `better-ui--tabs--container` | Tab switching, Turbo Frame loading |
| `better-ui--dialog--dialog` | Modal open/close with focus trap |
| `better-ui--dropdown--dropdown` | Dropdown menu, keyboard nav, auto-close |

### Manual Controller Registration

```javascript
import { Application } from "@hotwired/stimulus"
import { ButtonController, ActionMessagesController } from "@pandev-srl/better-ui"

const application = Application.start()
application.register("better-ui--button", ButtonController)
application.register("better-ui--action-messages", ActionMessagesController)
```

---

## Complete Form Example

```erb
<%= form_with model: @user, builder: BetterUi::UiFormBuilder, class: "space-y-6" do |f| %>
  <%= bui_card(size: :lg) do |card| %>
    <% card.with_header do %>
      <%= bui_heading(level: :h2) { "User Registration" } %>
    <% end %>

    <% card.with_body do %>
      <div class="space-y-4">
        <%= f.bui_text_input :name, placeholder: "Full name" %>

        <%= f.bui_text_input :email,
          hint: "We'll never share your email",
          placeholder: "you@example.com" do |c| %>
          <% c.with_prefix_icon { bui_fa_icon("envelope", style: :regular, size: :sm) } %>
        <% end %>

        <%= f.bui_password_input :password, hint: "Minimum 8 characters" %>
        <%= f.bui_password_input :password_confirmation %>

        <%= f.bui_textarea :bio, rows: 4, hint: "Tell us about yourself" %>
        <%= f.bui_number_input :age, min: 18, max: 120 %>

        <%= f.bui_select :country, [["Italy", "it"], ["France", "fr"], ["Germany", "de"]],
          placeholder: "Select your country" %>

        <%= f.bui_checkbox_group :interests,
          [["Technology", "tech"], ["Sports", "sports"], ["Music", "music"]],
          legend: "Interests",
          orientation: :horizontal %>

        <%= f.bui_checkbox :terms,
          label: "I agree to the terms and conditions",
          required: true %>
      </div>
    <% end %>

    <% card.with_footer do %>
      <div class="flex justify-end gap-3">
        <%= bui_button(variant: :secondary, style: :ghost, href: root_path) { "Cancel" } %>
        <%= bui_button(variant: :primary, type: :submit, show_loader_on_click: true) { "Create Account" } %>
      </div>
    <% end %>
  <% end %>
<% end %>
```

---

## Troubleshooting

### Styles Not Applying

Ensure `@source` includes vendor/bundle:

```css
@source "../../../vendor/bundle/**/*.{rb,erb}";
```

### Stimulus Controllers Not Working

1. Verify npm package: `npm list @pandev-srl/better-ui`
2. Check `registerControllers(application)` is called
3. Check browser console for errors

### Validation Errors Not Showing

Ensure using `BetterUi::UiFormBuilder` and model has ActiveModel validations.
