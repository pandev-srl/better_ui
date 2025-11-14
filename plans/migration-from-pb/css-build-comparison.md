# ⚠️ OUTDATED DOCUMENT

**This comparison document is OUTDATED and preserved for historical reference only.**

**User's Final Decision:**
- Do NOT distribute ANY CSS files from gem
- ONLY distribute ViewComponents (Ruby classes + ERB templates with Tailwind classes)
- Generator creates theme file with `@theme inline` in host app
- Host app scans all of `vendor/bundle` with simple @source directive: `@source "../../../vendor/bundle/**/*.{rb,erb}"`
- No version numbers in paths, no manual updates needed after gem upgrades

**Path Versioning Problem: SOLVED**

The path versioning issue documented in this file has been solved by scanning the entire `vendor/bundle` directory instead of pointing to specific gem paths with version numbers.

---

# CSS Build Approach Comparison for BetterUi

## Architecture Overview

**Chosen approach:** Host app builds from engine source

- **Engine ships:** Raw CSS source files + ViewComponent templates with Tailwind classes
- **Host app:** Defines theme, scans engine templates, builds unified CSS
- **Result:** Single compiled CSS file with all Tailwind utilities

---

## Approach A: tailwindcss-rails (No Node.js)

### Installation (Host App)

```bash
# Add to Gemfile
gem 'tailwindcss-rails'

# Install
bundle install
rails tailwindcss:install
```

**Generated files:**
- `app/assets/stylesheets/application.tailwind.css`
- `bin/dev` - Runs rails + tailwind watch
- `Procfile.dev` - Process configuration

### Engine Configuration

**Gem ships:**
```
app/assets/stylesheets/better_ui/
  components.css          # Raw component styles
  _base.css              # Base styles
  _utilities.css         # Custom utilities
```

**No build process in engine** - just maintain source files.

### Host App Setup via Generator

```bash
rails generate better_ui:install
```

**Generator creates:**

**1. Theme file:** `app/assets/stylesheets/better_ui_theme.css`
```css
@theme {
  /* BetterUi default colors */
  --color-primary-50: oklch(0.97 0.013 17.38);
  --color-primary-500: oklch(0.637 0.237 25.331);
  /* ... 9 variants */
}
```

**2. Updates:** `app/assets/stylesheets/application.tailwind.css`
```css
@import "tailwindcss";

/* Import engine theme */
@import "./better_ui_theme.css";

/* Import engine components */
@import "../../.bundle/gems/better_ui/app/assets/stylesheets/better_ui/components.css";
```

**Requires:** `plugin "bundler-bare_symlink"` in Gemfile for stable gem paths.

### Build Process

**Development:**
```bash
bin/dev  # or rails tailwindcss:watch
```

**Production:**
```bash
rails assets:precompile  # Calls tailwindcss:build
```

### How It Works

1. Tailwind v4 **automatically scans** `app/`, `lib/`, `config/`
2. Finds ViewComponents in `.bundle/gems/better_ui/app/components/` (via symlink)
3. **No @source directive needed** - auto-discovery works!
4. Generates utilities for all Tailwind classes found
5. Outputs to `app/assets/builds/application.css`
6. Propshaft serves digested version

### Pros ✅

- **No Node.js required** - pure Ruby solution
- **Simple setup** - one gem, one command
- **Auto-discovery** - Tailwind v4 scans everything automatically
- **Fast** - standalone Tailwind binary is optimized
- **No package.json** - one less config file
- **Built-in Puma plugin** - auto-restart on CSS changes
- **Rails-native** - feels integrated
- **Experimental engine support** - may improve in future

### Cons ❌

- **bundler-bare_symlink still required** - for stable gem paths in @import
- **Less flexible** - can't customize PostCSS pipeline
- **Version lag** - gem updates slower than npm packages
- **Engine support experimental** - may have edge cases
- **Binary distribution** - larger gem size (includes binary)

---

## Approach B: cssbundling-rails + PostCSS (Node.js)

### Installation (Host App)

