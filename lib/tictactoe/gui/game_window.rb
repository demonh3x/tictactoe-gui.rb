require 'Qt'

module Tictactoe
  module Gui
    class GameWindow < Qt::Widget
      def initialize(tictactoe, side_size, on_final_selection)
        super(nil)

        @dimensions = 2
        @side_size = side_size
        @ttt = tictactoe
        @on_final_selection = on_final_selection
        @moves = Moves.new

        self.object_name = "main_window"
        self.resize(240, 340)

        @main_layout = main_layout
        @cells = create_cells
        @main_layout.add_layout(layout_board(@cells), 0, 0, 1, 1)
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
      def main_layout
        main_layout = Qt::GridLayout.new(self)
        main_layout.object_name = "main_layout"
        main_layout
      end

      def create_cells
        cell_count = @side_size ** @dimensions
        (0..cell_count-1).map {|move| Cell.new(self, move)}
      end

      def layout_board(cells)
        board_layout = Qt::GridLayout.new()
        board_layout.object_name = "board_layout"

        expanding_policy = Qt::SizePolicy.new(Qt::SizePolicy::Expanding, Qt::SizePolicy::Expanding)

        coordinates_sequence = (0..@side_size-1).to_a.repeated_permutation(@dimensions)
        cells.each do |cell|
          coordinates = coordinates_sequence.next
          x = coordinates[0]
          y = coordinates[1]
          board_layout.add_widget(cell, x, y, 1, 1)
          cell.size_policy = expanding_policy
          Qt::Object.connect(cell, SIGNAL('clicked()'), self, SLOT("cell_clicked()"))
        end

        board_layout
      end

      slots :cell_clicked
      def cell_clicked
        make_move(sender.move)
        refresh_board
        refresh_result
      end

      def make_move(move)
        @moves.add(move)
        @ttt.tick(@moves)
      end

      def refresh_board
        marks = @ttt.marks

        @cells.each_with_index do |cell, index|
          mark = marks[index]
          cell.text = mark.to_s
        end
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

    class Cell < Qt::PushButton
      def initialize(parent, move)
        super(parent)
        @move = move

        i = move.to_s
        self.objectName = "cell_#{i}"
      end

      attr_reader :move
    end
  end
end
