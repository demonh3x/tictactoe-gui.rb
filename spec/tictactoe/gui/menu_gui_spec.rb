require 'spec_helper'
require 'user_interactions'
require 'tictactoe/gui/qtgui/menu_gui'
require 'tictactoe/gui/qtgui/widgets/factory'

RSpec.describe Tictactoe::Gui::QtGui::MenuGui, :integration => true, :gui => true do
  def qt_menu
    widget_factory.created_windows.first.root
  end

  let(:start_callback)  { spy() }
  let(:widget_factory)  { Tictactoe::Gui::QtGui::Widgets::Factory.new }
  let(:menu_gui)        { described_class.new(widget_factory).on_configured(start_callback) }
  let(:ui)              { menu_gui; UserInteractions.new(method(:qt_menu), nil) }

  it 'has the default options selected' do
    expect(ui.is_selected?(:x, :human)).to eq(true)
    expect(ui.is_selected?(:o, :human)).to eq(true)
    expect(ui.is_selected?(:board, 3)).to eq(true)
  end

  it 'sends the default options to the callback' do
    ui.start_game
    default_options = {
      :x => :human,
      :o => :human,
      :board => 3,
    }
    expect(start_callback).to have_received(:call).with(default_options)
  end

  describe 'sends the different options when selected' do
    it 'x is computer, o is human, board of size 4' do
      ui.select(:x, :computer)
      ui.select(:o, :human)
      ui.select(:board, 4)
      ui.start_game
      selected_options = {
        :x => :computer,
        :o => :human,
        :board => 4,
      }
      expect(start_callback).to have_received(:call).with(selected_options)
    end

    it 'x is human, o is computer, board of size 3' do
      ui.select(:x, :human)
      ui.select(:o, :computer)
      ui.select(:board, 3)
      ui.start_game
      selected_options = {
        :x => :human,
        :o => :computer,
        :board => 3,
      }
      expect(start_callback).to have_received(:call).with(selected_options)
    end
  end
end
