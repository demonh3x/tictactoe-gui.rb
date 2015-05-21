require 'Qt'

module Tictactoe
  module Gui
    module QtGui
      module Widgets
        class Options
          attr_reader :layout

          def initialize(options, on_select)
            self.options = options
            self.on_select = on_select
          end

          def set_parent(parent)
            self.parent = parent
            init
          end

          private
          attr_accessor :parent, :options, :on_select

          def init
            buttons = options.map {|id, text| create_button(parent, id, text, on_select)}
            layout = create_layout(buttons)

            @layout = layout
          end

          def create_layout(widgets)
            layout = Qt::GridLayout.new()
            widgets.each_with_index do |widget, column|
              layout.add_widget(widget, 0, column, 1, 1)
            end
            layout
          end

          def create_button(parent, id, text, on_select)
            button = Qt::PushButton.new(parent)
            button.object_name = id.to_s
            button.text = text
            button.connect(SIGNAL :clicked) do 
              on_select.call(id)
            end
            button
          end
        end
      end
    end
  end
end
