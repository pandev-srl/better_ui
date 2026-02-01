# BetterUi

A modern Rails UI component library built with ViewComponent and Tailwind CSS v4. BetterUi provides a comprehensive set of customizable, accessible, and production-ready components for Rails applications.

## Important: Dual Distribution

BetterUi uses a **dual distribution model**:
- **Ruby gem** (`better_ui`) - ViewComponents for Rails
- **npm package** (`@pandev-srl/better-ui`) - JavaScript (Stimulus controllers) and CSS (theme)

Your Rails application must install both. See [Installation Guide](doc/INSTALLATION.md) for detailed setup instructions.

## Quick Start

```ruby
# Gemfile
gem "better_ui"
```

```bash
bundle install
yarn add @pandev-srl/better-ui
```

**JavaScript** (app/javascript/application.js):
```javascript
import { Application } from "@hotwired/stimulus"
import { registerControllers } from "@pandev-srl/better-ui"

const application = Application.start()
registerControllers(application)
```

**CSS** (app/assets/stylesheets/application.css):
```css
/* Full bundle (recommended) */
@import "@pandev-srl/better-ui/css";
@source "../../../vendor/bundle/**/*.{rb,erb}";

/* Or import individual modules for customization */
/* @import "tailwindcss"; */
/* @import "@pandev-srl/better-ui/theme"; */
/* @import "@pandev-srl/better-ui/typography"; */
/* @import "@pandev-srl/better-ui/utilities"; */
```

**Start using components** - `bui_*` helpers are available automatically:
```erb
<%= bui_button(label: "Get Started", variant: :primary, size: :lg) %>
```

## Features

- **Rails 8.1+ Compatible**: Built for modern Rails applications
- **ViewComponent Architecture**: Encapsulated, testable, and reusable components
- **Tailwind CSS v4**: Leverages the latest Tailwind features with OKLCH color space
- **Fully Customizable**: 9 semantic color variants with complete theme control
- **View Helpers**: Concise `bui_*` helpers available automatically (no setup required)
- **Form Builder Integration**: Seamless integration with Rails forms via `UiFormBuilder`
- **Stimulus Controllers**: Interactive components with built-in JavaScript behaviors
- **Accessible by Default**: ARIA attributes and keyboard navigation support
- **Production Ready**: Battle-tested components with comprehensive documentation

## Installation

For detailed installation and configuration instructions, see the [Installation Guide](doc/INSTALLATION.md).

### Prerequisites

- Rails 8.1.1 or higher
- Node.js and npm (for Tailwind CSS)
- Tailwind CSS v4

## Component Overview

### Core Components

#### Button Component
A versatile button component with multiple styles, sizes, and states.
- **Variants**: primary, secondary, accent, success, danger, warning, info, light, dark
- **Styles**: solid, outline, ghost, soft
- **Sizes**: xs, sm, md, lg, xl
- **Features**: Loading states, icons, disabled states

```erb
<%= bui_button(label: "Save Changes", variant: :success, style: :solid) do |c| %>
  <% c.with_icon_before { "💾" } %>
<% end %>
```

#### Card Component
A flexible container component with customizable padding and optional slots.
- **Variants**: primary, secondary, accent, success, danger, warning, info, light, dark
- **Styles**: solid, outline, ghost, soft, bordered
- **Sizes**: xs, sm, md, lg, xl
- **Slots**: header, body, footer

```erb
<%= bui_card(size: :lg, style: :bordered) do |c| %>
  <% c.with_header { "Card Title" } %>
  <% c.with_body { "Card content goes here" } %>
  <% c.with_footer { "Footer content" } %>
<% end %>
```

#### Action Messages Component
Display notifications, alerts, and validation messages with style.
- **Variants**: All 9 semantic color variants
- **Styles**: solid, soft, outline, ghost
- **Features**: Dismissible, auto-dismiss, titles, icons

```erb
<%= bui_action_messages(
  variant: :danger,
  title: "Validation Errors",
  messages: @model.errors.full_messages,
  dismissible: true,
  auto_dismiss: 10
) %>
```

### Form Components

#### Text Input Component
Standard text input with error handling and icon support.

