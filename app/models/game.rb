class Game < ActiveRecord::Base
  def initialize(player1, player2)
    @view = View.new
    @score = { rounds_played: 0, turns: 0, drawn: 0, p1: 0, p2: 0}
    @continue_game = true
    @continue_round = true
    @player_one = player1
    @player_two = player2
    # main_loop(location)
  end

  def main_loop(location)
    
    @continue_game = true
  
      # Reset the board and turn count
      if @board.blank?
        @board = GameBoard.new      
    
        @score[:turns] = 0
        @score[:drawn] = 0
        @score[:p1] = 0
        @score[:p2] = 0
      end
      # Swap starting player each round, odd rounds = player 1, even = player 2
      @score[:rounds_played] % 2 != 0 ? @active_player = @player_two : @active_player = @player_one

      @continue_round = true
        @score[:turns] += 1

        # The game view will repeat continuously each turn until a valid move is chosen
        valid_input = false
          # Refresh the game view
          @view.game_state(@board, @score)
          @continue_game = true
          if location.to_i.between?(1,9)
             valid_input = true
             # If we have valid input, try to place the marker, if occupied, invalidate input
             puts @active_player
             if @board.place_marker(location.to_i, @active_player.marker) == "occupied"
               
               valid_input = false
               return{:error => "Occupied", :winner => nil, :continue => "Y", :current_pl => @active_player}
             end
           else
             puts " Invalid entry, please try again."
             return{:error => "Invalid Entry", :winner => nil, :continue => "Y", :current_pl => @active_player}
           end

        # Update game view after new marker is placed
        @view.game_state(@board, @score)

        # Check for winner as soon as it becomes possible
        if @score[:turns] > 3
          if @board.check_winner == @player_one.marker || @board.check_winner == @player_two.marker
            puts @active_palyer.inspect
            puts "444444444444444444444"
            return {:error => nil, :winner => @active_player, :continue => "N", :current_pl => @active_player}
           end
        end

        # If we've managed to hit the end of the 9th turn without a winner, it's a draw
        if @score[:turns] == 9 && @continue_round == true
          @score[:drawn] += 1
          @continue_round = false
          return {:error => "Draw", :winner => nil, :continue => "N", :current_pl => @active_player}
        end
        @active_player == @player_one ? @active_player = @player_two : @active_player = @player_one
        @score[:rounds_played] += 1
        return {:error => nil, :winner => nil, :continue => "Y", :current_pl => @active_player}
  end
  
end


class GameBoard

  # Ready an empty board
  def initialize
    @board = { 1 => "_", 2 => "_", 3 => "_",
               4 => "_", 5 => "_", 6 => "_",
               7 => "_", 8 => "_", 9 => "_" }
  end

  def print_row(row = nil)

    return "|#{@board[1]}|#{@board[2]}|#{@board[3]}|" if row == 1
    return "|#{@board[4]}|#{@board[5]}|#{@board[6]}|" if row == 2
    return "|#{@board[7]}|#{@board[8]}|#{@board[9]}|" if row == 3
  end

  # Handles converting an empty space into a player's marker, if the space is taken
  # the method will leave it unchanged and return a notification
  def place_marker(location, marker)
    if @board[location] == "_"
      @board[location] = marker
      puts @board.inspect
      puts "5555555555555555555555555555"
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

class View


  # Assigning symbols and taking names
  def player_info(player)
    puts "\e[H\e[2J"
    puts " ...::||| Player #{player} |||::..."
    puts ""
    if player == 1
      puts "   Your symbol will be X."
    elsif player == 2
      puts "   Your symbol will be O."; end
    puts ""
    puts ""
    print " Enter Player #{player}'s name: "
  end

  # This screen runs briefly after the creation of a new game/players
  def instructions
    puts "\e[H\e[2J"
    puts " ...::||| Instructions |||::..."
    puts " "
    puts "      Place three of your  "
    puts "   symbols in a line to win."
    puts "            "
    puts "    |1|2|3|     Select boxes    "
    puts "    |4|5|6|      using 1-9"
    puts "    |7|8|9|"
    puts ""
  end

  # This is the primary gameplay screen that updates each turn
  def game_state(board, score)
    puts "\e[H\e[2J"
    puts " ...::|||  TicTacToe  |||::..."
    puts " "
    puts "        Round #{score[:rounds_played]}, Turn #{score[:turns]}"
    puts "      Board         Score"
    puts ""
    puts "     #{board.print_row(1)}        P1:  #{score[:p1]}"
    puts "     #{board.print_row(2)}        P2:  #{score[:p2]}"
    puts "     #{board.print_row(3)}      Draw:  #{score[:drawn]}"
    puts ""
  end

  # Once the game is complete, a quick readout of the results
  def final_score(winner, score)
    puts "\e[H\e[2J"
    puts " ...::|||  Game Over  |||::..."
    puts " "
    puts "       Best of #{score[:rounds_played]} Rounds"
    puts "      "
    puts "        P1:  #{score[:p1]}   P2:  #{score[:p2]}"
    puts "         Drawn:  #{score[:drawn]}"
    puts "     "
    puts "     The winner is #{winner}!"
  end
  
end
