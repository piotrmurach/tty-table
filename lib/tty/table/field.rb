# encoding: utf-8

module TTY
  class Table
    # A class that represents a unique element in a table.
    #
    # Used internally by {Table::Header} and {Table::Row} to
    # define internal structure.
    #
    # @api private
    class Field
      include Equatable

      # The value inside the field
      #
      # @api public
      attr_reader :value

      # The formatted value inside the field used for display
      #
      # @api public
      attr_reader :content

      # The name for the value
      #
      # @api public
      attr_reader :name

      # TODO: Change to :content to separate value from formatted string
      attr_writer :value

      attr_writer :content

      # The field value width
      #
      # @api public
      attr_reader :width

      # Number of columns this field spans. Defaults to 1.
      #
      # @api public
      attr_reader :colspan

      # Number of rows this field spans. Defaults to 1.
      #
      # @api public
      attr_reader :rowspan

      # The field alignment
      #
      # @api public
      attr_reader :align

      # Initialize a Field
      #
      # @example
      #   field = TTY::Table::Field.new 'a1'
      #   field.value  # => a1
      #
      # @example
      #   field = TTY::Table::Field.new value: 'a1'
      #   field.value  # => a1
      #
      # @example
      #   field = TTY::Table::Field.new value: 'a1', align: :center
      #   field.value  # => a1
      #   field.align  # => :center
      #
      # @api private
      def initialize(value)
        options  = extract_options(value)
        @content = @value.to_s
        @width   = options.fetch(:width) { @value.to_s.size }
        @align   = options.fetch(:align) { nil }
        @colspan = options.fetch(:colspan) { 1 }
        @rowspan = options.fetch(:rowspan) { 1 }
      end

      # Extract options and set value
      #
      # @api private
      def extract_options(value)
        if value.class <= Hash
          options = value
          @value = options.fetch(:value)
        else
          @value = value
          options = {}
        end
        options
      end

      # Return the width this field would normally have bar other contraints
      #
      # @api public
      def value_width
        @width
      end

      def value_height
        @height
      end

      # Return number of lines this value spans.
      #
      # A distinction is being made between escaped and non-escaped strings.
      #
      # @return [Array[String]]
      #
      # @api public
      def lines
        escaped = content.scan(/(\\n|\\t|\\r)/)
        escaped.empty? ? content.split(/\n/, -1) : [content]
      end

      # If the string contains unescaped new lines then the longest token
      # deterimines the actual field length.
      #
      # @return [Integer]
      #
      # @api public
      def length
        (lines.max_by(&:length) || '').size
      end

      # Extract the number of lines this value spans
      #
      # @return [Integer]
      #
      # @api public
      def height
        lines.size
      end

      def chars
        content.chars
      end

      # Return field content
      #
      # @return [String]
      #
      # @api public
      def to_s
        content
      end
    end # Field
  end # Table
end # TTY
