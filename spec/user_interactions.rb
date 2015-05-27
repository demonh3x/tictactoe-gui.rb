require 'spec_helpers_qt'

class UserInteractions
  attr_accessor :qt_menu_getter, :qt_game_getter

  def initialize(qt_menu_getter, qt_game_getter)
    self.qt_menu_getter = qt_menu_getter
    self.qt_game_getter = qt_game_getter
  end

  def qt_menu
    qt_menu_getter.call
  end

  def qt_game
    qt_game_getter.call
  end

  def select(option, value)
    find(qt_menu, "#{option.to_s}_#{value.to_s}").click
  end

  def is_selected?(option, value)
    find(qt_menu, "#{option.to_s}_#{value.to_s}").checked
  end

  def start_game
    find(qt_menu, "start").click
  end

  def make_move(cell_index)
    find(qt_game, "cell_#{cell_index}").click
    tick
  end

  def get_result_text
    find(qt_game, "result").text
  end

  def is_game_visible?
    qt_game.visible
  end

  def are_options_visible?
    qt_menu.visible
  end

  def close_game
    find(qt_game, "close").click
  end

  def play_again
    find(qt_game, "play_again").click
  end

  def tick
    find(qt_game, "timer").timeout
  end

  private
  include Qt::SpecHelpers
end
