require 'Qt'
require 'tictactoe/game'
require 'tictactoe/gui/menu_window'
require 'tictactoe/gui/main_window'

module Tictactoe
  module Gui
    class Runner
      attr_reader :app, :menu, :game

      def initialize()
        @app = Qt::Application.new(ARGV)
        @menu = MenuWindow.new(lambda{|options|
          ttt = Game.new
          ttt.set_board_size(options[:board])
          ttt.set_player_x(options[:x])
          ttt.set_player_o(options[:o])
          @game = MainWindow.new(ttt, options[:board])
          @game.show
        })
      end

      def run
        menu.show
        app.exec
      end
    end
  end
end
