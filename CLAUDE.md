# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

BetterUi is a Rails 8.1+ engine gem that provides ViewComponent-based UI components with Tailwind CSS v4 styling. It follows the isolated namespace pattern with `BetterUi::Engine` inheriting from `::Rails::Engine` with `isolate_namespace BetterUi`.

**Critical Design Principle**: BetterUi ships **only Ruby components** (no CSS files). Host applications must configure Tailwind CSS v4 to scan `vendor/bundle` directories for component classes. See `doc/INSTALLATION.md` for details.

## Development Commands

### Setup
```bash
bundle install
```

### Testing
```bash
# Run all tests with coverage
bundle exec rake test

# Run specific test file
bundle exec ruby -Itest test/components/better_ui/button_component_test.rb

# Run specific test method
bundle exec ruby -Itest test/components/better_ui/button_component_test.rb -n test_renders_with_default_variant

# Test with SimpleCov minimum 75% coverage enforced
```

### Linting
```bash
# Run RuboCop with Omakase Ruby styling
bundle exec rubocop

# Auto-correct offenses
bundle exec rubocop -a
```

### Development Server & Component Previews
```bash
# Start dummy Rails app with Lookbook previews
cd test/dummy
bundle exec rails server

# View components at http://localhost:3000/rails/view_components
# Preview classes in spec/components/previews/better_ui/
```

## Architecture

### Component Hierarchy

**All components inherit from `BetterUi::ApplicationComponent < ViewComponent::Base`:**

```
ApplicationComponent (base class)
├── VARIANTS constant (9 semantic color variants: primary, secondary, accent, success, danger, warning, info, light, dark)
├── css_classes() helper (uses TailwindMerge for intelligent class merging)
│
├── ButtonComponent (with Stimulus controller)
├── CardComponent (slots: header, body, footer)
├── ActionMessagesComponent (with Stimulus controller)
└── Forms::BaseComponent (abstract base for form inputs)
    ├── Forms::TextInputComponent
    ├── Forms::NumberInputComponent
    ├── Forms::PasswordInputComponent (with Stimulus controller)
    └── Forms::TextareaComponent

UiFormBuilder (Rails form builder, integrates all form components)
```

### Engine Configuration (lib/better_ui/engine.rb)

**Critical initializers executed in order:**

1. **`better_ui.autoload_ignore`** - Excludes `lib/tasks` and `lib/generators` from Zeitwerk autoloading
2. **`better_ui.importmap`** - Adds engine's JavaScript to host app's importmap (for Stimulus controllers)
3. **`better_ui.view_component`** - Configures `app.config.view_component.previews.paths` for preview discovery
4. **`better_ui.lookbook`** - Configures Lookbook component browser with `spec/components/previews/` path

### JavaScript Architecture (Stimulus Controllers)

**Engine controllers** (`app/javascript/controllers/better_ui/`):
- `button_controller.js` - Loading states and click handling
- `action_messages_controller.js` - Dismissible alerts with auto-dismiss timer
- `forms/password_input_controller.js` - Password visibility toggle

**Naming convention**: Stimulus identifiers use hyphens (e.g., `data-controller="better-ui--button"`), while file paths use underscores. This is critical for proper registration.

**Host app integration**: Dummy app (`test/dummy/app/javascript/controllers/index.js`) uses `eagerLoadControllersFrom("controllers/better_ui", application)` to auto-register engine controllers.

### CSS & Theming

**No CSS is distributed** - Components use utility classes that must be scanned by host app's Tailwind build:

```css
/* Host app must configure PostCSS with: */
@source "../../../vendor/bundle/**/*.{rb,erb}";
```

**Theme customization** via `better_ui_theme.css` installed by generator:
- 9 color variants with 11 shades each (50-950)
- OKLCH color space for perceptually uniform colors
- CSS custom properties: `--color-{variant}-{shade}`
- Typography, spacing, shadows defined in `@theme inline` block

### Test Structure

**Test organization:**
- `test/components/better_ui/` - Component unit tests using ViewComponent::TestHelpers
- `test/form_builders/` - UiFormBuilder integration tests
- `test/generators/` - Generator tests
- `test/integration/` - Rails integration tests
- `spec/components/previews/` - Lookbook preview classes (not tests)

