module Tictactoe
  module Gui
    module QtGui
      class GameGui
        attr_reader :qt_root

        def initialize(widget_factory)
          @widget_factory = widget_factory
        end

        def set_board_size(size)
          self.size = size
          init
        end

        def on_play_again(handler)
          self.on_play_again_handler = handler
          init
        end

        def on_move(handler)
          on_move_hanlders << handler
          init
        end

        def on_tic(handler)
          self.on_tic_handler = handler
          init
        end

        def update(marks)
          check
          board.update(marks)
        end

        def announce(winner)
          check
          result.announce(winner)
        end

        def show
          check
          timer.start
          window.show
        end

        def close
          check
          timer.stop
          window.close
        end

        private
        attr_accessor :widget_factory
        attr_accessor :size, :on_play_again_handler, :on_tic_handler, :board, :play_again, :result, :timer, :window

        def on_move_hanlders
          @on_move_hanlders ||= []
        end

        def notify_on_move(move)
          on_move_hanlders.each do |handler|
            handler.call(move)
          end
        end

        def is_initialized?
          on_play_again_handler && on_tic_handler && size
        end

        def init
          return unless is_initialized?

          self.board = widget_factory.new_board(size, method(:notify_on_move))
          self.result = widget_factory.new_result()
          self.play_again = widget_factory.new_options(
            {:play_again => "Play again", :close => "Close"},
            lambda{|selection|
              close()
              on_play_again_handler.call() if selection == :play_again
            }
          )
          self.timer = widget_factory.new_timer(on_tic_handler)

          self.window = widget_factory.new_window(240, 340)
          window.add(board, result, play_again, timer)

          @qt_root = window.root
        end

        def check
          raise "Not initialized completelly" unless is_initialized?
        end
      end
    end
  end
end
