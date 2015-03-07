# coding: utf-8

require 'spec_helper'

RSpec.describe TTY::Table::Renderer::Unicode, 'coloring' do

  let(:color)  { Pastel.new(enabled: true) }

  before { allow(Pastel).to receive(:new).and_return(color) }

  context 'when border' do
    it "colors border" do
      table = TTY::Table.new header: ['header1', 'header2']
      table << ['a1', 'a2']
      table << ['b1', 'b2']
      renderer = described_class.new(table)
      renderer.border = {style: :green }

      expect(renderer.render).to eq <<-EOS.normalize
        #{color.green('┌───────┬───────┐')}
        #{color.green('│')}header1#{color.green('│')}header2#{color.green('│')}
        #{color.green('├───────┼───────┤')}
        #{color.green('│')}a1     #{color.green('│')}a2     #{color.green('│')}
        #{color.green('│')}b1     #{color.green('│')}b2     #{color.green('│')}
        #{color.green('└───────┴───────┘')}
      EOS
    end
  end

  context 'when content' do

  end
end
