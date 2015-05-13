require 'Qt'
require 'tictactoe/game'
require 'tictactoe/gui/menu_window'
require 'tictactoe/gui/game_window'
require 'tictactoe/gui/qtgui/factory'

module Tictactoe
  module Gui
    class Runner
      attr_reader :app, :menu, :game

      def initialize()
        @app = Qt::Application.new(ARGV)
        qt_factory = QtGui::WidgetFactory.new()

        @menu = MenuWindow.new(lambda{|menu, options|
          menu.hide

          on_end_selection = lambda{|game, selection|
            game.close
            menu.show if selection == :play_again
          }

          @game = GameWindow.new(
            qt_factory,
            create_game(options),
            options[:board],
            on_end_selection
          )
          @game.show
        })
      end

      def run
        menu.show
        app.exec
      end

      private
      def create_game(options)
        ttt = Game.new
        ttt.set_board_size(options[:board])
        ttt.set_player_x(options[:x])
        ttt.set_player_o(options[:o])
        ttt
      end
    end
  end
end
