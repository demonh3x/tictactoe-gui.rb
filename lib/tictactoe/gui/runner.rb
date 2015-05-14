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

          widget_factory = QtGui::WidgetFactory.new()
          window = QtGui::GameWindow.new()
          window.set_widget_factory(widget_factory)
          window.set_board_size(options[:board])

          on_end_selection = lambda{|game, selection|
            window.close
            menu.show if selection == :play_again
          }
          window.set_on_select_option(on_end_selection)

          Gui::Game.new(
            window,
            create_game(options)
          )
          window.show
          @game_qt_window = widget_factory.window.root
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
