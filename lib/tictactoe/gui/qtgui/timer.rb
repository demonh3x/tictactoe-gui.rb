require 'Qt'

module Tictactoe
  module Gui
    module QtGui
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
    end
  end
end
