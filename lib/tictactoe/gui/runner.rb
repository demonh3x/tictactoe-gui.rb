require 'Qt'
require 'tictactoe/game'
require 'tictactoe/gui/menu_window'
require 'tictactoe/gui/game_window'
require 'tictactoe/gui/qtgui/game_gui'
require 'tictactoe/gui/qtgui/menu_gui'

module Tictactoe
  module Gui
    class Runner
      attr_reader :menu, :game

      def initialize()
        @app = Qt::Application.new(ARGV)

        menu_gui = QtGui::MenuGui.new()
        menu = MenuWindow.new(menu_gui, lambda{|options|
          menu.hide

          game_gui = QtGui::GameGui.new()
          game = Gui::GameWindow.new(
            create_game(options),
            game_gui,
            lambda{
              menu.show
            }
          )
          game.show
          @game = game_gui.qt_root
        })
        @menu = menu_gui.qt_root
      end

      def run
        menu.show
        app.exec
      end

      private
      attr_reader :app

      def create_game(options)
        ttt = Tictactoe::Game.new
        ttt.set_board_size(options[:board])
        ttt.set_player_x(options[:x])
        ttt.set_player_o(options[:o])
        ttt
      end
    end
  end
end
