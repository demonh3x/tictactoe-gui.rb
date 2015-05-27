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

  def close_game
    find(qt_game, "close").click
  end

  def click_cell(cell_index)
    find(qt_game, "cell_#{cell_index}").click
  end

  def make_move(cell_index)
    click_cell(cell_index)
    tick
  end

  def get_cell_text(cell_index)
    find(qt_game, "cell_#{cell_index}").text
  end

  def get_board_marks
    find_all(qt_game, lambda {|widget| /cell_/ =~ widget.object_name}).map {|w| w.text}.map {|t| t.nil?? nil : t.to_sym}
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

  def is_ticking
    find(qt_game, "timer").active
  end

  private
  def find(widget, object_name)
    find_first(widget, lambda {|widget| widget.object_name == object_name})
  end

  def find_first(widget, matcher)
    return widget if matcher.call(widget)
    widget.children.each do |child|
      result = find_first(child, matcher)
      return result if result
    end
    nil
  end

  def find_all(widget, matcher, results=[])
    if matcher.call(widget)
      results << widget
    end
    widget.children.each do |child|
      find_all(child, matcher, results)
    end
    results
  end
end
