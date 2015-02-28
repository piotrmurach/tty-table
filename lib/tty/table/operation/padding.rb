# coding: utf-8

module TTY
  class Table
    module Operation
      # A class responsible for padding field with whitespace
      #
      # Used internally by {Table::Renderer}
      class Padding

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
          Verse.pad(field.content, @padding)
        end
      end # Padding
    end # Operation
  end # Table
end # TTY
