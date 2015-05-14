require 'tictactoe/gui/moves_buffer'
require 'tictactoe/gui/qtgui/game_window'

module Tictactoe
  module Gui
    class GameWindow
      def initialize(tictactoe, gui, on_play_again)
        @ttt = tictactoe
        @moves = MovesBuffer.new()
        @gui = gui

        board_size = Math.sqrt(@ttt.marks.length).to_i
        gui.set_board_size(board_size)
        gui.on_play_again(on_play_again)
        gui.on_move(method(:on_move))
        gui.on_tic(method(:refresh))
      end

      def show()
        gui.show()
      end

      private
      attr_reader :moves, :ttt, :gui

      def on_move(move)
        moves.add(move)
        refresh()
      end

      def refresh()
        ttt.tick(moves)
        refresh_board()
        refresh_result()
      end

      def refresh_board()
        gui.update(ttt.marks)
      end

      def refresh_result()
        gui.announce(ttt.winner) if ttt.is_finished?()
      end
    end
  end
end
