class GameLogic
  attr_reader :board, :players

  def initialize(board, players)
    @board = board
    @players = players
  end

  def check_winner
    players.each do |player|
      return player.symbol if winning_condition?(player.symbol)
    end
    nil
  end

  def board_full?
    board.grid.all? { |row| row.none?(&:nil?) }
  end

  private

  def winning_condition?(symbol)
    horizontal_win?(symbol) || vertical_win?(symbol) || diagonal_win?(symbol)
  end

  def horizontal_win?(symbol)
    board.grid.any? { |row| row.all? { |cell| cell == symbol } }
  end

  def vertical_win?(symbol)
    (0...board.grid_size).any? do |col|
      board.grid.all? { |row| row[col] == symbol }
    end
  end

  def diagonal_win?(symbol)
    left_to_right = (0...board.grid_size).all? { |i| board.grid[i][i] == symbol }
    right_to_left = (0...board.grid_size).all? { |i| board.grid[i][board.grid_size - 1 - i] == symbol }
    left_to_right || right_to_left
  end
end
