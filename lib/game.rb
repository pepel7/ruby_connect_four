# frozen_string_literal: true

require_relative 'player'
require_relative 'cage'

class Game
  attr_reader :computer, :user, :cage, :winner

  def initialize
    @computer = Player.new(34) # blue
    @user = Player.new(33) # yellow
    @cage = Cage.new(self)
  end

  def update_winner(color)
    @winner = color
  end
end
