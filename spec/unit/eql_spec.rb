# frozen_string_literal: true

RSpec.describe TTY::Table, "#eql?" do
  let(:header) { %w[h1 h2] }
  let(:rows) { [%w[a1 a2], %w[b1 b2]] }

  describe "#==" do
    it "is equivalent with the same table" do
      object = described_class.new(rows)
      expect(object).to eq(object)
    end

    it "is equivalent with a table containing same data" do
      expect(described_class.new(header, rows)).
        to eq(described_class.new(header, rows))
    end

    it "is not equivalent with a table containing different data" do
      expect(described_class.new(%w[h1 h2], rows)).
        to_not eq(described_class.new(%w[h3 h4], rows))
    end

    it "is not equivalent to another type" do
      expect(described_class.new(rows)).to_not eq(:other)
    end
  end

  describe "#eql?" do
    it "is equal with the same table object" do
      object = described_class.new(rows)
      expect(object).to eql(object)
    end

    it "is equal with a table containing same data" do
      expect(described_class.new(header, rows)).
        to eql(described_class.new(header, rows))
    end

    it "is not equal with a table containing different data" do
      expect(described_class.new(header, rows)).
        to_not eql(described_class.new(%w[h3 h4], rows))
    end

    it "is not equal to another type" do
      expect(described_class.new(rows)).to_not eql(:other)
    end
  end

  describe "#inspect" do
    it "displays object information" do
      expect(described_class.new(rows).inspect).to match(/#<TTY::Table header=nil rows=\[(.*?)\] original_rows=nil original_columns=nil/)
    end
  end

  describe "#hash" do
    it "calculates object hash" do
      expect(described_class.new(rows).hash).to be_a_kind_of(Numeric)
    end
  end
end
