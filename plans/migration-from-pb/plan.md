# Migration Plan: Powerbankly UI Components → BetterUi Rails Engine

## Overview
This plan outlines the migration of a complete UI component system from the Powerbankly application into the BetterUi Rails engine gem. The system includes 9 ViewComponents, a custom form builder, Stimulus controllers, and a comprehensive Tailwind CSS v4 theme.

## Components to Migrate

### Ruby Components (10 files)
1. `ApplicationComponent` → `BetterUi::ApplicationComponent`
2. `Ui::ButtonComponent` → `BetterUi::ButtonComponent`
3. `Ui::CardComponent` → `BetterUi::CardComponent`
4. `Ui::ActionMessagesComponent` → `BetterUi::ActionMessagesComponent`
5. `Ui::Forms::BaseComponent` → `BetterUi::Forms::BaseComponent`
6. `Ui::Forms::TextInputComponent` → `BetterUi::Forms::TextInputComponent`
7. `Ui::Forms::NumberInputComponent` → `BetterUi::Forms::NumberInputComponent`
8. `Ui::Forms::PasswordInputComponent` → `BetterUi::Forms::PasswordInputComponent`
9. `Ui::Forms::TextareaComponent` → `BetterUi::Forms::TextareaComponent`
10. `UiFormBuilder` → `BetterUi::UiFormBuilder`

### Templates (7 files)
- Each component above (except ApplicationComponent and BaseComponent) has a corresponding `.html.erb` template

### JavaScript/Stimulus (3 controllers)
1. `ui--button-component` → `better-ui--button`
2. `ui--action-messages-component` → `better-ui--action_messages`
3. `ui--forms--password-input-component` → `better-ui--forms--password_input`

### CSS/Styling
- Complete Tailwind CSS v4 theme with 9-variant color system
- Default theme provided by gem (customizable via generator)
- Component styles as raw CSS source files
- Typography and utility classes
- No PostCSS configuration in gem (host app responsibility)

---

## Host Application Requirements

**BetterUi distributes ViewComponents ONLY (Ruby classes + ERB templates with Tailwind classes).**
**NO CSS files are distributed from the gem.**

### Required Tools & Versions

| Tool | Version | Purpose |
|------|---------|---------|
| **Rails** | 8.1.1+ | Framework requirement (as per gemspec) |
| **Ruby** | 3.x+ | Recommended |
| **Tailwind CSS** | 4.0+ | CSS framework (uses CSS-based configuration) |
| **PostCSS** | 8.4+ | CSS processing |
| **@tailwindcss/postcss** | 4.0+ | Tailwind v4 PostCSS plugin |
| **postcss-cli** | 11.0+ | Command-line tool for PostCSS |

### CSS Build Process

Host applications need:
- **cssbundling-rails** (recommended) OR **tailwindcss-rails v4+**
- PostCSS configuration with `@tailwindcss/postcss` plugin
- Build script to compile CSS (e.g., `yarn build:css`)
- Development watch process (e.g., via Procfile.dev)

**Important:** Tailwind v4 uses **CSS `@source` directives exclusively** - no JavaScript `tailwind.config.js` file is needed or used.

### Installation

Run `rails generate better_ui:install` to create theme file in host app. The generator creates a theme file with `@theme inline` block and updates your CSS to scan gem templates in `vendor/bundle`.

See Phase 7.2 (INSTALLATION.md) for detailed setup instructions.

### What This Gem Provides

- ✅ ViewComponents (Ruby classes + ERB templates with Tailwind classes)
- ✅ Stimulus controllers (JavaScript)
- ✅ Form builder helper
- ✅ Rails generator to create theme file in host app
- ✅ Default 9-variant color system (as generator template)

### What This Gem Does NOT Provide

- ❌ CSS files (neither compiled nor source)
- ❌ PostCSS configuration files
- ❌ JavaScript `tailwind.config.js`
- ❌ package.json or Node dependencies
- ❌ Build scripts or asset compilation tools

**Exception:** The test/dummy app (for gem development) DOES include PostCSS/Tailwind setup - see Phase 6.5.

---

## Phase 1: Setup & Dependencies

### 1.1 Update Gemspec Dependencies
Add to `better_ui.gemspec`:
```ruby
spec.add_dependency "view_component", "~> 4.1"
spec.add_dependency "tailwind_merge", "~> 0.12"
spec.add_dependency "lookbook", "~> 2.3"
spec.add_dependency "importmap-rails"
```

### 1.2 Setup Asset Pipeline
- Configure Propshaft for CSS assets
- Setup importmap for JavaScript/Stimulus

### 1.3 Asset Distribution Strategy

**The BetterUi engine distributes ONLY ViewComponents (Ruby classes + ERB templates with Tailwind classes).**

**NO CSS files are distributed.** The host application is responsible for:
1. Creating theme file with color system (via generator)
2. Configuring Tailwind to scan gem templates in `vendor/bundle`
3. Generating CSS from Tailwind classes found in gem templates

