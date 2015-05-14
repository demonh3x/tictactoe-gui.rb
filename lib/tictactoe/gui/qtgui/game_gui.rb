require 'tictactoe/gui/qtgui/widgets/factory'

module Tictactoe
  module Gui
    module QtGui
      class GameGui
        attr_reader :qt_root

        def set_board_size(size)
          @size = size * size
          init
        end

        def on_play_again(listener)
          @on_play_again = listener
          init
        end

        def on_move(listener)
          @on_move = listener
          init
        end

        def on_tic(listener)
          @on_tic = listener
          init
        end

        def update(marks)
          check
          @board.update(marks)
        end

        def announce(winner)
          check
          @result.announce(winner)
        end

        def show()
          check
          @timer.start()
          @window.show()
        end

        def close()
          check
          @timer.stop()
          @window.close()
        end

        private
        def is_initialized?
          @on_play_again && @on_move && @on_tic && @size
        end

        def init
          return unless is_initialized?

          @widget_factory = QtGui::Widgets::Factory.new()
          @board = @widget_factory.new_board(@size, @on_move)
          @result = @widget_factory.new_result()
          @play_again = @widget_factory.new_options(
            [:play_again, :close],
            lambda{|widget, selection|
              close()
              @on_play_again.call() if selection == :play_again
            }
          )
          @timer = @widget_factory.new_timer(@on_tic)

          @window = @widget_factory.new_window(240, 340)
          @widget_factory.layout(@window, [@board, @result, @play_again, @timer])

          @qt_root = @widget_factory.window.root
        end

        def check
          raise "Not initialized completelly" unless is_initialized?
        end
      end
    end
  end
end
