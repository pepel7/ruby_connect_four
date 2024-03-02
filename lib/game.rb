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

  def play
    instruduction
    cage.show
    turns
    conclusion
  end

  def turns
    until cage.game_over?
      put_user_piece
      put_computer_piece
      cage.show
      break if cage.full?
    end
  end

  private

  def instruduction
    puts 'Welcome to the game Connect Four!'
    puts 'To win, you need to put your pieces in a horizontal, vertical'
    puts 'or diagonal 4-in-row. Your pieces are yellow. Good luck!'
  end

  def put_user_piece
    column_index = user_input
    cage.put_piece(column_index, '33')
  end

  def put_computer_piece
    column_index = rand(0..6)
    cage.put_piece(column_index, '34')
  end

  def conclusion
    if winner
      winner = @winner == '33' ? 'Yellow' : 'Blue'
      puts "Gameover! #{winner} wins!"
    elsif cage.full?
      puts 'A draw!'
    end
  end
end
