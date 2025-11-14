# BetterUi Demo Application

This is a demo Rails application showcasing the BetterUi component library. It demonstrates all available components with various configurations, styles, and use cases.

## Prerequisites

- Ruby (version specified in `.ruby-version`)
- Bundler
- Node.js (for Yarn 4)
- Yarn 4

## Setup

### 1. Install Dependencies

```bash
# Install Ruby dependencies
bundle install

# Install JavaScript dependencies
yarn install
```

### 2. Build CSS

Before running the application, you need to build the CSS once:

```bash
yarn build:css
```

This will compile `app/assets/stylesheets/application.tailwind.css` into `app/assets/builds/application.css`.

## Running the Application

### Development Mode (Recommended)

Use the `bin/dev` script to run both the Rails server and the CSS watcher in parallel:

```bash
./bin/dev
```

This will:
- Start the Rails server on port 3000
- Watch for CSS changes and rebuild automatically

Visit [http://localhost:3000](http://localhost:3000) to view the demo application.

### Manual Mode

If you prefer to run processes separately:

**Terminal 1 - Rails Server:**
```bash
bundle exec rails server
```

**Terminal 2 - CSS Watcher:**
```bash
yarn watch:css
```

## Project Structure

### PostCSS/Tailwind CSS v4 Setup

The application uses Tailwind CSS v4 with PostCSS for styling:

- **postcss.config.mjs** - PostCSS configuration with @tailwindcss/postcss plugin
- **app/assets/stylesheets/application.tailwind.css** - Main CSS entry point with Tailwind imports
- **app/assets/stylesheets/better_ui_theme.css** - BetterUi theme configuration (OKLCH colors)
- **app/assets/builds/application.css** - Compiled CSS output (gitignored)

### Demo Pages

The demo application includes the following pages:

- **Home** (`/`) - Overview and getting started
- **Buttons** (`/demos/buttons`) - Button component showcase
- **Cards** (`/demos/cards`) - Card component showcase
- **Alerts** (`/demos/alerts`) - ActionMessages component showcase
- **Forms** (`/demos/forms`) - Form input components showcase

### Key Files

- **app/controllers/demos_controller.rb** - Demo pages controller
- **app/views/demos/** - Demo page views
- **config/routes.rb** - Route definitions
- **Procfile.dev** - Development process configuration

## Customizing the Theme

Edit `app/assets/stylesheets/better_ui_theme.css` to customize:

- Color variants (primary, secondary, accent, success, danger, warning, info, light, dark)
- Typography settings
- Spacing and sizing
- Border radius
- Shadows

The theme uses OKLCH color space for better perceptual uniformity. After making changes, the CSS will be automatically rebuilt if you're running `./bin/dev`.

## Scanning for Tailwind Classes

The application is configured to scan the following directories for Tailwind classes:

- BetterUi engine components: `../../../../app/components/**/*.{rb,erb}`
- BetterUi engine views: `../../../../app/views/**/*.erb`
- Dummy app views: `../../views/**/*.erb`
- Dummy app controllers: `../../controllers/**/*.rb`
- JavaScript files: `../javascript/**/*.js`

This ensures all Tailwind classes used in both the gem and the demo app are included in the compiled CSS.

## Available Components

### Button Component
- 9 color variants (primary, secondary, accent, success, danger, warning, info, light, dark)
- 4 visual styles (solid, outline, ghost, soft)
- 5 sizes (xs, sm, md, lg, xl)
- Loading states and icons
- Disabled state

### Card Component
- 9 color variants
- 5 visual styles (solid, outline, ghost, soft, bordered)
- 5 sizes
- Header, body, and footer slots
- Configurable padding and shadows

### ActionMessages Component
- Display single or multiple messages
- 9 color variants
- 4 visual styles
- Dismissible functionality
- Auto-dismiss timer
- Perfect for flash messages and form validation errors

### Form Components
- TextInputComponent - Text inputs with prefix/suffix icons
- NumberInputComponent - Number inputs with min/max/step
- PasswordInputComponent - Password inputs
- TextareaComponent - Multi-line text areas
- All with labels, hints, errors, and 5 sizes

## Troubleshooting

### CSS not loading

Make sure you've built the CSS at least once:
```bash
yarn build:css
```

### Changes not appearing

If you're using `./bin/dev`, changes should appear automatically. If not, try:
1. Stop the dev server
2. Delete `app/assets/builds/application.css`
3. Run `./bin/dev` again

### Yarn/Node issues

This project uses Yarn 4. Make sure you have:
- Node.js installed
- Run `yarn install` to set up Yarn 4

## Testing Components

All demo pages include code examples showing how to use each component. You can:

1. View the rendered components
2. See the code used to create them
3. Experiment with different configurations
4. Test interactive features (loading states, dismissible alerts, etc.)

## Learn More

- [BetterUi Documentation](../../README.md)
- [Tailwind CSS v4 Documentation](https://tailwindcss.com/docs)
- [ViewComponent Documentation](https://viewcomponent.org/)
- [OKLCH Color Space](https://oklch.com/)
