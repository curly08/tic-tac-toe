# frozen_string_literal: true

require_relative '../lib/app'
require_relative '../lib/player'

describe TicTacToe do
  subject(:game) { described_class.new('Matt', 'Gary') }

  describe '#initialize' do
    context 'when players are set' do
      it 'creates players with appropriate marks' do
        player_one_mark = game.player_one.mark
        player_two_mark = game.player_two.mark
        expect(player_one_mark).to eq('X')
        expect(player_two_mark).to eq('O')
      end
    end
  end

  describe '#play_game' do
    context 'game_over is true' do

      before do
        allow(game).to receive(:puts).and_return(game.board.display)
        allow(game).to receive(:game_over?).and_return(true)
      end

      it 'calls #ending_message' do
        expect(game).to receive(:ending_message)
        game.play_game
      end

      it 'does not call play_move or update_display' do
        expect(game.player_one).not_to receive(:play_move)
        expect(game.board).not_to receive(:update_display)
        game.play_game
      end
    end
  end
end

describe Player do
  subject(:player) { described_class.new('Matt', 'X') }

  describe '#initialize' do
    context 'when class is initialized with the name matt' do
      it 'returns player with matt in name attribute' do
        name = player.instance_variable_get(:@name)
        expect(name).to eq('Matt')
      end

      it 'returns player with X mark' do
        mark = player.instance_variable_get(:@mark)
        expect(mark).to eq('X')
      end
    end
  end
end
