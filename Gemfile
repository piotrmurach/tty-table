source "https://rubygems.org"

gemspec

if Gem::Version.new(RUBY_VERSION) >= Gem::Version.new("2.1.0")
  gem "rspec-benchmark"
end
gem "json", "2.4.1" if RUBY_VERSION == "2.0.0"

group :tools do
  gem "yard", "~> 0.9.12"
end

group :metrics do
  gem "coveralls", "~> 0.8.22"
  gem "simplecov", "~> 0.16.1"
  gem "yardstick", "~> 0.9.9"
end

group :benchmarks do
  gem "benchmark-ips", "~> 2.7.2"
end
