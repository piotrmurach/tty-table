# encoding: utf-8

module TTY
  class Table
    # A class holding table field operations.
    #
    # @api private
    class Operations
      # The table
      #
      # @api private
      attr_reader :table
      private :table

      # Available operations
      #
      # @return [Hash]
      #
      # @api public
      attr_reader :operations

      # Initialize Operations
      #
      # @param [TTY::Table] table
      #   the table to perform operations on
      #
      # @return [Object]
      #
      # @api public
      def initialize(table)
        @table      = table
        @operations = Hash.new { |hash, key| hash[key] = [] }
      end

      # Add operation
      #
      # @param [Symbol] operation_type
      #   the operation type
      # @param [Object] object
      #   the callable object
      #
      # @return [Hash]
      #
      # @api public
      def add(operation_type, object)
        operations[operation_type] << object
      end

      # Apply operations to a table row
      #
      # @param [Array[Symbol]] types
      #  the operation types
      # @param [Hash] options
      #   the options for the row
      #
      # @return [TTY::Table]
      #
      # @api public
      def run_operations(*args)
        operation_types = args
        table.data.each_with_index do |row, row_i|
          row.fields.each_with_index do |val, col_i|
            operation_types.each do |type|
              operations[type].each { |op| op.call(val, row_i, col_i) }
            end
          end
        end
      end
    end # Operations
  end # Table
end # TTY
