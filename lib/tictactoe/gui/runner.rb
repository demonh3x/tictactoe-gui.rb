require 'Qt'
require 'tictactoe/game'
require 'tictactoe/gui/game_window'
require 'tictactoe/gui/qtgui/game_gui'
require 'tictactoe/gui/qtgui/menu_gui'
require 'tictactoe/gui/qtgui/widgets/factory'
require 'tictactoe/gui/human_player'

module Tictactoe
  module Gui
    class Runner
      def initialize()
        initialize_framework
        show_menu_window
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
      attr_accessor :menu_window, :game_window

      def initialize_framework
        self.app = Qt::Application.new(ARGV)
        self.widget_factory = QtGui::Widgets::Factory.new()
      end

      def show_menu_window
        self.menu_window = create_menu_gui
        menu_window.show
      end

      def create_menu_gui
        self.menu_gui = QtGui::MenuGui.new(widget_factory)
        menu_gui.on_configured(method(:show_game_window))
        menu_gui
      end

      def show_game_window(options)
        game_gui = create_game_gui
        game = create_game(options, game_gui)
        game_gui.set_board_size(game.marks.length)

        self.game_window = Gui::GameWindow.new(game, game_gui)
        game_window.show
      end

      def create_game(options, game_gui)
        game = Tictactoe::Game.new(options[:board], options[:x], options[:o])
        game.register_human_factory(lambda{|mark| HumanPlayer.new(mark).register_to(game_gui)})
        game
      end

      def create_game_gui
        self.game_gui = QtGui::GameGui.new(widget_factory)
        game_gui.on_play_again(method(:show_menu))
        game_gui
      end

      def show_menu
        menu_window.show
      end
    end
  end
end
