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

  describe '#turns' do
    context 'when game is ended in 4 turns' do
      before do
        allow(game.cage).to receive(:game_over?).and_return(false, false, false, false, true)
        allow(game.cage).to receive(:show)
        allow(game).to receive(:put_user_piece)
        allow(game).to receive(:put_computer_piece)
      end

      it 'sends put_user_piece 4 times' do
        expect(game).to receive(:put_user_piece).exactly(4).times
        game.turns
      end

      it 'sends put_computer_piece 4 times' do
        expect(game).to receive(:put_computer_piece).exactly(4).times
        game.turns
      end
    end
  end
end

# rubocop:enable Metrics/BlockLength
