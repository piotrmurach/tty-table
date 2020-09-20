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

        # A stub separator line
        #
        # @api private
        def separator
          return [] if border_options.separator # == EACH_ROW #TODO ask about this looks broken.
          # how could border_options ever be nil, if we just did border_options.separator
          border_options ? super : nil
        end
      end # Null
    end # Border
  end # Table
end # TTY
