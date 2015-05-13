require 'Qt'

module Tictactoe
  module Gui
    module QtGui
      class Board
        class Cell < Qt::PushButton
          def initialize(parent, move)
            super(parent)
            @move = move

            i = move.to_s
            self.objectName = "cell_#{i}"
          end

          attr_reader :move
        end

        attr_reader :layout

        def initialize(cell_count, on_move)
          @cell_count = cell_count
          @on_move = on_move
        end

        def set_parent(parent)
          @parent = parent.root
          init
        end

        def update(marks)
          @cells.zip(marks) do |cell, mark|
            cell.text = mark.to_s
          end
        end

        private
        def init
          cell_count = @cell_count
          parent = @parent
          on_move = @on_move

          cells = create_cells(cell_count, parent)
          layout = layout_board(cell_count, on_move, cells)

          @cells = cells
          @layout = layout
        end

        def create_cells(cell_count, parent)
          (0..cell_count-1).map do |move|
            Cell.new(parent, move)
          end
        end

        def layout_board(cell_count, on_move,  cells)
          board_layout = Qt::GridLayout.new()
          board_layout.object_name = "board_layout"

          expanding_policy = Qt::SizePolicy.new(Qt::SizePolicy::Expanding, Qt::SizePolicy::Expanding)

          side_size = Math.sqrt(cell_count)
          coordinates_sequence = (0..side_size-1).to_a.repeated_permutation(2)
          cells.zip(coordinates_sequence) do |cell, coordinates|
            x,y = coordinates

            board_layout.add_widget(cell, x, y, 1, 1)

            cell.size_policy = expanding_policy
            cell.connect(SIGNAL :clicked) do 
              on_move.call(cell.move)
            end
          end

          board_layout
        end
      end
    end
  end
end