This approach:
- Keeps the gem simple (no CSS files to maintain)
- Gives host apps full control over theming
- Avoids path versioning issues (no gem version numbers in paths)
- Follows ViewComponent best practices

**Gem provides:**
- ViewComponents with Tailwind classes in ERB templates
- Generator that creates theme file in host app
- Helper method `BetterUi.template_paths` for documentation purposes
- No CSS files
- No PostCSS configuration files
- No Node.js dependencies

**Host application setup:**
1. Run `rails generate better_ui:install`
2. Generator creates `app/assets/stylesheets/better_ui_theme.css` with `@theme inline` block
3. Generator updates host app CSS with simple @source directive: `@source "../../../vendor/bundle/**/*.{rb,erb}"`
4. Tailwind scans all gems in vendor/bundle and generates CSS for classes used

**Benefits of vendor/bundle scanning:**
- No version-specific paths (works with any gem version)
- No manual updates needed after gem upgrades
- Tailwind only generates CSS for classes actually used (no bloat from other gems)
- Works reliably in Docker with vendor/bundle

**Dummy app setup:**
The test dummy app WILL need PostCSS/Tailwind configuration for development and testing purposes (see Phase 6.5).

---

## Phase 2: Migrate Core Components

### 2.1 Base Component (`BetterUi::ApplicationComponent`)
**Source:** `/Users/umberto/Documents/Work/pandev/powerbankly/powerbankly/app/components/application_component.rb`
**Target:** `app/components/better_ui/application_component.rb`

**Key Features to Preserve:**
- VARIANTS constant: `[:primary, :secondary, :accent, :success, :danger, :warning, :info, :light, :dark]`
- `css_classes(*classes)` helper method using TailwindMerge
- Inherits from `ViewComponent::Base`

### 2.2 Button Component (`BetterUi::ButtonComponent`)
**Source:** `/Users/umberto/Documents/Work/pandev/powerbankly/powerbankly/app/components/ui/button_component.rb`
**Target:** `app/components/better_ui/button_component.rb`

**Features:**
- 5 sizes: `:xs, :sm, :md, :lg, :xl`
- 4 styles: `:solid, :outline, :ghost, :soft`
- 9 variants (from VARIANTS)
- Loading state with spinner
- Icon slots: `icon_before`, `icon_after`
- Stimulus controller: `better-ui--button`

**Template:** `app/components/better_ui/button_component/button_component.html.erb`

### 2.3 Card Component (`BetterUi::CardComponent`)
**Source:** `/Users/umberto/Documents/Work/pandev/powerbankly/powerbankly/app/components/ui/card_component.rb`
**Target:** `app/components/better_ui/card_component.rb`

**Features:**
- 5 sizes: `:xs, :sm, :md, :lg, :xl`
- 5 styles: `:solid, :outline, :ghost, :soft, :bordered`
- Slots: `header`, `body`, `footer`
- Optional shadow
- Configurable padding

**Template:** `app/components/better_ui/card_component/card_component.html.erb`

### 2.4 Action Messages Component (`BetterUi::ActionMessagesComponent`)
**Source:** `/Users/umberto/Documents/Work/pandev/powerbankly/powerbankly/app/components/ui/action_messages_component.rb`
**Target:** `app/components/better_ui/action_messages_component.rb`

**Features:**
- 4 styles: `:solid, :soft, :outline, :ghost`
- 9 variants
- Dismissible with close button
- Auto-dismiss timer
- Optional title and icon slot
- Stimulus controller: `better-ui--action_messages`

**Template:** `app/components/better_ui/action_messages_component/action_messages_component.html.erb`

### 2.5 Form Base Component (`BetterUi::Forms::BaseComponent`)
**Source:** `/Users/umberto/Documents/Work/pandev/powerbankly/powerbankly/app/components/ui/forms/base_component.rb`
**Target:** `app/components/better_ui/forms/base_component.rb`

**Features:**
- Abstract base class (not rendered directly)
- 5 sizes: `:xs, :sm, :md, :lg, :xl`
- Label, hint, error handling
- State management: normal, error, disabled, readonly
- Consistent sizing system

### 2.6 Text Input Component (`BetterUi::Forms::TextInputComponent`)
**Source:** `/Users/umberto/Documents/Work/pandev/powerbankly/powerbankly/app/components/ui/forms/text_input_component.rb`
**Target:** `app/components/better_ui/forms/text_input_component.rb`

**Features:**
- Inherits from `BetterUi::Forms::BaseComponent`
- Prefix/suffix icon slots
- Text input type

**Template:** `app/components/better_ui/forms/text_input_component/text_input_component.html.erb`

### 2.7 Number Input Component (`BetterUi::Forms::NumberInputComponent`)
**Source:** `/Users/umberto/Documents/Work/pandev/powerbankly/powerbankly/app/components/ui/forms/number_input_component.rb`
**Target:** `app/components/better_ui/forms/number_input_component.rb`

