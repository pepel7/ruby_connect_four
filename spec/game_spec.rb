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

  describe '#user_input' do
    context 'when user inputs a valid input' do
      before do
        valid_input = '6'
        valid_index_integer = 5
        allow(game).to receive(:gets).and_return(valid_input)
        allow(game).to receive(:verify_input).with(valid_index_integer).and_return(valid_index_integer)
        allow(game).to receive(:puts)
      end

      it 'completes loop and does not throw input error' do
        error_message = "\e[0;31;49mInput error! Please enter a column number between 1 and 7 that is not completely filled in.\e[0m"
        expect(game).not_to receive(:puts).with(error_message)
        game.user_input
      end

      it 'returns correct input' do
        valid_index_integer = 5
        returned_input = game.user_input
        expect(returned_input).to eql(valid_index_integer)
      end
    end

    context 'when user inputs an incorrect value once, then a valid input' do
      before do
        invalid_input = 'six'
        valid_input = '6'
        valid_index_integer = 5
        allow(game).to receive(:gets).and_return(invalid_input, valid_input)
        allow(game).to receive(:verify_input).with(invalid_input).and_return(nil)
        allow(game).to receive(:verify_input).with(valid_index_integer).and_return(valid_index_integer)
        allow(game).to receive(:puts)
      end

      it 'completes loop and throws 1 input error' do
        error_message = "\e[0;31;49mInput error! Please enter a column number between 1 and 7 that is not completely filled in.\e[0m"
        expect(game).to receive(:puts).with(error_message).once
        game.user_input

        expect(game).not_to receive(:puts).with(error_message)
        game.user_input
      end

      it 'returns correct input' do
        valid_index_integer = 5
        returned_input = game.user_input
        expect(returned_input).to eql(valid_index_integer)
      end
    end
  end

  describe '#verify_input' do
    context 'when input is valid' do
      it 'returns input' do
        valid_input = 2
        verified_input = game.verify_input(valid_input)
        expect(verified_input).to eql(valid_input)
      end
    end

    context 'when input is invalid' do
      it 'returns nil' do
        invalid_input = 19
        verified_input = game.verify_input(invalid_input)
        expect(verified_input).to be_nil
      end
    end
  end
end

# rubocop:enable Metrics/BlockLength
