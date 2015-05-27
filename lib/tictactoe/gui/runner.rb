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
      def initialize(framework = QtGui::Widgets::Factory.new)
        self.framework = framework
        show_windows
      end

      def run
        framework.start_event_loop
      end

      private
      attr_accessor :framework
      attr_accessor :menu_gui

      def show_windows
        self.menu_gui = create_menu_gui
        menu_gui.show
      end

      def create_menu_gui
        menu_gui = QtGui::MenuGui.new(framework)
        menu_gui.on_configured(method(:show_game))

        menu_gui
      end

      def show_game(options)
        create_game_window(options).show
      end

      def create_game_window(options)
        game_gui = create_game_gui(options)
        game = create_game(options)

        game.register_human_factory(human_factory(game_gui))
        Gui::GameUpdater.new(game, game_gui).receive_ticks_from(game_gui)

        game_gui
      end

      def create_game_gui(options)
        game_gui.on_play_again(lambda{menu_gui.show})
        game_gui = QtGui::GameGui.new(framework, options[:board])

        game_gui
      end

      def create_game(options)
        Tictactoe::Game.new(options[:board], options[:x], options[:o])
      end

      def human_factory(game_gui)
        lambda{|mark| HumanPlayer.new(mark).receive_moves_from(game_gui)}
      end
    end
  end
end
