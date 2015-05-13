require 'Qt'

module Tictactoe
  module Gui
    class GameWindow
      attr_reader :qt_root

      def initialize(tictactoe, side_size, on_select)
        @ttt = tictactoe
        @moves = Moves.new

        @factory = QtGui::WidgetFactory.new()

        cell_count = side_size * side_size
        @board = @factory.new_board(cell_count, method(:on_move))
        @result = @factory.new_result()
        play_again = @factory.new_options([:play_again, :close], on_select)

        @window = @factory.new_window()
        @factory.layout(@window, @board, @result, play_again)

        @timer = @factory.new_timer(method(:tick))
        @timer.set_parent(@window)
        @timer.start

        @qt_root = @window.root
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
          @result.announce(@ttt.winner)
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

        def announce(winner)
          if winner == nil
            @widget.text = "It is a draw."
          else
            @widget.text = "Player #{winner.to_s.upcase} has won."
          end
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

      class Options
        attr_reader :layout

        def initialize(options, on_select)
          @options = options
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
          options = @options

          buttons = options.map {|option| create_button(parent, option, on_select)}
          layout = create_layout(buttons)

          @layout = layout
        end

        def create_layout(widgets)
          layout = Qt::GridLayout.new()
          widgets.each_with_index do |widget, column|
            layout.add_widget(widget, 0, column, 1, 1)
          end
          layout
        end

        def create_button(parent, id, on_select)
          b = Qt::PushButton.new(parent)
          b.object_name = id.to_s
          b.text = id.to_s.sub('_', ' ').capitalize
          b.connect(SIGNAL :clicked) do 
            on_select.call(parent, id)
          end
          b
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
