module Tictactoe
  module Gui
    class HumanPlayer
      attr_reader :mark

      def initialize(mark)
        self.mark = mark
      end

      def register_to(subject)
        subject.on_move(method(:on_move))
        self
      end

      def get_move(state)
        moves.pop
      end

      private
      attr_writer :mark

      def on_move(move)
        moves << move
      end

      def moves
        @moves ||= []
      end
    end
  end
end
