require 'tictactoe/gui/moves_buffer'
require 'tictactoe/gui/qtgui/game_window'

module Tictactoe
  module Gui
    class GameWindow
      def initialize(tictactoe, gui)
        @ttt = tictactoe
        @moves = MovesBuffer.new()
        @gui = gui
        gui.on_move(method(:on_move))
        gui.on_tic(method(:refresh))
      end

      def on_move(move)
        @moves.add(move)
        refresh()
      end

      def refresh()
        @ttt.tick(@moves)
        refresh_board()
        refresh_result()
      end

      private
      def refresh_board()
        @gui.update(@ttt.marks)
      end

      def refresh_result()
        @gui.announce(@ttt.winner) if @ttt.is_finished?()
      end
    end
  end
end