**Features:**
- Number input with min/max/step
- Optional spinner controls
- Prefix/suffix icon slots
- CSS for hiding spinners

**Template:** `app/components/better_ui/forms/number_input_component/number_input_component.html.erb`

### 2.8 Password Input Component (`BetterUi::Forms::PasswordInputComponent`)
**Source:** `/Users/umberto/Documents/Work/pandev/powerbankly/powerbankly/app/components/ui/forms/password_input_component.rb`
**Target:** `app/components/better_ui/forms/password_input_component.rb`

**Features:**
- Inherits from `BetterUi::Forms::TextInputComponent`
- Visibility toggle button
- Eye/eye-slash icons (inline SVG)
- Stimulus controller: `better-ui--forms--password_input`

**Template:** `app/components/better_ui/forms/password_input_component/password_input_component.html.erb`

### 2.9 Textarea Component (`BetterUi::Forms::TextareaComponent`)
**Source:** `/Users/umberto/Documents/Work/pandev/powerbankly/powerbankly/app/components/ui/forms/textarea_component.rb`
**Target:** `app/components/better_ui/forms/textarea_component.rb`

**Features:**
- Configurable rows/cols
- Maxlength support
- Resize control: none, vertical, horizontal, both
- Prefix/suffix icon slots

**Template:** `app/components/better_ui/forms/textarea_component/textarea_component.html.erb`

### 2.10 Form Builder (`BetterUi::UiFormBuilder`)
**Source:** `/Users/umberto/Documents/Work/pandev/powerbankly/powerbankly/app/form_builders/ui_form_builder.rb`
**Target:** `app/form_builders/better_ui/ui_form_builder.rb`

**Features:**
- Inherits from `ActionView::Helpers::FormBuilder`
- Methods: `ui_text_input`, `ui_number_input`, `ui_password_input`, `ui_textarea`
- Automatic error handling
- Automatic required field detection
- Value population from model

---

## Phase 3: Migrate JavaScript/Stimulus Controllers

### 3.1 Setup JavaScript Structure
Create directory: `app/javascript/controllers/better_ui/`

### 3.2 Button Controller
**Source:** `/Users/umberto/Documents/Work/pandev/powerbankly/powerbankly/app/javascript/components/ui/button_component_controller.js`
**Target:** `app/javascript/controllers/better_ui/button_controller.js`
**Controller Name:** `better-ui--button`

**Features:**
- Loading state management
- Click handling
- Auto-reset on Turbo events (turbo:submit-end, turbo:frame-load)
- Accessibility attributes

### 3.3 Action Messages Controller
**Source:** `/Users/umberto/Documents/Work/pandev/powerbankly/powerbankly/app/javascript/components/ui/action_messages_component_controller.js`
**Target:** `app/javascript/controllers/better_ui/action_messages_controller.js`
**Controller Name:** `better-ui--action_messages`

**Features:**
- Dismiss action with fade-out animation
- Auto-dismiss timer
- Cleanup on disconnect

### 3.4 Password Input Controller
**Source:** `/Users/umberto/Documents/Work/pandev/powerbankly/powerbankly/app/javascript/components/ui/forms/password_input_component_controller.js`
**Target:** `app/javascript/controllers/better_ui/forms/password_input_controller.js`
**Controller Name:** `better-ui--forms--password_input`

**Features:**
- Password visibility toggle
- Icon switching (eye/eye-slash)
- Focus management

### 3.5 Create Index File
**Target:** `app/javascript/controllers/better_ui/index.js`

Register all controllers for eager loading.

### 3.6 Configure Importmap
Add to engine's configuration:
```ruby
# In engine initializer or lib/better_ui/engine.rb
config.importmap.paths << root.join("config/importmap.rb")
```

Create `config/importmap.rb`:
```ruby
pin_all_from "app/javascript/controllers/better_ui", under: "controllers/better_ui", preload: true
```

---

## Phase 4: CSS Theme & Generator

### 4.1 NO CSS Files in Gem

**Critical:** Do NOT create any CSS files under `app/assets/stylesheets/better_ui/`

The gem distributes ViewComponents ONLY. All CSS generation happens in the host app by scanning gem templates.

### 4.2 Color System Documentation

Document the default color system that will be provided via generator template:

**9 Semantic Variants:**
- primary, secondary, accent
- success, danger, warning, info
- light, dark

**Each variant includes:**
- Base color (500)
- Hover color (600)
- Active color (700)
- Text color (contrast)
- Light variants (50, 100, 200, 300, 400)
- Dark variants (800, 900, 950)

**Additional theme elements:**
- Base typography (h1-h6, p, hr styles)
- Utility classes (heading color variants, number spinner hiding)

### 4.3 Generator Template Creation

**Target:** `lib/generators/better_ui/install/templates/better_ui_theme.css.tt`

Create template file with complete `@theme inline` block containing all 9 color variants with full scales, typography settings, and utility classes.

This template will be copied to the host app where users can customize colors.

