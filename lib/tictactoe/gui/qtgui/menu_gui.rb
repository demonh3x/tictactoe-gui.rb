require 'tictactoe/gui/qtgui/widgets/factory'

module Tictactoe
  module Gui
    module QtGui
      class MenuGui
        attr_reader :qt_root

        def on_configured(listener)
          @on_configured = listener
          init
        end

        private
        def init  
          widget_factory = QtGui::Widgets::Factory.new()
          window = widget_factory.new_window(240, 150)
          game_options = widget_factory.new_game_options(@on_configured)
          window.add(game_options)

          @qt_root = window.root
        end
      end
    end
  end
end
