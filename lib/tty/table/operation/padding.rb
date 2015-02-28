# coding: utf-8

module TTY
  class Table
    module Operation
      # A class responsible for padding field with whitespace
      #
      # Used internally by {Table::Renderer}
      class Padding
        attr_reader :padding_top

        attr_reader :padding_right

        attr_reader :padding_bottom

        attr_reader :padding_left

        attr_reader :padding_width

        attr_reader :widths

        # Initialize a Padding operation
        #
        # @param [TTY::Table::Padder] padding
        #
        # @param [Array[Integer]] widths
        #
        # @api public
        def initialize(padding, widths)
          @padding = padding
          @widths  = widths
        end

        # Apply padding to a field
        #
        # @param [TTY::Table::Field] field
        #   the table field
        #
        # @param [Integer] row
        #   the field row index
        #
        # @param [Integer] col
        #   the field column index
        #
        # @return [TTY::Table::Field]
        #
        # @api public
        def call(field, row, col)
          column_width = widths[col]
          elements = []
          if @padding.top > 0
            elements << (' ' * column_width + "\n") * @padding.top
          end
          elements << field.content
          if @padding.bottom > 0
            elements << (' ' * column_width + "\n") * @padding.bottom
          end
          elements.map { |el| pad_multi_line(el) }.join("\n")
        end

        # Apply padding to multi line text
        #
        # @param [String] text
        #
        # @return [String]
        #
        # @api private
        def pad_multi_line(text)
          text.split("\n").map { |part| pad_around(part) }
        end

        # Apply padding to left and right side of string
        #
        # @param [String] text
        #
        # @return [String]
        #
        # @api private
        def pad_around(text)
          text.insert(0, ' ' * @padding.left).insert(-1, ' ' * @padding.right)
        end
      end # Padding
    end # Operation
  end # Table
end # TTY
