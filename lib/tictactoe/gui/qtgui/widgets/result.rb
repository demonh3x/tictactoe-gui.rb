require 'Qt'

module Tictactoe
  module Gui
    module QtGui
      module Widgets
        class Result
          attr_reader :layout

          def set_parent(parent)
            self.parent = parent
            init
          end

          def announce(winner)
            if winner == nil
              widget.text = "It is a draw."
            else
              widget.text = "Player #{winner.to_s.upcase} has won."
            end
          end

          private
          attr_accessor :parent, :widget

          def init
            self.widget = create_widget(parent)
            @layout = create_layout(widget)
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
      end
    end
  end
end
