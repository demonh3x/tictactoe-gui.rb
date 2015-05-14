require 'Qt'

module Tictactoe
  module Gui
    class MenuWindow 
      def initialize(menu_gui, on_configured)
        @gui = menu_gui
        menu_gui.on_configured(on_configured)
      end

      def show
        @gui.show
      end

      def hide
        @gui.hide
      end
    end
  end
end
