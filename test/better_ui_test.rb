require "test_helper"

class BetterUiTest < ActiveSupport::TestCase
  test "it has a version number" do
    assert BetterUi::VERSION
  end

  test "version is a string" do
    assert_kind_of String, BetterUi::VERSION
  end

  test "version follows semantic versioning format" do
    assert_match(/\A\d+\.\d+\.\d+\z/, BetterUi::VERSION)
  end

  test "root returns a Pathname" do
    assert_kind_of Pathname, BetterUi.root
  end

  test "root path exists" do
    assert Dir.exist?(BetterUi.root), "BetterUi root path should exist"
  end

  test "root contains lib directory" do
    lib_path = BetterUi.root.join("lib")
    assert Dir.exist?(lib_path), "BetterUi root should contain lib directory"
  end

  test "template_paths returns an array" do
    assert_kind_of Array, BetterUi.template_paths
  end

  test "template_paths includes views directory" do
    views_path = BetterUi::Engine.root.join("app", "views").to_s
    assert BetterUi.template_paths.include?(views_path) if Dir.exist?(views_path)
  end

  test "template_paths includes components directory" do
    components_path = BetterUi::Engine.root.join("app", "components").to_s
    assert BetterUi.template_paths.include?(components_path)
  end

  test "template_paths only includes existing directories" do
    BetterUi.template_paths.each do |path|
      assert Dir.exist?(path), "#{path} should exist"
    end
  end

  test "template_paths returns absolute paths" do
    BetterUi.template_paths.each do |path|
      assert Pathname.new(path).absolute?, "#{path} should be an absolute path"
    end
  end
end
