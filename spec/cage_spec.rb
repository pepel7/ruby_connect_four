# frozen_string_literal: true

# rubocop:disable Metrics/BlockLength

require_relative '../lib/cage'
require_relative '../lib/game'

describe Cage do
  let(:game) { double(Game) }
  subject(:cage) { described_class.new(game) }

  before do
    allow(game).to receive(:update_winner)
  end

  describe '#full?' do
    context 'when grid is empty' do
      it 'returns false' do
        expect(cage).not_to be_full
      end
    end

    context 'when grid is slightly filled' do
      before do
        cage.instance_variable_set(:@grid, [
          ["\e[0;34;49m●\e[0m", '○', '○', '○', '○', '○'],
          ['○', '○', '○', '○', '○', '○'],
          ["\e[0;34;49m●\e[0m", '○', '○', '○', '○', '○'],
          ['○', '○', '○', '○', '○', '○'],
          ['○', '○', '○', '○', '○', '○'],
          ["\e[0;34;49m●\e[0m", '○', '○', '○', '○', '○'],
          ['○', '○', '○', '○', '○', '○']
                                           ])
      end

      it 'returns false' do
        expect(cage).not_to be_full
      end
    end

    context 'when grid is full' do
      before do
        cage.instance_variable_set(:@grid, Array.new(7) { Array.new(6) { "\e[0;34;49m●\e[0m" } })
      end

      it 'returns true' do
        expect(cage).to be_full
      end
    end
  end

  describe '#put_piece' do
    context 'when there is an empty cell in the column for a piece' do
      it 'puts piece' do
        column_to_put = 5
        color_to_put = 40
        # old_piece = cage.grid[column_to_put][0]
        cage.put_piece(column_to_put, color_to_put)
        new_piece = cage.grid[column_to_put][0]
        expect(new_piece).to eql("\e[0;40;49m●\e[0m")
      end
    end
  end

  describe '#not_full_column?' do
    context 'when it is a full column' do
      before do
        cage.instance_variable_set(:@grid, [
          ["\e[0;34;49m●\e[0m", "\e[0;34;49m●\e[0m", "\e[0;34;49m●\e[0m", "\e[0;34;49m●\e[0m", "\e[0;34;49m●\e[0m", "\e[0;34;49m●\e[0m"],
          ['○', '○', '○', '○', '○', '○'],
          ['○', '○', '○', '○', '○', '○'],
          ['○', '○', '○', '○', '○', '○'],
          ['○', '○', '○', '○', '○', '○'],
          ['○', '○', '○', '○', '○', '○'],
          ['○', '○', '○', '○', '○', '○']
                                           ])
      end

      it 'returns false' do
        full_column = cage.not_full_column?(0)
        expect(full_column).to be false
      end
    end

    context 'when it is not a full column' do
      before do
        cage.instance_variable_set(:@grid, [
          ["\e[0;34;49m●\e[0m", '○', '○', '○', '○', '○'],
          ['○', '○', '○', '○', '○', '○'],
          ['○', '○', '○', '○', '○', '○'],
          ['○', '○', '○', '○', '○', '○'],
          ['○', '○', '○', '○', '○', '○'],
          ['○', '○', '○', '○', '○', '○'],
          ['○', '○', '○', '○', '○', '○']
                                           ])
      end

      it 'returns true' do
        full_column = cage.not_full_column?(0)
        expect(full_column).to be true
      end
    end
  end

  describe '#game_over?' do
    context 'when grid is empty' do
      it 'is not game over' do
        expect(cage).not_to be_game_over
      end
    end

    context 'when grid is slightly filled' do
      before do
        cage.instance_variable_set(:@grid, [
          ["\e[0;34;49m●\e[0m", '○', '○', '○', '○', '○'],
          ["\e[0;33;49m●\e[0m", "\e[0;33;49m●\e[0m", '○', '○', '○', '○'],
          ["\e[0;34;49m●\e[0m", '○', '○', '○', '○', '○'],
          ["\e[0;33;49m●\e[0m", "\e[0;33;49m●\e[0m", '○', '○', '○', '○'],
          ["\e[0;34;49m●\e[0m", '○', '○', '○', '○', '○'],
          ["\e[0;33;49m●\e[0m", "\e[0;33;49m●\e[0m", '○', '○', '○', '○'],
          ["\e[0;34;49m●\e[0m", '○', '○', '○', '○', '○']
                                           ])
      end

      it 'is not game over' do
        expect(cage).not_to be_game_over
      end
    end

    context 'when grid has a horizontal 4-in-a-row' do
      before do
        cage.instance_variable_set(:@grid, [
          ["\e[0;34;49m●\e[0m", '○', '○', '○', '○', '○'],
          ["\e[0;33;49m●\e[0m", "\e[0;33;49m●\e[0m", '○', '○', '○', '○'],
          ["\e[0;33;49m●\e[0m", '○', '○', '○', '○', '○'],
          ["\e[0;33;49m●\e[0m", "\e[0;33;49m●\e[0m", '○', '○', '○', '○'],
          ["\e[0;33;49m●\e[0m", '○', '○', '○', '○', '○'],
          ["\e[0;34;49m●\e[0m", "\e[0;34;49m●\e[0m", "\e[0;34;49m●\e[0m", '○', '○', '○'],
          ["\e[0;34;49m●\e[0m", '○', '○', '○', '○', '○']
                                            ])
      end

      it 'is game over' do
        expect(cage).to be_game_over
      end
    end

    context 'when grid has a vertical 4-in-a-row' do
      before do
        cage.instance_variable_set(:@grid, [
          ["\e[0;34;49m●\e[0m", '○', '○', '○', '○', '○'],
          ["\e[0;33;49m●\e[0m", "\e[0;33;49m●\e[0m", '○', '○', '○', '○'],
          ["\e[0;33;49m●\e[0m", '○', '○', '○', '○', '○'],
          ["\e[0;34;49m●\e[0m", "\e[0;33;49m●\e[0m", '○', '○', '○', '○'],
          ['○', '○', '○', '○', '○', '○'],
          ["\e[0;34;49m●\e[0m", "\e[0;34;49m●\e[0m", "\e[0;34;49m●\e[0m", "\e[0;34;49m●\e[0m", '○', '○'],
          ["\e[0;34;49m●\e[0m", '○', '○', '○', '○', '○']
                                            ])
      end

      it 'is game over' do
        expect(cage).to be_game_over
      end
    end

    context 'when grid has a diagonal 4-in-a-row' do
      before do
        cage.instance_variable_set(:@grid, [
          ["\e[0;34;49m●\e[0m", '○', '○', '○', '○', '○'],
          ["\e[0;33;49m●\e[0m", "\e[0;34;49m●\e[0m", '○', '○', '○', '○'],
          ["\e[0;33;49m●\e[0m", "\e[0;33;49m●\e[0m", "\e[0;34;49m●\e[0m", '○', '○', '○'],
          ["\e[0;33;49m●\e[0m", "\e[0;33;49m●\e[0m", "\e[0;33;49m●\e[0m", "\e[0;34;49m●\e[0m", '○', '○'],
          ['○', '○', '○', '○', '○', '○'],
          ['○', '○', '○', '○', '○', '○'],
          ['○', '○', '○', '○', '○', '○']
                                            ])
      end

      it 'is game over' do
        expect(cage).to be_game_over
      end

      it 'sends #update_winner' do
        expect(game).to receive(:update_winner)
        cage.game_over?
      end
    end
  end
end

# rubocop:enable Metrics/BlockLength
