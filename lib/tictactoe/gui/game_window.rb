require 'Qt'

module Tictactoe
  module Gui
    class GameWindow < Qt::Widget
      def initialize(tictactoe, side_size, on_final_selection)
        super(nil)

        @factory = QtUi.new(self) #SMELL: self should not be passed to factory
        @window = @factory.create_window

        @ttt = tictactoe
        @on_final_selection = on_final_selection
        @moves = Moves.new

        self.object_name = "main_window"
        self.resize(240, 340)

        @main_layout = @window.main_layout
        @board = @factory.create_board(side_size * side_size, method(:on_move))
        @main_layout.add_layout(@board.layout, 0, 0, 1, 1)
        @result = widget_result
        @main_layout.add_widget(@result, 1, 0, 1, 1)
        @main_layout.add_layout(layout_play_again, 2, 0, 1, 1)

        @timer = timer
        @timer.start
      end

      def close
        @timer.stop
        super
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

      def widget_result
        result = Qt::Label.new(self)
        result.object_name = "result"
        result
      end

      def layout_play_again
        buttons = Qt::GridLayout.new()
        buttons.add_widget(button_play_again, 1, 0, 1, 1)
        buttons.add_widget(button_close, 1, 1, 1, 1)
        buttons
      end

      def button_play_again
        play_again = Qt::PushButton.new(self)
        play_again.object_name = "play_again"
        play_again.text = "Play again"
        Qt::Object.connect(play_again, SIGNAL('clicked()'), self, SLOT("on_play_again()"))
        play_again
      end

      slots :on_play_again
      def on_play_again
        @on_final_selection.call(self, :play_again)
      end

      def button_close
        close = Qt::PushButton.new(self)
        close.object_name = "close"
        close.text = "Close"
        Qt::Object.connect(close, SIGNAL('clicked()'), self, SLOT("on_close()"))
        close
      end

      slots :on_close
      def on_close
        @on_final_selection.call(self, :close)
      end

      def timer
        timer = Qt::Timer.new(self)
        timer.object_name = 'timer'
        Qt::Object.connect(timer, SIGNAL('timeout()'), self, SLOT('tick()'))
        timer
      end

      slots :tick
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

    class QtUi
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

      class Window 
        attr_reader :main_layout

        def initialize(parent)
          @parent = parent
          @main_layout = create_main_layout
        end

        def create_main_layout
          main_layout = Qt::GridLayout.new(@parent)
          main_layout.object_name = "main_layout"
          main_layout
        end
      end

      def initialize(parent)
        @parent = parent
      end

      def create_board(cell_count, on_move)
        Board.new(@parent, cell_count, on_move) 
      end

      def create_window()
        Window.new(@parent)
      end

      def join(parent, child)
      end
    end
  end
end
