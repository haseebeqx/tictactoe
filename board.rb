require 'curses'

class Board
  attr_accessor :grid
  attr_reader :grid_size

  def initialize(grid_size)
    @grid_size = grid_size
    @grid = Array.new(grid_size) { Array.new(grid_size) }
  end

  def draw(selected_row, selected_col, player_text)
    Curses.clear
    display_text_at(0, 1, player_text)
    draw_grid(selected_row, selected_col)
    display_text_at(Curses.lines - 1, (Curses.cols - 62) / 2, "Press Q to exit, Use arrow keys to move, Press space to select")
    Curses.refresh
  end

  def mark_cell(row, col, symbol)
    @grid[row][col] = symbol if @grid[row][col].nil?
  end

  def cell_marked?(row, col)
    !@grid[row][col].nil?
  end

  def draw_game_over(message)
    Curses.clear
    draw_grid(0, 0)
    display_text_at(Curses.lines - 4, (Curses.cols - message.length) / 2, message, true)
    display_text_at(Curses.lines - 3, (Curses.cols - 15) / 2, "Press Q to exit")
    Curses.refresh
  end

  private

  def display_text_at(row, col, text, bold = false)
    Curses.setpos(row, col)
    if bold
      Curses.attron(Curses::A_BOLD) { Curses.addstr(text) }
    else
      Curses.addstr(text)
    end
  end

  def draw_grid(selected_row, selected_col)
    grid_start_row = (Curses.lines - (2 * grid_size - 1)) / 2
    grid_start_col = (Curses.cols - (4 * grid_size - 3)) / 2

    grid_size.times do |row|
      grid_size.times do |col|
        draw_cell(row, col, selected_row, selected_col, grid_start_row, grid_start_col)
      end
      draw_horizontal_divider(row, grid_start_row, grid_start_col) unless row == grid_size - 1
    end
  end

  def draw_cell(row, col, selected_row, selected_col, start_row, start_col)
    char = cell_character(row, col, selected_row, selected_col)
    cell_row, cell_col = start_row + row * 2, start_col + col * 4

    Curses.setpos(cell_row, cell_col)
    if row == selected_row && col == selected_col && grid[row][col]
      Curses.attron(Curses::A_BOLD) { Curses.addstr(grid[row][col].to_s) }
    else
      Curses.addstr(char)
    end
    Curses.setpos(cell_row, cell_col + 2)
    Curses.addstr('|') unless col == grid_size - 1
  end

  def cell_character(row, col, selected_row, selected_col)
    if row == selected_row && col == selected_col && grid[row][col].nil?
      '-'
    else
      grid[row][col] || ' '
    end
  end

  def draw_horizontal_divider(row, start_row, start_col)
    (4 * grid_size - 3).times do |i|
      Curses.setpos(start_row + row * 2 + 1, start_col + i)
      Curses.addstr('-')
    end
  end
end