```erb
<%= bui_text_input(
  name: "user[email]",
  label: "Email Address",
  hint: "We'll never share your email",
  placeholder: "you@example.com"
) do |c| %>
  <% c.with_prefix_icon { "@" } %>
<% end %>
```

#### Number Input Component
Numeric input with min/max validation and optional spinners.

```erb
<%= bui_number_input(
  name: "product[price]",
  label: "Price",
  min: 0,
  step: 0.01,
  show_spinner: false
) do |c| %>
  <% c.with_prefix_icon { "$" } %>
<% end %>
```

#### Password Input Component
Password field with visibility toggle functionality.

```erb
<%= bui_password_input(
  name: "user[password]",
  label: "Password",
  hint: "Minimum 8 characters"
) %>
```

#### Textarea Component
Multi-line text input with resizing options.

```erb
<%= bui_textarea(
  name: "post[content]",
  label: "Content",
  rows: 6,
  resize: :vertical,
  maxlength: 1000
) %>
```

#### Checkbox Component
Single checkbox with color variants and label positioning.

```erb
<%= bui_checkbox(
  name: "user[terms]",
  label: "I agree to the terms and conditions",
  variant: :primary
) %>
```

#### Checkbox Group Component
Multiple checkboxes for selecting from a collection.

```erb
<%= bui_checkbox_group(
  name: "user[roles]",
  collection: [["Admin", "admin"], ["Editor", "editor"]],
  legend: "User Roles",
  orientation: :vertical
) %>
```

### Drawer Layout Components

BetterUi provides a complete drawer layout system for building responsive admin dashboards and applications with sidebar navigation.

- **LayoutComponent**: Main wrapper with header, sidebar, and content
- **HeaderComponent**: Sticky header with logo, navigation, and actions
- **SidebarComponent**: Responsive sidebar with navigation
- **NavItemComponent**: Navigation items with icons and badges
- **NavGroupComponent**: Grouped navigation with titles

```erb
<%= bui_drawer_layout do |layout| %>
  <% layout.with_header do |header| %>
    <% header.with_logo { "MyApp" } %>
  <% end %>
  <% layout.with_sidebar do |sidebar| %>
    <% sidebar.with_navigation do %>
      <%= bui_drawer_nav_group(title: "Menu") do |group| %>
        <% group.with_item(label: "Dashboard", href: "/", active: true) %>
        <% group.with_item(label: "Settings", href: "/settings") %>
      <% end %>
    <% end %>
  <% end %>
  <% layout.with_main { yield } %>
<% end %>
```

### Form Builder Integration

BetterUi includes a custom form builder for seamless Rails form integration:

```erb
<%= form_with model: @user, builder: BetterUi::UiFormBuilder do |f| %>
  <%= f.bui_text_input :name %>
  <%= f.bui_text_input :email, hint: "We'll never share your email" %>
  <%= f.bui_password_input :password %>
  <%= f.bui_textarea :bio, rows: 6 %>
  <%= f.bui_number_input :age, min: 0, max: 120 %>
  <%= f.bui_select :role, [["Admin", "admin"], ["Editor", "editor"]] %>
  <%= f.bui_checkbox :newsletter, label: "Subscribe to newsletter" %>
  <%= f.bui_checkbox_group :roles, [["Admin", "admin"], ["Editor", "editor"]] %>
<% end %>
```

## Available View Helpers

### Core Components

| Helper | Component |
|--------|-----------|
| `bui_button` | ButtonComponent |
| `bui_link` | LinkComponent |
| `bui_card` | CardComponent |
| `bui_action_messages` | ActionMessagesComponent |
| `bui_avatar` | AvatarComponent |
| `bui_badge` | BadgeComponent |
| `bui_tag` | TagComponent |
| `bui_heading` | HeadingComponent |
| `bui_spinner` | SpinnerComponent |
| `bui_progress` | ProgressComponent |
| `bui_divider` | DividerComponent |
| `bui_tooltip` | TooltipComponent |
| `bui_container` | ContainerComponent |
| `bui_fa_icon` | FaIconComponent |
| `bui_breadcrumb` | Breadcrumb::BreadcrumbComponent |

### Form Components

