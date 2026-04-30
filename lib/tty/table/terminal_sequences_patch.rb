# frozen_string_literal: true

require "strings"
require "unicode_utils/each_grapheme"

module Strings
  module ANSI
    OSC_8_OPEN_MATCHER = /\A\e\]8;[^;]*;.*?(?:\a|\e\\)\z/m.freeze
    OSC_8_CLOSE_MATCHER = /\A\e\]8;;(?:\a|\e\\)\z/.freeze
    SGR_MATCHER = /\A\e\[[0-?]*m\z/.freeze
    SGR_RESET_MATCHER = /\A\e\[(?:0(?:;0)*)?m\z/.freeze

    TERMINAL_CONTROL_MATCHER = %r{
      \e(?:
        \[[0-?]*[ -/]*[@-~] |
        \][^\a\e]*(?:\a|\e\\) |
        P.*?(?:\a|\e\\) |
        X.*?(?:\a|\e\\) |
        \^.*?(?:\a|\e\\) |
        _.*?(?:\a|\e\\) |
        [@-_]
      )
    }mx.freeze

    def sanitize(string)
      string.gsub(TERMINAL_CONTROL_MATCHER, "")
    end
    module_function :sanitize

    def ansi?(string)
      !!(string =~ TERMINAL_CONTROL_MATCHER)
    end
    module_function :ansi?

    def only_ansi?(string)
      !!(string =~ /\A(?:#{TERMINAL_CONTROL_MATCHER})+\z/o)
    end
    module_function :only_ansi?

    def terminal_control?(string)
      !!(string =~ /\A#{TERMINAL_CONTROL_MATCHER}\z/o)
    end
    module_function :terminal_control?

    def sgr?(string)
      !!(string =~ SGR_MATCHER)
    end
    module_function :sgr?

    def sgr_reset?(string)
      !!(string =~ SGR_RESET_MATCHER)
    end
    module_function :sgr_reset?

    def osc_8_open?(string)
      !!(string =~ OSC_8_OPEN_MATCHER) && !osc_8_close?(string)
    end
    module_function :osc_8_open?

    def osc_8_close?(string)
      !!(string =~ OSC_8_CLOSE_MATCHER)
    end
    module_function :osc_8_close?

    def osc_8_close_for(open_sequence)
      terminator = open_sequence.end_with?("\a") ? "\a" : "\e\\"
      "\e]8;;#{terminator}"
    end
    module_function :osc_8_close_for

    def tokenize(string)
      tokens = []
      remaining = string.dup

      until remaining.empty?
        match = remaining.match(TERMINAL_CONTROL_MATCHER)

        if match&.begin(0) == 0
          tokens << match[0]
          remaining = match.post_match
          next
        end

        printable = match ? remaining[0...match.begin(0)] : remaining
        UnicodeUtils.each_grapheme(printable) { |grapheme| tokens << grapheme }
        remaining = match ? remaining[match.begin(0)..] : ""
      end

      tokens
    end
    module_function :tokenize
  end

  module Wrap
    def format_line(text_line, wrap_at, wrappers)
      lines = []
      line = reopen_wrappers(wrappers)
      word = +""
      pending = +""
      word_length = 0
      line_length = 0
      total_length = 0
      text_length = display_width(text_line)

      Strings::ANSI.tokenize(text_line).each do |token|
        if Strings::ANSI.terminal_control?(token)
          pending << token
          update_wrappers!(wrappers, token)
          next
        end

        unless pending.empty?
          word << pending
          pending = +""
        end

        char_length = display_width(token)
        total_length += char_length

        if line_length + word_length + char_length <= wrap_at
          if token == SPACE || total_length == text_length
            line << word << pending << token
            line_length += word_length + char_length
            word = +""
            word_length = 0
          else
            word << pending << token
            word_length += char_length
          end
          pending = +""
          next
        end

        if token == SPACE
          lines << close_wrappers(line, wrappers)
          line = reopen_wrappers(wrappers)
          line_length = 0
          word << pending << token
          word_length = char_length
        elsif word_length + char_length <= wrap_at
          lines << close_wrappers(line, wrappers) if display_width(line).positive?
          line = reopen_wrappers(wrappers)
          line << word << pending << token
          line_length = word_length + char_length
          word = +""
          word_length = 0
        else
          lines << close_wrappers(word, wrappers)
          line = reopen_wrappers(wrappers)
          line_length = 0
          word = +"#{pending}#{token}"
          word_length = char_length
        end
        pending = +""
      end

      unless pending.empty?
        if word.empty?
          line << pending
        else
          word << pending
        end
      end

      lines << close_wrappers(line, wrappers) if display_width(line).positive?
      lines << close_wrappers(word, wrappers) unless word.empty?
      lines
    end
    module_function :format_line

    def update_wrappers!(wrappers, token)
      if Strings::ANSI.osc_8_close?(token)
        wrappers.reject! { |wrapper| wrapper[:kind] == :osc_8 }
      elsif Strings::ANSI.osc_8_open?(token)
        wrappers.reject! { |wrapper| wrapper[:kind] == :osc_8 }
        wrappers << { kind: :osc_8, open: token, close: Strings::ANSI.osc_8_close_for(token) }
      elsif Strings::ANSI.sgr_reset?(token)
        wrappers.reject! { |wrapper| wrapper[:kind] == :sgr }
      elsif Strings::ANSI.sgr?(token)
        sgr_wrapper = wrappers.find { |wrapper| wrapper[:kind] == :sgr }

        if sgr_wrapper
          sgr_wrapper[:open] << token
        else
          wrappers << { kind: :sgr, open: token.dup, close: Strings::ANSI::RESET }
        end
      end
    end
    module_function :update_wrappers!

    def close_wrappers(content, wrappers)
      return content if wrappers.empty?

      closing = wrappers.reverse.map { |wrapper| wrapper[:close] }.join
      return "#{content[0...-1]}#{closing}#{NEWLINE}" if content.end_with?(NEWLINE)

      "#{content}#{closing}"
    end
    module_function :close_wrappers

    def reopen_wrappers(wrappers)
      wrappers.map { |wrapper| wrapper[:open] }.join
    end
    module_function :reopen_wrappers
  end
end
