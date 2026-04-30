# frozen_string_literal: true

RSpec.describe "terminal sequence handling" do
  let(:osc_8_open) { "\e]8;;https://example.com\a" }
  let(:osc_8_close) { "\e]8;;\a" }
  let(:red) { "\e[31m" }
  let(:reset) { "\e[0m" }

  describe TTY::Table::Field do
    it "treats OSC 8 hyperlinks as zero-width for width and length" do
      field = described_class.new("#{osc_8_open}hello#{osc_8_close}")

      expect(field.width).to eq(5)
      expect(field.length).to eq(5)
    end

    it "treats terminal control sequences as zero-width for width and length" do
      field = described_class.new("\e]133;A\a#{red}hello#{reset}")

      expect(field.width).to eq(5)
      expect(field.length).to eq(5)
    end
  end

  describe TTY::Table::Operation::Wrapped do
    subject(:operation) { described_class.new([5]) }

    it "preserves SGR styling across wrapped lines" do
      field = TTY::Table::Field.new("#{red}helloworld#{reset}")

      expect(operation.call(field, 0, 0)).to eq("#{red}hello#{reset}\n#{red}world#{reset}")
    end

    it "preserves OSC 8 hyperlinks across wrapped lines" do
      field = TTY::Table::Field.new("#{osc_8_open}helloworld#{osc_8_close}")

      expect(operation.call(field, 0, 0)).to eq("#{osc_8_open}hello#{osc_8_close}\n"\
        "#{osc_8_open}world#{osc_8_close}")
    end

    it "preserves both hyperlinks and SGR styling across wrapped lines" do
      field = TTY::Table::Field.new("#{osc_8_open}#{red}helloworld#{reset}#{osc_8_close}")

      expect(operation.call(field, 0, 0)).to eq(
        "#{osc_8_open}#{red}hello#{reset}#{osc_8_close}\n"\
        "#{osc_8_open}#{red}world#{reset}#{osc_8_close}",
      )
    end
  end
end
