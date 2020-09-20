# frozen_string_literal: true

module TTY
  class Table
    class Border
      # A class for a table row line chars manipulation
      class RowLine < Struct.new(:left, :center, :right)
        # Colorize characters with a given style
        #
        # @api public
        def colorize(border, style)
          self.right = border.set_color(style, right)
          self.center = border.set_color(style, center)
          self.left = border.set_color(style, left)
        end
      end # RowLine
    end # Border
  end # Table
end # TTY
