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

```erb
<!-- In your views -->
<%= render BetterUi::ButtonComponent.new(
  label: "Get Started",
  variant: "primary",
  size: "lg"
) %>
```

## Features

- **Rails 8.1+ Compatible**: Built for modern Rails applications
- **ViewComponent Architecture**: Encapsulated, testable, and reusable components
- **Tailwind CSS v4**: Leverages the latest Tailwind features with OKLCH color space
- **Fully Customizable**: 9 semantic color variants with complete theme control
- **Form Builder Integration**: Seamless integration with Rails forms via `UiFormBuilder`
- **Stimulus Controllers**: Interactive components with built-in JavaScript behaviors
- **Accessible by Default**: ARIA attributes and keyboard navigation support
- **Production Ready**: Battle-tested components with comprehensive documentation

## Installation

For detailed installation and configuration instructions, see the [Installation Guide](doc/INSTALLATION.md).

### Prerequisites

- Rails 8.1.1 or higher
- Node.js and npm (for Tailwind CSS)
- Tailwind CSS v4 (currently in beta)

## Component Overview

### Core Components

#### Button Component
A versatile button component with multiple styles, sizes, and states.
- **Variants**: primary, secondary, accent, success, danger, warning, info, light, dark
- **Styles**: solid, outline, ghost, soft
- **Sizes**: xs, sm, md, lg, xl
- **Features**: Loading states, icons, disabled states

```erb
<%= render BetterUi::ButtonComponent.new(
  label: "Save Changes",
  variant: "success",
  style: "solid"
) do |c| %>
  <% c.with_icon_before { "💾" } %>
<% end %>
```

#### Card Component
A flexible container component with customizable padding and optional slots.
- **Slots**: header, body, footer
- **Sizes**: sm, md, lg, xl
- **Styles**: Default, bordered, shadow variations

```erb
<%= render BetterUi::CardComponent.new(size: "lg") do |c| %>
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
<%= render BetterUi::ActionMessagesComponent.new(
  variant: "danger",
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
<%= render BetterUi::Forms::TextInputComponent.new(
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
<%= render BetterUi::Forms::NumberInputComponent.new(
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
<%= render BetterUi::Forms::PasswordInputComponent.new(
  name: "user[password]",
  label: "Password",
  hint: "Minimum 8 characters"
) %>
```

#### Textarea Component
Multi-line text input with resizing options.

```erb
<%= render BetterUi::Forms::TextareaComponent.new(
  name: "post[content]",
  label: "Content",
  rows: 6,
  resize: "vertical",
  maxlength: 1000
) %>
```

### Form Builder Integration

BetterUi includes a custom form builder for seamless Rails form integration:

```erb
<%= form_with model: @user, builder: BetterUi::UiFormBuilder do |f| %>
  <%= f.ui_text_input :name %>
  <%= f.ui_text_input :email, hint: "We'll never share your email" %>
  <%= f.ui_password_input :password %>
  <%= f.ui_textarea :bio, rows: 6 %>
  <%= f.ui_number_input :age, min: 0, max: 120 %>
<% end %>
```

## Documentation

- [**Installation Guide**](doc/INSTALLATION.md) - Detailed setup and configuration instructions
- [**Component API Reference**](doc/COMPONENTS.md) - Complete component documentation with examples
- [**Customization Guide**](doc/CUSTOMIZATION.md) - Theme customization and extending components
- [**Changelog**](CHANGELOG.md) - Version history and release notes

## Development Setup

For development and testing, BetterUi includes a dummy Rails application:

```bash
# Clone the repository
git clone https://github.com/umbertopeserico/better_ui.git
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

For bug reports and feature requests, please use the [GitHub Issues](https://github.com/umbertopeserico/better_ui/issues) page.

For questions and discussions, use the [GitHub Discussions](https://github.com/umbertopeserico/better_ui/discussions) forum.

## License

BetterUi is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Credits

Built with ❤️ by [Umberto Peserico](https://github.com/umbertopeserico) and contributors.

Powered by:
- [ViewComponent](https://viewcomponent.org/) - GitHub's component framework for Rails
- [Tailwind CSS](https://tailwindcss.com/) - A utility-first CSS framework
- [Stimulus](https://stimulus.hotwired.dev/) - A modest JavaScript framework for Rails

## Acknowledgments

Special thanks to the Ruby on Rails community and all contributors who help make BetterUi better.