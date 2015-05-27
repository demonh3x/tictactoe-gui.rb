require 'tictactoe/gui/game_updater'

module Mock
  class Game
    attr_accessor :on_tick, :state

    def initialize
      self.on_tick = lambda{|game|}
    end
   
    def tick
      on_tick.call(self)
      @has_received_tick = true
    end

    def has_received_tick?
      @has_received_tick
    end
  end

  class Gui
    def initialize
      @update_count = 0
    end

    def update(state)
      @updated_with = state
      @update_count += 1
    end

    def has_been_updated_with?(expected_state)
      @updated_with == expected_state
    end

    def has_been_updated_only_once?
      @update_count == 1
    end
  end

  class Clock
    def on_tick(handler)
      @registered = handler
    end

    def has_registered?(expected_handler)
      @registered == expected_handler
    end
  end
end

RSpec.describe Tictactoe::Gui::GameUpdater do
  let(:game)    { Mock::Game.new }
  let(:gui)     { Mock::Gui.new }
  let(:clock)   { Mock::Clock.new }
  let(:updater) { described_class.new(game, gui) }

  it 'ticks the game when updated' do
    expect(game).not_to have_received_tick
    updater.update
    expect(game).to have_received_tick
  end

  it 'updates the gui with the game state' do
    game.on_tick = lambda{|game| game.state = :updated_state}
    updater.update
    expect(gui).to have_been_updated_with(:updated_state)
  end

  it 'does not update the gui if the state has not changed' do
    game.on_tick = lambda{|game| game.state = :old_state}
    updater.update
    updater.update
    expect(gui).to have_been_updated_only_once
  end

  it 'can receive ticks from a clock' do
    updater.receive_ticks_from(clock)
    expect(clock).to have_registered(updater.method(:update))
  end

  it 'returns self after a receive_ticks_from(clock) call' do
    actual_self = updater.receive_ticks_from(clock)
    expect(actual_self).to eq(updater)
  end
end
