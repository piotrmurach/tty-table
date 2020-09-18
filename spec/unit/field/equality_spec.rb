# frozen_string_literal: true

RSpec.describe TTY::Table::Field, "equality" do
  let(:value) { "1" }
  let(:object) { described_class.new(value) }

  describe "#==" do
    it "is equal with the same object" do
      expect(object).to eq(object)
    end

    it "is equal with an quivalent object" do
      expect(object).to eq(object.dup)
    end

    it "is equal with an equivalent object of subclass" do
      other = Class.new(described_class).new(value)
      expect(object).to eq(other)
    end

    it "isn't equal with an object having a dirrent value" do
      other = described_class.new("2")
      expect(object).to_not eq(other)
    end
  end

  describe "#eql" do
    it "is equal with the same object" do
      expect(object).to eql(object)
    end

    it "is equal with an quivalent object" do
      expect(object).to eql(object.dup)
    end

    it "is equal with an equivalent object of subclass" do
      other = described_class.new(value)
      expect(object).to eql(other)
    end

    it "isn't equal with an object having a dirrent value" do
      other = described_class.new("2")
      expect(object).to_not eql(other)
    end
  end

  describe "#inspect" do
    it "displays object information" do
      expect(object.inspect).to eq("#<TTY::Table::Field value=\"1\" " \
                                   "rowspan=1 colspan=1>")
    end
  end

  describe "#hash" do
    it "calculates object hash" do
      expect(object.hash).to be_a_kind_of(Numeric)
    end
  end
end
