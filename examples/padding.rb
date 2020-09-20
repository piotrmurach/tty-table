# frozen_string_literal: true

require "pastel"
require_relative "../lib/tty-table"

pastel = Pastel.new
yellow = pastel.yellow.detach
header = [yellow.("Column 1"), yellow.("Column 2"), yellow.("Column 3")]
table = TTY::Table.new(header: header) do |t|
  t << %w[11 12 13]
  t << %w[21 22 23]
  t << %w[31 32 33]
end

puts table.render(:ascii, padding: [1, 2, 1, 2])
