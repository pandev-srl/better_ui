# BetterUi Installation Guide

This guide walks you through installing and configuring BetterUi in your Rails application.

## Prerequisites

- Rails 8.1.1 or higher
- Node.js and npm (for Tailwind CSS and npm package)
- A Rails application with asset pipeline configured

## Installation Steps

### 1. Add the gem to your Gemfile

```ruby
gem "better_ui"
```

Then run:

```bash
bundle install
```

### 2. Install the npm package

```bash
# Using yarn (recommended)
yarn add @pandev-srl/better-ui

# Or using npm
npm install @pandev-srl/better-ui
```

### 3. Run the install generator (optional)

```bash
bin/rails generate better_ui:install
```

This generator will:
- Install the npm package automatically
- Copy the theme CSS file for customization (default behavior)
- Show configuration instructions

Use `--no-copy-theme` flag to skip copying the theme CSS file:
```bash
bin/rails generate better_ui:install --no-copy-theme
```

### 4. Configure JavaScript

Add to your JavaScript entry point (e.g., `app/javascript/application.js`):

```javascript
import { Application } from "@hotwired/stimulus"
import { registerControllers } from "@pandev-srl/better-ui"

const application = Application.start()
registerControllers(application)
```

### 5. Configure CSS

Add to your main CSS file (e.g., `app/assets/stylesheets/application.css`):

**Option 1: Import pre-built CSS (simplest)**
```css
@import "@pandev-srl/better-ui/css";

/* Scan gem templates for Tailwind classes */
@source "../../../vendor/bundle/**/*.{rb,erb}";

/* Scan application files for Tailwind classes */
@source "../../**/*.{erb,html,rb}";
@source "../javascript/**/*.js";
```

**Option 2: Import individual modules for customization**
```css
@import "tailwindcss";
@import "@pandev-srl/better-ui/theme";       /* Design tokens */
@import "@pandev-srl/better-ui/typography";  /* Typography utilities */
@import "@pandev-srl/better-ui/utilities";   /* General utilities */

/* Scan gem templates for Tailwind classes */
@source "../../../vendor/bundle/**/*.{rb,erb}";

/* Scan application files for Tailwind classes */
@source "../../**/*.{erb,html,rb}";
@source "../javascript/**/*.js";
```

### 6. Configure Tailwind CSS v4

Ensure you have Tailwind CSS v4 installed:

```bash
yarn add tailwindcss@next @tailwindcss/postcss@next
```

Create or update `postcss.config.js` in your project root:

```javascript
module.exports = {
  plugins: {
    "@tailwindcss/postcss": {}
  }
}
```

## What Gets Installed

### npm Package (@pandev-srl/better-ui)

The npm package provides:

**JavaScript (10 Stimulus Controllers):**
- `ButtonController` - Loading states and click handling
- `ActionMessagesController` - Dismissible alerts with auto-dismiss
- `TagController` - Dismissible tags
- `PasswordInputController` - Password visibility toggle
- `SelectController` - Custom dropdown with keyboard navigation
- `DrawerLayoutController` - Mobile drawer toggle and responsive behavior
- `TabsContainerController` - Tab switching and Turbo Frame loading
- `DialogController` - Modal open/close behavior
- `DropdownController` - Dropdown menu with keyboard navigation
- `TooltipController` - Fixed-position tooltips with viewport flipping
- `registerControllers()` - Helper to register all controllers at once

**CSS (Theme):**
- 9 semantic color variants (primary, secondary, accent, success, danger, warning, info, light, dark)
- Grayscale utility colors for neutral elements
- 11 shades per variant (50-950) using OKLCH color space
- Typography, spacing, border radius, and shadow tokens
- Utility classes (focus rings, glass effects, etc.) in separate modules

### Ruby Gem (better_ui)

The gem provides:

**ViewComponents (42 total):**
- Core: Button, Link, Card, ActionMessages, Avatar, Badge, Tag, Heading, Spinner, Progress, Divider, Tooltip, Container, FaIcon, Breadcrumb
- Forms: TextInput, NumberInput, PasswordInput, Textarea, Checkbox, CheckboxGroup, Select
- Table: Table, Header, HeaderCell, Row, Cell, Column
- Dialog: Dialog, Alert, Confirm
- Tabs: Container, Tab, Panel
- Drawer: Layout, Header, Sidebar, NavItem, NavGroup

**View Helpers:**
- `BetterUi::ApplicationHelper` with `bui_*` helper methods (auto-included in all views)

**Form Builder:**
- `BetterUi::UiFormBuilder` for seamless Rails form integration

## Using Components

### View Helpers (Recommended)

BetterUi provides `bui_*` view helpers that are **automatically available** in all views - no setup required:

