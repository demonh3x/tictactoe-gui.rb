require 'spec_helper'
require 'tictactoe/gui/game_updater'
require 'tictactoe/gui/qtgui/game_gui'
require 'tictactoe/gui/qtgui/widgets/factory'

RSpec.describe Tictactoe::Gui::GameUpdater, :integration => true, :gui => true do
  before(:each) do
    Qt::Application.new(ARGV)
  end

  def create(ttt)
    widget_factory = Tictactoe::Gui::QtGui::Widgets::Factory.new()
    game_gui = Tictactoe::Gui::QtGui::GameGui.new(widget_factory)
    game_gui.on_play_again(lambda{})
    game_gui.set_board_size(ttt.marks.length)
    game_updater = described_class.new(ttt, game_gui)
    game_gui.on_tic(game_updater.method(:update))
    game_gui
  end

  it 'is a widget' do
    gui = create(spy(:marks => [nil] * 9)).qt_root
    expect(gui).to be_kind_of(Qt::Widget)
    expect(gui.parent).to be_nil
    expect(gui.object_name).to eq("main_window")
  end

  RSpec::Matchers.define :have_widged_named do |expected|
    match do |widget|
      widget.children.any? do |child|
        child.object_name == expected
      end
    end
  end

  def expect_to_have_cell(gui, index)
    expect(gui).to have_widged_named "cell_#{index}"
  end

  it 'has the board cells' do
    tictactoe = spy(:marks => [
      nil, nil, nil,
      nil, nil, nil,
      nil, nil, nil
    ])
    gui = create(tictactoe).qt_root
    (0..8).each do |index|
      expect_to_have_cell(gui, index)
    end
  end

  def find_cell(gui, index)
    find(gui, "cell_#{index}")
  end

  def get_cell_text(gui, index)
    find_cell(gui, index).text
  end

  def get_result_text(gui)
    find(gui, 'result').text
  end

  def get_timer(gui)
    find(gui, 'timer')
  end

  def timer_tick(gui)
    get_timer(gui).timeout
  end

  def is_timer_active?(gui)
    get_timer(gui).active
  end

  def get_timer_interval(gui)
    get_timer(gui).interval
  end

  def make_move(gui, cell_index)
    find_cell(gui, cell_index).click
    timer_tick(gui)
  end

  (0..8).each do |index|
    it "when a move is made to the cell #{index}, interacts with tictactoe" do
      tictactoe = spy(:marks => [nil] * 9)
      gui = create(tictactoe).qt_root
      make_move(gui, index)
      expect(tictactoe).to have_received(:tick)
    end
  end

  describe 'after a move, displays the mark in the cell' do
    it 'in cell 0' do
      tictactoe = spy(:marks => [
        :x,  nil, nil,
        nil, nil, nil,
        nil, nil, nil
      ])
      gui = create(tictactoe).qt_root
      make_move(gui, 0)
      expect(get_cell_text(gui, 0)).to eq('x')
    end

    it 'in cell 6' do
      tictactoe = spy(:marks => [
        nil, nil, nil,
        nil, nil, nil,
        :x,  nil, nil
      ])
      gui = create(tictactoe).qt_root
      make_move(gui, 6)
      expect(get_cell_text(gui, 6)).to eq('x')
    end
  end

  it 'has the result widget' do
    gui = create(spy(:marks => [nil] * 9)).qt_root
    expect(gui).to have_widged_named("result")
  end

  describe 'after a move shows the result' do
    it 'unless it is not finished' do
      tictactoe = spy({
        :marks => [nil] * 9,
        :is_finished? => false,
      })
      gui = create(tictactoe).qt_root
      make_move(gui, 0)
      expect(get_result_text(gui)).to eq(nil)
    end

    it 'of winner x' do
      tictactoe = spy({
        :marks => [nil] * 9,
        :is_finished? => true,
        :winner => :x,
      })
      gui = create(tictactoe).qt_root
      make_move(gui, 0)
      expect(get_result_text(gui)).to eq('Player X has won.')
    end

    it 'of winner o' do
      tictactoe = spy({
        :marks => [nil] * 9,
        :is_finished? => true,
        :winner => :o,
      })
      gui = create(tictactoe).qt_root
      make_move(gui, 0)
      expect(get_result_text(gui)).to eq('Player O has won.')
    end

    it 'of a draw' do
      tictactoe = spy({
        :marks => [nil] * 9,
        :is_finished? => true,
        :winner => nil,
      })
      gui = create(tictactoe).qt_root
      make_move(gui, 0)
      expect(get_result_text(gui)).to eq('It is a draw.')
    end
  end

  describe 'the timer' do
    it 'exists' do
      gui = create(spy(:marks => [nil] * 9)).qt_root
      expect(get_timer(gui)).to be_an_instance_of Qt::Timer
    end

    it 'has the shortest update interval' do
      gui = create(spy(:marks => [nil] * 9)).qt_root
      expect(get_timer_interval(gui)).to eq(0)
    end

    it 'is active after showing the window' do
      gui = create(spy(:marks => [nil] * 9))
      gui.show
      expect(is_timer_active?(gui.qt_root)).to eq(true)
    end

    it 'is stopped after closing the window' do
      gui = create(spy(:marks => [nil] * 9))
      gui.close
      expect(is_timer_active?(gui.qt_root)).to eq(false)
    end

    describe 'when timing out' do
      it 'calls tick on tictactoe' do
        tictactoe = spy(:marks => [nil] * 9)
        gui = create(tictactoe).qt_root

        expect(tictactoe).not_to have_received(:tick)
        timer_tick(gui)
        expect(tictactoe).to have_received(:tick)
      end

      it 'updates the board' do
        tictactoe = spy(:marks => [
          :x,  nil, nil,
          nil, nil, nil,
          nil, nil, nil
        ])
        gui = create(tictactoe).qt_root
        timer_tick(gui)
        expect(get_cell_text(gui, 0)).to eq('x')
      end
    end
  end
end