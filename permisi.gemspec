# frozen_string_literal: true

require_relative "lib/permisi/version"

Gem::Specification.new do |spec|
  spec.name          = "permisi"
  spec.version       = Permisi::VERSION
  spec.authors       = ["Ukaza Perdana"]
  spec.email         = ["ukaza@hey.com"]

  spec.summary       = "Simple and dynamic role-based access control for Rails"

  spec.description   = <<~DESCRIPTION
    Permisi provides a way of dynamically declaring user rights (a.k.a. permissions) using a simple role-based access control scheme.
    A user may be associated to multiple roles with a different set of permissions in each role.
    The roles and user-roles association can be dynamically defined and changed on runtime.
  DESCRIPTION

  spec.homepage      = "https://github.com/ukazap/permisi"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.4.4")

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = "#{spec.homepage}/blob/main/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{\A(?:test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "activesupport", ">= 3.2.0"
  spec.add_dependency "activerecord", ">= 3.2.0"
  spec.add_dependency "activemodel", ">= 3.2.0"
  spec.add_dependency "zeitwerk", ["~> 2.4", ">= 2.4.2"]

  # For more information and examples about making a new gem, checkout our
  # guide at: https://bundler.io/guides/creating_gem.html
end
