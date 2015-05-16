require 'Qt'

module Tictactoe
  module Gui
    module QtGui
      module Widgets
        class Window
          attr_reader :root

          def initialize(width, height)
            @root = create_root(width, height)
            @layout = create_layout(@root, "main_layout")
          end

          def close
            root.close
          end

          def show
            root.show
          end

          def add(*children)
            children.each_with_index do |child, row|
              child.set_parent(self.root)
              layout.add_layout(child.layout, row, 0, 1, 1) if child.respond_to? "layout"
            end
          end

          private
          attr_reader :layout

          def create_root(width, height)
            root = Qt::Widget.new()
            root.object_name = "main_window"
            root.resize(width, height)
            root
          end

          def create_layout(parent, name)
            layout = Qt::GridLayout.new(parent)
            layout.object_name = name
            layout
          end
        end
      end
    end
  end
end
