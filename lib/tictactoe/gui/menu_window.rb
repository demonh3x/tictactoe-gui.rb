require 'Qt'

module Tictactoe
  module Gui
    class MenuWindow 
      attr_reader :qt_window

      def initialize(on_configured)
        @widget_factory = QtGui::WidgetFactory.new()
        @window = @widget_factory.new_window(240, 150)
        @game_options = @widget_factory.new_game_options(on_configured)
        @widget_factory.layout(@window, [@game_options])

        @qt_window = @widget_factory.window.root
      end

      def show
        @qt_window.show
      end
    end
  end
end
