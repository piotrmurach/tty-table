# encoding: utf-8

require 'tty-table'

table = TTY::Table.new header: ['header1', 'header2', 'header3']
table << ['a1', 'a2', 'a3']
table << ['b1','b2', 'b3']
table << ['c1', 'c2', 'c3']

puts table.render(:ascii, alignments: [:right, :center, :left])
