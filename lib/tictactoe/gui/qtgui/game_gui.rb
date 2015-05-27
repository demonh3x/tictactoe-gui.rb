require 'tictactoe/gui/events'

module Tictactoe
  module Gui
    module QtGui
      class GameGui
        include Events
        receives_handlers_for :on_move, :on_tick, :on_play_again

        def initialize(widget_factory, board_side_size)
          self.board = widget_factory.new_board(board_side_size, notifier(:on_move))
          self.timer = widget_factory.new_timer(notifier(:on_tick))
          self.result = widget_factory.new_result
          play_again = widget_factory.new_options(
            {:play_again => "Play again", :close => "Close"},
            lambda{|selection|
              window.close
              timer.stop
              notifier(:on_play_again).call if selection == :play_again
            }
          )

          self.window = widget_factory.new_window(240, 340)
          window.add(board, result, play_again, timer)
        end

        def show
          window.show
          timer.start
        end

        def update(state)
          board.update(state.marks)
          result.announce(state.winner) if state.is_finished?
        end

        private
        attr_accessor :window, :board, :result, :timer
      end
    end
  end
end
