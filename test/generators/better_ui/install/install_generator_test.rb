# frozen_string_literal: true

require "test_helper"
require "generators/better_ui/install/install_generator"

module BetterUi
  module Generators
    class InstallGeneratorTest < Rails::Generators::TestCase
      tests BetterUi::Generators::InstallGenerator
      destination File.expand_path("../../../../tmp", __dir__)
      setup :prepare_destination

      test "generator creates theme file" do
        run_generator

        assert_file "app/assets/stylesheets/better_ui_theme.css" do |content|
          assert_match(/@theme inline/, content)
          assert_match(/--color-primary-500/, content)
          assert_match(/--color-secondary-500/, content)
          assert_match(/--color-accent-500/, content)
          assert_match(/--color-success-500/, content)
          assert_match(/--color-danger-500/, content)
          assert_match(/--color-warning-500/, content)
          assert_match(/--color-info-500/, content)
          assert_match(/--color-light-500/, content)
          assert_match(/--color-dark-500/, content)
        end
      end

      test "generator creates application.postcss.css with correct imports" do
        run_generator

        assert_file "app/assets/stylesheets/application.postcss.css" do |content|
          assert_match(/@import "tailwindcss"/, content)
          assert_match(/@import "\.\/better_ui_theme\.css"/, content)
          assert_match(/@source "\.\.\/\.\.\/\.\.\/vendor\/bundle\/\*\*\/\*\.{rb,erb}"/, content)
          assert_match(/@source "\.\.\/\.\.\/\*\*\/\*\.{erb,html,rb}"/, content)
          assert_match(/@source "\.\.\/javascript\/\*\*\/\*\.js"/, content)
        end
      end

      test "generator updates existing application.postcss.css" do
        # Create a fake existing application.postcss.css
        FileUtils.mkdir_p(File.join(destination_root, "app/assets/stylesheets"))
        File.write(
          File.join(destination_root, "app/assets/stylesheets/application.postcss.css"),
          "/* Existing content */\n"
        )

        run_generator

        assert_file "app/assets/stylesheets/application.postcss.css" do |content|
          # Check that new imports were prepended
          assert_match(/@import "tailwindcss"/, content)
          assert_match(/@import "\.\/better_ui_theme\.css"/, content)
          assert_match(/@source "\.\.\/\.\.\/\.\.\/vendor\/bundle\/\*\*\/\*\.{rb,erb}"/, content)

          # Check that existing content is preserved
          assert_match(/\/\* Existing content \*\//, content)

          # Check that imports come before existing content
          tailwind_pos = content.index('@import "tailwindcss"')
          existing_pos = content.index("/* Existing content */")
          assert tailwind_pos < existing_pos,
                 "Imports should be prepended before existing content"
        end
      end

      test "generator includes all color variants" do
        run_generator

        assert_file "app/assets/stylesheets/better_ui_theme.css" do |content|
          # Test that all 9 variants exist with their full color scales
          %w[primary secondary accent success danger warning info light dark].each do |variant|
            %w[50 100 200 300 400 500 600 700 800 900 950].each do |scale|
              assert_match(/--color-#{variant}-#{scale}:/, content,
                           "Missing color: #{variant}-#{scale}")
            end
          end
        end
      end

      test "generator includes utility classes" do
        run_generator

        assert_file "app/assets/stylesheets/better_ui_theme.css" do |content|
          assert_match(/\.text-heading-primary/, content)
          assert_match(/\.no-spinner/, content)
          assert_match(/\.focus-ring/, content)
          assert_match(/\.glass/, content)
        end
      end

      test "generator includes typography tokens" do
        run_generator

        assert_file "app/assets/stylesheets/better_ui_theme.css" do |content|
          assert_match(/--font-family-sans:/, content)
          assert_match(/--font-family-serif:/, content)
          assert_match(/--font-family-mono:/, content)
        end
      end

      test "theme file uses OKLCH color space" do
        run_generator

        assert_file "app/assets/stylesheets/better_ui_theme.css" do |content|
          # Check that colors are defined using OKLCH format
          assert_match(/oklch\(\d+\.\d+ \d+\.\d+ \d+\)/, content)
        end
      end
    end
  end
end
