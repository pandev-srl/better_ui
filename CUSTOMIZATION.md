# BetterUi Customization Guide

Learn how to customize BetterUi components, create custom themes, and extend the framework to match your brand and design requirements.

## Table of Contents

- [Understanding the Color System](#understanding-the-color-system)
- [OKLCH Color Space](#oklch-color-space)
- [Customizing Colors](#customizing-colors)
- [Creating Custom Variants](#creating-custom-variants)
- [Typography Customization](#typography-customization)
- [Modifying Size Scales](#modifying-size-scales)
- [Extending Components](#extending-components)
- [Custom Utility Classes](#custom-utility-classes)
- [Dark Mode Considerations](#dark-mode-considerations)

## Understanding the Color System

BetterUi uses a semantic color system with 9 variants, each serving a specific purpose:

### The 9 Variants

| Variant | Purpose | Default Shade | Use Cases |
|---------|---------|---------------|-----------|
| `primary` | Main brand color | 600 | Primary actions, brand elements |
| `secondary` | Supporting color | 500 | Secondary buttons, neutral elements |
| `accent` | Highlight color | 500 | Special features, highlights |
| `success` | Positive feedback | 600 | Success messages, confirmations |
| `danger` | Destructive/Error | 600 | Delete buttons, error states |
| `warning` | Caution | 500 | Warnings, important notices |
| `info` | Informational | 500 | Tips, information messages |
| `light` | Light elements | 100 | Light backgrounds, borders |
| `dark` | Dark elements | 900 | Dark mode, high contrast |

### Color Scale Structure

Each variant includes 11 shades (50-950):

```css
--color-primary-50:  /* Lightest - backgrounds */
--color-primary-100: /* Very light - hover states */
--color-primary-200: /* Light - active states */
--color-primary-300: /* Light-medium */
--color-primary-400: /* Medium-light */
--color-primary-500: /* Medium - base color */
--color-primary-600: /* Medium-dark - default */
--color-primary-700: /* Dark - hover */
--color-primary-800: /* Darker - active */
--color-primary-900: /* Very dark - text */
--color-primary-950: /* Darkest - high contrast */
```

## OKLCH Color Space

BetterUi uses OKLCH (Oklab Lightness, Chroma, Hue) for perceptually uniform colors.

### What is OKLCH?

OKLCH provides:
- **Better consistency** across different hues
- **Predictable lightness** relationships
- **Smooth gradients** without muddy midpoints
- **Accessible contrast** calculations

### Format

```css
oklch(lightness chroma hue)
```

- **Lightness**: 0-1 (0 = black, 1 = white)
- **Chroma**: 0-0.4 (0 = gray, 0.4 = maximum saturation)
- **Hue**: 0-360 degrees (color wheel)

### Hue Reference

| Hue | Color |
|-----|-------|
| 0-30 | Red |
| 30-90 | Yellow |
| 90-150 | Green |
| 150-240 | Blue |
| 240-300 | Purple |
| 300-360 | Pink |

## Customizing Colors

Edit `app/assets/stylesheets/better_ui_theme.css`:

### Change Primary Color

```css
@theme inline {
  /* Your brand blue (hue 220) */
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
```

### Generate Consistent Scales

Start with your brand color at 500, then scale lightness:

```css
/* Brand purple at 500 */
--color-brand-500: oklch(0.60 0.20 280);

/* Scale up (lighter) */
--color-brand-400: oklch(0.69 0.16 280); /* +0.09 */
--color-brand-300: oklch(0.78 0.12 280); /* +0.18 */
--color-brand-200: oklch(0.86 0.08 280); /* +0.26 */
--color-brand-100: oklch(0.93 0.04 280); /* +0.33 */
--color-brand-50:  oklch(0.97 0.02 280); /* +0.37 */

/* Scale down (darker) */
--color-brand-600: oklch(0.51 0.22 280); /* -0.09 */
--color-brand-700: oklch(0.43 0.20 280); /* -0.17 */
--color-brand-800: oklch(0.35 0.16 280); /* -0.25 */
--color-brand-900: oklch(0.28 0.12 280); /* -0.32 */
--color-brand-950: oklch(0.20 0.08 280); /* -0.40 */
```

## Creating Custom Variants

Add a new "brand" variant:

### 1. Define Colors

```css
@theme inline {
  /* Custom brand variant */
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

### 2. Add Utilities (Optional)

```css
@layer utilities {
  .text-heading-brand {
    @apply text-brand-900 dark:text-brand-100;
  }
}
```

### 3. Use in Views

```erb
<div class="bg-brand-500 text-white p-4">
  Custom brand element
</div>
```

## Typography Customization

### Change Font Families

In `better_ui_theme.css`:

```css
@theme inline {
  /* Custom fonts */
  --font-family-sans: "Inter", system-ui, sans-serif;
  --font-family-serif: "Merriweather", Georgia, serif;
  --font-family-mono: "Fira Code", Monaco, monospace;
}
```

### Load Custom Fonts

In your application layout:

```html
<!-- Google Fonts -->
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">

<!-- Or self-hosted -->
<style>
  @font-face {
    font-family: 'Inter';
    src: url('/fonts/Inter.woff2') format('woff2');
    font-weight: 400 700;
  }
</style>
```

## Modifying Size Scales

### Spacing Scale

```css
@theme inline {
  /* Custom spacing */
  --space-xs: 0.25rem;  /* 4px */
  --space-sm: 0.5rem;   /* 8px */
  --space-md: 1rem;     /* 16px */
  --space-lg: 1.5rem;   /* 24px */
  --space-xl: 2rem;     /* 32px */
}
```

### Border Radius

```css
@theme inline {
  /* Custom radius */
  --radius-sm: 0.125rem;  /* 2px */
  --radius-md: 0.375rem;  /* 6px */
  --radius-lg: 0.5rem;    /* 8px */
  --radius-xl: 0.75rem;   /* 12px */
  --radius-full: 9999px;
}
```

### Shadows

```css
@theme inline {
  /* Custom shadows */
  --shadow-sm: 0 1px 2px 0 rgb(0 0 0 / 0.05);
  --shadow-md: 0 4px 6px -1px rgb(0 0 0 / 0.1);
  --shadow-lg: 0 10px 15px -3px rgb(0 0 0 / 0.1);
}
```

## Extending Components

### Method 1: CSS Overrides

Use `container_classes`:

```erb
<%= render BetterUi::ButtonComponent.new(
  label: "Custom",
  container_classes: "rounded-full shadow-lg"
) %>
```

### Method 2: Inheritance

Create custom components:

```ruby
# app/components/brand_button_component.rb
class BrandButtonComponent < BetterUi::ButtonComponent
  def initialize(**options)
    options[:container_classes] = css_classes(
      "rounded-full",
      options[:container_classes]
    )
    super(**options)
  end
end
```

### Method 3: Composition

Wrap BetterUi components:

```erb
<!-- app/components/card_with_header.html.erb -->
<%= render BetterUi::CardComponent.new do |card| %>
  <% card.with_header do %>
    <h2 class="text-xl font-bold gradient-text">
      <%= title %>
    </h2>
  <% end %>
  <% card.with_body { content } %>
<% end %>
```

## Custom Utility Classes

Add project-specific utilities:

```css
@layer utilities {
  /* Glass morphism */
  .glass {
    @apply bg-white/80 backdrop-blur-md border-white/20;
  }

  /* Gradient text */
  .gradient-text {
    @apply bg-gradient-to-r from-primary-600 to-accent-600
           bg-clip-text text-transparent;
  }

  /* Custom card */
  .brand-card {
    @apply bg-white rounded-xl shadow-lg p-6
           border border-primary-100;
  }

  /* Animation */
  .animate-slide-up {
    animation: slideUp 0.3s ease-out;
  }

  @keyframes slideUp {
    from {
      opacity: 0;
      transform: translateY(10px);
    }
    to {
      opacity: 1;
      transform: translateY(0);
    }
  }
}
```

Use in views:

```erb
<div class="glass rounded-lg p-4 animate-slide-up">
  <h1 class="gradient-text text-3xl">Welcome</h1>
</div>

<div class="brand-card">
  Custom styled card
</div>
```

## Dark Mode Considerations

### Color Utilities

Define dark mode variants:

```css
@layer utilities {
  .text-heading-primary {
    @apply text-primary-900 dark:text-primary-100;
  }

  .bg-surface {
    @apply bg-white dark:bg-grayscale-900;
  }

  .border-default {
    @apply border-grayscale-200 dark:border-grayscale-700;
  }
}
```

### Dark Mode Toggle

Add to your app:

```erb
<button onclick="toggleDarkMode()" class="p-2">
  <span class="dark:hidden">🌙</span>
  <span class="hidden dark:inline">☀️</span>
</button>

<script>
function toggleDarkMode() {
  document.documentElement.classList.toggle('dark');
  localStorage.theme = document.documentElement.classList.contains('dark')
    ? 'dark' : 'light';
}

// Initialize
if (localStorage.theme === 'dark' ||
    (!('theme' in localStorage) &&
     window.matchMedia('(prefers-color-scheme: dark)').matches)) {
  document.documentElement.classList.add('dark');
}
</script>
```

## Quick Start Examples

### Example 1: Corporate Blue Theme

```css
@theme inline {
  /* Corporate blue */
  --color-primary-500: oklch(0.55 0.25 240);
  --color-primary-600: oklch(0.45 0.27 240);
  --color-primary-700: oklch(0.38 0.25 240);

  /* Professional fonts */
  --font-family-sans: "Helvetica Neue", Arial, sans-serif;
}
```

### Example 2: Playful Creative Theme

```css
@theme inline {
  /* Vibrant purple */
  --color-primary-500: oklch(0.65 0.30 290);

  /* Bright accent */
  --color-accent-500: oklch(0.75 0.28 60);

  /* Rounded corners */
  --radius-lg: 1rem;

  /* Fun fonts */
  --font-family-sans: "Comic Sans MS", cursive;
}
```

### Example 3: Minimal Monochrome

```css
@theme inline {
  /* All grays */
  --color-primary-500: oklch(0.50 0 0);
  --color-secondary-500: oklch(0.60 0 0);

  /* Minimal radius */
  --radius-md: 2px;

  /* Clean fonts */
  --font-family-sans: "Inter", sans-serif;
}
```

## Best Practices

1. **Maintain Contrast** - Ensure WCAG AA (4.5:1 minimum)
2. **Test All States** - Check hover, active, disabled
3. **Keep Consistency** - Use consistent lightness progression
4. **Document Changes** - Comment customizations
5. **Version Control** - Track theme changes
6. **Test Both Modes** - Verify light and dark mode
7. **Use Semantic Names** - Name by purpose, not color

## Troubleshooting

### Colors Not Applying

```bash
# Clear and rebuild
rm -rf tmp/cache
bin/rails assets:clobber
bin/rails assets:precompile
```

### Check Import Order

```css
/* Correct order in application.postcss.css */
@import "tailwindcss";
@import "./better_ui_theme.css"; /* After Tailwind */
```

### Contrast Issues

Use OKLCH lightness for proper contrast:
- Text on light: L < 0.40
- Text on dark: L > 0.60
- Minimum difference: 0.40

## Resources

- [OKLCH Color Tool](https://oklch.com)
- [Contrast Checker](https://webaim.org/resources/contrastchecker/)
- [Tailwind v4 Docs](https://tailwindcss.com/docs)
- [Installation Guide](INSTALLATION.md)
- [Components Reference](COMPONENTS.md)