**Custom test helpers** (`test/test_helper.rb`):
- `assert_selector(selector, text:, count:)` - Nokogiri-based CSS selector assertions
- `refute_selector(selector)` - Assert selector absence
- `assert_text(text)` - Assert text presence
- `has_css?(selector)` - Boolean check for selector
- `rendered_html` - Access to rendered component HTML

**Testing pattern:**
```ruby
def test_renders_with_variant
  render_inline(BetterUi::ButtonComponent.new(label: "Test", variant: :success))
  assert_selector("button.bg-success-600")
end
```

### Dummy Application

**Minimal Rails app** (`test/dummy/`) for development and testing:
- **Loaded frameworks**: ActiveModel, ActionController, ActionView, Rails TestUnit
- **NOT loaded**: ActiveJob, ActiveRecord, ActiveStorage, ActionMailer, ActionMailbox, ActionText, ActionCable
- **Asset pipeline**: Propshaft
- **JavaScript**: Importmap with Stimulus
- **Server**: Puma

**Purpose**: Test engine in realistic Rails environment and develop components with Lookbook previews.

## Key Patterns

### Namespace Isolation

All code must be namespaced under `BetterUi::`:
- Components: `class BetterUi::ButtonComponent < BetterUi::ApplicationComponent`
- Controllers: `class BetterUi::ApplicationController < ActionController::Base`
- Form builders: `class BetterUi::UiFormBuilder < ActionView::Helpers::FormBuilder`
- Routes: `BetterUi::Engine.routes.draw { ... }`

### Tailwind Class Detection

**Critical for JIT compilation**: Tailwind classes must be **literal strings** in Ruby code, not interpolated:

```ruby
# ✅ CORRECT - JIT compiler detects classes
case @variant
when :primary then "bg-primary-600"
when :success then "bg-success-600"
end

# ❌ WRONG - JIT compiler cannot detect interpolated classes
"bg-#{@variant}-600"
```

### Data Attribute Naming Convention

**HTML data attributes use hyphens**, not underscores:

```ruby
# ✅ CORRECT
data: { controller: "better-ui--button" }
data: { "better-ui--button-target": "input" }

# ❌ WRONG
data: { controller: "better_ui--button" }
```

This is critical for Stimulus controller registration.

### Component Testing Philosophy

**Test rendered HTML, not implementation details:**

```ruby
# ✅ CORRECT - Tests public API and rendered output
def test_renders_button_with_label
  render_inline(BetterUi::ButtonComponent.new(label: "Click me"))
  assert_selector("button", text: "Click me")
end

# ❌ WRONG - Tests private implementation
def test_component_classes_method
  component = BetterUi::ButtonComponent.new(label: "Test")
  assert_equal "btn-primary", component.send(:component_classes)
end
```

### ViewComponent Preview Organization

**Preview classes** (`spec/components/previews/`) demonstrate components with Lookbook:

```ruby
class BetterUi::ButtonComponentPreview < ViewComponent::Preview
  # @label All Variants
  def all_variants
    # Preview implementation - returns rendered HTML or uses template
  end
end
```

**Template files**: `spec/components/previews/better_ui/button_component_preview/all_variants.html.erb`

**Important**: ERB templates don't inherit Ruby class context, so use fully qualified constants:
```erb
<!-- ✅ CORRECT -->
<% BetterUi::ApplicationComponent::VARIANTS.each do |variant, _| %>

<!-- ❌ WRONG -->
<% VARIANTS.each do |variant, _| %>
```

## Commit Conventions

Use conventional commit format:
```
feat: add new component feature
fix: resolve rendering bug
docs: update installation guide
refactor: reorganize component structure
test: add missing test coverage
```

## Documentation Structure

- `README.md` - Main entry point, quick start guide
- `CHANGELOG.md` - Version history and release notes
- `doc/INSTALLATION.md` - Detailed setup with Tailwind CSS v4 configuration
- `doc/COMPONENTS.md` - Complete API reference for all components
- `doc/CUSTOMIZATION.md` - Theme customization with OKLCH color system
- `doc/COVERAGE.md` - Test coverage report and strategy

## Development Methodology

**TDD (Test-Driven Development)**: Always write tests first when developing new features or fixing bugs. Target 100% test coverage.