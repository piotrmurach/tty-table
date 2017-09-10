# encoding: utf-8

require 'equatable'

require_relative 'error'

module TTY
  class Table
    # A class that represents table column properties.
    #
    # Used by {Table} to manage column sizing.
    #
    # @api private
    class Columns
      include Equatable

      # Initialize Columns
      #
      # @param [Array[Array[Object]]] data
      #
      # @api public
      def initialize(table)
        @data = table.data
      end

      # Calculate total table width
      #
      # @return [Integer]
      #
      # @api public
      def total_width
        extract_widths.reduce(:+)
      end

      # Calcualte maximum column widths
      #
      # @return [Array] column widths
      #
      # @api private
      def extract_widths
        colcount = data.max { |row_a, row_b| row_a.size <=> row_b.size }.size
        find_maximas(colcount)
      end

      # Assert data integrity for column widths
      #
      # @param [Array] column_widths
      #
      # @param [Integer] table_widths
      #
      # @raise [TTY::InvalidArgument]
      #
      # @api public
      def self.assert_widths(column_widths, table_widths)
        if column_widths.empty?
          fail InvalidArgument, 'Value for :column_widths must be ' \
                                 'a non-empty array'
        end
        if column_widths.size != table_widths
          fail InvalidArgument, 'Value for :column_widths must match ' \
                                 'table column count'
        end
      end

      # Converts column widths to array format or infers default widths
      #
      # @param [TTY::Table] table
      #
      # @param [Array, Numeric, NilClass] column_widths
      #
      # @return [Array[Integer]]
      #
      # @api public
      def self.widths_from(table, column_widths = nil)
        case column_widths
        when Array
          assert_widths(column_widths, table.columns_size)
          Array(column_widths).map(&:to_i)
        when Numeric
          Array.new(table.columns_size, column_widths)
        when NilClass
          new(table).extract_widths
        else
          fail TypeError, 'Invalid type for column widths'
        end
      end

      private

      attr_reader :data

      # Find maximum widths for each row and header if present.
      #
      # @param [Integer] colcount
      #   number of columns
      #
      # @return [Array[Integer]]
      #
      # @api private
      def find_maximas(colcount)
        maximas = []
        start   = 0

        start.upto(colcount - 1) do |col_index|
          maximas << find_maximum(col_index)
        end
        maximas
      end

      # Find a maximum column width. The calculation takes into account
      # wether the content is escaped or not.
      #
      # @param [Integer] index
      #   the column index
      #
      # @return [Integer]
      #
      # @api private
      def find_maximum(index)
        data.map do |row|
          (field = row.call(index)) ? field.length : 0
        end.max
      end
    end # ColumnSet
  end # Table
end # TTY
