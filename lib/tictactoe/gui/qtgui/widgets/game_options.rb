require 'Qt'

module Tictactoe
  module Gui
    module QtGui
      module Widgets
        class GameOptions
          attr_reader :layout

          def initialize(on_select)
            @selection = {}
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

            layout = new_main_layout
            layout.add_widget(widget_x_selector(parent), 0, 0, 1, 1)
            layout.add_widget(widget_o_selector(parent), 0, 1, 1, 1)
            layout.add_widget(widget_board_selector(parent), 0, 2, 1, 1)
            ws = widget_start(
              parent,
              lambda{
                on_select.call(@selection)
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
              [
                [:x_human,    "human",    lambda{|sel| sel[:x] = :human}, :default],
                [:x_computer, "computer", lambda{|sel| sel[:x] = :computer}],
              ]
            )
          end

          def widget_o_selector(parent)
            widget_options(
              parent,
              "player o",
              [
                [:o_human,    "human",    lambda{|sel| sel[:o] = :human}, :default],
                [:o_computer, "computer", lambda{|sel| sel[:o] = :computer}],
              ]
            )
          end

          def widget_board_selector(parent)
            widget_options(
              parent,
              "board size",
              [
                [:board_3, "3", lambda{|sel| sel[:board] = 3}, :default],
                [:board_4, "4", lambda{|sel| sel[:board] = 4}],
              ]
            )
          end

          def widget_options(parent, title, options)
            group = Qt::GroupBox.new(title)
            layout = Qt::VBoxLayout.new()

            options.each do |id, text, selection_fn, is_default|
              option = Qt::RadioButton.new(parent)
              option.object_name = id.to_s
              option.text = text
              select = lambda{
                selection_fn.call(@selection)
                option.checked = true
              }
              option.connect(SIGNAL :clicked) do
                select.call
              end
              select.call if is_default
              layout.add_widget(option)
            end

            group.set_layout(layout)
            group
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
end
