# frozen_string_literal: true

require "test_helper"

class EngineTest < ActiveSupport::TestCase
  test "engine exists" do
    assert_kind_of Class, BetterUi::Engine
  end

  test "engine inherits from Rails::Engine" do
    assert BetterUi::Engine < Rails::Engine
  end

  test "engine root exists" do
    assert BetterUi::Engine.root.exist?
  end

  test "engine root is a Pathname" do
    assert_kind_of Pathname, BetterUi::Engine.root
  end

  test "engine has app directory" do
    app_path = BetterUi::Engine.root.join("app")
    assert Dir.exist?(app_path), "Engine should have app directory"
  end

  test "engine has lib directory" do
    lib_path = BetterUi::Engine.root.join("lib")
    assert Dir.exist?(lib_path), "Engine should have lib directory"
  end

  test "engine has components directory" do
    components_path = BetterUi::Engine.root.join("app", "components")
    assert Dir.exist?(components_path), "Engine should have app/components directory"
  end

  test "engine has form_builders directory" do
    form_builders_path = BetterUi::Engine.root.join("app", "form_builders")
    assert Dir.exist?(form_builders_path), "Engine should have app/form_builders directory"
  end

  test "engine has assets directory for npm package" do
    assets_path = BetterUi::Engine.root.join("assets")
    assert Dir.exist?(assets_path), "Engine should have assets directory for npm package"
  end

  test "engine assets directory has package.json" do
    package_json_path = BetterUi::Engine.root.join("assets", "package.json")
    assert File.exist?(package_json_path), "Engine assets should have package.json"
  end

  test "engine autoload paths include lib directory" do
    lib_path = BetterUi::Engine.root.join("lib").to_s
    assert BetterUi::Engine.config.autoload_paths.include?(lib_path),
           "Engine autoload paths should include lib directory"
  end

  test "engine preview paths exist" do
    preview_path = BetterUi::Engine.root.join("spec", "components", "previews")
    assert Dir.exist?(preview_path), "Engine should have spec/components/previews directory"
  end

  test "engine is mounted in routes" do
    # Check if the engine is accessible
    assert_nothing_raised do
      BetterUi::Engine.routes
    end
  end

  test "engine routes is a RouteSet" do
    assert_kind_of ActionDispatch::Routing::RouteSet, BetterUi::Engine.routes
  end

  test "package.json has correct scripts" do
    package_json = JSON.parse(File.read(BetterUi::Engine.root.join("assets", "package.json")))
    scripts = package_json["scripts"]

    assert_equal "vite build --watch", scripts["dev"]
    assert_equal "vite build && yarn types", scripts["build"]
    assert scripts.key?("types")
    assert scripts.key?("prepublishOnly")
    refute scripts.key?("build:css")
    refute scripts.key?("build:watch")
  end

  test "package.json has correct devDependencies" do
    package_json = JSON.parse(File.read(BetterUi::Engine.root.join("assets", "package.json")))
    dev_deps = package_json["devDependencies"]

    assert dev_deps.key?("@types/node")
    assert dev_deps.key?("vite")
    assert dev_deps.key?("typescript")
    assert dev_deps.key?("tailwindcss")
    refute dev_deps.key?("postcss-cli")
  end

  test "package.json specifies Yarn 4 as package manager" do
    package_json = JSON.parse(File.read(BetterUi::Engine.root.join("assets", "package.json")))

    assert package_json["packageManager"]&.start_with?("yarn@4")
  end

  test "package.json has correct exports" do
    package_json = JSON.parse(File.read(BetterUi::Engine.root.join("assets", "package.json")))
    exports = package_json["exports"]

    assert exports["."]
    assert exports["./css"]
    assert exports["./theme"]
    assert exports["./typography"]
    assert exports["./utilities"]
  end
end
