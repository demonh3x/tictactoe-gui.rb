require 'tictactoe/gui/moves_buffer'
require 'tictactoe/gui/qtgui/game_window'

module Tictactoe
  module Gui
    class GameWindow
      def initialize(gui, tictactoe, side_size, on_select)
        @ttt = tictactoe
        @moves = MovesBuffer.new()

        @gui = gui
        @gui.set_on_select_option(on_select)
        @gui.set_on_move(method(:on_move))
        @gui.set_on_tic(method(:refresh))
      end

      def show; @gui.show; end
      def close; @gui.close; end

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
        @gui.update(@ttt.marks)
      end

      def refresh_result()
        @gui.announce(@ttt.winner) if @ttt.is_finished?()
      end
    end
  end
end
