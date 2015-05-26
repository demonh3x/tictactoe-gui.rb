require 'spec_helper'
require 'tictactoe/gui/runner'

RSpec.describe Tictactoe::Gui::Runner, :integration => true, :gui => true do
  def tick
    find(runner.qt_game, "timer").timeout
  end

  def click_cell(cell_index)
    find(runner.qt_game, "cell_#{cell_index}").click
  end

  def make_move(cell_index)
    click_cell(cell_index)
    tick
  end

  def select(option, value)
    find(runner.qt_menu, "#{option.to_s}_#{value.to_s}").click
  end

  def start_game
    find(runner.qt_menu, "start").click
  end

  def close_game
    find(runner.qt_game, "close").click
  end

  def play_again
    find(runner.qt_game, "play_again").click
  end

  def get_result_text
    find(runner.qt_game, "result").text
  end

  def are_options_visible?
    runner.qt_menu.visible
  end

  def is_game_visible?
    runner.qt_game.visible
  end

  let(:runner) do
    runner = described_class.new
  end

  it 'creates a Qt application' do
    runner
    app_count = ObjectSpace.each_object(Qt::Application).count
    expect(app_count).to be > 0
  end

  it 'runs a full game between two humans on a 3 by 3 board' do
    select(:board, 3)
    select(:x, :human)
    select(:o, :human)
    start_game

    make_move(0) #x
    make_move(3) #o
    make_move(1) #x
    make_move(4) #o
    expect(get_result_text).to eq(nil)
    make_move(2) #x
    expect(get_result_text).to eq('Player X has won.')
  end

  it 'runs a full game between two humans on a 4 by 4 board' do
    select(:board, 4)
    select(:x, :human)
    select(:o, :human)
    start_game

    make_move(0) #x
    make_move(4) #o
    make_move(1) #x
    make_move(5) #o
    make_move(2) #x
    make_move(6) #o
    expect(get_result_text).to eq(nil)
    make_move(3) #x
    expect(get_result_text).to eq('Player X has won.')
  end

  it 'runs a full game between two computers on a 3 by 3 board' do
    select(:board, 3)
    select(:x, :computer)
    select(:o, :computer)
    start_game

    8.times do
      tick
    end
    expect(get_result_text).to eq(nil)
    tick
    expect(get_result_text).to eq('It is a draw.')
  end

  it 'hides the options when a game starts running' do
    select(:board, 3)
    select(:x, :human)
    select(:o, :human)
    
    expect(are_options_visible?).to eq(true)
    start_game
    expect(are_options_visible?).to eq(false)
    expect(is_game_visible?).to eq(true)
  end

  it 'shows the options when playing again' do
    select(:board, 3)
    select(:x, :human)
    select(:o, :human)
    start_game

    make_move(0) #x
    make_move(3) #o
    make_move(1) #x
    make_move(4) #o
    make_move(2) #x

    expect(is_game_visible?).to eq(true)
    expect(are_options_visible?).to eq(false)
    play_again
    expect(is_game_visible?).to eq(false)
    expect(are_options_visible?).to eq(true)
  end

  it 'hides everything after closing the game' do
    select(:board, 3)
    select(:x, :human)
    select(:o, :human)
    start_game

    make_move(0) #x
    make_move(3) #o
    make_move(1) #x
    make_move(4) #o
    make_move(2) #x

    expect(is_game_visible?).to eq(true)
    expect(are_options_visible?).to eq(false)
    close_game
    expect(is_game_visible?).to eq(false)
    expect(are_options_visible?).to eq(false)
  end
end
