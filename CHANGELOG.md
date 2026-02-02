# Changelog

All notable changes to BetterUi will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [0.10.0] - 2026-02-02

### Added
- **Pagination::PaginationComponent**: Framework-agnostic pagination with page windowing and gap collapsing algorithm
  - 4 visual styles (solid, outline, ghost, soft), 9 color variants, 5 sizes, 5 border-radius options, and shadow support
  - First/last and prev/next navigation with inline SVG icons or custom text labels
  - Configurable page window size with smart gap collapsing (single hidden pages are shown instead of ellipsis)
  - Info slot and auto-generated "Showing X-Y of Z results" text via `per_page`/`total_count` parameters
  - Full accessibility: `aria-current`, `aria-disabled`, `aria-hidden`, `rel="prev"`/`rel="next"`, labeled navigation
  - `bui_pagination` view helper for manual configuration
  - `bui_pagination_for` convenience helper for Pagy gem integration (extracts page, count, and URL automatically)
  - Input validation with descriptive error messages for all parameters
  - Renders nothing when `total_pages <= 1`
  - 88 tests and Lookbook previews
- **Table::TableComponent**: `row_html` option for per-row HTML attribute customization in collection mode
  - Accepts a proc/lambda receiving `(item)` or `(item, index)` that returns a Hash of HTML attributes
  - Custom CSS classes are merged with built-in striped/hoverable/highlighted classes via TailwindMerge
  - Supports `class`, `id`, `data-*`, `aria-*`, and any other HTML attributes
  - Returns nil for no-op; raises `ArgumentError` on non-Hash returns
  - Ignored when `body_row_partial` is set (partial takes precedence)

