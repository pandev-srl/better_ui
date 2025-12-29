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

### Basic Usage

```erb
<%= render BetterUi::ButtonComponent.new(
  label: "Click me",
  variant: :primary
) %>
```

### Button with Block Content

```erb
<%= render BetterUi::ButtonComponent.new(variant: :success) do %>
  Save Changes
<% end %>
```

### Submit Button

```erb
<%= render BetterUi::ButtonComponent.new(
  label: "Submit Form",
  variant: :success,
  type: :submit,
  size: :lg
) %>
```

### Button with Icon

```erb
<%= render BetterUi::ButtonComponent.new(label: "Download") do |c| %>
  <% c.with_icon_before do %>
    <svg class="w-5 h-5"><use href="#download-icon"/></svg>
  <% end %>
<% end %>
```

### Loading Button

```erb
<%= render BetterUi::ButtonComponent.new(
  label: "Processing...",
  show_loader: true,
  disabled: true
) %>
```

### Auto-Loading on Click

```erb
<%= render BetterUi::ButtonComponent.new(
  label: "Save",
  show_loader_on_click: true,
  type: :submit
) %>
```

### Link Button

```erb
<%= render BetterUi::ButtonComponent.new(
  label: "View Users",
  href: users_path
) %>
```

### External Link Button

```erb
<%= render BetterUi::ButtonComponent.new(
  label: "Visit Site",
  href: "https://example.com",
  target: "_blank"
) %>
```

### Danger Button with Confirmation

```erb
<%= render BetterUi::ButtonComponent.new(
  label: "Delete",
  variant: :danger,
  style: :outline,
  href: user_path(@user),
  method: :delete,
  data: { turbo_confirm: "Are you sure?" }
) %>
```

### Ghost Button

```erb
<%= render BetterUi::ButtonComponent.new(
  label: "Cancel",
  variant: :secondary,
  style: :ghost
) %>
```

### Button Sizes

```erb
<%= render BetterUi::ButtonComponent.new(label: "XS", size: :xs) %>
<%= render BetterUi::ButtonComponent.new(label: "SM", size: :sm) %>
<%= render BetterUi::ButtonComponent.new(label: "MD", size: :md) %>
<%= render BetterUi::ButtonComponent.new(label: "LG", size: :lg) %>
<%= render BetterUi::ButtonComponent.new(label: "XL", size: :xl) %>
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
| `header_classes` | String | `nil` | Header CSS classes |
| `body_classes` | String | `nil` | Body CSS classes |
| `footer_classes` | String | `nil` | Footer CSS classes |

### Slots

- `header` - Top section
- `body` - Main content
- `footer` - Bottom section

### Basic Card

```erb
<%= render BetterUi::CardComponent.new do |c| %>
  <% c.with_body do %>
    <p>Card content goes here</p>
  <% end %>
<% end %>
```

### Full Card Structure

```erb
<%= render BetterUi::CardComponent.new(size: :lg, shadow: true) do |c| %>
  <% c.with_header do %>
    <h3 class="text-lg font-semibold">Card Title</h3>
  <% end %>

  <% c.with_body do %>
    <p>Main content area.</p>
  <% end %>

  <% c.with_footer do %>
    <div class="flex justify-end gap-2">
      <%= render BetterUi::ButtonComponent.new(label: "Cancel", style: :ghost) %>
      <%= render BetterUi::ButtonComponent.new(label: "Save") %>
    </div>
  <% end %>
<% end %>
```

### Outlined Card

```erb
<%= render BetterUi::CardComponent.new(variant: :primary, style: :outline) do |c| %>
  <% c.with_body { "Outlined primary card" } %>
<% end %>
```

### Soft Card

```erb
<%= render BetterUi::CardComponent.new(variant: :success, style: :soft) do |c| %>
  <% c.with_body { "Soft success card" } %>
<% end %>
```

### Bordered Card (Variant-Agnostic)

```erb
<%= render BetterUi::CardComponent.new(style: :bordered) do |c| %>
  <% c.with_body { "Neutral bordered card" } %>
<% end %>
```

### Card without Shadow

```erb
<%= render BetterUi::CardComponent.new(shadow: false) do |c| %>
  <% c.with_body { "Shadow-free card" } %>