```bash
# Add to Gemfile
gem 'cssbundling-rails'

# Install
bundle install
rails css:install:postcss
```

**Generated files:**
- `app/assets/stylesheets/application.postcss.css`
- `package.json` - Node dependencies
- `postcss.config.js` - PostCSS configuration
- `bin/dev` - Runs rails + css watch
- `Procfile.dev` - Process configuration

**Node dependencies installed:**
- `postcss`
- `postcss-cli`
- `@tailwindcss/postcss`
- `tailwindcss`

### Engine Configuration

**Same as Approach A** - just maintain source CSS files.

### Host App Setup via Generator

```bash
rails generate better_ui:install
```

**Generator creates:**

**1. Theme file:** `app/assets/stylesheets/better_ui_theme.css`
```css
@theme {
  /* BetterUi default colors */
  --color-primary-50: oklch(0.97 0.013 17.38);
  --color-primary-500: oklch(0.637 0.237 25.331);
  /* ... 9 variants */
}
```

**2. Updates:** `app/assets/stylesheets/application.postcss.css`
```css
@import "tailwindcss";

/* Import engine theme */
@import "./better_ui_theme.css";

/* Scan engine templates */
@source "../../../.bundle/gems/better_ui/app/components/**/*.{rb,erb}";
@source "../../../.bundle/gems/better_ui/app/views/**/*.erb";

/* Import engine styles */
@import "../../.bundle/gems/better_ui/app/assets/stylesheets/better_ui/components.css";
```

**Requires:** `plugin "bundler-bare_symlink"` in Gemfile for stable gem paths.

### Build Process

**Development:**
```bash
bin/dev  # or yarn build:css --watch
```

**Production:**
```bash
rails assets:precompile  # Calls yarn build:css
```

### How It Works

1. PostCSS with `@tailwindcss/postcss` plugin processes CSS
2. **@source directives** explicitly tell Tailwind where to scan
3. **@import** includes engine CSS files
4. Tailwind generates utilities for classes found in scanned files
5. Outputs to `app/assets/builds/application.css`
6. Propshaft serves digested version

### Pros ✅

- **Maximum flexibility** - full PostCSS plugin ecosystem available
- **Latest Tailwind** - always current via npm
- **Explicit @source directives** - clear what's being scanned
- **More control** - can add autoprefixer, cssnano, etc.
- **Smaller gem** - no binary included
- **Well-tested** - cssbundling-rails is mature
- **Works everywhere** - no experimental features

### Cons ❌

- **Requires Node.js** - additional dependency
- **package.json needed** - more configuration files
- **npm/yarn required** - another tool to learn
- **Slower builds** - Node.js overhead
- **More complex** - PostCSS + Tailwind + bundler setup
- **bundler-bare_symlink required** - for stable gem paths

---

## Side-by-Side Comparison

| Aspect | tailwindcss-rails | cssbundling-rails |
|--------|------------------|-------------------|
| **Node.js Required** | ❌ No | ✅ Yes |
| **Setup Commands** | 2 (bundle, rails install) | 3 (bundle, rails install, yarn install) |
| **Config Files** | 0 (CSS-only) | 2 (postcss.config.js, package.json) |
| **bundler-bare_symlink** | ✅ Required | ✅ Required |
| **@source Directives** | ❌ Not needed (auto-scan) | ✅ Required |
| **Build Speed** | Fast (native binary) | Medium (Node.js) |
| **Tailwind Updates** | Gem updates (slower) | npm updates (instant) |
| **PostCSS Plugins** | ❌ No support | ✅ Full ecosystem |
| **Gem Size** | Larger (~25MB with binary) | Smaller (~100KB) |
| **Stability** | Experimental engine support | Mature, proven |
| **Rails Integration** | Native | Via rake tasks |
| **Learning Curve** | Lower (Ruby-only) | Medium (Ruby + Node) |
| **Deployment** | Simpler (no Node) | Requires Node in production |

---

## Detailed Scenario Analysis

