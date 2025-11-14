# frozen_string_literal: true

require "rails/generators/base"

module BetterUi
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path("templates", __dir__)

      desc "Installs BetterUi theme and configures Tailwind CSS v4"

      def copy_theme_file
        say "Creating BetterUi theme file...", :green
        template "better_ui_theme.css.tt", "app/assets/stylesheets/better_ui_theme.css"
      end

      def update_application_css
        application_css_path = "app/assets/stylesheets/application.postcss.css"
        full_path = File.join(destination_root, application_css_path)

        if File.exist?(full_path)
          say "Updating existing application.postcss.css...", :green
          update_existing_application_css(application_css_path)
        else
          say "Creating application.postcss.css...", :green
          create_application_css(application_css_path)
        end
      end

      def show_post_install_message
        say "\n"
        say "=" * 80, :green
        say "BetterUi installation complete!", :green
        say "=" * 80, :green
        say "\n"
        say "Generated files:", :cyan
        say "  - app/assets/stylesheets/better_ui_theme.css"
        say "  - app/assets/stylesheets/application.postcss.css"
        say "\n"
        say "Next steps:", :yellow
        say "  1. Ensure you have Tailwind CSS v4 installed:"
        say "     npm install tailwindcss@next @tailwindcss/postcss@next"
        say "\n"
        say "  2. Configure PostCSS (postcss.config.js):"
        say "     module.exports = {"
        say "       plugins: ["
        say "         require('@tailwindcss/postcss')"
        say "       ]"
        say "     }"
        say "\n"
        say "  3. Customize your theme colors in:"
        say "     app/assets/stylesheets/better_ui_theme.css"
        say "\n"
        say "  4. Import BetterUi components in your views:"
        say "     <%= render BetterUi::ButtonComponent.new(label: \"Click me\") %>"
        say "\n"
        say "=" * 80, :green
      end

      private

      def update_existing_application_css(path)
        full_path = File.join(destination_root, path)
        content = File.read(full_path)

        # Check if imports already exist
        has_tailwind_import = content.include?('@import "tailwindcss"')
        has_theme_import = content.include?('@import "./better_ui_theme.css"')
        has_vendor_source = content.include?('@source "../../../vendor/bundle/**/*.{rb,erb}"')
        has_views_source = content.include?('@source "../../**/*.{erb,html,rb}"')
        has_js_source = content.include?('@source "../javascript/**/*.js"')

        additions = []

        additions << '@import "tailwindcss";' unless has_tailwind_import
        additions << '@import "./better_ui_theme.css";' unless has_theme_import
        additions << "" if additions.any? && !content.strip.empty?
        additions << "/* Scan gem templates for Tailwind classes */"
        additions << '@source "../../../vendor/bundle/**/*.{rb,erb}";' unless has_vendor_source
        additions << "" unless has_views_source
        additions << "/* Scan application files for Tailwind classes */"
        additions << '@source "../../**/*.{erb,html,rb}";' unless has_views_source
        additions << '@source "../javascript/**/*.js";' unless has_js_source

        if additions.any?
          # Prepend additions to the file
          prepend_to_file path, additions.join("\n") + "\n\n"
          say "  Added BetterUi configuration to application.postcss.css", :green
        else
          say "  application.postcss.css already configured", :yellow
        end
      end

      def create_application_css(path)
        create_file path, <<~CSS
          @import "tailwindcss";
          @import "./better_ui_theme.css";

          /* Scan gem templates for Tailwind classes */
          @source "../../../vendor/bundle/**/*.{rb,erb}";

          /* Scan application files for Tailwind classes */
          @source "../../**/*.{erb,html,rb}";
          @source "../javascript/**/*.js";

          /* Your custom styles here */
        CSS
      end
    end
  end
end
