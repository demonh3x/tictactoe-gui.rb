require 'Qt'

module Tictactoe
  module Gui
    class GameWindow
      attr_reader :qt_root

      def initialize(tictactoe, side_size, on_selection)

        @ttt = tictactoe
        @moves = Moves.new

        @factory = QtGui::WidgetFactory.new()

        @window = @factory.new_window()
        @qt_root = @window.root

        @board = @factory.new_board(side_size * side_size, method(:on_move))
        @result = @factory.new_result()
        play_again = @factory.new_play_again(on_selection)
        @factory.layout(@window, @board, @result, play_again)

        @timer = @factory.new_timer(method(:tick))
        @timer.set_parent(@window)
        @timer.start
      end

      def close
        @timer.stop
        @qt_root.close
      end

      private
      def on_move(move)
        @moves.add(move)
        @ttt.tick(@moves)
        refresh_board
        refresh_result
      end

      def tick
        @ttt.tick(@moves)
        refresh_board
        refresh_result
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

      class Result
        attr_reader :layout

        def set_parent(parent)
          @parent = parent.root
          init
        end

        def text=(text)
          @widget.text = text
        end

        private
        def init
          parent = @parent

          widget = create_widget(parent)
          layout = create_layout(widget)

          @widget = widget
          @layout = layout
        end

        def create_layout(widget)
          layout = Qt::GridLayout.new()
          layout.add_widget(widget, 0, 0, 1, 1)
          layout
        end

        def create_widget(parent)
          result = Qt::Label.new(parent)
          result.object_name = "result"
          result
        end
      end

      class PlayAgain
        attr_reader :layout

        def initialize(on_select)
          @on_select = on_select
        end

        def set_parent(parent)
          @parent = parent.root
          init
        end

        private
        def init
          parent = @parent
          on_select = @on_select

          layout = layout_play_again(
            button_play_again(parent, on_select),
            button_close(parent, on_select),
          )

          @layout = layout
        end

        def layout_play_again(play_again, close)
          buttons = Qt::GridLayout.new()
          buttons.add_widget(play_again, 1, 0, 1, 1)
          buttons.add_widget(close, 1, 1, 1, 1)
          buttons
        end

        def button_play_again(parent, on_select)
          play_again = Qt::PushButton.new(parent)
          play_again.object_name = "play_again"
          play_again.text = "Play again"
          play_again.connect(SIGNAL :clicked) do 
            on_select.call(parent, :play_again)
          end
          play_again
        end

        def button_close(parent, on_select)
          close = Qt::PushButton.new(parent)
          close.object_name = "close"
          close.text = "Close"
          close.connect(SIGNAL :clicked) do 
            on_select.call(parent, :close)
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

        private
        def create_main_layout(parent)
          main_layout = Qt::GridLayout.new(parent)
          main_layout.object_name = "main_layout"
          main_layout
        end
      end

      class Timer
        def initialize(on_timeout)
          @on_timeout = on_timeout
        end

        def set_parent(parent)
          @parent = parent.root
          init
        end

        def start
          @timer.start
        end

        def stop
          @timer.stop
        end

        private
        def init
          parent = @parent
          on_timeout = @on_timeout

          timer = timer(parent, on_timeout)

          @timer = timer
        end

        def timer(parent, on_timeout)
          timer = Qt::Timer.new(parent)
          timer.object_name = 'timer'
          timer.connect(SIGNAL :timeout) do 
            on_timeout.call()
          end
          timer
        end
      end
      
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

        def new_play_again(on_select)
          PlayAgain.new(on_select)
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
