module Tictactoe
  module Gui
    class GameWindow
      def initialize(game, game_gui)
        self.game = game
        self.game_gui = game_gui
      end

      def show
        game.register_human_factory(lambda{|mark| HumanPlayer.new(mark).register_to(game_gui)})

        game_gui.set_board_size(game.marks.length)
        game_gui.on_tic(method(:refresh))

        game_gui.show
      end

      private
      attr_accessor :game, :game_gui

      def refresh
        game.tick
        refresh_board
        refresh_result
      end

      def refresh_board
        game_gui.update(game.marks)
      end

      def refresh_result
        game_gui.announce(game.winner) if game.is_finished?
      end
    end
  end
end
