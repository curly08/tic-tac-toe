# frozen_string_literal: true

# player with name and mark attributes
class Player
  def initialize(name)
    @name = name
    @mark = nil
  end

  def set_mark(value)
    @mark = value
  end
end