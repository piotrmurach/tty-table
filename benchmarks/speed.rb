# coding: utf-8

require 'benchmark'
require 'benchmark/ips'

require_relative '../lib/tty-table'

header = [:name, :color]
rows   = (1..100).map { |n| ["row#{n}", "red"] }
table  = TTY::Table.new(header, rows)

# Benchmark speed of table operations
Benchmark.ips do |r|
  r.report("Ruby #to_s") do
    rows.to_s
  end

  r.report("TTY #render") do
    table.render
  end

  r.report("TTY #render ASCII") do
    table.render(:ascii)
  end

  r.report("TTY #render Unicode") do
    table.render(:unicode)
  end

  r.report("TTY #render Color") do
    table.render(:ascii, border: {style: :red})
  end
end

#          Ruby #to_s     2588.6 (±12.2%) i/s -      12948 in   5.084883s
#         TTY #render       20.8 (±9.6%) i/s  -        104 in   5.030159s
#   TTY #render ASCII       18.1 (±16.5%) i/s -         89 in   5.041230s
# TTY #render Unicode       18.0 (±16.7%) i/s -         88 in   5.029868s
#   TTY #render Color       11.7 (±17.1%) i/s -         58 in   5.071654s
