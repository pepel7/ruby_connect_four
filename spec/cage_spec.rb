# frozen_string_literal: true

# rubocop:disable Metrics/BlockLength

require_relative '../lib/cage'
require_relative '../lib/game'

describe Cage do
  let(:game) { double(Game) }
  subject(:cage) { described_class.new(game) }
end

# rubocop:enable Metrics/BlockLength
