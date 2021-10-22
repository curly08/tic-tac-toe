# frozen_string_literal: true

require_relative '../lib/player'
require_relative '../lib/board'

# Game class
class TicTacToe
  attr_reader :player_one, :player_two, :board

  def initialize(first_player_name, second_player_name)
    @arr = [first_player_name, second_player_name].shuffle!
    @player_one = Player.new(@arr[0], 'X')
    @player_two = Player.new(@arr[1], 'O')
    @board = Board.new

    @possible_inputs = {
      'top left': 1, 'top middle': 5, 'top right': 9,
      'middle left': 13, 'middle middle': 17, 'middle right': 21,
      'bottom left': 25, 'bottom middle': 29, 'bottom right': 33
    }
  end

  def play_game
    puts board.display
    until game_over? do
      player_one.turn_count == player_two.turn_count ? player_one.play_move : player_two.play_move
      puts board.update_display
    end
    ending_message
  end

  # move method
  def play_move(name, mark)
    puts "#{name}, where would you like to place your mark?"
    @input = gets.chomp.strip
    place_mark(@input, mark)
    puts show_board
    check_for_win(name, mark)
  end

  def place_mark(input, mark)
    if @possible_inputs.include?(input.to_sym)
      @possible_inputs.each_pair do |possible_input, index|
        if input == possible_input.to_s
          @board.delete_at(index)
          @board.insert(index, mark)
          @possible_inputs.delete(possible_input)
          break
        end
      end
    else
      invalid_input(mark)
    end
  end

  def invalid_input(mark)
    puts "Invalid input. Try something like #{@possible_inputs.keys.sample(1).to_s.tr('[:]', '')}"
    @input = gets.chomp.strip
    place_mark(@input, mark)
  end

  def check_for_win(name, mark)
    @winning_scenarios = [
      [@board.at(1), @board.at(5), @board.at(9)],
      [@board.at(13), @board.at(17), @board.at(21)],
      [@board.at(25), @board.at(29), @board.at(33)],
      [@board.at(1), @board.at(13), @board.at(25)],
      [@board.at(5), @board.at(17), @board.at(29)],
      [@board.at(9), @board.at(21), @board.at(33)],
      [@board.at(1), @board.at(17), @board.at(33)],
      [@board.at(9), @board.at(17), @board.at(25)]
    ]

    @winning_scenarios.each do |scenario|
      if scenario.all?(mark)
        puts "Congrats, #{name}"
        @game_over = true
      end
    end
  end

  def game_over?

  end

  def ending_message

  end

  def show_board
    @board.join
  end
end
