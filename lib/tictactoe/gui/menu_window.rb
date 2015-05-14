require 'Qt'

module Tictactoe
  module Gui
    class MenuWindow < Qt::Widget
      def initialize(start_callback)
        super(nil)
        @start_callback = start_callback
        @options = {
          :x => :human,
          :o => :human,
          :board => 3,
        }

        self.object_name = "main_window"
        self.resize(240, 150)

        main_layout = new_main_layout(self)
        main_layout.add_widget(widget_x_selector(self), 0, 0, 1, 1)
        main_layout.add_widget(widget_o_selector(self), 0, 1, 1, 1)
        main_layout.add_widget(widget_board_selector(self), 0, 2, 1, 1)
        main_layout.add_widget(widget_start(self), 1, 0, 1, 3)
      end
      
      private
      def new_main_layout(parent)
        main_layout = Qt::GridLayout.new(parent)
        main_layout.object_name = "main_layout"
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
          Qt::Object.connect(option, SIGNAL('clicked()'), parent, SLOT('option_selected()'))
          layout.add_widget(option)
        end

        first_option.checked = true

        group.set_layout(layout)
        group
      end

      def widget_start(parent)
        b = Qt::PushButton.new(parent)
        b.object_name = "start"
        b.text = "Start game"
        Qt::Object.connect(b, SIGNAL('clicked()'), parent, SLOT('start_game()'))
        b
      end

      slots :option_selected
      def option_selected
        case sender.object_name
        when "x_human"
          @options[:x] = :human
        when "o_human"
          @options[:o] = :human
        when "x_computer"
          @options[:x] = :computer
        when "o_computer"
          @options[:o] = :computer
        when "board_3"
          @options[:board] = 3
        when "board_4"
          @options[:board] = 4
        end
      end

      slots :start_game
      def start_game
        @start_callback.call(self, @options)
      end
    end
  end
end
