# coding: utf-8

require 'strings'

module TTY
  class Table
    module Operation
      # A class responsible for padding field with whitespace
      #
      # Used internally by {Table::Renderer}
      class Padding
        # Initialize a Padding operation
        #
        # @param [Strings::Padder] padding
        #
        # @param [Array[Integer]] widths
        #
        # @api public
        def initialize(padding)
          @padding = padding
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
        def call(field, *)
          Strings.pad(field.content, padding)
        end

        protected

        attr_reader :padding
      end # Padding
    end # Operation
  end # Table
end # TTY
