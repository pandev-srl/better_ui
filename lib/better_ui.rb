# frozen_string_literal: true

require "view_component"
require "tailwind_merge"
require "lookbook"
require "better_ui/version"
require "better_ui/engine"

module BetterUi
  # Returns an array of paths where BetterUi templates are located.
  # This is useful for debugging and documentation purposes.
  #
  # @return [Array<String>] Array of absolute paths to template directories
  #
  # @example
  #   BetterUi.template_paths
  #   # => ["/path/to/gem/app/views", "/path/to/gem/app/components"]
  def self.template_paths
    root = Engine.root
    [
      root.join("app", "views").to_s,
      root.join("app", "components").to_s
    ].select { |path| Dir.exist?(path) }
  end

  # Returns the root path of the BetterUi gem.
  # This is useful when you need to reference gem assets or files.
  #
  # @return [Pathname] The root path of the gem
  #
  # @example
  #   BetterUi.root
  #   # => #<Pathname:/path/to/better_ui>
  def self.root
    Engine.root
  end
end
