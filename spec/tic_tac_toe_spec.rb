# frozen_string_literal: true

require_relative '../lib/app'
require_relative '../lib/player'

describe TicTacToe do

end

describe Player do
  subject(:player) { described_class.new('Matt') }

  describe '#initialize' do
    context 'when class is initialized with the name matt' do
      it 'returns player with matt in name attribute' do
        name = player.instance_variable_get(:@name)
        expect(name).to eq('Matt')
      end

      it 'returns player with nil mark' do
        mark = player.instance_variable_get(:@mark)
        expect(mark).to be_nil
      end
    end
  end

  describe '#set_mark' do
    context 'when set_mark is called on player with value' do
      it 'changes mark attribute to value' do
        value = 'X'
        expect { player.set_mark(value) }.to change { player.instance_variable_get(:@mark) }.from(nil).to(value)
      end
    end
  end
end
