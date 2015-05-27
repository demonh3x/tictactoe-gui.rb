require 'tictactoe/gui/human_player'

RSpec.describe Tictactoe::Gui::HumanPlayer do
  class FakeGui
    attr_accessor :callback

    def send_move_event(move)
      callback.call(move)
    end

    def on_move(callback)
      self.callback = callback
    end
  end

  let(:mark)   { :mark }
  let(:player) { described_class.new(mark) }
  let(:state)  { :ignored_state }
  let(:gui)    { FakeGui.new }

  it 'returns the received move' do
    player.has_moved_to(3)
    expect(player.get_move(state)).to eq(3)
  end

  it 'returns nil when getting more moves than received' do
    player.has_moved_to(4)
    player.get_move(state)
    expect(player.get_move(state)).to be_nil
  end

  it 'returns the mark' do
    expect(player.mark).to eq(mark)
  end

  it 'registers a callback on gui' do
    player.receive_moves_from(gui)
    expect(gui.callback).to eq(player.method(:has_moved_to))
  end

  it 'returns itself after registering a callback on gui' do
    actual_self = player.receive_moves_from(gui)
    expect(actual_self).to eq(player)
  end
end
