# SimpleCov must be loaded before anything else for accurate coverage
require "simplecov"
SimpleCov.start "rails" do
  # Cover all code in the lib and app directories
  add_filter "/test/"
  add_filter "/spec/"
  add_filter "/config/"
  add_filter "/db/"
  add_filter "/vendor/"

  # Filter out non-Ruby files
  add_filter do |source_file|
    !source_file.filename.end_with?('.rb')
  end

  # Group coverage results for better organization
  add_group "Components", "app/components"
  add_group "Form Builders", "app/form_builders"
  add_group "Lib", "lib/better_ui"

  # Set minimum coverage expectation
  # Note: Running individual test files will have lower coverage
  # Run all tests together for accurate coverage: bundle exec rake test
  minimum_coverage 75
end

# Configure Rails Environment
ENV["RAILS_ENV"] = "test"

require_relative "../test/dummy/config/environment"
require "rails/test_help"

# Require view_component and test helpers
require "view_component"
require "view_component/test_helpers"

# Require tailwind_merge for CSS class merging
require "tailwind_merge"

# Include ViewComponent test helpers in all test cases
module ActiveSupport
  class TestCase
  include ViewComponent::TestHelpers

  # Helper method to access rendered content as HTML string
  def rendered_html
    @rendered_content
  end

  # Custom assertion helpers for testing rendered HTML
  def assert_selector(selector, text: nil, count: nil, **options)
    html_doc = Nokogiri::HTML.fragment(rendered_html)
    elements = html_doc.css(selector)

    if count
      assert_equal count, elements.count,
        "Expected to find #{count} elements matching '#{selector}' but found #{elements.count}"
    else
      assert elements.any?, "Expected to find element matching '#{selector}' but found none"
    end

    if text
      assert elements.any? { |el| el.text.include?(text) },
        "Expected to find element matching '#{selector}' with text '#{text}'"
    end
  end

  def refute_selector(selector, **options)
    html_doc = Nokogiri::HTML.fragment(rendered_html)
    elements = html_doc.css(selector)

    assert elements.empty?, "Expected not to find element matching '#{selector}' but found #{elements.count}"
  end

  def assert_text(text)
    html_doc = Nokogiri::HTML.fragment(rendered_html)
    actual_text = html_doc.text
    assert actual_text.include?(text), "Expected to find text '#{text}' in rendered output"
  end

  def has_css?(selector)
    html_doc = Nokogiri::HTML.fragment(rendered_html)
    html_doc.css(selector).any?
  end
  end
end
