module Tictactoe
  module Gui
    class MovesBuffer
      def initialize()
        @moves = []
      end

      def add(move)
        @moves.push(move)
      end

      def get_move!
        @moves.pop
      end
    end
  end
end
