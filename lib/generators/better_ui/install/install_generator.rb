# frozen_string_literal: true

require "rails/generators/base"

module BetterUi
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path("templates", __dir__)

      class_option :copy_theme, type: :boolean, default: true,
        desc: "Copy theme CSS file for customization instead of using npm package default"

      desc "Installs BetterUi npm package and configures your Rails application"

      def install_npm_package
        say "Installing @pandev-srl/better-ui npm package...", :green

        if File.exist?(File.join(destination_root, "yarn.lock"))
          run "yarn add @pandev-srl/better-ui"
        elsif File.exist?(File.join(destination_root, "pnpm-lock.yaml"))
          run "pnpm add @pandev-srl/better-ui"
        else
          run "npm install @pandev-srl/better-ui"
        end
      end

      def copy_theme_file
        return unless options[:copy_theme]

        say "Copying BetterUi theme file for customization...", :green
        template "better_ui_theme.css.tt", "app/assets/stylesheets/better_ui_theme.css"
      end

      def show_post_install_message
        say "\n"
        say "=" * 80, :green
        say "BetterUi installation complete!", :green
        say "=" * 80, :green
        say "\n"

        say "JavaScript Setup:", :cyan
        say "  Add to your JavaScript entry point (e.g., app/javascript/application.js):"
        say ""
        say "    import { Application } from \"@hotwired/stimulus\""
        say "    import { registerControllers } from \"@pandev-srl/better-ui\""
        say ""
        say "    const application = Application.start()"
        say "    registerControllers(application)"
        say "\n"

        say "CSS Setup:", :cyan

        if options[:copy_theme]
          say "  Theme file copied to: app/assets/stylesheets/better_ui_theme.css"
          say "  Import in your main CSS file:"
          say ""
          say "    @import \"tailwindcss\";"
          say "    @import \"./better_ui_theme.css\";"
        else
          say "  Add to your main CSS file (e.g., app/assets/stylesheets/application.css):"
          say ""
          say "    /* Option 1: Import pre-built CSS */"
          say "    @import \"@pandev-srl/better-ui/css\";"
          say ""
          say "    /* Option 2: Import individual modules for customization */"
          say "    @import \"tailwindcss\";"
          say "    @import \"@pandev-srl/better-ui/theme\";       /* Design tokens */"
          say "    @import \"@pandev-srl/better-ui/typography\";  /* Typography utilities */"
          say "    @import \"@pandev-srl/better-ui/utilities\";   /* General utilities */"
        end

        say "\n"
        say "Tailwind Configuration:", :cyan
        say "  Ensure Tailwind scans BetterUi components for classes:"
        say "  Add to your CSS file:"
        say ""
        say "    @source \"../../../vendor/bundle/**/*.{rb,erb}\";"
        say "\n"

        say "Usage:", :cyan
        say "  <%= render BetterUi::ButtonComponent.new(label: \"Click me\") %>"
        say "\n"
        say "=" * 80, :green
      end
    end
  end
end