### 4.4 Install Generator

**Target:** `lib/generators/better_ui/install/install_generator.rb`

**Generator Behavior:**

1. **Creates theme file in host app:**
   - Target: `app/assets/stylesheets/better_ui_theme.css`
   - Contains: Complete `@theme inline { ... }` block with all color variants
   - Host app can customize colors, typography, etc.

2. **Updates host app CSS:**
   - Modifies `app/assets/stylesheets/application.postcss.css` (or creates if missing)
   - Adds `@import` for theme file
   - Adds `@source` directive to scan vendor/bundle: `@source "../../../vendor/bundle/**/*.{rb,erb}"`
   - Adds `@source` directives for host app files

**Generator Command:**
```bash
rails generate better_ui:install
```

**What it creates:**

**File: `app/assets/stylesheets/better_ui_theme.css`**
```css
@theme inline {
  /* Primary color */
  --color-primary-50: oklch(0.97 0.01 250);
  --color-primary-500: oklch(0.55 0.22 250);
  --color-primary-600: oklch(0.50 0.22 250);
  /* ... all 9 variants with full scale */

  /* Base typography */
  /* ... typography settings ... */

  /* Utility classes */
  /* ... custom utilities ... */
}
```

**Updates: `app/assets/stylesheets/application.postcss.css`**
```css
@import "tailwindcss";

/* Import BetterUi theme (customize colors here) */
@import "./better_ui_theme.css";

/* Scan BetterUi gem templates in vendor/bundle */
@source "../../../vendor/bundle/**/*.{rb,erb}";

/* Scan your app files */
@source "../../**/*.{erb,html,rb}";
@source "../javascript/**/*.js";
```

**Key Benefits:**
- Simple `@source` directive with no version numbers
- Scans all gems in vendor/bundle (Tailwind only generates CSS for classes used)
- No manual updates needed after gem upgrades
- Works in Docker with vendor/bundle

**Generator Options:**

The generator could support options like:
```bash
rails generate better_ui:install --css-file=app/assets/stylesheets/custom.css
```

### 4.5 Path Helper (Informational Only)

**Target:** `lib/better_ui.rb`

Create helper method for documentation purposes:

```ruby
module BetterUi
  class << self
    def template_paths
      [
        "#{Engine.root}/app/components/**/*.{rb,erb}",
        "#{Engine.root}/app/views/**/*.{erb,html}",
        "#{Engine.root}/app/helpers/**/*.rb"
      ]
    end
  end
end
```

**Note:** This helper is for debugging/documentation only. It cannot be used in `@source` directives because Tailwind CLI runs before Rails.

### 4.6 Verify No CSS Assets

**Checklist:**
- [ ] NO files in `app/assets/stylesheets/better_ui/`
- [ ] NO application.postcss.css in gem
- [ ] NO components.css in gem
- [ ] ONLY generator template in `lib/generators/better_ui/install/templates/better_ui_theme.css.tt`
- [ ] Gem distributes ViewComponents with Tailwind classes only

---

## Phase 5: Setup Lookbook & Migrate Previews

### 5.1 Configure Lookbook
Add initializer: `lib/better_ui/engine.rb`
```ruby
config.lookbook.enabled = true
config.lookbook.preview_paths = [root.join("spec/components/previews")]
```

### 5.2 Migrate Component Previews
**Source:** `/Users/umberto/Documents/Work/pandev/powerbankly/powerbankly/spec/components/previews/`
**Target:** `spec/components/previews/better_ui/`

Create previews for:
1. **ButtonComponent** - All variants, sizes, styles, loading states
2. **CardComponent** - All layouts with header/body/footer combinations
3. **ActionMessagesComponent** - All variants and styles
4. **TextInputComponent** - With/without icons, error states
5. **NumberInputComponent** - With constraints, spinners
6. **PasswordInputComponent** - Toggle visibility demo
7. **TextareaComponent** - Various sizes and resize options

### 5.3 Preview Naming Convention
- `BetterUi::ButtonComponentPreview`
- `BetterUi::CardComponentPreview`
- `BetterUi::ActionMessagesComponentPreview`
- `BetterUi::Forms::TextInputComponentPreview`
- etc.

---

## Phase 6: Demo Pages in Dummy App

### 6.1 Create Demo Controller
**Target:** `test/dummy/app/controllers/better_ui/demos_controller.rb`

Actions:
- `index` - Overview of all components
- `buttons` - Button showcase
- `cards` - Card layouts
- `alerts` - Action messages
- `forms` - Complete form examples

### 6.2 Create Demo Views
**Target:** `test/dummy/app/views/better_ui/demos/`

Views for each action demonstrating:
- All component variations
- Interactive examples
- Code snippets for usage
- Color system showcase

### 6.3 Add Routes
**Target:** `test/dummy/config/routes.rb`

```ruby
namespace :better_ui do
  resources :demos, only: [:index] do
    collection do
      get :buttons
      get :cards
      get :alerts
      get :forms
    end
  end
end
```

