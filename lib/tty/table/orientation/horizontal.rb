# frozen_string_literal: true

module TTY
  class Table
    # A class representing table orientation
    class Orientation
      # A class responsible for horizontal table transformation
      class Horizontal < Orientation
        # Rotate table horizontally
        #
        # @param [Table] table
        #
        # @return [nil]
        #
        # @api public
        def transform(table)
          table.rotate_horizontal
        end

        # Slice vertical table data into horizontal
        #
        # @param [Table] table
        #
        # @api public
        def slice(table)
          head, body, array_h, array_b = 4.times.map { [] }
          first_column  = 0
          second_column = 1

          (0...table.original_columns * table.original_rows).each do |col_index|
            row      = table.rows[col_index]
            array_h += [row[first_column]]
            array_b += [row[second_column]]

            if (col_index + 1) % table.original_columns == 0
              head << array_h
              body << array_b
              array_h, array_b = [], []
            end
          end
          [head.uniq, body]
        end
      end # Horizontal
    end # Orientation
  end # Table
end # TTY
