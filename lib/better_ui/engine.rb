# frozen_string_literal: true

module BetterUi
  class Engine < ::Rails::Engine
    isolate_namespace BetterUi

    # Configure Zeitwerk autoloading for the engine
    config.autoload_paths += %W[
      #{root}/lib
    ]

    # Ignore non-autoloadable directories
    Rails.autoloaders.main.ignore(
      "#{root}/lib/tasks"
    )
  end
end
