# frozen_string_literal: true

module TTY
  class Table
    # A class that represents table border options
    #
    # Used internally by {Table::Border} to manage options such as style
    #
    # @api private
    class BorderOptions
      # Create options instance from hash
      #
      # @api public
      def self.from(options)
        return new if options.nil?

        opts = case options
               when self.class
                 options.to_hash
               else
                 options
               end
        new(**opts)
      end

      attr_accessor :characters

      attr_accessor :separator

      attr_accessor :style

      # Initialize a BorderOptions
      #
      # @param [String] style
      #   the style like :red
      # @param [String] separator
      #   the separator character
      # @param [Hash] characters
      #   the border characters
      #
      # @api public
      def initialize(characters: {}, separator: nil, style: nil)
        @characters = characters
        @separator = separator
        @style = style
      end

      # Convert to hash
      #
      # @return [Hash]
      #
      # @api public
      def to_hash
        { characters: characters, separator: separator, style: style }
      end

      # Check if there should be a separator AFTER this line
      #
      # @param [Integer] line
      #
      # @return [Boolean]
      #
      # @api public
      def separator?(line)
        case separator
        when TTY::Table::Border::EACH_ROW
          true
        when Array
          separator.include?(line)
        when Proc
          separator.call(line)
        else
          false
        end
      end
    end # BorderOptions
  end # Table
end # TTY
