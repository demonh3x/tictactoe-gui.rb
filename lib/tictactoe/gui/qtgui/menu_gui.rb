require 'tictactoe/gui/events'

module Tictactoe
  module Gui
    module QtGui
      class MenuGui
        include Events
        receives_handlers_for :on_configured

        def initialize(widget_factory)
          self.window = widget_factory.new_window(240, 150)
          game_options = widget_factory.new_game_options(lambda{|options|
            window.close
            notifier(:on_configured).call(options)
          })
          window.add(game_options)
        end

        def show
          window.show
        end

        private
        attr_accessor :window
      end
    end
  end
end
