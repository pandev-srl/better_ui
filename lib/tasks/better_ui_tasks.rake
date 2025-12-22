# frozen_string_literal: true

namespace :better_ui do
  desc "Sync npm package version with gem version"
  task :sync_version do
    require_relative "../better_ui/version"

    package_json_path = File.expand_path("../../assets/package.json", __dir__)

    unless File.exist?(package_json_path)
      puts "Error: assets/package.json not found at #{package_json_path}"
      exit 1
    end

    require "json"
    package_json = JSON.parse(File.read(package_json_path))
    old_version = package_json["version"]
    package_json["version"] = BetterUi::VERSION

    File.write(package_json_path, JSON.pretty_generate(package_json) + "\n")

    puts "Synced npm package version: #{old_version} -> #{BetterUi::VERSION}"
  end

  desc "Build npm package (run from gem root)"
  task :build_npm do
    assets_dir = File.expand_path("../../assets", __dir__)

    Dir.chdir(assets_dir) do
      puts "Installing npm dependencies..."
      system("npm install") || abort("Failed to install npm dependencies")

      puts "Building npm package..."
      system("npm run build") || abort("Failed to build npm package")

      puts "npm package built successfully in assets/dist/"
    end
  end
end
