require_relative 'board'
require_relative 'player'
require_relative 'game_logic'
require 'curses'

class Game
  def initialize(grid_size)
    Curses.init_screen
    Curses.curs_set(0)
    Curses.noecho
    Curses.stdscr.keypad(true)

    @board = Board.new(grid_size)
    @players = [Player.new('X'), Player.new('O')]
    @current_player_index = 0
    @selected_row = 0
    @selected_col = 0
    @game_logic = GameLogic.new(@board, @players)
  end

  def start
    loop do
      if game_over?
        @board.draw_game_over(game_over_message)
        break if wait_for_exit
      else
        @board.draw(@selected_row, @selected_col, current_player.symbol)
        process_input(Curses.getch)
      end
    end
  ensure
    Curses.close_screen
  end

  private

  def current_player
    @players[@current_player_index]
  end

  def switch_player
    @current_player_index = (@current_player_index + 1) % @players.size
  end

  def process_input(input)
    case input
    when Curses::Key::UP
      @selected_row = [@selected_row - 1, 0].max
    when Curses::Key::DOWN
      @selected_row = [@selected_row + 1, @board.grid_size - 1].min
    when Curses::Key::LEFT
      @selected_col = [@selected_col - 1, 0].max
    when Curses::Key::RIGHT
      @selected_col = [@selected_col + 1, @board.grid_size - 1].min
    when " "
      if @board.grid[@selected_row][@selected_col].nil?
        @board.mark_cell(@selected_row, @selected_col, current_player.symbol)
        switch_player
      end
    when 'q', 'Q'
      exit_game
    end
  end

  def game_over?
    winner = @game_logic.check_winner
    if winner
      return true
    elsif @game_logic.board_full?
      return true
    end
    false
  end

  def exit_game
    Curses.close_screen
    exit
  end

  def game_over_message
    winner = @game_logic.check_winner
    if winner
      "Game Over. Player #{winner} wins!"
    elsif @game_logic.board_full?
      "Game Over. It's a draw!"
    end
  end

  def wait_for_exit
    case Curses.getch
    when 'q', 'Q'
      true
    else
      false
    end
  end
end
