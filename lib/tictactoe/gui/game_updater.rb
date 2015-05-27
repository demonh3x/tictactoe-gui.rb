module Tictactoe
  module Gui
    class GameUpdater
      def initialize(game, gui)
        self.game = game
        self.gui = gui
      end

      def update
        advance_game
        update_state
      end

      def receive_ticks_from(clock)
        clock.on_tick(method(:update))
        self
      end

      private
      attr_accessor :game, :gui
      attr_accessor :previous_state

      def advance_game
        game.tick
      end

      def update_state
        gui.update(game.state) if game.state != previous_state
        self.previous_state = game.state
      end
    end
  end
end
