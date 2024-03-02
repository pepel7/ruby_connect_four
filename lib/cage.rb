# frozen_string_literal: true

require 'colorize'

class Cage
  attr_reader :grid, :game

  NEIGHBORS = [
    [0, +1], [+1, +1], [+1, 0], [+1, -1], [0, -1], [-1, -1], [-1, 0], [-1, +1]
  ].freeze

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

  def full?
    grid.all? { |column| column.all? { |cell| cell != '○' } }
  end

  def put_piece(column, color)
    first_empty_cell = grid[column].index('○')
    grid[column][first_empty_cell] = "\e[0;#{color};49m●\e[0m"
  end

  def not_full_column?(column)
    grid[column].any? { |cell| empty_cell?(cell) }
  end

  def game_over? # rubocop:disable Metrics/MethodLength
    grid.each do |column|
      column.each do |cell|
        beginning_coords = [grid.index(column), column.index(cell)]
        combo_color = cell[4..5]
        NEIGHBORS.each do |shift|
          if find_next_in_combo(1, beginning_coords, shift, combo_color)
            game.update_winner(combo_color)
            return true
          end
        end
      end
    end
    false
  end

  private

  def display_row(row) # rubocop:disable Metrics/AbcSize
    "#{grid[0][row]} #{grid[1][row]} #{grid[2][row]} #{grid[3][row]} #{grid[4][row]} #{grid[5][row]} #{grid[6][row]}"
  end

  def column_numbers
    (1..7).to_a.join(' ').gray
  end

  def empty_cell?(cell)
    cell == '○'
  end

  def find_next_in_combo(combo_count, current_coords, shift, combo_color)
    return true if combo_count == 4

    next_coords = [current_coords[0] + shift[0], current_coords[1] + shift[1]]
    next_cell = grid[next_coords[0]][next_coords[1]] unless off?(next_coords)
    next_cell_color = next_cell&.slice(4..5)
    return unless same_color?(next_cell_color, combo_color)

    combo_count += 1
    find_next_in_combo(combo_count, next_coords, shift, combo_color)
  end

  def off?(coord_pair)
    coord_pair.any? { |coord| !coord.between?(0, 6) }
  end

  def same_color?(first_color, second_color)
    first_color == second_color unless first_color.nil? || second_color.nil?
  end
end
