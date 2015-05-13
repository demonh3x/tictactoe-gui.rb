require 'tictactoe/gui/moves_buffer'

module Tictactoe
  module Gui
    class GameWindow
      def initialize(gui, tictactoe, side_size, on_select)
        @ttt = tictactoe
        @moves = MovesBuffer.new()

        cell_count = side_size * side_size
        @board = gui.new_board(cell_count, method(:on_move))
        @result = gui.new_result()
        @play_again = gui.new_options([:play_again, :close], on_select)
        @timer = gui.new_timer(method(:refresh))

        @window = gui.new_window()
        gui.layout(@window, [@board, @result, @play_again, @timer])
      end

      def close
        @timer.stop()
        @window.close()
      end

      def show
        @timer.start()
        @window.show()
      end

      private
      def on_move(move)
        @moves.add(move)
        refresh()
      end

      def refresh()
        @ttt.tick(@moves)
        @timer.stop() if @ttt.is_finished?()
        refresh_board()
        refresh_result()
      end

      def refresh_board()
        @board.update(@ttt.marks)
      end

      def refresh_result()
        @result.announce(@ttt.winner) if @ttt.is_finished?()
      end
    end
  end
end
