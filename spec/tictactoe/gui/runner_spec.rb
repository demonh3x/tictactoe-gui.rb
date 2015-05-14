require 'spec_helper'
require 'tictactoe/gui/runner'

RSpec.describe Tictactoe::Gui::Runner, :integration => true, :gui => true do
  def tick(gui)
    find(gui, "timer").timeout
  end

  def click_cell(gui, index)
    find(gui, "cell_#{index}").click
  end

  it 'creates a Qt application' do
    described_class.new
    app_count = ObjectSpace.each_object(Qt::Application).count
    expect(app_count).to be > 0
  end

  it 'running a full game between two humans on a 3 by 3 board' do
    app = described_class.new
    menu = app.menu.qt_window

    find(menu, "board_3").click
    find(menu, "x_human").click
    find(menu, "o_human").click
    find(menu, "start").click
    game = app.game_qt_window

    click_cell(game, 0) #x
    click_cell(game, 3) #o
    click_cell(game, 1) #x
    click_cell(game, 4) #o
    expect(find(game, "result").text).to eq(nil)
    click_cell(game, 2) #x
    expect(find(game, "result").text).to eq('Player X has won.')
  end

  it 'running a full game between two humans on a 4 by 4 board' do
    app = described_class.new
    menu = app.menu.qt_window

    find(menu, "board_4").click
    find(menu, "x_human").click
    find(menu, "o_human").click
    find(menu, "start").click
    game = app.game_qt_window

    click_cell(game, 0) #x
    click_cell(game, 4) #o
    click_cell(game, 1) #x
    click_cell(game, 5) #o
    click_cell(game, 2) #x
    click_cell(game, 6) #o
    expect(find(game, "result").text).to eq(nil)
    click_cell(game, 3) #x
    expect(find(game, "result").text).to eq('Player X has won.')
  end

  it 'running a full game between two computers on a 3 by 3 board' do
    app = described_class.new
    menu = app.menu.qt_window

    find(menu, "board_3").click
    find(menu, "x_computer").click
    find(menu, "o_computer").click
    find(menu, "start").click
    game = app.game_qt_window

    8.times do
      tick(game)
    end
    expect(find(game, "result").text).to eq(nil)
    tick(game)
    expect(find(game, "result").text).to eq('It is a draw.')
  end

  it 'hides the options window when a game starts running' do
    app = described_class.new
    menu = app.menu.qt_window
    menu.show

    find(menu, "board_3").click
    find(menu, "x_human").click
    find(menu, "o_human").click
    
    expect(menu.visible).to eq(true)
    find(menu, "start").click
    expect(menu.visible).to eq(false)
    expect(app.game_qt_window.visible).to eq(true)
  end

  it 'after a game, when playing again; shows the menu window' do
    app = described_class.new
    menu = app.menu.qt_window
    menu.show

    find(menu, "board_3").click
    find(menu, "x_human").click
    find(menu, "o_human").click
    find(menu, "start").click
    game = app.game_qt_window

    click_cell(game, 0) #x
    click_cell(game, 3) #o
    click_cell(game, 1) #x
    click_cell(game, 4) #o
    click_cell(game, 2) #x

    expect(app.game_qt_window.visible).to eq(true)
    expect(menu.visible).to eq(false)
    find(app.game_qt_window, "play_again").click
    expect(app.game_qt_window.visible).to eq(false)
    expect(menu.visible).to eq(true)
  end

  it 'after a game, when not playing again; does not show any window' do
    app = described_class.new
    menu = app.menu.qt_window
    menu.show

    find(menu, "board_3").click
    find(menu, "x_human").click
    find(menu, "o_human").click
    find(menu, "start").click
    game = app.game_qt_window

    click_cell(game, 0) #x
    click_cell(game, 3) #o
    click_cell(game, 1) #x
    click_cell(game, 4) #o
    click_cell(game, 2) #x

    expect(app.game_qt_window.visible).to eq(true)
    expect(menu.visible).to eq(false)
    find(app.game_qt_window, "close").click
    expect(app.game_qt_window.visible).to eq(false)
    expect(menu.visible).to eq(false)
  end
end