### 6.4 Mount Engine
Ensure engine is mounted in dummy app:
```ruby
mount BetterUi::Engine, at: "/better_ui"
```

### 6.5 Dummy App CSS Build Setup

Since the gem distributes raw CSS, the dummy app needs its own PostCSS/Tailwind build setup for development and testing.

#### Files to Create:

**1. `test/dummy/package.json`**
```json
{
  "name": "better-ui-dummy",
  "private": true,
  "type": "module",
  "packageManager": "yarn@4.0.0",
  "scripts": {
    "build:css": "postcss ./app/assets/stylesheets/application.tailwind.css -o ./app/assets/builds/application.css",
    "watch:css": "postcss ./app/assets/stylesheets/application.tailwind.css -o ./app/assets/builds/application.css --watch"
  },
  "devDependencies": {
    "@tailwindcss/postcss": "^4.1.0",
    "postcss": "^8.4.49",
    "postcss-cli": "^11.0.0",
    "tailwindcss": "^4.1.0"
  }
}
```

**2. `test/dummy/postcss.config.mjs`**
```javascript
export default {
  plugins: {
    "@tailwindcss/postcss": {}
  }
}
```

**3. `test/dummy/app/assets/stylesheets/application.tailwind.css`**
```css
@import "tailwindcss";

/* Import BetterUi theme */
@import "./better_ui_theme.css";

/* Scan engine templates (relative paths work in dummy app) */
@source "../../../../app/components/**/*.{rb,erb}";
@source "../../../../app/views/**/*.erb";
@source "../../../../app/helpers/**/*.rb";

/* Scan dummy app files */
@source "../../views/**/*.erb";
@source "../../controllers/**/*.rb";
@source "../javascript/**/*.js";
```

**4. Copy theme file to dummy app:**

Run the generator or manually create the theme file:
```bash
cd test/dummy
rails generate better_ui:install
```

Or manually create `test/dummy/app/assets/stylesheets/better_ui_theme.css` with the default theme from the generator template.

**5. `test/dummy/Procfile.dev`**
```
web: bin/rails server -p 3000
css: yarn watch:css
```

**6. `test/dummy/bin/dev`**
```bash
#!/usr/bin/env sh

if ! command -v foreman &> /dev/null
then
  echo "Installing foreman..."
  gem install foreman
fi

foreman start -f Procfile.dev "$@"
```

Make executable: `chmod +x test/dummy/bin/dev`

#### Files to Modify:

**Update `test/dummy/app/views/layouts/application.html.erb`:**
Change stylesheet reference to point to compiled CSS:
```erb
<%= stylesheet_link_tag "application", "data-turbo-track": "reload" %>
```

**Update root `.gitignore`:**
```
# Dummy app Node and build files
/test/dummy/node_modules/
/test/dummy/app/assets/builds/
/test/dummy/yarn.lock
/test/dummy/package-lock.json
/test/dummy/pnpm-lock.yaml
```

#### Setup Steps:

1. Run `yarn install` in `test/dummy/`
2. Run `yarn build:css` to test initial compilation
3. Start development server with `test/dummy/bin/dev`
4. Verify CSS compiles and hot-reloads on changes

**Note:** The compiled CSS outputs to `test/dummy/app/assets/builds/` which Propshaft serves. Build outputs should be gitignored.

---

## Phase 7: Documentation & Configuration Guide

### 7.1 Update README.md
Add sections:

- **CSS Build Requirements** (Add at top, prominently):
  ```markdown
  ## CSS Build Requirements

  ⚠️ **Important:** BetterUi distributes **raw, uncompiled CSS** using Tailwind CSS v4.
  Your Rails application **must have a CSS build process** to use this gem.

  **Supported setups:**
  - cssbundling-rails with PostCSS + Tailwind CSS v4
  - tailwindcss-rails gem v4+

  See [INSTALLATION.md](INSTALLATION.md) for detailed setup instructions.
  ```

- **Installation** - Link to INSTALLATION.md for full setup guide
- **Quick Start** - Minimal example showing component usage
- **Components Overview** - List all available components with links to COMPONENTS.md
- **Usage Examples** - Basic usage for each component
- **Color System** - Brief overview, link to CUSTOMIZATION.md
- **Form Builder** - Integration with Rails forms
- **Stimulus Controllers** - How interactive features work
- **Development** - Link to dummy app setup (Phase 6.5)
- **Contributing** - Link to contribution guidelines
- **License** - MIT License information

### 7.2 Create INSTALLATION.md
Comprehensive step-by-step guide for host applications:

#### Prerequisites

**BetterUi distributes ViewComponents ONLY (Ruby classes + ERB templates with Tailwind classes).**
**NO CSS files are distributed.** Your Rails application MUST have a CSS build process.

**Required tools:**
- Rails 8.1.1+
- Tailwind CSS v4+
- PostCSS with `@tailwindcss/postcss` plugin
- CSS bundling setup (cssbundling-rails or tailwindcss-rails)

