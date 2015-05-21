require 'Qt'
require 'tictactoe/game'
require 'tictactoe/gui/menu_window'
require 'tictactoe/gui/game_window'
require 'tictactoe/gui/qtgui/game_gui'
require 'tictactoe/gui/qtgui/menu_gui'
require 'tictactoe/gui/human_player'

module Tictactoe
  module Gui
    class Runner
      attr_reader :menu, :game

      def initialize()
        self.app = Qt::Application.new(ARGV)

        menu_gui = QtGui::MenuGui.new()
        menu = MenuWindow.new(menu_gui, lambda{|options|
          game_gui = QtGui::GameGui.new()

          game = create_game(options)
          game_window = Gui::GameWindow.new(game, game_gui, lambda{menu.show})
          game_window.show
          @game = game_gui.qt_root
        })
        @menu = menu_gui.qt_root
      end

      def run
        menu.show
        app.exec
      end

      private
      attr_accessor :app

      def create_game(options)
        Tictactoe::Game.new(options[:board], options[:x], options[:o])
      end
    end
  end
end
