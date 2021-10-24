# frozen_string_literal: true

# rubocop:disable all

require_relative '../lib/app'
require_relative '../lib/player'

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

describe TicTacToe do
  let(:player_one) { instance_double(Player) }
  let(:player_two) { instance_double(Player) }
  subject(:game) { described_class.new(player_one, player_two) }

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
        expect(game).not_to receive(:play_move)
        expect(game.board).not_to receive(:update_display)
        game.play_game
      end
    end
  end

  describe '#play_move' do
    context 'when input is valid' do
      input = '3'

      before do
        allow(game).to receive(:input_valid?).and_return(false, true)
        allow(game).to receive(:puts)
        allow(game).to receive(:gets).and_return(input)
      end

      it 'loop ends after 1 try' do
        expect(game).to receive(:puts).once
        expect(game).to receive(:gets).and_return(input).once
        game.play_move(game.player_one)
      end


      it 'adds input to chosen_spots' do
        expect {game.play_move(game.player_one)}.to change { game.chosen_spots }.from([]).to([input])
      end

      it 'increases player turn count' do
        expect(game.player_one).to receive(:increase_turn_count)
        game.play_move(game.player_one)
      end
    end

    context 'when input is invalid once' do
      input = 'r'

      before do
        allow(game).to receive(:input_valid?).and_return(false, false, true)
        allow(game).to receive(:puts)
        allow(game).to receive(:gets).and_return(input)
      end

      it 'runs loop twice' do
        expect(game).to receive(:input_valid?).exactly(3).times
        game.play_move(game.player_one)
      end

      it 'does not increase player turn_count' do
        expect(game.player_one).to receive(:increase_turn_count)
        game.play_move(game.player_one)
      end
    end

    context 'when input is invalid twice' do
      input = 'r'

      before do
        allow(game).to receive(:input_valid?).and_return(false, false, false, true)
        allow(game).to receive(:puts)
        allow(game).to receive(:gets).and_return(input)
      end

      it 'runs loop three times' do
        expect(game).to receive(:input_valid?).exactly(4).times
        game.play_move(game.player_one)
      end
    end
  end

  describe '#input_valid?' do
    context 'input is valid' do
      it 'returns true' do
        
      end
    end

    context 'input is invalid' do
      it 'returns false' do
        
      end
    end
  end
end