#### Installation Steps

**1. Add BetterUi to Gemfile:**
```ruby
gem 'better_ui'
```

Run: `bundle install`

**2. Setup CSS Build Process (if not already configured):**

If your app doesn't have CSS bundling:
```bash
bundle add cssbundling-rails
rails css:install:postcss
```

This creates:
- `package.json` with PostCSS dependencies
- `postcss.config.js` configuration file
- `app/assets/stylesheets/application.postcss.css` entry point
- Build script in `package.json`

**3. Install Tailwind CSS v4:**

Add to `package.json` dependencies:
```json
{
  "devDependencies": {
    "@tailwindcss/postcss": "^4.1.0",
    "postcss": "^8.4.49",
    "postcss-cli": "^11.0.0",
    "tailwindcss": "^4.1.0"
  }
}
```

Run: `yarn install` (or `npm install`)

**4. Configure PostCSS:**

Update `postcss.config.js`:
```javascript
export default {
  plugins: {
    "@tailwindcss/postcss": {}
  }
}
```

**5. Run BetterUi Generator:**

```bash
rails generate better_ui:install
```

This creates:
- `app/assets/stylesheets/better_ui_theme.css` - Theme file with `@theme inline` block
- Updates `app/assets/stylesheets/application.postcss.css` with imports and @source directives

**6. Your Complete CSS File:**

After running the generator, your `application.postcss.css` should look like:

```css
/* app/assets/stylesheets/application.postcss.css */
@import "tailwindcss";

/* Import BetterUi theme (customize colors here) */
@import "./better_ui_theme.css";

/* Scan BetterUi gem templates in vendor/bundle */
@source "../../../vendor/bundle/**/*.{rb,erb}";

/* Scan your app files */
@source "../../**/*.{erb,html,rb}";
@source "../javascript/**/*.js";
```

**Key Benefits:**
- Simple `@source` directive with no version numbers
- Scans all gems in vendor/bundle (Tailwind only generates CSS for classes actually used)
- No manual updates needed after gem upgrades
- Works in Docker with vendor/bundle

**7. Customize Your Theme (Optional):**

Edit `app/assets/stylesheets/better_ui_theme.css` to change colors:

```css
@theme inline {
  /* Change primary color */
  --color-primary-500: oklch(0.55 0.22 250);  /* Default blue */
  --color-primary-500: oklch(0.55 0.22 150);  /* Change to green */

  /* Customize other variants */
  /* ... */
}
```

**8. Pin JavaScript (Stimulus Controllers):**

Add to `config/importmap.rb`:
```ruby
pin_all_from BetterUi::Engine.root.join("app/javascript/controllers/better_ui"),
             under: "controllers/better_ui",
             preload: true
```

**9. Register Stimulus Controllers:**

In your `app/javascript/controllers/index.js`:
```javascript
import { application } from "./application"
import { eagerLoadControllersFrom } from "@hotwired/stimulus-loading"

// Import BetterUi controllers
eagerLoadControllersFrom("controllers/better_ui", application)
```

**10. Build CSS and Start Development:**
```bash
# Build CSS once
yarn build:css

# Or use dev script (with CSS watch)
bin/dev
```

Your `Procfile.dev` should include:
```
web: bin/rails server
css: yarn build:css --watch
```

#### Troubleshooting

**Problem: Tailwind classes from BetterUi components not working**

**Solution:**
1. Verify @source directive in your CSS: `@source "../../../vendor/bundle/**/*.{rb,erb}"`
2. Check your bundle location: `bundle config get path`
3. If not using vendor/bundle, adjust the path (e.g., for system gems use different relative path)
4. Rebuild CSS: `yarn build:css`
5. Clear Rails cache: `rails tmp:clear`
6. Check terminal for Tailwind errors

**Problem: "Cannot find module" errors when building CSS**

**Solution:**
1. Verify all npm packages are installed: `yarn install`
2. Check `package.json` has all required dependencies
3. Ensure PostCSS config file exists and is valid

**Problem: Build fails with PostCSS errors**

**Solution:**
1. Verify `@tailwindcss/postcss` is installed: `yarn list @tailwindcss/postcss`
2. Check PostCSS config syntax (should use `export default` for `.mjs` files)
3. Ensure Tailwind CSS v4+ is installed

**Problem: Stimulus controllers not loading**

**Solution:**
1. Check importmap setup: `bin/importmap json` should show better_ui paths
2. Verify controller files exist: `bundle show better_ui`
3. Check browser console for import errors
4. Ensure controllers are registered in `index.js`

**Problem: Different bundle location (not vendor/bundle)**

**Solution:**
If your gems are in a different location (e.g., system gems):
1. Find bundle path: `bundle config get path`
2. Calculate relative path from `app/assets/stylesheets/` to your bundle directory
3. Update @source directive in `application.postcss.css`

