# frozen_string_literal: true

require_relative "../border"

module TTY
  class Table
    class Border
      # A class that represents no border.
      class Null < Border
        def_border do
          top           EMPTY_CHAR
          top_mid       EMPTY_CHAR
          top_left      EMPTY_CHAR
          top_right     EMPTY_CHAR
          bottom        EMPTY_CHAR
          bottom_mid    EMPTY_CHAR
          bottom_left   EMPTY_CHAR
          bottom_right  EMPTY_CHAR
          mid           EMPTY_CHAR
          mid_mid       EMPTY_CHAR
          mid_left      EMPTY_CHAR
          mid_right     EMPTY_CHAR
          left          EMPTY_CHAR
          center        SPACE_CHAR
          right         EMPTY_CHAR
        end

        # A stub middle line
        #
        # @api private
        def middle_line
          border_options.separator ? "" : super
        end
      end # Null
    end # Border
  end # Table
end # TTY