| Helper | Component |
|--------|-----------|
| `bui_text_input` | Forms::TextInputComponent |
| `bui_email_input` | Forms::TextInputComponent (type: :email) |
| `bui_tel_input` | Forms::TextInputComponent (type: :tel) |
| `bui_date_input` | Forms::TextInputComponent (type: :date) |
| `bui_time_input` | Forms::TextInputComponent (type: :time) |
| `bui_number_input` | Forms::NumberInputComponent |
| `bui_password_input` | Forms::PasswordInputComponent |
| `bui_textarea` | Forms::TextareaComponent |
| `bui_checkbox` | Forms::CheckboxComponent |
| `bui_checkbox_group` | Forms::CheckboxGroupComponent |
| `bui_select` | Forms::SelectComponent |

### Layout & Navigation

| Helper | Component |
|--------|-----------|
| `bui_drawer_layout` | Drawer::LayoutComponent |
| `bui_drawer_sidebar` | Drawer::SidebarComponent |
| `bui_drawer_header` | Drawer::HeaderComponent |
| `bui_drawer_nav_item` | Drawer::NavItemComponent |
| `bui_drawer_nav_group` | Drawer::NavGroupComponent |

### Interactive Components

| Helper | Component |
|--------|-----------|
| `bui_dialog` | Dialog::DialogComponent |
| `bui_dialog_alert` | Dialog::AlertComponent |
| `bui_dialog_confirm` | Dialog::ConfirmComponent |
| `bui_dropdown` | Dropdown::DropdownComponent |
| `bui_tabs` | Tabs::ContainerComponent |
| `bui_tab` | Tabs::TabComponent |
| `bui_tab_panel` | Tabs::PanelComponent |
| `bui_table` | Table::TableComponent |

> **Note**: You can also use ViewComponent directly with `render BetterUi::*Component.new(...)` if you prefer the explicit rendering syntax.

## Documentation

- [**Installation Guide**](doc/INSTALLATION.md) - Detailed setup and configuration instructions
- [**Component API Reference**](doc/COMPONENTS.md) - Complete component documentation with examples
- [**Customization Guide**](doc/CUSTOMIZATION.md) - Theme customization and extending components
- [**Changelog**](CHANGELOG.md) - Version history and release notes

## Development Setup

For development and testing, BetterUi includes a dummy Rails application:

```bash
# Clone the repository
git clone https://github.com/pandev-srl/better_ui.git
cd better_ui

# Install dependencies
bundle install

# Run tests
bundle exec rake test

# Start the dummy app server
cd test/dummy
bundle exec rails server
```

Visit `http://localhost:3000` to see the components in action.

### Running Tests

```bash
# Run all tests
bundle exec rake test

# Run specific test file
bundle exec ruby -Itest test/components/better_ui/button_component_test.rb

# Run with coverage
COVERAGE=true bundle exec rake test
```

### Code Style

BetterUi follows Omakase Ruby styling via `rubocop-rails-omakase`:

```bash
# Run linter
bundle exec rubocop

# Auto-fix issues
bundle exec rubocop -a
```

## Contributing

We welcome contributions! Please follow these guidelines:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Write tests for your changes
4. Ensure all tests pass and code follows style guide
5. Commit your changes with conventional commits (`feat: add amazing feature`)
6. Push to the branch (`git push origin feature/amazing-feature`)
7. Open a Pull Request

### Contribution Areas

- New components
- Component enhancements
- Documentation improvements
- Bug fixes
- Performance optimizations
- Accessibility improvements

## Support

For bug reports and feature requests, please use the [GitHub Issues](https://github.com/pandev-srl/better_ui/issues) page.

For questions and discussions, use the [GitHub Discussions](https://github.com/pandev-srl/better_ui/discussions) forum.

## License

BetterUi is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Credits

Built with ❤️ by [Umberto Peserico](https://github.com/umbertopeserico) and [Alessio Bussolari](https://github.com/alessiobussolari).

Powered by:
- [ViewComponent](https://viewcomponent.org/) - GitHub's component framework for Rails
- [Tailwind CSS](https://tailwindcss.com/) - A utility-first CSS framework
- [Stimulus](https://stimulus.hotwired.dev/) - A modest JavaScript framework for Rails

## Acknowledgments

Special thanks to the Ruby on Rails community and all contributors who help make BetterUi better.
