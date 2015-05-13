require 'tictactoe/gui/qtgui/board'
require 'tictactoe/gui/qtgui/window'
require 'tictactoe/gui/qtgui/result'
require 'tictactoe/gui/qtgui/options'
require 'tictactoe/gui/qtgui/timer'

module Tictactoe
  module Gui
    module QtGui
      class WidgetFactory
        def new_board(cell_count, on_move)
          Board.new(cell_count, on_move) 
        end

        def new_window()
          Window.new()
        end

        def new_result()
          Result.new()
        end

        def new_options(options, on_select)
          Options.new(options, on_select)
        end

        def new_timer(on_timeout)
          Timer.new(on_timeout)
        end

        def layout(window, *children)
          children.each_with_index do |child, row|
            child.set_parent(window)
            window.layout.add_layout(child.layout, row, 0, 1, 1)
          end
        end
      end
    end
  end
end
