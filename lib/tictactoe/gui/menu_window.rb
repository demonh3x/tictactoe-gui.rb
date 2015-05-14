require 'Qt'

module Tictactoe
  module Gui
    class MenuWindow 
      attr_reader :qt_window

      def initialize(start_callback)
        @start_callback = start_callback
        @options = {
          :x => :human,
          :o => :human,
          :board => 3,
        }

        @qt_window = Qt::Widget.new
        @qt_window.object_name = "main_window"
        @qt_window.resize(240, 150)

        main_layout = new_main_layout(@qt_window)
        main_layout.add_widget(widget_x_selector(@qt_window), 0, 0, 1, 1)
        main_layout.add_widget(widget_o_selector(@qt_window), 0, 1, 1, 1)
        main_layout.add_widget(widget_board_selector(@qt_window), 0, 2, 1, 1)
        main_layout.add_widget(widget_start(@qt_window), 1, 0, 1, 3)
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
          @options[:x] = :human
        when :o_human
          @options[:o] = :human
        when :x_computer
          @options[:x] = :computer
        when :o_computer
          @options[:o] = :computer
        when :board_3
          @options[:board] = 3
        when :board_4
          @options[:board] = 4
        end
      end

      def widget_start(parent)
        b = Qt::PushButton.new(parent)
        b.object_name = "start"
        b.text = "Start game"
        b.connect(SIGNAL :clicked) do
          start_game()
        end
        b
      end

      def start_game
        @start_callback.call(@qt_window, @options)
      end
    end
  end
end
