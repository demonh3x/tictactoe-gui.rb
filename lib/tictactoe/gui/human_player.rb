module Tictactoe
  module Gui
    class HumanPlayer
      attr_reader :mark

      def initialize(mark)
        self.mark = mark
      end

      def has_moved_to(move)
        moves << move
      end

      def receive_moves_from(user)
        user.on_move(method(:has_moved_to))
        self
      end

      def get_move(state)
        moves.pop
      end

      private
      attr_writer :mark

      def moves
        @moves ||= []
      end
    end
  end
end
