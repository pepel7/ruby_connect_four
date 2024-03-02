# frozen_string_literal: true

require 'colorize'

class Cage
  attr_reader :grid, :game

  def initialize(game)
    @grid = Array.new(7) { Array.new(6) { '○' } } # 7 colums, 6 rows
    @game = game
  end

  def show
    puts <<-HEREDOC
      ┌───────────────┐
      │ #{display_row(5)} │
      │ #{display_row(4)} │
      │ #{display_row(3)} │
      │ #{display_row(2)} │
      │ #{display_row(1)} │
      │ #{display_row(0)} │
      └───────────────┘
        #{column_numbers}
    HEREDOC
  end

  private

  def display_row(row) # rubocop:disable Metrics/AbcSize
    "#{grid[0][row]} #{grid[1][row]} #{grid[2][row]} #{grid[3][row]} #{grid[4][row]} #{grid[5][row]} #{grid[6][row]}"
  end

  def column_numbers
    (1..7).to_a.join(' ').gray
  end
end