<% end %>
```

### Stats Card

```erb
<%= render BetterUi::CardComponent.new(variant: :info, style: :soft) do |c| %>
  <% c.with_body do %>
    <div class="text-center">
      <p class="text-3xl font-bold">1,234</p>
      <p class="text-sm text-gray-500">Total Users</p>
    </div>
  <% end %>
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

### Slots

- `icon` - Custom icon slot

### Basic Alert

```erb
<%= render BetterUi::ActionMessagesComponent.new(
  variant: :success,
  messages: ["Your changes have been saved."]
) %>
```

### Alert with Title

```erb
<%= render BetterUi::ActionMessagesComponent.new(
  variant: :danger,
  title: "Validation Errors",
  messages: @model.errors.full_messages
) %>
```

### Auto-Dismissing Alert

```erb
<%= render BetterUi::ActionMessagesComponent.new(
  variant: :info,
  messages: ["This message will disappear in 5 seconds."],
  auto_dismiss: 5
) %>
```

### Non-Dismissible Alert

```erb
<%= render BetterUi::ActionMessagesComponent.new(
  variant: :warning,
  messages: ["Important notice"],
  dismissible: false
) %>
```

### Flash Messages Helper

```erb
<% flash.each do |type, message| %>
  <% variant = { notice: :success, alert: :danger, warning: :warning }[type.to_sym] || :info %>
  <%= render BetterUi::ActionMessagesComponent.new(
    variant: variant,
    messages: [message],
    auto_dismiss: 5
  ) %>
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
  <%= render BetterUi::ButtonComponent.new(label: "Submit", type: :submit) %>
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

### With Form Builder

```erb
<%= form_with model: @user, builder: BetterUi::UiFormBuilder do |f| %>
  <%= f.bui_text_input :email,
    hint: "We'll never share your email",
    placeholder: "you@example.com" %>
<% end %>
```

### With Form Builder and Icon

```erb
<%= form_with model: @user, builder: BetterUi::UiFormBuilder do |f| %>
  <%= f.bui_text_input :email do |c| %>
    <% c.with_prefix_icon do %>
      <svg class="w-5 h-5 text-gray-400"><use href="#mail-icon"/></svg>
    <% end %>
  <% end %>
<% end %>
```

### Standalone Usage

```erb
<%= render BetterUi::Forms::TextInputComponent.new(
  name: "user[email]",
  label: "Email Address",
  hint: "We'll never share your email",
  placeholder: "you@example.com",
  required: true
) %>
```

### With Errors

```erb
<%= render BetterUi::Forms::TextInputComponent.new(
  name: "user[email]",
  label: "Email",
  value: "invalid-email",
  errors: ["Email is invalid"]
) %>
```

### With Prefix Icon

```erb
<%= render BetterUi::Forms::TextInputComponent.new(
  name: "user[username]",
  label: "Username"
) do |c| %>
  <% c.with_prefix_icon { "@" } %>
<% end %>
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

### With Form Builder

```erb
<%= form_with model: @product, builder: BetterUi::UiFormBuilder do |f| %>
  <%= f.bui_number_input :price,
    min: 0,
    step: 0.01,
    hint: "Enter price in dollars" %>
<% end %>
```

### Standalone Usage

```erb
<%= render BetterUi::Forms::NumberInputComponent.new(
  name: "product[price]",
  label: "Price",
  min: 0,
  step: 0.01,
  show_spinner: false
) do |c| %>
  <% c.with_prefix_icon { "$" } %>
<% end %>
```

### Quantity Input

```erb
<%= render BetterUi::Forms::NumberInputComponent.new(
  name: "quantity",
  label: "Quantity",
  min: 1,
  max: 100,
  value: 1
) %>
```

---

## PasswordInputComponent

Password input with visibility toggle.

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

### With Form Builder

```erb
<%= form_with model: @user, builder: BetterUi::UiFormBuilder do |f| %>
  <%= f.bui_password_input :password,
    hint: "Minimum 8 characters" %>
<% end %>
```

### Standalone Usage

```erb
<%= render BetterUi::Forms::PasswordInputComponent.new(
  name: "user[password]",
  label: "Password",
  hint: "Minimum 8 characters",
  required: true
) %>
```

### Password Confirmation

```erb
<%= render BetterUi::Forms::PasswordInputComponent.new(
  name: "user[password_confirmation]",
  label: "Confirm Password",
  required: true
) %>
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

### With Form Builder

```erb
<%= form_with model: @post, builder: BetterUi::UiFormBuilder do |f| %>
  <%= f.bui_textarea :content,
    rows: 6,
    hint: "Write your content here" %>