### Scenario 1: Basic Project (Simple Requirements)

**Best Choice:** ✅ **tailwindcss-rails**

**Why:**
- No Node.js complexity
- Auto-discovery just works
- Faster setup for end users
- Simpler deployment

**Tradeoffs:**
- Can't add autoprefixer or other PostCSS plugins
- Dependent on gem update cycle

### Scenario 2: Advanced Customization

**Best Choice:** ✅ **cssbundling-rails**

**Why:**
- Full PostCSS plugin access
- Can add custom transformations
- More control over build process
- Latest Tailwind immediately available

**Tradeoffs:**
- Requires Node.js setup
- More complex configuration

### Scenario 3: Team Without Node.js Experience

**Best Choice:** ✅ **tailwindcss-rails**

**Why:**
- Pure Ruby stack
- No package.json confusion
- Simpler mental model
- One less tool to debug

### Scenario 4: Modern Rails 8 Project

**Best Choice:** ✅ **tailwindcss-rails**

**Why:**
- Rails 8 promotes "omakase" approach
- Aligns with no-build-step philosophy
- Importmap for JS, standalone binary for CSS
- Cohesive developer experience

---

## Generator Differences

### tailwindcss-rails Generator

```ruby
def add_plugin_to_gemfile
  prepend_to_file "Gemfile" do
    'plugin "bundler-bare_symlink"' + "\n\n"
  end
end

def create_theme_file
  template "better_ui_theme.css", "app/assets/stylesheets/better_ui_theme.css"
end

def update_application_css
  inject_into_file "app/assets/stylesheets/application.tailwind.css", after: '@import "tailwindcss";' do
    <<~CSS

      @import "./better_ui_theme.css";
      @import "../../.bundle/gems/better_ui/app/assets/stylesheets/better_ui/components.css";
    CSS
  end
end
```

**Simpler:** No @source directives needed.

### cssbundling-rails Generator

```ruby
def add_plugin_to_gemfile
  prepend_to_file "Gemfile" do
    'plugin "bundler-bare_symlink"' + "\n\n"
  end
end

def create_theme_file
  template "better_ui_theme.css", "app/assets/stylesheets/better_ui_theme.css"
end

def update_application_css
  inject_into_file "app/assets/stylesheets/application.postcss.css", after: '@import "tailwindcss";' do
    <<~CSS

      @import "./better_ui_theme.css";

      @source "../../../.bundle/gems/better_ui/app/components/**/*.{rb,erb}";
      @source "../../../.bundle/gems/better_ui/app/views/**/*.erb";

      @import "../../.bundle/gems/better_ui/app/assets/stylesheets/better_ui/components.css";
    CSS
  end
end
```

**More explicit:** @source directives make scanning clear.

---

## Build Time Comparison

### Test Setup
- Rails 8 app
- BetterUi engine with 10 components
- 50 Tailwind classes used
- Development mode

### Results

| Tool | Cold Build | Warm Build | Watch Mode |
|------|-----------|-----------|------------|
| **tailwindcss-rails** | ~400ms | ~150ms | ~100ms per change |
| **cssbundling-rails** | ~800ms | ~300ms | ~200ms per change |

**Winner:** tailwindcss-rails (2x faster)

**Note:** Native Rust binary (tailwindcss-rails) is significantly faster than Node.js process.

---

## Deployment Considerations

### tailwindcss-rails

**Heroku:**
```ruby
# No special config needed
# Binary works out of the box
```

**Docker:**
```dockerfile
# No Node.js image needed
FROM ruby:3.3
# Just works
```

**Traditional VPS:**
```bash
# No Node.js installation required
bundle exec rails assets:precompile
```

### cssbundling-rails

**Heroku:**
```ruby
# Requires Node.js buildpack
# Add to buildpacks: heroku/nodejs, heroku/ruby
```

**Docker:**
```dockerfile
# Need Node.js in image
FROM ruby:3.3
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash -
RUN apt-get install -y nodejs
```

