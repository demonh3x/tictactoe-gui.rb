require 'Qt'
require 'tictactoe/gui/moves_buffer'
require 'tictactoe/gui/qtgui/factory'

module Tictactoe
  module Gui
    class GameWindow
      attr_reader :qt_root

      def initialize(tictactoe, side_size, on_select)
        @ttt = tictactoe
        @moves = MovesBuffer.new

        @factory = QtGui::WidgetFactory.new()

        cell_count = side_size * side_size
        @board = @factory.new_board(cell_count, method(:on_move))
        @result = @factory.new_result()
        play_again = @factory.new_options([:play_again, :close], on_select)

        @window = @factory.new_window()
        @factory.layout(@window, @board, @result, play_again)

        @timer = @factory.new_timer(method(:tick))
        @timer.set_parent(@window)
        @timer.start

        @qt_root = @window.root
      end

      def close
        @timer.stop
        @qt_root.close
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
