# frozen_string_literal: true

require "forwardable"

require_relative "border_options"

module TTY
  class Table
    # A class responsible for bulding and modifying border
    #
    # Used internally by {Table::Border} to allow for building custom border
    # through DSL
    # @api private
    class BorderDSL
      extend Forwardable

      # Border options
      #
      # @return [Table::BorderOptions]
      attr_reader :options

      def_delegators :@options, :characters

      # Initialize a BorderDSL
      #
      # @param [Hash] characters
      #   the border characters
      #
      # @return [undefined]
      #
      # @api private
      def initialize(border_opts = nil, &block)
        @options = TTY::Table::BorderOptions.from(border_opts)
        yield_or_eval(&block) if block_given?
      end

      # Apply style color to the border
      #
      # @param [Symbol] value
      #   the style color for the border
      #
      # @return [undefined]
      #
      # @api public
      def style(value = (not_set = true))
        return options.style if not_set

        options.style = value
      end

      # Apply table tuple separator
      #
      # @param [Symbol] value
      #   the table tuple separator
      #
      # @return [undefined]
      #
      # @api public
      def separator(value = (not_set = true))
        return options.separator if not_set

        options.separator = value
      end

      # Set top border character
      #
      # @param [String] value
      #   the character value
      #
      # @return [undefined]
      #
      # @api public
      def top(value)
        characters["top"] = value
      end

      # Set top middle border character
      #
      # @param [String] value
      #   the character value
      #
      # @return [undefined]
      #
      # @api public
      def top_mid(value)
        characters["top_mid"] = value
      end

      # Set top left corner border character
      #
      # @param [String] value
      #   the character value
      #
      # @return [undefined]
      #
      # @api public
      def top_left(value)
        characters["top_left"] = value
      end

      # Set top right corner border character
      #
      # @param [String] value
      #   the character value
      #
      # @return [undefined]
      #
      # @api public
      def top_right(value)
        characters["top_right"] = value
      end

      # Set bottom border character
      #
      # @param [String] value
      #   the character value
      #
      # @return [undefined]
      #
      # @api public
      def bottom(value)
        characters["bottom"] = value
      end

      # Set bottom middle border character
      #
      # @param [String] value
      #   the character value
      #
      # @return [undefined]
      #
      # @api public
      def bottom_mid(value)
        characters["bottom_mid"] = value
      end

      # Set bottom left corner border character
      #
      # @param [String] value
      #   the character value
      #
      # @return [undefined]
      #
      # @api public
      def bottom_left(value)
        characters["bottom_left"] = value
      end

      # Set bottom right corner border character
      #
      # @param [String] value
      #   the character value
      #
      # @return [undefined]
      #
      # @api public
      def bottom_right(value)
        characters["bottom_right"] = value
      end

      # Set middle border character
      #
      # @param [String] value
      #   the character value
      #
      # @return [undefined]
      #
      # @api public
      def mid(value)
        characters["mid"] = value
      end

      # Set middle border character
      #
      # @param [String] value
      #   the character value
      #
      # @return [undefined]
      #
      # @api public
      def mid_mid(value)
        characters["mid_mid"] = value
      end

      # Set middle left corner border character
      #
      # @param [String] value
      #   the character value
      #
      # @return [undefined]
      #
      # @api public
      def mid_left(value)
        characters["mid_left"] = value
      end

      # Set middle right corner border character
      #
      # @param [String] value
      #   the character value
      #
      # @return [undefined]
      #
      # @api public
      def mid_right(value)
        characters["mid_right"] = value
      end

      # Set left border character
      #
      # @param [String] value
      #   the character value
      #
      # @return [undefined]
      #
      # @api public
      def left(value)
        characters["left"] = value
      end

      # Set center border character
      #
      # @param [String] value
      #   the character value
      #
      # @return [undefined]
      #
      # @api public
      def center(value)
        characters["center"] = value
      end

      # Set right border character
      #
      # @param [String] value
      #   the character value
      #
      # @return [undefined]
      #
      # @api public
      def right(value)
        characters["right"] = value
      end

      private

      # Evaluate block
      #
      # @return [Table]
      #
      # @api private
      def yield_or_eval(&block)
        return unless block
        block.arity > 0 ? yield(self) : instance_eval(&block)
      end
    end # BorderDSL
  end # Table
end # TTY
