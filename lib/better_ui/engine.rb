# frozen_string_literal: true

module BetterUi
  class Engine < ::Rails::Engine
    isolate_namespace BetterUi

    # Configure Zeitwerk autoloading for the engine
    config.autoload_paths += %W[
      #{root}/lib
    ]

    # Ignore non-autoloadable directories
    initializer "better_ui.autoload_ignore", before: :set_autoload_paths do
      Rails.autoloaders.main.ignore(
        "#{root}/lib/tasks",
        "#{root}/lib/generators"
      )
    end

    # Configure importmap for JavaScript controllers (if available)
    initializer "better_ui.importmap", before: "importmap" do |app|
      if app.config.respond_to?(:importmap)
        app.config.importmap.paths << root.join("config/importmap.rb")
        app.config.assets.paths << root.join("app/javascript")
      end
    end

    # Configure ViewComponent preview paths (must run before Lookbook)
    initializer "better_ui.view_component", before: :load_config_initializers do |app|
      # Add engine preview paths to ViewComponent using absolute paths
      if app.config.respond_to?(:view_component)
        # Use the correct configuration: previews.paths (not preview_paths or previews_paths)
        app.config.view_component.previews.paths << root.join("spec/components/previews").to_s
      end
    end

    # Configure Lookbook for component previews (must run before Lookbook scans for previews)
    initializer "better_ui.lookbook", before: "lookbook.set_autoload_paths" do |app|
      # Only configure Lookbook if it's available
      if defined?(Lookbook)
        # Add engine preview paths to Lookbook with absolute path
        Lookbook.config.preview_paths << root.join("spec/components/previews").to_s

        # Configure Lookbook to work with the engine namespace
        Lookbook.config.project_name = "BetterUi Components"

        # Enable syntax highlighting for code examples
        Lookbook.config.preview_srcdoc = true
      end
    end
  end
end
