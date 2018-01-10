# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'tty/table/version'

Gem::Specification.new do |spec|
  spec.name          = 'tty-table'
  spec.version       = TTY::Table::VERSION
  spec.authors       = ["Piotr Murach"]
  spec.email         = [""]
  spec.summary       = %q{A flexible and intuitive table generator}
  spec.description   = %q{A flexible and intuitive table generator}
  spec.homepage      = "https://piotrmurach.github.io/tty/"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(spec|features)/})
  spec.require_paths = ["lib"]

  spec.required_ruby_version = '>= 2.0.0'

  spec.add_dependency 'equatable',   '~> 0.5.0'
  spec.add_dependency 'necromancer', '~> 0.4.0'
  spec.add_dependency 'pastel',      '~> 0.7.2'
  spec.add_dependency 'tty-screen',  '~> 0.6.4'
  spec.add_dependency 'strings',     '~> 0.1.0'

  spec.add_development_dependency 'bundler', '>= 1.5.0', '< 2.0'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec', '~> 3.1'
end
