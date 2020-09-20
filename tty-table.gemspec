# frozen_string_literal: true

require_relative "lib/tty/table/version"

Gem::Specification.new do |spec|
  spec.name          = "tty-table"
  spec.version       = TTY::Table::VERSION
  spec.authors       = ["Piotr Murach"]
  spec.email         = ["piotr@piotrmurach.com"]
  spec.summary       = %q{A flexible and intuitive table generator}
  spec.description   = %q{A flexible and intuitive table generator}
  spec.homepage      = "https://ttytoolkit.org"
  spec.license       = "MIT"
  if spec.respond_to?(:metadata=)
    spec.metadata = {
      "allowed_push_host" => "https://rubygems.org",
      "bug_tracker_uri"   => "https://github.com/piotrmurach/tty-table/issues",
      "changelog_uri"     => "https://github.com/piotrmurach/tty-table/blob/master/CHANGELOG.md",
      "documentation_uri" => "https://www.rubydoc.info/gems/tty-table",
      "homepage_uri"      => spec.homepage,
      "source_code_uri"   => "https://github.com/piotrmurach/tty-table"
    }
  end
  spec.files         = Dir["lib/**/*"]
  spec.extra_rdoc_files = Dir["README.md", "CHANGELOG.md", "LICENSE.txt"]
  spec.require_paths = ["lib"]
  spec.required_ruby_version = ">= 2.0.0"

  spec.add_dependency "pastel",     "~> 0.8"
  spec.add_dependency "strings",    "~> 0.2.0"
  spec.add_dependency "tty-screen", "~> 0.8"

  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec", ">= 3.0"
end