Examples:
- System gems: `@source "../../../../../.rbenv/versions/3.3.0/lib/ruby/gems/3.3.0/gems/**/*.{rb,erb}"`
- Custom path: Adjust `../` count based on your directory structure

#### Customization

See CUSTOMIZATION.md for complete color system documentation and advanced theming options.

### 7.3 Create COMPONENTS.md
Detailed documentation for each component:
- Component name and namespace
- Parameters and options
- Slot usage
- Examples with code
- Stimulus controller integration (if applicable)

### 7.4 Create CUSTOMIZATION.md
Guide for customizing:
- Color system override
- Size system modification
- Adding new variants
- Extending components
- Custom styles

---

## Phase 8: Testing & Validation

### 8.1 Component Rendering Tests
Create test files in `test/components/better_ui/`:
- Test each component renders without errors
- Test with various parameter combinations
- Test slot rendering

### 8.2 Stimulus Controller Tests
If setting up JS tests:
- Test button loading states
- Test action messages dismissal
- Test password visibility toggle

### 8.3 Form Builder Tests
Create `test/form_builders/better_ui/ui_form_builder_test.rb`:
- Test form helper methods
- Test error handling
- Test required field detection

### 8.4 Integration Tests
In dummy app `test/integration/`:
- Test demo pages load successfully
- Test component interactions
- Test form submissions

