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

  class FakeState
    attr_reader :available_moves

    def initialize(available_moves)
      @available_moves = available_moves 
    end
  end

  let(:mark)   {:mark}
  let(:gui)    {FakeGui.new}
  let(:player) {described_class.new(mark).register_to(gui)}
  let(:state)  {FakeState.new([1, 2, 3])}

  it 'registers a callback on gui' do
    player
    expect(gui.callback).to eq(player.method(:on_move))
  end

  it 'returns the move from the gui' do
    player
    gui.send_move_event(3)
    expect(player.get_move(state)).to eq(3)
  end

  it 'does not return a previous move' do
    player
    gui.send_move_event(4)
    player.get_move(state)
    expect(player.get_move(state)).to be_nil
  end

  it 'returns the mark' do
    expect(player.mark).to eq(mark)
  end
end
