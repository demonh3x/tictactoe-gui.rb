require 'Qt'

module Tictactoe
  module Gui
    module QtGui
      class GameOptions
        attr_reader :layout

        def initialize(on_select)
          @on_select = on_select
          @selection = {
            :x => :human,
            :o => :human,
            :board => 3,
          }
        end

        def set_parent(parent)
          @parent = parent.root
          init
        end

        private
        def init
          parent = @parent
          on_select = @on_select

          layout = new_main_layout
          layout.add_widget(widget_x_selector(parent), 0, 0, 1, 1)
          layout.add_widget(widget_o_selector(parent), 0, 1, 1, 1)
          layout.add_widget(widget_board_selector(parent), 0, 2, 1, 1)
          ws = widget_start(
            parent,
            lambda{
              on_select.call(parent, @selection)
            }
          )
          layout.add_widget(ws, 1, 0, 1, 3)

          @layout = layout
        end

        def new_main_layout()
          main_layout = Qt::GridLayout.new()
          main_layout.object_name = "game_options_layout"
          main_layout
        end

        def widget_x_selector(parent)
          widget_options(
            parent,
            "player x",
            {
              :x_human => "human",
              :x_computer => "computer",
            }
          )
        end

        def widget_o_selector(parent)
          widget_options(
            parent,
            "player o",
            {
              :o_human => "human",
              :o_computer => "computer",
            }
          )
        end

        def widget_board_selector(parent)
          widget_options(
            parent,
            "board size",
            {
              :board_3 => "3",
              :board_4 => "4",
            }
          )
        end

        def widget_options(parent, title, options)
          group = Qt::GroupBox.new(title)
          layout = Qt::VBoxLayout.new()

          first_option = nil
          options.each do |id, text|
            option = Qt::RadioButton.new(parent)
            first_option ||= option
            option.object_name = id.to_s
            option.text = text.to_s
            option.connect(SIGNAL :clicked) do
              option_selected(id)
            end
            layout.add_widget(option)
          end

          first_option.checked = true

          group.set_layout(layout)
          group
        end

        def option_selected(id)
          case id
          when :x_human
            @selection[:x] = :human
          when :o_human
            @selection[:o] = :human
          when :x_computer
            @selection[:x] = :computer
          when :o_computer
            @selection[:o] = :computer
          when :board_3
            @selection[:board] = 3
          when :board_4
            @selection[:board] = 4
          end
        end

        def widget_start(parent, on_click)
          b = Qt::PushButton.new(parent)
          b.object_name = "start"
          b.text = "Start game"
          b.connect(SIGNAL :clicked) do
            on_click.call()
          end
          b
        end
      end
    end
  end
end