<% end %>
```

### Standalone Usage

```erb
<%= render BetterUi::Forms::TextareaComponent.new(
  name: "post[content]",
  label: "Content",
  rows: 6,
  resize: :vertical,
  maxlength: 1000
) %>
```

### Non-Resizable

```erb
<%= render BetterUi::Forms::TextareaComponent.new(
  name: "comment",
  label: "Comment",
  rows: 3,
  resize: :none
) %>
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

### With Form Builder

```erb
<%= form_with model: @user, builder: BetterUi::UiFormBuilder do |f| %>
  <%= f.bui_checkbox :terms,
    label: "I agree to the terms and conditions",
    required: true %>
<% end %>
```

### Standalone Usage

```erb
<%= render BetterUi::Forms::CheckboxComponent.new(
  name: "user[newsletter]",
  label: "Subscribe to newsletter",
  variant: :primary
) %>
```

### Different Variants

```erb
<%= render BetterUi::Forms::CheckboxComponent.new(
  name: "accept",
  label: "Accept terms",
  variant: :success
) %>
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

### With Form Builder

```erb
<%= form_with model: @user, builder: BetterUi::UiFormBuilder do |f| %>
  <%= f.bui_checkbox_group :roles,
    [["Admin", "admin"], ["Editor", "editor"], ["Viewer", "viewer"]],
    legend: "User Roles" %>
<% end %>
```

### Standalone Usage

```erb
<%= render BetterUi::Forms::CheckboxGroupComponent.new(
  name: "user[interests]",
  collection: [
    ["Technology", "tech"],
    ["Sports", "sports"],
    ["Music", "music"]
  ],
  legend: "Select your interests",
  orientation: :vertical
) %>
```

### Horizontal Layout

```erb
<%= render BetterUi::Forms::CheckboxGroupComponent.new(
  name: "features",
  collection: [["Feature A", "a"], ["Feature B", "b"]],
  orientation: :horizontal
) %>
```

### Pre-Selected Values

```erb
<%= render BetterUi::Forms::CheckboxGroupComponent.new(
  name: "categories",
  collection: [["Cat 1", "1"], ["Cat 2", "2"], ["Cat 3", "3"]],
  selected: ["1", "3"]
) %>
```

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

### Basic Layout

```erb
<%= render BetterUi::Drawer::LayoutComponent.new do |layout| %>
  <% layout.with_header(sticky: true) do |header| %>
    <% header.with_logo { image_tag("logo.svg") } %>
    <% header.with_mobile_menu_button do %>
      <button data-action="click->better-ui--drawer--layout#toggle">
        <svg class="w-6 h-6"><!-- Menu icon --></svg>
      </button>
    <% end %>
  <% end %>

  <% layout.with_sidebar do |sidebar| %>
    <% sidebar.with_navigation { render "shared/nav" } %>
  <% end %>

  <% layout.with_main do %>
    <%= yield %>
  <% end %>
