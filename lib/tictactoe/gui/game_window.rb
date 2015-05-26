module Tictactoe
  module Gui
    class GameWindow
      def initialize(game, game_gui)
        @game = game
        @game_gui = game_gui

        game.register_human_factory(lambda{|mark| HumanPlayer.new(game_gui, mark)})

        game_gui.set_board_size(game.marks.length)

        game_gui.on_move(method(:on_move))
        game_gui.on_tic(method(:refresh))
      end

      def show
        game_gui.show
      end

      private
      attr_reader :game, :game_gui

      def on_move(move)
        refresh
      end

      def refresh
        game.tick
        refresh_board
        refresh_result
      end

      def refresh_board
        game_gui.update(game.marks)
      end

      def refresh_result
        game_gui.announce(game.winner) if game.is_finished?
      end
    end
  end
end
