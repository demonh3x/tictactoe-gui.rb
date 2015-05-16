require 'Qt'

module Tictactoe
  module Gui
    module QtGui
      module Widgets
        class Timer
          def initialize(on_tic)
            @on_tic = on_tic
          end

          def set_parent(parent)
            @parent = parent
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
            on_tic = @on_tic

            timer = timer(parent, on_tic)

            @timer = timer
          end

          def timer(parent, on_tic)
            timer = Qt::Timer.new(parent)
            timer.object_name = 'timer'
            timer.connect(SIGNAL :timeout) do 
              on_tic.call()
            end
            timer
          end
        end
      end
    end
  end
end
