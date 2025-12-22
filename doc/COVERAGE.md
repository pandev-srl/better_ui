# Test Coverage

BetterUi uses [SimpleCov](https://github.com/simplecov-ruby/simplecov) to track test coverage.

## Current Coverage

**Line Coverage: 100% (895 / 895 lines)**

### Coverage by Group

- **Components**: ViewComponent classes (Button, Card, ActionMessages, Forms)
- **Form Builders**: Rails form builder integration
- **Lib**: Engine configuration and utilities

## Running Tests with Coverage

To generate a coverage report:

```bash
bundle exec rake test
```

The coverage report will be generated in the `coverage/` directory.

## Viewing Coverage Report

Open the HTML report in your browser:

```bash
open coverage/index.html
```

Or on Linux:

```bash
xdg-open coverage/index.html
```

## Coverage Configuration

SimpleCov is configured in `test/test_helper.rb` with the following settings:

- **Minimum Coverage**: 75%
- **Filters**: Excludes test files, specs, config, and vendor directories
- **Groups**: Organized by Components, Form Builders, and Lib

## Maintaining Coverage

To maintain 100% test coverage:

1. Run tests and review the HTML report before submitting changes
2. Write tests first (TDD) when adding new components or features
3. Ensure all edge cases and error paths are covered
4. Keep coverage at 100% - never merge code that reduces coverage

## CI/CD Integration

In your CI/CD pipeline, you can fail builds if coverage drops below the threshold:

```bash
bundle exec rake test
# SimpleCov will exit with status 2 if coverage is below minimum
```

## Notes

- Coverage is calculated only for Ruby files (`.rb`)
- JavaScript files are not included in coverage metrics
- The `coverage/` directory is ignored by git (see `.gitignore`)
- Running individual test files will show lower coverage than running the full suite
