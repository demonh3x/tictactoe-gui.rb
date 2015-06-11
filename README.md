# tictactoe-gui.rb
[![Travis CI](https://travis-ci.org/demonh3x/tictactoe-gui.rb.svg?branch=master)](https://travis-ci.org/demonh3x/tictactoe-gui.rb)
[![Code Climate](https://codeclimate.com/github/demonh3x/tictactoe-gui.rb/badges/gpa.svg)](https://codeclimate.com/github/demonh3x/tictactoe-gui.rb)
[![Test Coverage](https://codeclimate.com/github/demonh3x/tictactoe-gui.rb/badges/coverage.svg)](https://codeclimate.com/github/demonh3x/tictactoe-gui.rb/coverage)

## Description

This is a [graphical user interface][gui] for [tictactoe-core.rb][core]

[gui]: http://en.wikipedia.org/wiki/Graphical_user_interface
[core]: https://github.com/demonh3x/tictactoe-core.rb

## Dependencies

##### Execution
* Ruby, from v2.0.0 to 2.2.0 (other versions might work too)
* [tictactoe-core.rb][core] v0.1.2
* [qtbindings][qt]

[qt]: https://github.com/ryanmelt/qtbindings/

##### Testing
* [RSpec][rspec] 3.1.0
* [Codeclimate Test Reporter][climate] (For CI environment)

[rspec]: http://rspec.info/
[climate]: https://github.com/codeclimate/ruby-test-reporter

##### Others
* [Bundler][bundler] (To manage dependencies)
* [Rake][rake] (To run preconfigured tasks)

[bundler]: http://bundler.io/
[rake]: https://github.com/ruby/rake

## Setup

##### Install dependencies
Follow the instructions for installing [qtbindings][qt] on your OS. When installed, `bundle install`

##### Run tests
`rake`

##### Run game
`rake run` or `bin/tictactoe_gui`

## Rake tasks
run `rake -T` to see all available tasks

## Previews

##### Menu
![](https://raw.githubusercontent.com/demonh3x/tictactoe-gui.rb/master/previews/gui_menu.png)

##### Game
![](https://raw.githubusercontent.com/demonh3x/tictactoe-gui.rb/master/previews/gui_4x4game.png)
