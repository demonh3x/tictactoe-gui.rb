require 'tictactoe/gui/moves_buffer'

module Tictactoe
  module Gui
    class GameWindow
      attr_reader :window

      def initialize(gui, tictactoe, side_size, on_select)
        @ttt = tictactoe
        @moves = MovesBuffer.new

        cell_count = side_size * side_size
        @board = gui.new_board(cell_count, method(:on_move))
        @result = gui.new_result()
        play_again = gui.new_options([:play_again, :close], on_select)

        @window = gui.new_window()
        gui.layout(@window, @board, @result, play_again)

        @timer = gui.new_timer(method(:tick))
        @timer.set_parent(@window)
        @timer.start
      end

      def close
        @timer.stop
        @window.close
      end

      def show
        @window.show
      end

      private
      def on_move(move)
        @moves.add(move)
        @ttt.tick(@moves)
        refresh_board
        refresh_result
      end

      def tick
        @ttt.tick(@moves)
        refresh_board
        refresh_result
      end

      def refresh_board
        @board.update(@ttt.marks)
      end

      def refresh_result
        if @ttt.is_finished?
          @result.announce(@ttt.winner)
        end
      end
    end
  end
end
