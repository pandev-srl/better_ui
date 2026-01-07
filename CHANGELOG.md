# Changelog

All notable changes to BetterUi will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- Initial release of BetterUi Rails engine gem
- Rails 8.1+ compatibility with isolated namespace pattern
- Tailwind CSS v4 integration with OKLCH color space support
- ViewComponent-based architecture for all components
- Zeitwerk autoloading configuration
- **ApplicationComponent**: Base component class with VARIANTS constant and CSS class merging utilities
- **ButtonComponent**: Versatile button with 9 color variants, 4 styles (solid, outline, ghost, soft), 5 sizes, loading states, icon slots, and Stimulus controller integration
- **CardComponent**: Flexible container with header/body/footer slots, size variants, border and shadow options
- **ActionMessagesComponent**: Notification system with dismissible alerts, auto-dismiss timer, multiple styles, and Stimulus controller for interactivity
- **Forms::BaseComponent**: Abstract base class for form inputs with common functionality
- **Forms::TextInputComponent**: Text input with validation, hints, errors, icons, and size variants
- **Forms::NumberInputComponent**: Number input with min/max/step validation, optional spinner controls
- **Forms::PasswordInputComponent**: Password field with visibility toggle via Stimulus controller
- **Forms::TextareaComponent**: Multi-line text input with resizable options, rows/cols configuration
- **Forms::CheckboxComponent**: Single checkbox with 9 color variants, label positioning (left/right), hints and validation
- **Forms::CheckboxGroupComponent**: Multiple checkboxes with vertical/horizontal orientation, fieldset legend, and collection support
- **Drawer::LayoutComponent**: Responsive page layout with header, sidebar, and main content area; mobile drawer support via Stimulus controller
- **Drawer::HeaderComponent**: Sticky header with slots for logo, navigation, actions, and mobile menu button; 4 variants (light, dark, transparent, primary)
- **Drawer::SidebarComponent**: Responsive sidebar with header, navigation, and footer slots; configurable width (sm, md, lg) and position (left, right)
- **Drawer::NavItemComponent**: Navigation item with icon and badge slots, active state styling, HTTP method support for logout links
- **Drawer::NavGroupComponent**: Grouped navigation items with optional title, automatic variant inheritance
- **UiFormBuilder**: Custom Rails form builder integrating all form components
- Theme system with 9 semantic color variants and OKLCH color space
- Stimulus controllers for button, password input, action messages, and drawer layout
- `better_ui:install` generator for initial setup
- Release scripts (`bin/release_gem`, `bin/release_npm`, `bin/release_all`)

### Changed
- Refactored CSS into modular structure for better customization:
  - `@pandev-srl/better-ui/css` - Full bundle
  - `@pandev-srl/better-ui/theme` - Design tokens only
  - `@pandev-srl/better-ui/typography` - Typography utilities
  - `@pandev-srl/better-ui/utilities` - General utilities
