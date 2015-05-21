require 'Qt'

module Tictactoe
  module Gui
    module QtGui
      module Widgets
        class Timer
          def initialize(on_tic)
            self.on_tic = on_tic
          end

          def set_parent(parent)
            self.parent = parent
            init
          end

          def start
            timer.start
          end

          def stop
            timer.stop
          end

          private
          attr_accessor :on_tic, :parent, :timer

          def init
            self.timer = create_timer(parent, on_tic)
          end

          def create_timer(parent, on_tic)
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
