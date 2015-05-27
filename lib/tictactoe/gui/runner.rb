require 'Qt'
require 'tictactoe/game'
require 'tictactoe/gui/game_updater'
require 'tictactoe/gui/qtgui/game_gui'
require 'tictactoe/gui/qtgui/menu_gui'
require 'tictactoe/gui/qtgui/widgets/factory'
require 'tictactoe/gui/human_player'

module Tictactoe
  module Gui
    class Runner
      def initialize
        initialize_framework
        show_windows
      end

      def run
        app.exec
      end

      def qt_menu
        menu_gui.qt_root
      end

      def qt_game
        game_gui.qt_root
      end

      private
      attr_accessor :menu_gui, :game_gui

      attr_accessor :app, :widget_factory

      def initialize_framework
        self.app = Qt::Application.new(ARGV)
        self.widget_factory = QtGui::Widgets::Factory.new()
      end

      def show_windows
        create_menu_gui
        show_menu
      end

      def create_menu_gui
        self.menu_gui = QtGui::MenuGui.new(widget_factory)
        menu_gui.on_configured(method(:show_game))
        menu_gui
      end

      def show_game(options)
        game_gui = create_game_gui(options)
        game = create_game(options, game_gui)

        Gui::GameUpdater.new(game, game_gui).receive_ticks_from(game_gui)
        game_gui.show
      end

      def create_game(options, game_gui)
        game = Tictactoe::Game.new(options[:board], options[:x], options[:o])
        game.register_human_factory(lambda{|mark| HumanPlayer.new(mark).receive_moves_from(game_gui)})
        game
      end

      def create_game_gui(options)
        self.game_gui = QtGui::GameGui.new(widget_factory)
        game_gui.set_board_size(options[:board] * options[:board])
        game_gui.on_play_again(method(:show_menu))
        game_gui
      end

      def show_menu
        menu_gui.show
      end
    end
  end
end
