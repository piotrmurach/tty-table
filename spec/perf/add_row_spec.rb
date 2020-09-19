# frozen_string_literal: true

require "rspec-benchmark"

RSpec.describe TTY::Table, "#<<" do
  include RSpec::Benchmark::Matchers

  let(:array) { [] }
  let(:table) { described_class.new }
  let(:row) { %w[YYYY-MM-DD Something 123.456] }

  it "performs slower than adding elements to an array" do
    expect {
      table << row
    }.to perform_slower_than {
      array << row
    }.at_most(30).times
  end
end
