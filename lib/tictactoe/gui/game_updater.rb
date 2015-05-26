module Tictactoe
  module Gui
    class GameUpdater
      def initialize(game, gui)
        self.game = game
        self.gui = gui
      end

      def update
        update_game
        update_board
        update_result
      end

      def receive_ticks_from(clock)
        clock.on_tic(method(:update))
        self
      end

      private
      attr_accessor :game, :gui

      def update_game
        game.tick
      end

      def update_board
        gui.update(game.marks)
      end

      def update_result
        gui.announce(game.winner) if game.is_finished?
      end
    end
  end
end
