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
    context '#game_over is true' do
      before do
        allow(game).to receive(:puts)
        allow(game).to receive(:game_over?).and_return(true)
      end

      it 'does not call methods within' do
        expect(game).not_to receive(:play_move)
        expect(game).to receive(:puts).once
        expect(game).not_to receive(:check_for_win)
        expect(game).not_to receive(:check_for_tie)
        game.play_game
      end
    end

    context '#game_over is false' do
      before do
        allow(game).to receive(:puts)
        allow(game).to receive(:game_over?).and_return(false, true)
      end

      it 'does call methods within' do
        expect(game).to receive(:play_move)
        expect(game).to receive(:puts)
        expect(game).to receive(:check_for_win)
        expect(game).to receive(:check_for_tie)
        game.play_game
      end
    end
  end

  describe '#play_move' do
    context 'when input is valid' do
      input = '3'

      before do
        allow(game).to receive(:input_valid?).and_return(true)
        allow(game).to receive(:puts)
        allow(game).to receive(:gets).and_return(input)
        allow(game).to receive(:place_mark)
      end

      it 'loop ends after 1 try' do
        expect(game).to receive(:puts).once
        expect(game).to receive(:gets).and_return(input).once
        expect(game).to receive(:place_mark).once
        game.play_move(game.player_one)
      end

      it 'adds input to chosen_spots' do
        expect {game.play_move(game.player_one)}.to change { game.chosen_spots }.from([]).to([input])
      end

      it 'increases player turn count' do
        expect(game.player_one).to receive(:increase_turn_count)
        game.play_move(game.player_one)
      end

      it 'updates player mark history' do
        expect(game.player_one).to receive(:update_mark_history).with(input)
        game.play_move(game.player_one)
      end
    end

    context 'when input is invalid once' do
      input = 'r'

      before do
        allow(game).to receive(:input_valid?).and_return(false, false, true)
        allow(game).to receive(:puts)
        allow(game).to receive(:gets).and_return(input)
        allow(game).to receive(:place_mark)
      end

      it 'runs loop twice' do
        expect(game).to receive(:input_valid?).exactly(3).times
        game.play_move(game.player_one)
      end
    end

    context 'when input is invalid twice' do
      input = 'r'

      before do
        allow(game).to receive(:input_valid?).and_return(false, false, false, true)
        allow(game).to receive(:puts)
        allow(game).to receive(:gets).and_return(input)
        allow(game).to receive(:place_mark)
      end

      it 'runs loop three times' do
        expect(game).to receive(:input_valid?).exactly(4).times
        game.play_move(game.player_one)
      end
    end
  end

  describe '#input_valid?' do
    context 'input is an unchosen board location' do
      it 'returns true' do
        result = game.input_valid?('3')
        expect(result).to be(true)
      end
    end

    context 'input is a chosen board location' do
      before do
        allow(game).to receive(:puts)
        game.chosen_spots = ['3']
      end

      it 'does not return true' do
        result = game.input_valid?('3')
        expect(result).not_to be(true)
      end
    end

    context 'input is not a number' do
      before do
        allow(game).to receive(:puts)
      end

      it 'does not return true' do
        result = game.input_valid?('d')
        expect(result).not_to be(true)
      end
    end
  end

  describe '#check_for_win' do
    context 'when row is won' do
      before do
        allow(game).to receive(:puts)
        game.player_one.marked_locations = %w[1 2 3]
      end

      it 'changes game.game_over to true' do
        expect { game.check_for_win(game.player_one) }.to change { game.game_over }.from(false).to(true)
      end
    end

    context 'when diagonal is won' do
      before do
        allow(game).to receive(:puts)
        game.player_one.marked_locations = %w[9 1 5]
      end

      it 'changes game.game_over to true' do
        expect { game.check_for_win(game.player_one) }.to change { game.game_over }.from(false).to(true)
      end
    end

    context 'when column is won' do
      before do
        allow(game).to receive(:puts)
        game.player_one.marked_locations = %w[7 4 2 6 1]
      end

      it 'changes game.game_over to true' do
        expect { game.check_for_win(game.player_one) }.to change { game.game_over }.from(false).to(true)
      end
    end

    context 'no winning condition is met' do
      before do
        game.player_one.marked_locations = %w[6 1 7 9]
      end

      it 'does not change game.game_over' do
        expect { game.check_for_win(game.player_one) }.not_to change { game.game_over }
      end
    end
  end

  describe '#check_for_tie' do
    context 'when there is a cats game' do
      before do
        game.player_one.marked_locations = %w[6 1 7 9]
        game.player_two.marked_locations = %w[6 1 7 9]
        game.chosen_spots = %w[6 1 7 9 3 2 5 4 8]
        allow(game).to receive(:puts)
      end

      it 'changes game.game_over to true' do
        expect {game.check_for_tie}.to change {game.game_over}.from(false).to(true)
      end
    end

    context 'when there is no cats game' do
      before do
        game.player_one.marked_locations = %w[6 1 7 9]
        game.player_two.marked_locations = %w[6 1 7 9]
        game.chosen_spots = %w[6 1 7 9 3 2 4 8]
      end

      it 'game_over does not change' do
        expect {game.check_for_tie}.not_to change {game.game_over}
      end
    end
  end
end
