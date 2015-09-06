class GameBoard

  # Ready an empty board
  def initialize
    @board = { 1 => "_", 2 => "_", 3 => "_",
               4 => "_", 5 => "_", 6 => "_",
               7 => "_", 8 => "_", 9 => "_" }
  end

  def place_marker(location, marker)
    if @board[location] == "_"
      @board[location] = marker
    else
      return "occupied"; 
    end
  end

  def check_winner(winner = nil)
    # Check rows
    (1..9).step(3) do |i|
      if @board[i] == @board[i+1] && @board[i] == @board[i+2]
        return winner = @board[i]; end;
      end

    # Check columns
    for i in 1..3
      
      if @board[i] == @board[i+3] && @board[i] == @board[i+6]
        return winner = @board[i]; 
      end; 
    end

    # Check top left - bottom right diag
    if @board[1] == @board[5] && @board[1] == @board[9]
      return winner = @board[1]; end

    # Check top right - bottom left diag
    if @board[3] == @board[5] && @board[3] == @board[7]
      return winner = @board[3]; end
  end

end

