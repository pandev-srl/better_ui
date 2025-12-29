# Changelog

All notable changes to BetterUi will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Changed
- Refactored CSS into modular structure for better customization:
  - `@pandev-srl/better-ui/css` - Full bundle (unchanged)
  - `@pandev-srl/better-ui/theme` - Design tokens only (@theme inline)
  - `@pandev-srl/better-ui/typography` - Typography utilities (.text-heading-*)
  - `@pandev-srl/better-ui/utilities` - General utilities (no-spinner, focus-ring, glass)

### Added
- Initial release of BetterUi Rails engine gem
- Rails 8.1+ compatibility with isolated namespace pattern
- Tailwind CSS v4 integration with OKLCH color space support
- ViewComponent-based architecture for all components
- Zeitwerk autoloading configuration

### Core Components
- **ApplicationComponent**: Base component class with VARIANTS constant and CSS class merging utilities
- **ButtonComponent**: Versatile button with 9 color variants, 4 styles (solid, outline, ghost, soft), 5 sizes, loading states, icon slots, and Stimulus controller integration
- **CardComponent**: Flexible container with header/body/footer slots, size variants, border and shadow options
- **ActionMessagesComponent**: Notification system with dismissible alerts, auto-dismiss timer, multiple styles, and Stimulus controller for interactivity

### Form Components
- **Forms::BaseComponent**: Abstract base class for form inputs with common functionality
- **Forms::TextInputComponent**: Text input with validation, hints, errors, icons, and size variants
- **Forms::NumberInputComponent**: Number input with min/max/step validation, optional spinner controls
- **Forms::PasswordInputComponent**: Password field with visibility toggle via Stimulus controller
- **Forms::TextareaComponent**: Multi-line text input with resizable options, rows/cols configuration
- **Forms::CheckboxComponent**: Single checkbox with 9 color variants, label positioning (left/right), hints and validation
- **Forms::CheckboxGroupComponent**: Multiple checkboxes with vertical/horizontal orientation, fieldset legend, and collection support

### Drawer Components
- **Drawer::LayoutComponent**: Responsive page layout with header, sidebar, and main content area; mobile drawer support via Stimulus controller
- **Drawer::HeaderComponent**: Sticky header with slots for logo, navigation, actions, and mobile menu button; 4 variants (light, dark, transparent, primary)
- **Drawer::SidebarComponent**: Responsive sidebar with header, navigation, and footer slots; configurable width (sm, md, lg) and position (left, right)
- **Drawer::NavItemComponent**: Navigation item with icon and badge slots, active state styling, HTTP method support for logout links
- **Drawer::NavGroupComponent**: Grouped navigation items with optional title, automatic variant inheritance

### Form Builder
- **UiFormBuilder**: Custom Rails form builder integrating all form components
  - `ui_text_input`, `ui_number_input`, `ui_password_input`, `ui_textarea`
  - `bui_checkbox`, `bui_checkbox_group`
  - Automatic value population from models
  - Validation error display
  - Required field detection from model validators
  - Support for nested attributes
  - Icon slots integration

### Theme System
- 9 semantic color variants (primary, secondary, accent, success, danger, warning, info, light, dark)
- Complete color scales with 11 shades per variant (50-950)
- OKLCH color space for perceptually uniform colors
- Typography tokens for sans, serif, and mono font families
- Spacing scale tokens
- Border radius scale
- Shadow utilities
- Glass morphism effects

### Installation Generator
- `better_ui:install` generator creating:
  - Theme configuration file (`better_ui_theme.css`)
  - Application stylesheet setup with Tailwind v4 @source directives
  - Automatic vendor/bundle scanning for component styles

### Stimulus Controllers
- `better-ui--button`: Loading states and click handling
- `better-ui--forms--password-input`: Password visibility toggle
- `better-ui--action-messages`: Dismiss and auto-dismiss functionality
- `better-ui--drawer--layout`: Mobile drawer toggle, overlay handling, responsive behavior

### Developer Tools
- Helper methods for debugging:
  - `BetterUi.template_paths`: Returns component template paths
  - `BetterUi.root`: Returns gem root path
- Comprehensive test suite using Rails dummy application
- RuboCop integration with Omakase Ruby styling

### Documentation
- Comprehensive README with quick start guide
- Detailed installation guide with troubleshooting
- Complete component API reference
- Theme customization guide with OKLCH examples
- Inline code documentation with YARD annotations

## [0.1.0] - Unreleased

### Note
This is the initial pre-release version. The gem is under active development and the API may change before the official 0.1.0 release.

### Known Issues
- Components require Tailwind CSS v4 (currently in beta)
- Host application must properly configure PostCSS with Tailwind
- Theme file must be imported after Tailwind base

### Upcoming Features
- Additional form components (select, radio)
- Modal and dialog components
- Data table component
- Toast notification system
- Enhanced accessibility features
- Dark mode improvements

---

For more information, see the [GitHub repository](https://github.com/umbertopeserico/better_ui).