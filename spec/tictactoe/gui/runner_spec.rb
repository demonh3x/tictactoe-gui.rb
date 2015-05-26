require 'spec_helper'
require 'tictactoe/gui/runner'

RSpec.describe Tictactoe::Gui::Runner, :integration => true, :gui => true do
  def tick(gui)
    find(gui, "timer").timeout
  end

  def make_move(gui, cell_index)
    find(gui, "cell_#{cell_index}").click
    tick(gui)
  end

  it 'creates a Qt application' do
    described_class.new
    app_count = ObjectSpace.each_object(Qt::Application).count
    expect(app_count).to be > 0
  end

  it 'running a full game between two humans on a 3 by 3 board' do
    app = described_class.new
    menu = app.menu

    find(menu, "board_3").click
    find(menu, "x_human").click
    find(menu, "o_human").click
    find(menu, "start").click
    game = app.game

    make_move(game, 0) #x
    make_move(game, 3) #o
    make_move(game, 1) #x
    make_move(game, 4) #o
    expect(find(game, "result").text).to eq(nil)
    make_move(game, 2) #x
    expect(find(game, "result").text).to eq('Player X has won.')
  end

  it 'running a full game between two humans on a 4 by 4 board' do
    app = described_class.new
    menu = app.menu

    find(menu, "board_4").click
    find(menu, "x_human").click
    find(menu, "o_human").click
    find(menu, "start").click
    game = app.game

    make_move(game, 0) #x
    make_move(game, 4) #o
    make_move(game, 1) #x
    make_move(game, 5) #o
    make_move(game, 2) #x
    make_move(game, 6) #o
    expect(find(game, "result").text).to eq(nil)
    make_move(game, 3) #x
    expect(find(game, "result").text).to eq('Player X has won.')
  end

  it 'running a full game between two computers on a 3 by 3 board' do
    app = described_class.new
    menu = app.menu

    find(menu, "board_3").click
    find(menu, "x_computer").click
    find(menu, "o_computer").click
    find(menu, "start").click
    game = app.game

    8.times do
      tick(game)
    end
    expect(find(game, "result").text).to eq(nil)
    tick(game)
    expect(find(game, "result").text).to eq('It is a draw.')
  end

  it 'hides the options window when a game starts running' do
    app = described_class.new
    menu = app.menu
    menu.show

    find(menu, "board_3").click
    find(menu, "x_human").click
    find(menu, "o_human").click
    
    expect(menu.visible).to eq(true)
    find(menu, "start").click
    game = app.game
    expect(menu.visible).to eq(false)
    expect(game.visible).to eq(true)
  end

  it 'after a game, when playing again; shows the menu window' do
    app = described_class.new
    menu = app.menu
    menu.show

    find(menu, "board_3").click
    find(menu, "x_human").click
    find(menu, "o_human").click
    find(menu, "start").click
    game = app.game

    make_move(game, 0) #x
    make_move(game, 3) #o
    make_move(game, 1) #x
    make_move(game, 4) #o
    make_move(game, 2) #x

    expect(game.visible).to eq(true)
    expect(menu.visible).to eq(false)
    find(game, "play_again").click
    expect(game.visible).to eq(false)
    expect(menu.visible).to eq(true)
  end

  it 'after a game, when not playing again; does not show any window' do
    app = described_class.new
    menu = app.menu
    menu.show

    find(menu, "board_3").click
    find(menu, "x_human").click
    find(menu, "o_human").click
    find(menu, "start").click
    game = app.game

    make_move(game, 0) #x
    make_move(game, 3) #o
    make_move(game, 1) #x
    make_move(game, 4) #o
    make_move(game, 2) #x

    expect(game.visible).to eq(true)
    expect(menu.visible).to eq(false)
    find(game, "close").click
    expect(game.visible).to eq(false)
    expect(menu.visible).to eq(false)
  end
end
