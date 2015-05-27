require 'spec_helper'
require 'user_interactions'
require 'tictactoe/gui/runner'
require 'tictactoe/gui/qtgui/widgets/factory'

RSpec.describe Tictactoe::Gui::Runner, :integration => true, :gui => true do
  def qt_game
    qt_framework.created_windows.last.root
  end

  def qt_menu
    qt_framework.created_windows.first.root
  end

  let(:ui)            { runner; UserInteractions.new(method(:qt_menu), method(:qt_game)) }
  let(:qt_framework)  { Tictactoe::Gui::QtGui::Widgets::Factory.new }
  let(:runner)        { described_class.new(qt_framework) }

  it 'creates a Qt application' do
    qt_framework
    app_count = ObjectSpace.each_object(Qt::Application).count
    expect(app_count).to be > 0
  end

  it 'runs a full game between two humans on a 3 by 3 board' do
    ui.select(:board, 3)
    ui.select(:x, :human)
    ui.select(:o, :human)
    ui.start_game

    ui.make_move(0) #x
    ui.make_move(3) #o
    ui.make_move(1) #x
    ui.make_move(4) #o
    expect(ui.get_result_text).to eq(nil)
    ui.make_move(2) #x
    expect(ui.get_result_text).to eq('Player X has won.')
  end

  it 'runs a full game between two humans on a 4 by 4 board' do
    ui.select(:board, 4)
    ui.select(:x, :human)
    ui.select(:o, :human)
    ui.start_game

    ui.make_move(0) #x
    ui.make_move(4) #o
    ui.make_move(1) #x
    ui.make_move(5) #o
    ui.make_move(2) #x
    ui.make_move(6) #o
    expect(ui.get_result_text).to eq(nil)
    ui.make_move(3) #x
    expect(ui.get_result_text).to eq('Player X has won.')
  end

  it 'runs a full game between two computers on a 3 by 3 board' do
    ui.select(:board, 3)
    ui.select(:x, :computer)
    ui.select(:o, :computer)
    ui.start_game

    8.times do
      ui.tick
    end
    expect(ui.get_result_text).to eq(nil)
    ui.tick
    expect(ui.get_result_text).to eq('It is a draw.')
  end

  it 'hides the options when a game starts running' do
    ui.select(:board, 3)
    ui.select(:x, :human)
    ui.select(:o, :human)
    
    expect(ui.are_options_visible?).to eq(true)
    ui.start_game
    expect(ui.are_options_visible?).to eq(false)
    expect(ui.is_game_visible?).to eq(true)
  end

  it 'shows the options when playing again' do
    ui.select(:board, 3)
    ui.select(:x, :human)
    ui.select(:o, :human)
    ui.start_game

    ui.make_move(0) #x
    ui.make_move(3) #o
    ui.make_move(1) #x
    ui.make_move(4) #o
    ui.make_move(2) #x

    expect(ui.is_game_visible?).to eq(true)
    expect(ui.are_options_visible?).to eq(false)
    ui.play_again
    expect(ui.is_game_visible?).to eq(false)
    expect(ui.are_options_visible?).to eq(true)
  end

  it 'hides everything after closing the game' do
    ui.select(:board, 3)
    ui.select(:x, :human)
    ui.select(:o, :human)
    ui.start_game

    ui.make_move(0) #x
    ui.make_move(3) #o
    ui.make_move(1) #x
    ui.make_move(4) #o
    ui.make_move(2) #x

    expect(ui.is_game_visible?).to eq(true)
    expect(ui.are_options_visible?).to eq(false)
    ui.close_game
    expect(ui.is_game_visible?).to eq(false)
    expect(ui.are_options_visible?).to eq(false)
  end
end
