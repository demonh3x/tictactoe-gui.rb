require 'Qt'
require 'tictactoe/game'
require 'tictactoe/gui/menu_window'
require 'tictactoe/gui/game'
require 'tictactoe/gui/qtgui/factory'
require 'tictactoe/gui/qtgui/game_window'

module Tictactoe
  module Gui
    class Runner
      attr_reader :app, :menu, :game_qt_window

      def initialize()
        @app = Qt::Application.new(ARGV)

        @menu = MenuWindow.new(lambda{|menu, options|
          menu.hide

          gui = QtGui::GameGui.new()
          gui.set_board_size(options[:board])
          gui.on_play_again(lambda{
            menu.show
          })

          Gui::GameWindow.new(
            create_game(options),
            gui
          )
          gui.show
          @game_qt_window = gui.widget_factory.window.root
        })
      end

      def run
        menu.show
        app.exec
      end

      private
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