<% end %>
```

### HeaderComponent

Sticky header with logo, navigation, and actions.

#### Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `sticky` | Boolean | `true` | Sticky positioning |
| `variant` | Symbol | `:light` | `:light`, `:dark` |
| `container_classes` | String | `nil` | Additional CSS |

#### Slots

- `logo` - Logo/brand area
- `navigation` - Main navigation links
- `mobile_menu_button` - Mobile toggle button
- `actions` - Right-side actions (user menu, etc.)

### SidebarComponent

Responsive sidebar with navigation and footer.

#### Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `variant` | Symbol | `:light` | `:light`, `:dark` |
| `width` | Symbol | `:md` | `:sm`, `:md`, `:lg` |
| `position` | Symbol | `:left` | `:left`, `:right` |

#### Slots

- `navigation` - Navigation content
- `footer` - Footer content

### NavGroupComponent

Grouped navigation with title.

#### Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `title` | String | `nil` | Group title |
| `variant` | Symbol | `:light` | `:light`, `:dark` |
| `collapsible` | Boolean | `false` | Enable collapse |
| `collapsed` | Boolean | `false` | Initial state |

#### Slot

- `item` (multiple) - NavItemComponent instances

### NavItemComponent

Individual navigation item.

#### Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `label` | String | Required | Item label |
| `href` | String | `"#"` | Link URL |
| `active` | Boolean | `false` | Active state |
| `variant` | Symbol | `:light` | `:light`, `:dark` |
| `badge` | String | `nil` | Badge text |
| `badge_variant` | Symbol | `:primary` | Badge color |

#### Slot

- `icon` - Item icon

### Complete Admin Layout Example

```erb
<%= render BetterUi::Drawer::LayoutComponent.new(sidebar_breakpoint: :lg) do |layout| %>
  <% layout.with_header(variant: :dark, sticky: true) do |header| %>
    <% header.with_logo { "Admin Panel" } %>
    <% header.with_mobile_menu_button do %>
      <button data-action="click->better-ui--drawer--layout#toggle" class="text-white p-2">
        <svg class="w-6 h-6"><!-- Hamburger --></svg>
      </button>
    <% end %>
    <% header.with_actions do %>
      <%= render "shared/user_menu" %>
    <% end %>
  <% end %>

  <% layout.with_sidebar(variant: :dark, width: :md) do |sidebar| %>
    <% sidebar.with_navigation do %>
      <%= render BetterUi::Drawer::NavGroupComponent.new(title: "Dashboard", variant: :dark) do |group| %>
        <% group.with_item(label: "Overview", href: admin_path, active: true) %>
        <% group.with_item(label: "Analytics", href: admin_analytics_path) %>
      <% end %>

      <%= render BetterUi::Drawer::NavGroupComponent.new(title: "Management", variant: :dark) do |group| %>
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
/* app/assets/stylesheets/application.css */
@import "tailwindcss";
@import "@pandev-srl/better-ui/theme";
@import "@pandev-srl/better-ui/typography";
@import "@pandev-srl/better-ui/utilities";

@theme inline {
  /* Custom brand blue */
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

### Custom Font

```css
@theme inline {
  --font-family-sans: "Inter", system-ui, sans-serif;
}
```

### Adding a Custom Variant

```css
@theme inline {
  --color-brand-50: oklch(0.97 0.02 280);
  --color-brand-100: oklch(0.93 0.04 280);
  --color-brand-200: oklch(0.86 0.08 280);
  --color-brand-300: oklch(0.78 0.12 280);
  --color-brand-400: oklch(0.69 0.16 280);
  --color-brand-500: oklch(0.60 0.20 280);
  --color-brand-600: oklch(0.51 0.22 280);
  --color-brand-700: oklch(0.43 0.20 280);
  --color-brand-800: oklch(0.35 0.16 280);
  --color-brand-900: oklch(0.28 0.12 280);
  --color-brand-950: oklch(0.20 0.08 280);
}
```

Use in templates:

```erb
<div class="bg-brand-500 text-white">Custom brand element</div>
```

---

## Stimulus Controllers

BetterUi provides these Stimulus controllers:

| Controller | Purpose |
|------------|---------|
| `better-ui--button` | Loading states, click handling |
| `better-ui--action-messages` | Dismissible alerts, auto-dismiss |
| `better-ui--forms--password-input` | Password visibility toggle |
| `better-ui--drawer--layout` | Mobile drawer toggle |

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
  <%= render BetterUi::CardComponent.new(size: :lg) do |card| %>
    <% card.with_header do %>
      <h2 class="text-xl font-semibold">User Registration</h2>
    <% end %>

    <% card.with_body do %>
      <div class="space-y-4">
        <%= f.bui_text_input :name, placeholder: "Full name" %>

        <%= f.bui_text_input :email,
          hint: "We'll never share your email",
          placeholder: "you@example.com" do |c| %>
          <% c.with_prefix_icon do %>
            <svg class="w-5 h-5 text-gray-400"><use href="#mail"/></svg>
          <% end %>
        <% end %>

        <%= f.bui_password_input :password,
          hint: "Minimum 8 characters" %>

        <%= f.bui_password_input :password_confirmation %>

        <%= f.bui_textarea :bio,
          rows: 4,
          hint: "Tell us about yourself" %>

        <%= f.bui_number_input :age,
          min: 18,
          max: 120 %>

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
        <%= render BetterUi::ButtonComponent.new(
          label: "Cancel",
          variant: :secondary,
          style: :ghost,
          href: root_path
        ) %>
        <%= render BetterUi::ButtonComponent.new(
          label: "Create Account",
          variant: :primary,
          type: :submit,
          show_loader_on_click: true
        ) %>
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
