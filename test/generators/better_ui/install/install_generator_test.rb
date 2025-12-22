# frozen_string_literal: true

require "test_helper"
require "generators/better_ui/install/install_generator"

module BetterUi
  module Generators
    class InstallGeneratorTest < Rails::Generators::TestCase
      tests BetterUi::Generators::InstallGenerator
      destination File.expand_path("../../../../tmp", __dir__)
      setup :prepare_destination

      # Stub package manager commands to prevent actual execution
      # This prevents npm/yarn/pnpm from creating lock files during tests
      def run_generator(args = [], config = {})
        @captured_commands = []
        test_instance = self

        # Create a module to intercept the run method
        stub_module = Module.new do
          define_method(:run) do |command, options = {}|
            test_instance.instance_variable_get(:@captured_commands) << command
            say_status :run, command, :green
            true
          end
        end

        # Prepend the stub module
        BetterUi::Generators::InstallGenerator.prepend(stub_module)

        super
      end

      attr_reader :captured_commands

      test "generator installs npm package via npm by default" do
        # Create destination without yarn.lock or pnpm-lock.yaml
        FileUtils.mkdir_p(destination_root)

        output = run_generator

        # Generator should attempt to run npm install
        assert_match(/Installing @pandev-srl\/better-ui/, output)
        assert_includes captured_commands, "npm install @pandev-srl/better-ui"
      end

      test "generator uses yarn when yarn.lock exists" do
        FileUtils.mkdir_p(destination_root)
        File.write(File.join(destination_root, "yarn.lock"), "")

        output = run_generator

        assert_match(/Installing @pandev-srl\/better-ui/, output)
        assert_includes captured_commands, "yarn add @pandev-srl/better-ui"
      end

      test "generator uses pnpm when pnpm-lock.yaml exists" do
        FileUtils.mkdir_p(destination_root)
        File.write(File.join(destination_root, "pnpm-lock.yaml"), "")

        output = run_generator

        assert_match(/Installing @pandev-srl\/better-ui/, output)
        assert_includes captured_commands, "pnpm add @pandev-srl/better-ui"
      end

      test "generator does not create theme file by default" do
        run_generator

        assert_no_file "app/assets/stylesheets/better_ui_theme.css"
      end

      test "generator creates theme file with copy_theme option" do
        run_generator ["--copy-theme"]

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

      test "theme file includes all color variants with full scales" do
        run_generator ["--copy-theme"]

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

      test "theme file includes utility classes" do
        run_generator ["--copy-theme"]

        assert_file "app/assets/stylesheets/better_ui_theme.css" do |content|
          assert_match(/\.text-heading-primary/, content)
          assert_match(/\.no-spinner/, content)
          assert_match(/\.focus-ring/, content)
          assert_match(/\.glass/, content)
        end
      end

      test "theme file includes typography tokens" do
        run_generator ["--copy-theme"]

        assert_file "app/assets/stylesheets/better_ui_theme.css" do |content|
          assert_match(/--font-family-sans:/, content)
          assert_match(/--font-family-serif:/, content)
          assert_match(/--font-family-mono:/, content)
        end
      end

      test "theme file uses OKLCH color space" do
        run_generator ["--copy-theme"]

        assert_file "app/assets/stylesheets/better_ui_theme.css" do |content|
          # Check that colors are defined using OKLCH format
          assert_match(/oklch\(\d+\.\d+ \d+\.\d+ \d+\)/, content)
        end
      end

      test "generator shows post-install instructions" do
        output = run_generator

        # Check for JavaScript setup instructions
        assert_match(/JavaScript Setup:/, output)
        assert_match(/registerControllers/, output)
        assert_match(/@pandev-srl\/better-ui/, output)

        # Check for CSS setup instructions
        assert_match(/CSS Setup:/, output)

        # Check for Tailwind configuration instructions
        assert_match(/Tailwind Configuration:/, output)
        assert_match(/vendor\/bundle/, output)

        # Check for usage example
        assert_match(/Usage:/, output)
        assert_match(/BetterUi::ButtonComponent/, output)
      end

      test "generator shows different CSS instructions when copy_theme is used" do
        output = run_generator ["--copy-theme"]

        # Check that it mentions the copied theme file
        assert_match(/Theme file copied to:/, output)
        assert_match(/better_ui_theme\.css/, output)
      end
    end
  end
end