### 8.5 Visual Validation
Manual testing via:
- Lookbook previews (http://localhost:3000/rails/lookbook)
- Demo pages in dummy app
- Check all variants, sizes, styles render correctly
- Verify responsive behavior
- Test interactive features (buttons, alerts, password toggle)

### 8.6 Color System Validation
- Verify all 9 variants display correctly
- Test hover/active states
- Ensure contrast ratios are accessible
- Test in both light and dark contexts

---

## Migration Checklist

### Phase 1: Setup ✓
- [ ] Add gem dependencies to gemspec
- [ ] Configure importmap
- [ ] Document asset distribution strategy (raw CSS, no PostCSS in gem)

### Phase 2: Components ✓
- [ ] Migrate ApplicationComponent
- [ ] Migrate ButtonComponent + template
- [ ] Migrate CardComponent + template
- [ ] Migrate ActionMessagesComponent + template
- [ ] Migrate Forms::BaseComponent
- [ ] Migrate Forms::TextInputComponent + template
- [ ] Migrate Forms::NumberInputComponent + template
- [ ] Migrate Forms::PasswordInputComponent + template
- [ ] Migrate Forms::TextareaComponent + template
- [ ] Migrate UiFormBuilder

### Phase 3: JavaScript ✓
- [ ] Setup JavaScript directory structure
- [ ] Migrate button controller
- [ ] Migrate action_messages controller
- [ ] Migrate password_input controller
- [ ] Create controllers index file
- [ ] Configure importmap

### Phase 4: CSS Theme & Generator ✓
- [ ] Verify NO CSS files in app/assets/stylesheets/better_ui/ (gem distributes NO CSS)
- [ ] Document complete color system (9 variants with full scale)
- [ ] Document base typography styles
- [ ] Document utility classes
- [ ] Create path helper method in lib/better_ui.rb (informational only)
- [ ] Create theme generator: lib/generators/better_ui/install/install_generator.rb
- [ ] Create generator template: lib/generators/better_ui/install/templates/better_ui_theme.css.tt
- [ ] Generator creates theme file with @theme inline in host app
- [ ] Generator updates host app CSS with vendor/bundle @source directive
- [ ] Test generator creates correct files and paths
- [ ] Verify NO PostCSS config files in gem root (except test/dummy/)
- [ ] Verify NO CSS files distributed from gem

### Phase 5: Lookbook ✓
- [ ] Configure Lookbook
- [ ] Migrate button preview
- [ ] Migrate card preview
- [ ] Migrate action messages preview
- [ ] Migrate form input previews

### Phase 6: Demo App ✓
- [ ] Create demos controller
- [ ] Create demo views
- [ ] Add routes
- [ ] Setup dummy app CSS build (PostCSS + Tailwind + Yarn)
- [ ] Create Procfile.dev and bin/dev for development
- [ ] Update .gitignore for build outputs
- [ ] Test demo pages

### Phase 7: Documentation ✓
- [ ] Update README.md with CSS Build Requirements section
- [ ] Create INSTALLATION.md with two theme approaches (default vs custom)
- [ ] Document ERB @source approach as primary method
- [ ] Document generator usage in INSTALLATION.md
- [ ] Create COMPONENTS.md
- [ ] Create CUSTOMIZATION.md
- [ ] Ensure all docs emphasize Tailwind v4 CSS-only (no JS config)

### Phase 8: Testing ✓
- [ ] Component rendering tests
- [ ] Form builder tests
- [ ] Integration tests
- [ ] Visual validation in Lookbook
- [ ] Visual validation in demo app
- [ ] Color system validation

---

## Technical Decisions Summary

| Aspect | Decision | Rationale |
|--------|----------|-----------|
| **Component Namespace** | Direct under `BetterUi::` (e.g., `BetterUi::ButtonComponent`) | Simpler, cleaner namespace. Forms get `BetterUi::Forms::` |
| **Form Components** | Nested under `BetterUi::Forms::` | Logical grouping, prevents cluttering main namespace |
| **Stimulus Controllers** | Prefix with `better-ui--` | Prevents conflicts with host app controllers |
| **Color System** | Include defaults, allow override | Ships ready-to-use, but customizable via Tailwind |
| **JavaScript Distribution** | Importmap | Rails 8 standard, simpler setup for host apps |
| **CSS Distribution** | ViewComponents only, NO CSS files | Host app creates theme and scans gem templates in vendor/bundle, avoids version issues |
| **Previews** | Lookbook integration | Best-in-class component preview system |
| **Testing** | ViewComponent tests + dummy app | Standard Rails engine testing approach |

---

## Post-Migration Tasks

1. **Version 0.1.0 Release**
   - Tag initial release
   - Publish to RubyGems (or private gem server)

2. **Update Powerbankly**
   - Remove migrated components
   - Add `better_ui` gem dependency
   - Update component references
   - Update Stimulus controller names
   - Test integration

3. **Documentation Site** (Future)
   - Deploy Lookbook publicly
   - Create interactive documentation
   - Add search functionality

4. **Community** (If open source)
   - Setup contributing guidelines
   - Create issue templates
   - Add code of conduct
   - Setup CI/CD

---

## Key Files Reference

### Component Mapping
| Source | Target | Type |
|--------|--------|------|
| `app/components/application_component.rb` | `app/components/better_ui/application_component.rb` | Base |
| `app/components/ui/button_component.rb` | `app/components/better_ui/button_component.rb` | Component |
| `app/components/ui/card_component.rb` | `app/components/better_ui/card_component.rb` | Component |
| `app/components/ui/action_messages_component.rb` | `app/components/better_ui/action_messages_component.rb` | Component |
| `app/components/ui/forms/base_component.rb` | `app/components/better_ui/forms/base_component.rb` | Base |
| `app/components/ui/forms/text_input_component.rb` | `app/components/better_ui/forms/text_input_component.rb` | Component |
| `app/components/ui/forms/number_input_component.rb` | `app/components/better_ui/forms/number_input_component.rb` | Component |
| `app/components/ui/forms/password_input_component.rb` | `app/components/better_ui/forms/password_input_component.rb` | Component |
| `app/components/ui/forms/textarea_component.rb` | `app/components/better_ui/forms/textarea_component.rb` | Component |
| `app/form_builders/ui_form_builder.rb` | `app/form_builders/better_ui/ui_form_builder.rb` | Builder |

### JavaScript Mapping
| Source | Target | Controller Name |
|--------|--------|-----------------|
| `app/javascript/components/ui/button_component_controller.js` | `app/javascript/controllers/better_ui/button_controller.js` | `better-ui--button` |
| `app/javascript/components/ui/action_messages_component_controller.js` | `app/javascript/controllers/better_ui/action_messages_controller.js` | `better-ui--action_messages` |
| `app/javascript/components/ui/forms/password_input_component_controller.js` | `app/javascript/controllers/better_ui/forms/password_input_controller.js` | `better-ui--forms--password_input` |

---

## Notes & Considerations

### Breaking Changes
- Controller names change from `ui--*` to `better-ui--*`
- Component namespaces flatten from `Ui::` to `BetterUi::`
- Form builder class name changes from `UiFormBuilder` to `BetterUi::UiFormBuilder`

### Compatibility
- Rails 8.1.1+ required (as per gemspec)
- Ruby 3.x recommended
- Tailwind CSS v4
- ViewComponent 4.1+
- Hotwired Stimulus

### CSS Build Approach
- **Gem Distribution:** Raw, uncompiled CSS source files only
- **No Build Tooling in Gem:** No PostCSS config, no Node dependencies, no package.json
- **Host App Responsibility:** Host applications must have their own CSS build process
- **Dummy App Exception:** The test dummy app DOES include PostCSS/Tailwind setup for development/testing
- **Benefits:** Simpler gem maintenance, no version conflicts, host apps have full control

### Performance
- Importmap enables HTTP/2 benefits
- Tailwind JIT compilation keeps CSS minimal
- ViewComponent provides fast rendering
- No jQuery or heavy JS frameworks

### Accessibility
- All components should maintain ARIA attributes
- Color contrast ratios validated
- Keyboard navigation supported
- Screen reader friendly

---

## Success Criteria

✅ All components render correctly in isolation (Lookbook)
✅ All components render correctly in demo pages
✅ Stimulus controllers function as expected
✅ Color system works and is overridable
✅ Form builder integrates with Rails forms
✅ Documentation is complete and clear
✅ Tests pass
✅ No regressions in Powerbankly after integration
✅ Gem can be installed in new Rails app and components work immediately
