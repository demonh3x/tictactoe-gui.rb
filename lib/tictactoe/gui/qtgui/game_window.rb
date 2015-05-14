module Tictactoe
  module Gui
    module QtGui
      class GameWindow
        def set_widget_factory(widget_factory)
          @widget_factory = widget_factory
          init
        end
        def set_board_size(size)
          @size = size * size
          init
        end

        def set_on_select_option(listener)
          @on_select_option = listener
          init
        end

        def set_on_move(listener)
          @on_move = listener
          init
        end

        def set_on_tic(listener)
          @on_tic = listener
          init
        end

        def update(marks)
          @board.update(marks)
        end

        def announce(winner)
          @result.announce(winner)
        end

        def show()
          @timer.start()
          @window.show()
        end

        def close()
          @timer.stop()
          @window.close()
        end

        private
        def init
          return unless @widget_factory && @on_select_option && @on_move && @on_tic && @size

          @board = @widget_factory.new_board(@size, @on_move)
          @result = @widget_factory.new_result()
          @play_again = @widget_factory.new_options([:play_again, :close], @on_select_option)
          @timer = @widget_factory.new_timer(@on_tic)

          @window = @widget_factory.new_window()
          @widget_factory.layout(@window, [@board, @result, @play_again, @timer])
        end
      end
    end
  end
end
