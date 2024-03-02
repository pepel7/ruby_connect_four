# frozen_string_literal: true

require_relative '../lib/game'
require_relative '../lib/cage'

# rubocop:disable Metrics/BlockLength

describe Game do
  subject(:game) { described_class.new }

  describe '#update_winner' do
    it 'updates @winner' do
      new_winner_color = 'yellow'

      expect { game.update_winner(new_winner_color) }.to change { game.winner }.to(new_winner_color)
    end
  end
end

# rubocop:enable Metrics/BlockLength
