# frozen_string_literal: true

RSpec.describe TTY::Table, '#rotate' do
  let(:header) { ['h1', 'h2', 'h3', 'h4', 'h5'] }
  let(:rows) { [['a1', 'a2', 'a3', 'a4', 'a5'], ['b1', 'b2', 'b3', 'b4', 'b5']] }

  subject(:table) { described_class.new(header, rows) }

  before { table.orientation = :horizontal }

  context 'with default' do
    context 'without header' do
      let(:header) { nil }

      it 'preserves orientation' do
        expect(table.header).to be_nil
        expect(table.rotate.to_a).to eql rows
      end
    end

    context 'with header' do
      it 'preserves orientation' do
        expect(table.rotate.to_a).to eql [header] + rows
      end
    end
  end

  context 'with no header' do
    let(:header) { nil }

    it 'rotates the rows' do
      table.orientation = :vertical
      expect(table.rotate.to_a).to eql [
        ['1', 'a1'],
        ['2', 'a2'],
        ['3', 'a3'],
        ['4', 'a4'],
        ['5', 'a5'],
        ['1', 'b1'],
        ['2', 'b2'],
        ['3', 'b3'],
        ['4', 'b4'],
        ['5', 'b5']
      ]
      expect(table.header).to be_nil
    end

    it 'rotates the rows back' do
      table.orientation = :vertical
      table.rotate
      table.orientation = :horizontal
      expect(table.rotate.to_a).to eql rows
      expect(table.header).to eql header
    end

    it 'rotates the output' do
      expect(table.to_s).to eq("a1 a2 a3 a4 a5\nb1 b2 b3 b4 b5")
      table.orientation = :vertical
      table.rotate
      expect(table.to_s).to eq("1 a1\n2 a2\n3 a3\n4 a4\n5 a5\n1 b1\n2 b2\n3 b3\n4 b4\n5 b5")
    end
  end

  context 'with header' do
    it 'rotates the rows and merges header' do
      table.orientation = :vertical
      expect(table.rotate.to_a).to eql [
        ['h1', 'a1'],
        ['h2', 'a2'],
        ['h3', 'a3'],
        ['h4', 'a4'],
        ['h5', 'a5'],
        ['h1', 'b1'],
        ['h2', 'b2'],
        ['h3', 'b3'],
        ['h4', 'b4'],
        ['h5', 'b5']
      ]
      expect(table.header).to be_empty
    end

    it 'rotates the rows and header back' do
      table.orientation = :vertical
      table.rotate
      expect(table.orientation).to be_a TTY::Table::Orientation::Vertical

      table.orientation = :horizontal
      expect(table.rotate.to_a).to eql [header] + rows
      expect(table.header).to eql header
    end
  end
end
