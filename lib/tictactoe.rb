# frozen_string_literal: false

require_relative '../lib/player'

# Game class
class TicTacToe
  attr_accessor :chosen_spots, :board_display, :game_over
  attr_reader :player_one, :player_two

  def initialize(first_player_name, second_player_name)
    @arr = [first_player_name, second_player_name].shuffle!
    @player_one = Player.new(@arr[0], 'X')
    @player_two = Player.new(@arr[1], 'O')
    @board_display = " 1 | 2 | 3 \n---+---+---\n 4 | 5 | 6 \n---+---+---\n 7 | 8 | 9 "
    @winning_scenarios = [
      %w[1 2 3],
      %w[4 5 6],
      %w[7 8 9],
      %w[1 4 7],
      %w[2 5 8],
      %w[3 6 9],
      %w[1 5 9],
      %w[3 5 7]
    ]
    @chosen_spots = []
    @game_over = false
  end

  def play_game
    puts board_display
    until game_over?
      current_player = player_one.turn_count == player_two.turn_count ? player_one : player_two
      play_move(current_player)
      puts board_display
      check_for_win(current_player)
      check_for_tie
    end
  end

  def play_move(player)
    puts "#{player.name}, where would you like to place your mark?"
    input = gets.chomp
    input = gets.chomp until input_valid?(input)
    place_mark(player, input)
    chosen_spots << input
    player.update_mark_history(input)
    player.increase_turn_count
  end

  def input_valid?(input)
    return true if input.to_i.between?(1, 9) && !chosen_spots.include?(input)

    puts "Invalid input. Select an open spot like #{%w[1 2 3 4 5 6 7 8 9].reject { |num| chosen_spots.include?(num) }}"
  end

  def place_mark(player, input)
    @board_display.gsub!(input, player.mark)
  end

  def check_for_win(player)
    @winning_scenarios.any? do |winning_scenario|
      if (winning_scenario - player.marked_locations).empty?
        puts "Congratulations, #{player.name}! You won!"
        @game_over = true
      end
    end
  end

  def check_for_tie
    return unless (%w[1 2 3 4 5 6 7 8 9] - chosen_spots).empty?

    puts "Cat's game!"
    @game_over = true
  end

  def game_over?
    @game_over
  end
end
