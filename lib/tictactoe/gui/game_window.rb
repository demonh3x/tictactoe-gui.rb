require 'Qt'

module Tictactoe
  module Gui
    class GameWindow
      attr_reader :qt_root

      def initialize(tictactoe, side_size, on_final_selection)
        @window = QtGui::WidgetFactory.create_window()
        @factory = QtGui::WidgetFactory.new(@window.root)
        @qt_root = @window.root

        @ttt = tictactoe
        @on_final_selection = on_final_selection
        @moves = Moves.new

        @main_layout = @window.layout
        @board = @factory.create_board(side_size * side_size, method(:on_move))
        @result = @factory.create_result()
        play_again = @factory.create_play_again(@on_final_selection)
        @factory.layout(@window, @board, @result, play_again)

        @timer = timer
        @timer.start
      end

      def close
        @timer.stop
        @qt_root.close
      end

      private

      def on_move(move)
        make_move(move)
        refresh_board
        refresh_result
      end

      def make_move(move)
        @moves.add(move)
        @ttt.tick(@moves)
      end

      def refresh_board
        @board.update(@ttt.marks)
      end

      def refresh_result
        if @ttt.is_finished?
          winner = @ttt.winner

          if winner == nil
            @result.text = "It is a draw."
          else
            @result.text = "Player #{winner.to_s.upcase} has won."
          end
        end
      end

      def timer
        timer = Qt::Timer.new(@qt_root)
        timer.object_name = 'timer'
        timer.connect(SIGNAL :timeout) do 
          tick()
        end
        timer
      end

      def tick
        @ttt.tick(@moves)
        refresh_board
        refresh_result
      end
    end

    class Moves
      def initialize()
        @moves = []
      end

      def add(move)
        @moves.push(move)
      end

      def get_move!
        @moves.pop
      end
    end

    module QtGui
      class Cell < Qt::PushButton
        def initialize(parent, move)
          super(parent)
          @move = move

          i = move.to_s
          self.objectName = "cell_#{i}"
        end

        attr_reader :move
      end

      class Board
        attr_reader :layout

        def initialize(parent, cell_count, on_move)
          @parent = parent
          @cell_count = cell_count
          @on_move = on_move

          @cells = create_cells
          @layout = layout_board(@cells)
        end

        def update(marks)
          @cells.zip(marks) do |cell, mark|
            cell.text = mark.to_s
          end
        end

        private
        def create_cells
          (0..@cell_count-1).map do |move|
            Cell.new(@parent, move)
          end
        end

        def layout_board(cells)
          board_layout = Qt::GridLayout.new()
          board_layout.object_name = "board_layout"

          expanding_policy = Qt::SizePolicy.new(Qt::SizePolicy::Expanding, Qt::SizePolicy::Expanding)

          side_size = Math.sqrt(@cell_count)
          coordinates_sequence = (0..side_size-1).to_a.repeated_permutation(2)
          cells.zip(coordinates_sequence) do |cell, coordinates|
            x,y = coordinates

            board_layout.add_widget(cell, x, y, 1, 1)

            cell.size_policy = expanding_policy
            cell.connect(SIGNAL :clicked) do 
              @on_move.call(cell.move)
            end
          end

          board_layout
        end
      end

      class Result
        attr_reader :layout

        def initialize(parent)
          @parent = parent
          @widget = create_widget
          @layout = create_layout(@widget)
        end

        def text=(text)
          @widget.text = text
        end

        private
        def create_layout(widget)
          layout = Qt::GridLayout.new()
          layout.add_widget(widget, 0, 0, 1, 1)
          layout
        end

        def create_widget
          result = Qt::Label.new(@parent)
          result.object_name = "result"
          result
        end
      end

      class PlayAgain
        attr_reader :layout

        def initialize(parent, on_select)
          @parent = parent
          @on_final_selection = on_select
          @layout = layout_play_again
        end

        private
        def layout_play_again
          buttons = Qt::GridLayout.new()
          buttons.add_widget(button_play_again, 1, 0, 1, 1)
          buttons.add_widget(button_close, 1, 1, 1, 1)
          buttons
        end

        def button_play_again
          play_again = Qt::PushButton.new(@parent)
          play_again.object_name = "play_again"
          play_again.text = "Play again"
          play_again.connect(SIGNAL :clicked) do 
            @on_final_selection.call(@parent, :play_again)
          end
          play_again
        end

        def button_close
          close = Qt::PushButton.new(@parent)
          close.object_name = "close"
          close.text = "Close"
          close.connect(SIGNAL :clicked) do 
            @on_final_selection.call(@parent, :close)
          end
          close
        end
      end

      class Window
        attr_reader :root
        attr_reader :layout

        def initialize()
          @root = Qt::Widget.new()
          @root.object_name = "main_window"
          @root.resize(240, 340)
          @layout = create_main_layout(@root)
        end

        def create_main_layout(parent)
          main_layout = Qt::GridLayout.new(parent)
          main_layout.object_name = "main_layout"
          main_layout
        end
      end
      
      class WidgetFactory
        def initialize(parent)
          @parent = parent
        end

        def create_board(cell_count, on_move)
          Board.new(@parent, cell_count, on_move) 
        end

        def self.create_window
          Window.new()
        end

        def create_result()
          Result.new(@parent)
        end

        def create_play_again(on_select)
          PlayAgain.new(@parent, on_select)
        end

        def layout(parent, *children)
          children.each_with_index do |child, row|
            parent.layout.add_layout(child.layout, row, 0, 1, 1)
          end
        end
      end
    end
  end
end
