require 'tictactoe/gui/qtgui/widgets/board'
require 'tictactoe/gui/qtgui/widgets/window'
require 'tictactoe/gui/qtgui/widgets/result'
require 'tictactoe/gui/qtgui/widgets/options'
require 'tictactoe/gui/qtgui/widgets/game_options'
require 'tictactoe/gui/qtgui/widgets/timer'

module Tictactoe
  module Gui
    module QtGui
      module Widgets
        class Factory
          def new_board(cell_count, on_move)
            Board.new(cell_count, on_move) 
          end

          def new_window(width, height)
            window = Window.new(width, height)
            created_windows << window
            window
          end

          def created_windows
            @windows ||= []
          end

          def new_result()
            Result.new()
          end

          def new_options(options, on_select)
            Options.new(options, on_select)
          end

          def new_timer(on_tic)
            Timer.new(on_tic)
          end

          def new_game_options(on_select)
            GameOptions.new(on_select)
          end
        end
      end
    end
  end
end
