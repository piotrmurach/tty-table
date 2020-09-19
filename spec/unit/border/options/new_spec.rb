# frozen_string_literal: true

RSpec.describe TTY::Table::BorderOptions, "#new" do
  it "defaults characters to an empty hash" do
    expect(described_class.new.characters).to eq({})
  end

  it "sets characters option" do
    border_options = described_class.new(characters: {top: "**"})
    expect(border_options.characters).to eq({top: "**"})
  end

  it "defaulats separator to nil" do
    expect(described_class.new.separator).to eq(nil)
  end

  it "sets separator to a value" do
    border_options = described_class.new(separator: :each_row)
    expect(border_options.separator).to eq(:each_row)
  end

  it "defaults border style to nil" do
    expect(described_class.new.style).to eq(nil)
  end

  it "sets border style to a value" do
    border_options = described_class.new(style: :red)
    expect(border_options.style).to eq(:red)
  end
end
