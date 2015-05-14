require 'tictactoe/gui/moves_buffer'

module Tictactoe
  module Gui
    class GameWindow
      def initialize(tictactoe, game_gui, on_play_again)
        @ttt = tictactoe
        @moves = MovesBuffer.new()
        @game_gui = game_gui

        game_gui.set_board_size(@ttt.marks.length)
        game_gui.on_play_again(on_play_again)
        game_gui.on_move(method(:on_move))
        game_gui.on_tic(method(:refresh))
      end

      def show()
        game_gui.show()
      end

      private
      attr_reader :moves, :ttt, :game_gui

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
        game_gui.update(ttt.marks)
      end

      def refresh_result()
        game_gui.announce(ttt.winner) if ttt.is_finished?()
      end
    end
  end
end
