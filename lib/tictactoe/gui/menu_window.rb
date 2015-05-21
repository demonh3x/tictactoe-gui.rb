require 'Qt'

module Tictactoe
  module Gui
    class MenuWindow 
      def initialize(menu_gui, on_configured)
        self.gui = menu_gui
        menu_gui.on_configured(on_configured)
      end

      def show
        gui.show
      end

      private
      attr_accessor :gui
    end
  end
end
