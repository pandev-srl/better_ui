# BetterUi Installation Guide

This guide walks you through installing and configuring BetterUi in your Rails application.

## Prerequisites

- Rails 8.1.1 or higher
- Node.js and npm (for Tailwind CSS)
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

### 2. Run the install generator

```bash
bin/rails generate better_ui:install
```

This generator will:

- Create `app/assets/stylesheets/better_ui_theme.css` with your theme configuration
- Create or update `app/assets/stylesheets/application.postcss.css` with necessary imports and @source directives

### 3. Install Tailwind CSS v4

BetterUi requires Tailwind CSS v4 (currently in beta):

```bash
npm install tailwindcss@next @tailwindcss/postcss@next
```

### 4. Configure PostCSS

Create or update `postcss.config.js` in your project root:

```javascript
module.exports = {
  plugins: [
    require('@tailwindcss/postcss')
  ]
}
```

### 5. Configure Asset Pipeline

Ensure your application layout includes the stylesheet:

```erb
<!-- app/views/layouts/application.html.erb -->
<!DOCTYPE html>
<html>
  <head>
    <title>Your App</title>
    <%= stylesheet_link_tag "application", "data-turbo-track": "reload" %>
    <%= javascript_importmap_tags %>
  </head>
  <body>
    <%= yield %>
  </body>
</html>
```

## What Gets Generated

### Theme File (better_ui_theme.css)

The generator creates a comprehensive theme file with:

- **9 Color Variants**: primary, secondary, accent, success, danger, warning, info, light, dark
- **Full Color Scales**: Each variant includes shades from 50 to 950
- **OKLCH Color Space**: Modern color definition for better perceptual uniformity
- **Typography Tokens**: Font family definitions (sans, serif, mono)
- **Spacing Tokens**: Consistent spacing scale
- **Border Radius Tokens**: From none to full rounded
- **Shadow Tokens**: From subtle to prominent shadows
- **Utility Classes**: Pre-configured utilities like:
  - `.text-heading-{variant}` for semantic heading colors
  - `.no-spinner` for hiding number input spinners
  - `.focus-ring` for consistent focus states
  - `.glass` for glass morphism effects

### Application CSS (application.postcss.css)

The generator configures your application CSS with:

```css
@import "tailwindcss";
@import "./better_ui_theme.css";

/* Scan gem templates for Tailwind classes */
@source "../../../vendor/bundle/**/*.{rb,erb}";

/* Scan application files for Tailwind classes */
@source "../../**/*.{erb,html,rb}";
@source "../javascript/**/*.js";
```

The `@source` directives tell Tailwind CSS v4 where to find classes:
- **vendor/bundle**: Scans gem templates (including BetterUi components)
- **Application views**: Scans your app's ERB, HTML, and Ruby files
- **JavaScript**: Scans JS files for dynamic class names

## Customizing Your Theme

After installation, you can customize the theme by editing `app/assets/stylesheets/better_ui_theme.css`.

### Customizing Colors

Each color variant follows this structure:

```css
/* Primary color example */
--color-primary-50: oklch(0.97 0.01 250);   /* Lightest */
--color-primary-100: oklch(0.94 0.03 250);
--color-primary-200: oklch(0.88 0.06 250);
--color-primary-300: oklch(0.80 0.12 250);
--color-primary-400: oklch(0.70 0.18 250);
--color-primary-500: oklch(0.60 0.22 250);  /* Base color */
--color-primary-600: oklch(0.50 0.24 250);
--color-primary-700: oklch(0.42 0.22 250);
--color-primary-800: oklch(0.34 0.18 250);
--color-primary-900: oklch(0.28 0.12 250);
--color-primary-950: oklch(0.18 0.08 250);  /* Darkest */
```

OKLCH format: `oklch(lightness chroma hue)`
- **Lightness**: 0-1 (0 = black, 1 = white)
- **Chroma**: 0-0.4 (saturation intensity)
- **Hue**: 0-360 (color angle)

### Customizing Typography

```css
--font-family-sans: system-ui, -apple-system, sans-serif;
--font-family-serif: Georgia, Cambria, serif;
--font-family-mono: ui-monospace, Monaco, monospace;
```

### Adding Custom Utilities

Add your own utility classes in the `@layer utilities` block:

```css
@theme inline {
  /* ... existing theme ... */

  @layer utilities {
    .your-custom-class {
      @apply bg-primary-500 text-white;
    }
  }
}
```

## Using BetterUi Components

Once installed, you can use BetterUi components in your views:

```erb
<%= render BetterUi::ButtonComponent.new(
  label: "Click me",
  variant: "primary"
) %>
```

## Helper Methods

BetterUi provides helper methods for debugging and development:

```ruby
# Get paths to BetterUi templates
BetterUi.template_paths
# => ["/path/to/gem/app/views", "/path/to/gem/app/components"]

# Get the gem root path
BetterUi.root
# => #<Pathname:/path/to/better_ui>
```

## Troubleshooting

### Classes not applying

1. Ensure PostCSS is properly configured
2. Check that `@source` directives include all necessary paths
3. Restart your Rails server after making changes to CSS configuration
4. Clear browser cache or do a hard refresh

### Gem components not styled

Ensure the vendor/bundle path is included in your `application.postcss.css`:

```css
@source "../../../vendor/bundle/**/*.{rb,erb}";
```

This tells Tailwind to scan gem templates for Tailwind classes.

### Colors not working

1. Verify that `@import "./better_ui_theme.css"` comes after `@import "tailwindcss"`
2. Check that the theme file exists in `app/assets/stylesheets/better_ui_theme.css`
3. Ensure you're using the correct color names (e.g., `bg-primary-500` not `bg-blue-500`)

## Updating the Theme

If you need to regenerate the theme file (e.g., after an update):

```bash
bin/rails generate better_ui:install --force
```

This will overwrite existing files. Back up your customizations first!

## Development and Testing

To test BetterUi components in isolation, you can create a test page:

```erb
<!-- app/views/better_ui_test/index.html.erb -->
<div class="p-8 space-y-4">
  <h1 class="text-heading-primary text-3xl font-bold">BetterUi Components</h1>

  <!-- Test your components here -->
</div>
```

## Next Steps

- Explore available BetterUi components in the documentation
- Customize your theme colors to match your brand
- Build your application with consistent, beautiful UI components
- Check out the [Tailwind CSS v4 documentation](https://tailwindcss.com/docs) for more styling options

## Support

For issues, questions, or contributions, please visit the [BetterUi GitHub repository](https://github.com/your-username/better_ui).
