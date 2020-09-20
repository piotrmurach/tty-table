# frozen_string_literal: true

module TTY
  class Table
    # A module responsible for indenting table representation
    module Indentation
      # Return a table part with indentation inserted
      #
      # @param [#map, #to_s] part
      #   the rendered table part
      #
      # @api public
      def indent(part, indentation)
        if part.is_a?(Enumerable) && part.respond_to?(:to_a)
          part.map { |line| insert_indentation(line, indentation) }
        else
          insert_indentation(part, indentation)
        end
      end
      module_function :indent

      # Insert indentation into a table renderd line
      #
      # @param [String] line
      #   the rendered table line
      # @param [Integer] indentation
      #   the amount of indentation to apply
      #
      # @return [String]
      #
      # @api public
      def insert_indentation(line, indentation)
        line ? " " * indentation + line.to_s : ""
      end
      module_function :insert_indentation
    end # Indentation
  end # Table
end # TTY
