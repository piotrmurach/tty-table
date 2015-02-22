# coding: utf-8

require 'spec_helper'

RSpec.describe TTY::Table::Indentation, '.indent' do
  let(:indent) { 2 }

  subject(:indentation) { described_class.new(indent) }

  context 'when enumerable' do
    it 'inserts indentation for each element' do
      expect(indentation.indent(['line1'])).to eql(['  line1'])
    end
  end

  context 'when string' do
    it 'inserts indentation' do
      expect(indentation.indent('line1')).to eql('  line1')
    end
  end
end
