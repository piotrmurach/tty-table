# coding: utf-8

if ENV['COVERAGE'] || ENV['TRAVIS']
  require 'simplecov'
  require 'coveralls'

  SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[
    SimpleCov::Formatter::HTMLFormatter,
    Coveralls::SimpleCov::Formatter
  ]

  SimpleCov.start do
    command_name 'spec'
    add_filter 'spec'
  end
end

require 'tty-table'
require 'tty-screen'

puts "#################################"
puts "TTY::Screen::VERSION = #{TTY::Screen::VERSION}"
puts "#size = #{TTY::Screen.size}"
puts "#size_from_java = #{TTY::Screen.size_from_java}"
puts "#size_from_win_api = #{TTY::Screen.size_from_win_api}"
puts "#size_from_ioctl = #{TTY::Screen.size_from_ioctl}"
puts "#size_from_io_console = #{TTY::Screen.size_from_io_console}"
puts "#size_from_readline = #{TTY::Screen.size_from_readline}"
puts "#size_from_tput = #{TTY::Screen.size_from_tput}"
puts "#size_from_stty = #{TTY::Screen.size_from_stty}"
puts "#size_from_env = #{TTY::Screen.size_from_env}"
puts "#size_from_ansicon = #{TTY::Screen.size_from_ansicon}"
puts "#################################"

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  # Limits the available syntax to the non-monkey patched syntax that is recommended.
  config.disable_monkey_patching!

  # This setting enables warnings. It's recommended, but in some cases may
  # be too noisy due to issues in dependencies.
  config.warnings = true

  if config.files_to_run.one?
    config.default_formatter = 'doc'
  end

  config.profile_examples = 2

  config.order = :random

  Kernel.srand config.seed
end

def unindent(string)
  prefix = string.scan(/^[ \t]+(?=\S)/).min
  string.gsub(/^#{prefix}/, '').chomp
end
