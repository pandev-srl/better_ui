# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

BetterUi is a Rails engine gem (Rails 8.1.1+) that provides UI components and functionality to Rails applications. It follows the isolated namespace pattern with `BetterUi::Engine` inheriting from `::Rails::Engine` with `isolate_namespace BetterUi`.

## Development Commands

### Setup
```bash
bundle install
```

### Testing
```bash
# Run all tests
bundle exec rake test

# Run specific test file
bundle exec ruby -Itest test/path/to/test_file.rb

# Run specific test
bundle exec ruby -Itest test/path/to/test_file.rb -n test_method_name
```

### Linting
```bash
# Run RuboCop with Omakase Ruby styling
bundle exec rubocop

# Auto-correct offenses
bundle exec rubocop -a
```

### Development Server
The gem includes a dummy Rails app in `test/dummy/` for development:
```bash
cd test/dummy
bundle exec rails server
```

## Architecture

### Engine Structure
- **Engine Definition**: `lib/better_ui/engine.rb` - defines the isolated Rails engine
- **Main Module**: `lib/better_ui.rb` - entry point that requires version and engine
- **Version**: `lib/better_ui/version.rb` - gem version constant

### MVC Components
All application components are namespaced under `BetterUi::`:
- **Controllers**: `app/controllers/better_ui/` - inherit from `BetterUi::ApplicationController`
- **Models**: `app/models/better_ui/` - inherit from `BetterUi::ApplicationRecord`
- **Helpers**: `app/helpers/better_ui/` - namespaced helper modules
- **Views**: `app/views/layouts/better_ui/` - engine-specific layouts
- **Assets**: `app/assets/stylesheets/better_ui/` - CSS assets

### Test Dummy Application
The `test/dummy/` directory contains a minimal Rails application used for testing the engine:
- **Rails Frameworks Loaded**: ActiveModel, ActionController, ActionView, Rails TestUnit
- **Rails Frameworks NOT Loaded**: ActiveJob, ActiveRecord, ActiveStorage, ActionMailer, ActionMailbox, ActionText, ActionCable
- Uses Propshaft for asset pipeline
- Uses Puma as web server

### Routes
Engine routes are defined in `config/routes.rb` within the `BetterUi::Engine.routes.draw` block. When mounted in a host application, these routes are namespaced.

### Code Style
Follows Omakase Ruby styling via `rubocop-rails-omakase` gem. Configuration in `.rubocop.yml` inherits from the omakase base configuration.

## Key Patterns

### Namespace Isolation
All classes, modules, and routes are isolated under the `BetterUi` namespace. When adding new components:
- Controllers inherit from `BetterUi::ApplicationController`
- Models inherit from `BetterUi::ApplicationRecord`
- Use `module BetterUi` wrapper for all engine code

### Test Structure
Tests are organized by type:
- `test/controllers/` - controller tests
- `test/models/` - model tests
- `test/helpers/` - helper tests
- `test/integration/` - integration tests
- `test/fixtures/` - test fixtures
- `test/mailers/` - mailer tests

Test environment is configured via `test/test_helper.rb` which loads the dummy Rails app.
- do commits with standard conventional commit