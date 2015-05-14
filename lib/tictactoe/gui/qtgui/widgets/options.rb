require 'Qt'

module Tictactoe
  module Gui
    module QtGui
      module Widgets
        class Options
          attr_reader :layout

          def initialize(options, on_select)
            @options = options
            @on_select = on_select
          end

          def set_parent(parent)
            @parent = parent
            init
          end

          private
          def init
            parent = @parent
            on_select = @on_select
            options = @options

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
            b = Qt::PushButton.new(parent)
            b.object_name = id.to_s
            b.text = text
            b.connect(SIGNAL :clicked) do 
              on_select.call(id)
            end
            b
          end
        end
      end
    end
  end
end
