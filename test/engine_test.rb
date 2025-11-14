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

  test "engine has javascript directory" do
    js_path = BetterUi::Engine.root.join("app", "javascript")
    assert Dir.exist?(js_path), "Engine should have app/javascript directory"
  end

  test "engine has importmap configuration" do
    importmap_path = BetterUi::Engine.root.join("config", "importmap.rb")
    assert File.exist?(importmap_path), "Engine should have config/importmap.rb"
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
end
