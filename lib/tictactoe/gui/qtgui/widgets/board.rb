require 'Qt'

module Tictactoe
  module Gui
    module QtGui
      module Widgets
        class Board
          attr_reader :layout

          def initialize(side_size, on_move)
            self.cell_count = side_size * side_size
            self.on_move = on_move
            init
          end

          def set_parent(parent)
          end

          def update(marks)
            cells.zip(marks) do |cell, mark|
              cell.text = mark.to_s
            end
          end

          private
          attr_accessor :cell_count, :on_move, :cells

          def init
            self.cells = create_cells(cell_count, on_move)
            @layout = layout_board(cells)
          end

          def create_cells(cell_count, on_move)
            (0..cell_count-1).map do |move|
              b = Qt::PushButton.new
              b.objectName = "cell_#{move.to_s}"
              b.connect(SIGNAL :clicked) do 
                on_move.call(move)
              end
              b
            end
          end

          def layout_board(cells)
            board_layout = Qt::GridLayout.new()
            board_layout.object_name = "board_layout"

            expanding_policy = Qt::SizePolicy.new(Qt::SizePolicy::Expanding, Qt::SizePolicy::Expanding)

            side_size = Math.sqrt(cells.count)
            coordinates_sequence = (0..side_size-1).to_a.repeated_permutation(2)
            cells.zip(coordinates_sequence) do |cell, coordinates|
              x,y = coordinates

              board_layout.add_widget(cell, x, y, 1, 1)

              cell.size_policy = expanding_policy
            end

            board_layout
          end
        end
      end
    end
  end
end
