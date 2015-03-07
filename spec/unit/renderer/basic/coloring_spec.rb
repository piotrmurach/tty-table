# coding: utf-8

require 'spec_helper'

RSpec.describe TTY::Table::Renderer::Basic, 'coloring' do
  let(:clear)    { "\e[0m" }
  let(:color)    { Pastel.new(enabled: true) }

  before { allow(Pastel).to receive(:new).and_return(color) }

  context 'when border ' do
    it "doesn't color" do
      table = TTY::Table.new header: ['header1', 'header2']
      table << ['a1', 'a2']
      table << ['b1', 'b2']
      renderer = described_class.new(table)
      renderer.border = {style: :green}

      expect(renderer.render).to eql <<-EOS.normalize
        header1 header2
        a1      a2     
        b1      b2     
      EOS
    end
  end

  context 'when content' do

  end
end
