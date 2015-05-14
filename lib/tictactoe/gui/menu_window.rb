require 'Qt'

module Tictactoe
  module Gui
    class MenuWindow 
      def initialize(menu_gui, on_configured)
        menu_gui.on_configured(on_configured)
      end
    end
  end
end
