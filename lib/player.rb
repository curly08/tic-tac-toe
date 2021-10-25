# frozen_string_literal: true

# player with name and mark attributes
class Player
  attr_accessor :marked_locations
  attr_reader :name, :mark, :turn_count

  def initialize(name, mark)
    @name = name
    @mark = mark
    @turn_count = 0
    @marked_locations = []
  end

  def increase_turn_count
    @turn_count += 1
  end

  def update_mark_history(input)
    marked_locations << input
  end
end
