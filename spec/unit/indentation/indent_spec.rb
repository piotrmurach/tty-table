# frozen_string_literal: true

RSpec.describe TTY::Table::Indentation, '.indent' do
  context 'when enumerable' do
    it 'inserts indentation for each element' do
      expect(described_class.indent(['line1'], 2)).to eql(['  line1'])
    end

    it "inserts indentation for each line within an element" do
      expect(described_class.indent(["line1\nline2", nil, ""], 2)).
        to eql(["  line1\n  line2", "", "  "])
    end
  end

  context 'when string' do
    it 'inserts indentation' do
      expect(described_class.indent('line1', 2)).to eql('  line1')
    end

    it "inserts indentation for an empty string" do
      expect(described_class.indent("", 2)).to eql("  ")
    end

    it "inserts indentation for each line" do
      expect(described_class.indent("line1\nline2", 2)).
        to eql("  line1\n  line2")
    end

    it "preserves a trailing newline" do
      expect(described_class.indent("line1\n", 2)).to eql("  line1\n")
    end

    it "inserts indentation for blank lines" do
      expect(described_class.indent("line1\n\nline3", 2)).
        to eql("  line1\n  \n  line3")
    end
  end

  context "when missing" do
    it "returns an empty string for nil" do
      expect(described_class.indent(nil, 2)).to eql("")
    end

    it "returns an empty string for false" do
      expect(described_class.indent(false, 2)).to eql("")
    end
  end
end
