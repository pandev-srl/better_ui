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

**JavaScript (Stimulus Controllers):**
- `ButtonController` - Loading states and click handling
- `ActionMessagesController` - Dismissible alerts with auto-dismiss
- `PasswordInputController` - Password visibility toggle
- `DrawerLayoutController` - Mobile drawer toggle and responsive behavior
- `registerControllers()` - Helper to register all controllers

**CSS (Theme):**
- 9 semantic color variants (primary, secondary, accent, success, danger, warning, info, light, dark)
- Grayscale utility colors for neutral elements
- 11 shades per variant (50-950) using OKLCH color space
- Typography, spacing, border radius, and shadow tokens
- Utility classes (focus rings, glass effects, etc.) in separate modules

### Ruby Gem (better_ui)

The gem provides:

**ViewComponents:**
- `BetterUi::ButtonComponent`
- `BetterUi::CardComponent`
- `BetterUi::ActionMessagesComponent`
- Form components (TextInput, NumberInput, PasswordInput, Textarea, Checkbox, CheckboxGroup)
- Drawer components (Layout, Header, Sidebar, NavItem, NavGroup)

**Form Builder:**
- `BetterUi::UiFormBuilder` for seamless Rails form integration

## Using Components

### Direct Component Usage

```erb
<%= render BetterUi::ButtonComponent.new(
  label: "Click me",
  variant: "primary",
  size: "lg"
) %>

<%= render BetterUi::CardComponent.new(size: "lg") do |c| %>
  <% c.with_header { "Card Title" } %>
  <% c.with_body { "Card content" } %>
<% end %>
```

### Form Builder Usage

```erb
<%= form_with model: @user, builder: BetterUi::UiFormBuilder do |f| %>
  <%= f.ui_text_input :name %>
  <%= f.ui_text_input :email, hint: "We'll never share your email" %>
  <%= f.ui_password_input :password %>
  <%= f.ui_textarea :bio, rows: 6 %>
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
