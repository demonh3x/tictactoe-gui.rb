require 'tictactoe/gui/moves_buffer'
require 'tictactoe/gui/qtgui/game_window'

module Tictactoe
  module Gui
    class Game
      def initialize(window, tictactoe)
        @ttt = tictactoe
        @moves = MovesBuffer.new()

        @window = window
        @window.set_on_move(method(:on_move))
        @window.set_on_tic(method(:refresh))
      end

      private
      def on_move(move)
        @moves.add(move)
        refresh()
      end

      def refresh()
        @ttt.tick(@moves)
        refresh_board()
        refresh_result()
      end

      def refresh_board()
        @window.update(@ttt.marks)
      end

      def refresh_result()
        @window.announce(@ttt.winner) if @ttt.is_finished?()
      end
    end
  end
end