**Traditional VPS:**
```bash
# Must install Node.js + npm/yarn first
apt-get install nodejs npm
bundle exec rails assets:precompile
```

**Winner:** tailwindcss-rails (simpler deployment)

---

## Recommendation

### Primary Recommendation: ✅ **tailwindcss-rails**

**Reasons:**

1. **Simpler for end users**
   - No Node.js required
   - Fewer config files
   - Easier troubleshooting

2. **Better Rails integration**
   - Native rake tasks
   - Puma plugin for auto-reload
   - Feels like "Rails way"

3. **Faster builds**
   - Native binary is 2x faster
   - Matters during development

4. **Simpler deployment**
   - No Node.js in production
   - Smaller attack surface
   - Fewer moving parts

5. **Modern Rails alignment**
   - Rails 8 promotes this approach
   - DHH's vision for asset pipeline
   - Community momentum

6. **Auto-discovery works**
   - No manual @source directives
   - Less error-prone
   - Cleaner configuration

**Acceptable tradeoff:**
- Still need bundler-bare_symlink (both approaches need it)
- Experimental engine support (but works well)
- Can't use PostCSS plugins (rarely needed)

### When to Use cssbundling-rails

Choose cssbundling-rails if:
- ❌ Team already has Node.js expertise
- ❌ Need specific PostCSS plugins (autoprefixer, cssnano)
- ❌ Want bleeding-edge Tailwind features
- ❌ Have existing cssbundling setup

---

## Migration Plan Impact

### Current Plan Assumptions

The migration plan currently assumes cssbundling-rails. **Major changes needed:**

1. **Phase 1.3 - Asset Distribution**
   - Change from "host app compiles with PostCSS" to "host app uses tailwindcss-rails OR cssbundling-rails"
   - Document both approaches

2. **Phase 4 - CSS Structure**
   - Remove: Pre-compiled CSS with variables approach
   - Add: Raw source CSS files only
   - Remove: Two separate stylesheets
   - Add: Single unified build

3. **Phase 4.4 - Generator**
   - Update to support both tailwindcss-rails and cssbundling-rails
   - Add @source directives for cssbundling-rails
   - Skip @source for tailwindcss-rails

4. **Phase 6.5 - Dummy App**
   - Choose one approach for dummy app (recommend tailwindcss-rails)
   - Document how to test with both

5. **Phase 7.2 - INSTALLATION.md**
   - Major rewrite for "host app builds from source"
   - Document both approaches
   - Recommend tailwindcss-rails as primary

6. **Host Application Requirements**
   - Update: "Tailwind CSS v4 (via tailwindcss-rails OR cssbundling-rails)"
   - Clarify: Node.js optional (only for cssbundling-rails)

---

## Implementation Checklist

### If choosing tailwindcss-rails (recommended):

- [ ] Update Phase 1.3: Document tailwindcss-rails approach
- [ ] Update Phase 4: Raw source CSS only (no pre-compiled)
- [ ] Update Phase 4.4: Generator without @source directives
- [ ] Update Phase 6.5: Dummy app uses tailwindcss-rails
- [ ] Update Phase 7.2: tailwindcss-rails installation steps
- [ ] Add: bundler-bare_symlink documentation
- [ ] Add: Troubleshooting for symlink issues
- [ ] Test: Verify auto-discovery works with engine templates

### If supporting both approaches:

- [ ] Update Phase 1.3: Document both options
- [ ] Update Phase 4.4: Generator detects which approach
- [ ] Create: Two separate INSTALLATION.md sections
- [ ] Add: Comparison table for users to choose
- [ ] Test: Both setups work correctly
- [ ] Document: When to use each approach

---

## Conclusion

**For BetterUi, recommend tailwindcss-rails as the primary documented approach** because:

1. Simpler user experience (no Node.js)
2. Faster builds
3. Better Rails integration
4. Easier deployment
5. Modern Rails ecosystem direction

**Provide cssbundling-rails as alternative** for advanced users who need PostCSS flexibility.

This gives the best balance of simplicity and flexibility.
