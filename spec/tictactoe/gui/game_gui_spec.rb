require 'spec_helper'
require 'user_interactions'
require 'tictactoe/gui/qtgui/widgets/factory'
require 'tictactoe/gui/qtgui/game_gui'

RSpec.describe Tictactoe::Gui::QtGui::GameGui, :integration => true, :gui => true do
  class OnMoveHandler
    attr_reader :received_move

    def call(move)
      @received_move = move
    end
  end

  class OnTickHandler
    attr_reader :received_ticks

    def initialize
      @received_ticks = 0 
    end

    def call
      @received_ticks += 1
    end
  end

  class OnPlayAgainHandler
    def call
      @has_been_called = true
    end

    def has_been_called?
      @has_been_called
    end
  end

  def qt_game
    widget_factory.created_windows.last.root
  end

  class StateStub
    def initialize(marks, is_finished, winner)
      @marks = marks   
      @is_finished = is_finished
      @winner = winner
    end

    def marks
      @marks
    end

    def is_finished?
      @is_finished
    end

    def winner
      @winner
    end
  end

  let(:widget_factory) { Tictactoe::Gui::QtGui::Widgets::Factory.new }
  let(:game_gui)       { described_class.new(widget_factory, 3) } 
  let(:ui)             { game_gui; UserInteractions.new(nil, method(:qt_game)) }

  it 'notifies when a move has been made' do
    handler1 = OnMoveHandler.new
    handler2 = OnMoveHandler.new
    game_gui.on_move(handler1)
    game_gui.on_move(handler2)
    ui.click_cell(0)

    expect(handler1.received_move).to eq(0)
    expect(handler2.received_move).to eq(0)
  end

  it 'notifies when requesting to play again' do
    handler = OnPlayAgainHandler.new
    game_gui.on_play_again(handler)
    ui.play_again

    expect(handler).to have_been_called
  end

  it 'does not notify to play again when closing' do
    handler = OnPlayAgainHandler.new
    game_gui.on_play_again(handler)
    ui.close_game

    expect(handler).not_to have_been_called
  end

  it 'is hidden before calling show' do
    expect(ui.is_game_visible?).to eq(false)
  end

  it 'is displayed after calling show' do
    game_gui.show

    expect(ui.is_game_visible?).to eq(true)
  end

  it 'hides after requesting to play again' do
    game_gui.show
    ui.play_again

    expect(ui.is_game_visible?).to eq(false)
  end

  it 'hides after requesting to close' do
    game_gui.show
    ui.close_game
    
    expect(ui.is_game_visible?).to eq(false)
  end

  it 'notifies when a tick event has happened' do
    handler = OnTickHandler.new
    game_gui.on_tick(handler)
    ui.tick

    expect(handler.received_ticks).to eq(1)
  end

  it 'is not ticking before calling show' do
    expect(ui.is_ticking).to eq(false)
  end

  it 'starts ticking after calling show' do
    game_gui.show
    expect(ui.is_ticking).to eq(true)
  end

  it 'stops ticking after requesting to play_again' do
    game_gui.show
    ui.play_again
    expect(ui.is_ticking).to eq(false)
  end

  it 'stops ticking after requesting to close' do
    game_gui.show
    ui.close_game
    expect(ui.is_ticking).to eq(false)
  end

  it 'displays 9 places for the marks when the board is 3x3' do
    expect(ui.get_board_marks.length).to eq(9)
  end

  it 'displays 16 places for the marks when the board is 4x4' do
    described_class.new(widget_factory, 4)
    ui = UserInteractions.new(nil, method(:qt_game))
    expect(ui.get_board_marks.length).to eq(16)
  end

  it 'does not show anything in the board before updating' do
    expected = [
      nil, nil, nil,
      nil, nil, nil,
      nil, nil, nil,
    ]
    expect(ui.get_board_marks).to eq(expected)
  end

  it 'can update the board with a state' do
    board_marks = [
     :x, :o, nil,
     :o, nil, :x,
     :x, :o, nil
    ]
    game_gui.update(StateStub.new(board_marks, false, nil))
    expect(ui.get_board_marks).to eq(board_marks)
  end

  it 'does not display the winner before there is one' do
    game_gui.update(StateStub.new([], false, nil))
    expect(ui.get_result_text).to eq(nil)
  end

  it 'displays the winner message' do
    game_gui.update(StateStub.new([], true, :x))
    expect(ui.get_result_text).to eq("Player X has won.")
  end

  it 'displays the draw message' do
    game_gui.update(StateStub.new([], true, nil))
    expect(ui.get_result_text).to eq("It is a draw.")
  end
end
