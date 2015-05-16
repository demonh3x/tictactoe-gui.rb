require 'spec_helper'
require 'tictactoe/gui/menu_window'
require 'tictactoe/gui/qtgui/menu_gui'

RSpec.describe Tictactoe::Gui::MenuWindow, :integration => true, :gui => true do
  before(:each) do
    Qt::Application.new(ARGV)
  end

  def create(start_callback)
    menu_gui = Tictactoe::Gui::QtGui::MenuGui.new()
    described_class.new(menu_gui, start_callback)
    menu_gui.qt_root
  end

  it 'has the default options selected' do
    menu = create(spy())
    expect(find(menu, "x_human").checked).to eq(true)
    expect(find(menu, "o_human").checked).to eq(true)
    expect(find(menu, "board_3").checked).to eq(true)
  end

  it 'sends the default options to the callback' do
    start_callback = spy()
    menu = create(start_callback)
    find(menu, "start").click
    default_options = {
      :x => :human,
      :o => :human,
      :board => 3,
    }
    expect(start_callback).to have_received(:call).with(default_options)
  end

  describe 'sends the different options when selected' do
    it 'x is computer, o is human, board of size 4' do
      start_callback = spy()
      menu = create(start_callback)
      find(menu, "x_computer").click
      find(menu, "o_human").click
      find(menu, "board_4").click
      find(menu, "start").click
      selected_options = {
        :x => :computer,
        :o => :human,
        :board => 4,
      }
      expect(start_callback).to have_received(:call).with(selected_options)
    end

    it 'x is human, o is computer, board of size 3' do
      start_callback = spy()
      menu = create(start_callback)
      find(menu, "x_human").click
      find(menu, "o_computer").click
      find(menu, "board_3").click
      find(menu, "start").click
      selected_options = {
        :x => :human,
        :o => :computer,
        :board => 3,
      }
      expect(start_callback).to have_received(:call).with(selected_options)
    end
  end
end
