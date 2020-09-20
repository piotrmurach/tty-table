# frozen_string_literal: true

require_relative "../lib/tty-table"

table = TTY::Table.new header: ["Right align", "Center align", "Left align"]
table << %w[a1 a2 a3]
table << %w[b1 b2 b3]
table << %w[c1 c2 c3]

puts table.render(:ascii, alignments: %i[right center left])