### Documentation
- Added live demo link to README ([better-ui.pandev.it](https://better-ui.pandev.it))

## [0.9.1] - 2026-02-01

### Fixed
- **Gemspec**: Include `spec/components/previews` in packaged gem files, so Lookbook previews are available to host applications

## [0.9.0] - 2026-02-01

### Added
- **Dialog::DialogComponent**: Modal dialog with configurable size (sm/md/lg/xl/full), backdrop/escape close, optional close button, focus trap, and Stimulus controller (`better-ui--dialog--dialog`)
- **Dialog::AlertComponent**: Alert dialog with variant-based icon, title, message, and OK button
- **Dialog::ConfirmComponent**: Confirmation dialog with cancel/confirm buttons, destructive action support, and custom events
- **Table::TableComponent**: Dual-mode table (slot-based and collection-based) with card-style design, colspan/rowspan support, empty state, and inside-card rendering
- **Table::HeaderComponent**: Table header row with cell slots
- **Table::HeaderCellComponent**: Header cell with scope attribute, sortable option, and sort direction indicator
- **Table::RowComponent**: Table body row with striped, hoverable, and highlighted options
- **Table::CellComponent**: Standard table data cell with alignment and sizing
- **Table::ColumnComponent**: Column configuration for collection-based table mode
- **Dropdown::DropdownComponent**: Composable dropdown menu with keyboard navigation, auto-close, placement options (top/bottom/left/right), and Stimulus controller (`better-ui--dropdown--dropdown`)
- **Dropdown::ItemComponent**: Dropdown menu item with icon slot, link/button modes, and danger variant
- **Dropdown::DividerComponent**: Visual separator for dropdown menus
- **Dropdown::HeaderComponent**: Non-interactive header text for dropdown sections
- **AvatarComponent**: User avatar with image or initials fallback, 3 shapes (circle, square, rounded), 5 sizes, status indicator (online, offline, busy, away), and badge slot
- **BadgeComponent**: Inline label with dot/counter modes, 4 styles (solid, outline, soft, ghost), 4 sizes, pill option, and icon slot; uses `InlineLabelStyles` concern
- **TagComponent**: Dismissible label with 3 styles (solid, outline, soft), link mode, icon slot, and Stimulus controller (`better-ui--tag`)
- **LinkComponent**: Styled anchor with 3 styles (default, underline, ghost), icon slots, disabled state, and target/rel handling
- **HeadingComponent**: Semantic heading (h1-h6) with subtitle, divider, color variants, alignment, and actions slot
- **SpinnerComponent**: Loading indicator with color variants, 5 sizes, and optional label
- **ProgressComponent**: Percentage progress bar with label, value display, animation, and color variants
- **DividerComponent**: Horizontal/vertical separator with 3 styles (solid, dashed, dotted), optional label, and configurable spacing
- **ContainerComponent**: Responsive max-width container with 5 sizes (sm, md, lg, xl, full), padding, and centering options
- **FaIconComponent**: FontAwesome icon wrapper with spin, pulse, flip, rotate, fixed-width, and size options
- **Breadcrumb::BreadcrumbComponent**: Breadcrumb navigation with 3 separator types (slash, chevron, dot) and size variants
- **Breadcrumb::ItemComponent**: Breadcrumb item with label, href, and optional icon
- **Concerns::InlineLabelStyles**: Shared concern for Badge and Tag inline label styling
- **Forms::SelectComponent**: Custom select dropdown with keyboard navigation, type-ahead search, clearable option, ARIA support, and Stimulus controller (`better-ui--forms--select`)
- **Forms::TextInputComponent**: Added configurable input types (`:email`, `:tel`, `:date`, `:time`) with corresponding `bui_email_input`, `bui_tel_input`, `bui_date_input`, `bui_time_input` view helpers
- **Table enhancements**: Added scope attribute on header cells, configurable rounded borders (none/sm/md/lg/xl/full), row highlighting, sortable headers with sort direction indicator, and partials system for header/row/footer customization
- **Tooltip Stimulus controller** (`better-ui--tooltip`): Fixed positioning with viewport boundary detection and automatic flipping to escape overflow clipping
- **Tag Stimulus controller** (`better-ui--tag`): Dismissible tags with shared fade-out animation via `utils/dismiss.js`
- **Dismiss utility** (`utils/dismiss.js`): Shared fade-out dismiss animation used by ActionMessages and Tag controllers
- **`bui_*` view helpers**: Added helpers for all new components — `bui_dialog`, `bui_dialog_alert`, `bui_dialog_confirm`, `bui_table`, `bui_dropdown`, `bui_avatar`, `bui_badge`, `bui_tag`, `bui_link`, `bui_heading`, `bui_spinner`, `bui_progress`, `bui_divider`, `bui_container`, `bui_fa_icon`, `bui_breadcrumb`, `bui_tooltip`, `bui_select`, `bui_email_input`, `bui_tel_input`, `bui_date_input`, `bui_time_input`
- **Lookbook previews** for all new components with multiple variants, sizes, styles, and interactive examples
- **Test coverage** for all new components and form builder integration

### Changed
- **ApplicationComponent**: Added unified `SHADOWS` constant (none/sm/md/lg/xl) for consistent shadow parameter across all components
- **CardComponent**: Bordered style is now variant-specific with default `:light`, producing colored borders per variant
- **Table::TableComponent**: Hoverable and bordered styles are now variant-aware, applying variant-specific colors
- **Gemspec**: Updated description to reference Tailwind CSS v4 (removed outdated BEM methodology reference)

### Fixed
- **TooltipComponent**: Replaced CSS-only positioning with Stimulus controller using fixed positioning to properly escape overflow clipping in scrollable containers
- **Lookbook previews**: Removed trailing text in `@param` annotations that broke Lookbook variant select dropdowns (ActionMessages, Badge, Button, Link previews)
- **Table tests**: Aligned assertions with bordered style and header size changes

### Documentation
- Added comprehensive documentation for Dialog, Table, Dropdown, and all 13 migrated general components
- Updated all existing component docs to use `bui_*` helper syntax
- Added COMPONENT_COMPARISON.md documenting old vs new component architecture
- Fixed inconsistencies across README, INSTALLATION.md, CLAUDE.md, and gemspec (helper counts, controller lists, component hierarchy, method names)

## [0.8.0] - 2026-01-30

### Added
- **Tabs::ContainerComponent**: Flexible tabs container with two operating modes:
  - **JS mode**: Client-side tab switching with all content rendered in DOM
  - **Turbo mode**: Server-rendered content via Turbo Frames with animated loader overlay
  - 3 styles (underline, pills, bordered), 5 sizes, 9 color variants
  - Horizontal and vertical (left/right) orientations
  - Tab alignment (start, center, end, stretch)
  - Custom loader content via `loader` slot
- **Tabs::TabComponent**: Individual tab with icon, badge, and disabled state support
- **Tabs::PanelComponent**: Tab panel with lazy-loading support for Turbo mode
- **Tabs Stimulus controller** (`better-ui--tabs--container`): Handles tab switching, keyboard navigation, Turbo Frame loading, and loader state management
- **Lookbook previews** for Tabs component: default, Turbo mode, all styles (underline/pills/bordered), sizes, variants, alignments, vertical positions, icons/badges, and disabled states
- **View helpers auto-inclusion**: `bui_*` helpers are now automatically available in all views without manual `include` — handled by new `better_ui.helpers` engine initializer
- **`bui_tabs` helper**: Render Tabs component via `bui_tabs` view helper

### Changed
- **Drawer::SidebarComponent**: Navigation wrapper now applies `space-y-6` vertical spacing between NavGroupComponents automatically, removing the need for manual spacing wrappers in views

### Documentation
- README rewritten to use `bui_*` helper syntax in all examples
- INSTALLATION.md updated to document helper auto-inclusion
- Added MIGRATION_STATUS.md documenting component migration progress

## [0.7.2] - 2026-01-16

### Added
- **Grayscale color variant**: Added `grayscale` utility colors (50-950 shades) for neutral elements like borders, dividers, and disabled states

### Changed
- **Install generator**: `copy_theme` option now defaults to `true` - theme file is copied by default for easier customization. Use `--no-copy-theme` to skip.
- **Theme template**: `better_ui_theme.css.tt` now contains only design tokens (CSS custom properties). Utility classes moved to separate `typography` and `utilities` modules.

## [0.7.1] - 2026-01-15

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
