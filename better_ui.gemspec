require_relative "lib/better_ui/version"

Gem::Specification.new do |spec|
  spec.name        = "better_ui"
  spec.version     = BetterUi::VERSION
  spec.authors     = [ "Umberto Peserico" ]
  spec.email       = [ "umberto.peserico@pandev.it" ]
  spec.homepage    = "https://github.com/alessiobussolari/better_ui"
  spec.summary     = "Elegant and reusable UI components for Rails with integrated documentation"
  spec.description = "Better UI is a Rails gem that works as a mountable engine containing reusable UI components, " \
                     "built with ViewComponent and Tailwind CSS, following the BEM methodology. " \
                     "It includes documentation and interactive previews with Lookbook."
  spec.license     = "MIT"

  # Specify minimum Ruby version (Rails 8.1+ requires Ruby 3.2+)
  spec.required_ruby_version = ">= 3.2.0"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the "allowed_push_host"
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  spec.metadata["allowed_push_host"] = "https://rubygems.org"

  spec.metadata["source_code_uri"] = "https://github.com/alessiobussolari/better_ui"
  spec.metadata["changelog_uri"] = "https://github.com/alessiobussolari/better_ui/blob/main/CHANGELOG.md"

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
      .reject { |f| f.include?("node_modules") || f.include?("assets/dist") }
  end

  spec.add_dependency "rails", "~> 8.1", ">= 8.1.1"
  spec.add_dependency "view_component", "~> 4.1"
  spec.add_dependency "tailwind_merge", "~> 0.12"
  spec.add_dependency "lookbook", "~> 2.3"
end
