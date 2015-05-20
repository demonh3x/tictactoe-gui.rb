module Tictactoe
  module Gui
    class HumanPlayer
      attr_reader :mark

      def initialize(gui, mark)
        register_handler_for(gui)
        @mark = mark
      end

      def get_move(state)
        moves.pop
      end

      private
      def on_move(move)
        moves << move
      end

      def moves
        @moves ||= []
      end

      def register_handler_for(gui)
        gui.on_move(method(:on_move))
      end
    end
  end
end
