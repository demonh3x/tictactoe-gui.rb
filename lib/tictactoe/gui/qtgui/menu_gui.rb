module Tictactoe
  module Gui
    module QtGui
      class MenuGui
        attr_reader :qt_root

        def initialize(widget_factory)
          @widget_factory = widget_factory
        end

        def on_configured(handler)
          self.on_configured_handler = handler
          init
        end

        def show
          window.show
        end

        private
        attr_accessor :widget_factory
        attr_accessor :window, :on_configured_handler

        def init  
          self.window = widget_factory.new_window(240, 150)
          game_options = widget_factory.new_game_options(lambda{|options|
            window.close
            on_configured_handler.call(options)
          })
          window.add(game_options)

          @qt_root = window.root
        end
      end
    end
  end
end