```erb
<%= bui_button(label: "Click me", variant: :primary, size: :lg) %>

<%= bui_card(size: :lg) do |c| %>
  <% c.with_header { "Card Title" } %>
  <% c.with_body { "Card content" } %>
<% end %>

<%= bui_text_input(name: "email", label: "Email", placeholder: "you@example.com") %>

<%= bui_drawer_layout do |layout| %>
  <% layout.with_header do |header| %>
    <% header.with_logo { "MyApp" } %>
  <% end %>
  <% layout.with_sidebar do |sidebar| %>
    <% sidebar.with_navigation do %>
      <%= bui_drawer_nav_group(title: "Menu") do |group| %>
        <% group.with_item(label: "Dashboard", href: "/", active: true) %>
      <% end %>
    <% end %>
  <% end %>
  <% layout.with_main { yield } %>
<% end %>
```

**Available helpers:**

| Category | Helpers |
|----------|---------|
| Core | `bui_button`, `bui_link`, `bui_card`, `bui_action_messages`, `bui_avatar`, `bui_badge`, `bui_tag`, `bui_heading`, `bui_spinner`, `bui_progress`, `bui_divider`, `bui_tooltip`, `bui_container`, `bui_fa_icon`, `bui_breadcrumb` |
| Forms | `bui_text_input`, `bui_email_input`, `bui_tel_input`, `bui_date_input`, `bui_time_input`, `bui_number_input`, `bui_password_input`, `bui_textarea`, `bui_checkbox`, `bui_checkbox_group`, `bui_select` |
| Table | `bui_table` |
| Dialog | `bui_dialog`, `bui_dialog_alert`, `bui_dialog_confirm` |
| Tabs | `bui_tabs`, `bui_tab`, `bui_tab_panel` |
| Drawer | `bui_drawer_layout`, `bui_drawer_sidebar`, `bui_drawer_header`, `bui_drawer_nav_item`, `bui_drawer_nav_group` |

### Direct Component Usage

You can also use ViewComponent directly if you prefer the explicit syntax:

```erb
<%= bui_button(variant: :primary, size: :lg) { "Click me" } %>

<%= bui_card(size: :lg) do |c| %>
  <% c.with_header { "Card Title" } %>
  <% c.with_body { "Card content" } %>
<% end %>
```

### Form Builder Usage

```erb
<%= form_with model: @user, builder: BetterUi::UiFormBuilder do |f| %>
  <%= f.bui_text_input :name %>
  <%= f.bui_text_input :email, hint: "We'll never share your email" %>
  <%= f.bui_password_input :password %>
  <%= f.bui_textarea :bio, rows: 6 %>
  <%= f.bui_number_input :age, min: 18 %>
  <%= f.bui_checkbox :terms, label: "I agree to the terms" %>
  <%= f.bui_select :country, [["Italy", "it"], ["France", "fr"]] %>
  <%= bui_button(type: :submit, variant: :primary) { "Submit" } %>
<% end %>
```

## Customizing the Theme

### Overriding CSS Variables

Create a custom theme file and override the CSS variables:

```css
@import "tailwindcss";
@import "@pandev-srl/better-ui/theme";       /* Design tokens */
@import "@pandev-srl/better-ui/typography";  /* Typography utilities */
@import "@pandev-srl/better-ui/utilities";   /* General utilities */

@theme inline {
  /* Override primary color to your brand */
  --color-primary-500: oklch(0.60 0.24 220);
  --color-primary-600: oklch(0.50 0.26 220);
  /* ... other overrides */
}
```

### Theme File for Full Customization

The generator copies the theme file to `app/assets/stylesheets/better_ui_theme.css` by default. This file contains only design tokens (CSS custom properties) that you can customize:

- Color variants (primary, secondary, accent, etc.)
- Grayscale colors
- Typography tokens
- Spacing and sizing tokens
- Border radius values
- Shadow definitions

To skip copying the theme file and use the npm package defaults:

```bash
bin/rails generate better_ui:install --no-copy-theme
```

## Vite Configuration

If using Vite with Rails, ensure proper configuration:

```javascript
// vite.config.js
import { defineConfig } from 'vite'
import RubyPlugin from 'vite-plugin-ruby'

export default defineConfig({
  plugins: [RubyPlugin()],
  css: {
    postcss: {
      plugins: [require('@tailwindcss/postcss')()]
    }
  }
})
```

## Troubleshooting

### Controllers not working

1. Verify npm package is installed: `npm list @pandev-srl/better-ui`
2. Check JavaScript import is correct
3. Verify `registerControllers(application)` is called after `Application.start()`
4. Check browser console for errors

### Styles not applying

1. Ensure CSS import is correct
2. Check that `@source` directives include `vendor/bundle`
3. Restart your dev server after CSS changes
4. Clear browser cache

### Colors not working

1. Verify theme is imported after Tailwind
2. Check OKLCH color syntax is correct
3. Ensure you're using correct color names (e.g., `bg-primary-500`)

## Development

For development on the BetterUi gem itself:

```bash
# Clone the repository
git clone https://github.com/umbertopeserico/better_ui.git
cd better_ui

# Install Ruby dependencies
bundle install

# Install npm dependencies and build
cd assets
yarn install
yarn build
cd ..

# Run tests
bundle exec rake test

# Start the dummy app server
cd test/dummy
bundle exec rails server
```

## Support

For issues, questions, or contributions, please visit the [BetterUi GitHub repository](https://github.com/umbertopeserico/better_ui).
