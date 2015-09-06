class Game < ActiveRecord::Base
  def initialize(player1, player2)
    @score = { rounds_played: 0, turns: 0, drawn: 0, p1: 0, p2: 0}
    @continue_game = true
    @continue_round = true
    @player_one = player1
    @player_two = player2
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
      @score[:rounds_played] % 2 != 0 ? (@active_player, @other_player = @player_two, @player_one) : (@active_player, @other_player = @player_one, @player_two)

      @continue_round = true
        @score[:turns] += 1

        # The game view will repeat continuously each turn until a valid move is chosen
        valid_input = false
          # Refresh the game view
          @continue_game = true
          if location.to_i.between?(1,9)
             valid_input = true
             # If we have valid input, try to place the marker, if occupied, invalidate input
             if @board.place_marker(location.to_i, @active_player.marker) == "occupied"
               
               valid_input = false
               return{:error => "Occupied", :winner => nil, :continue => "Y", :current_pl => @active_player, :other_pl => @other_player}
             end
           else
             puts " Invalid entry, please try again."
             return{:error => "Invalid Entry", :winner => nil, :continue => "Y", :current_pl => @active_player,  :other_pl => @other_player}
           end

        # Check for winner as soon as it becomes possible
        if @score[:turns] > 3
          if @board.check_winner == @player_one.marker || @board.check_winner == @player_two.marker
            return {:error => nil, :winner => @active_player, :continue => "N", :current_pl => @active_player,  :other_pl => @other_player}
           end
        end

        # If we've managed to hit the end of the 9th turn without a winner, it's a draw
        if @score[:turns] == 9 && @continue_round == true
          @score[:drawn] += 1
          @continue_round = false
          return {:error => "Draw", :winner => nil, :continue => "N", :current_pl => @active_player,  :other_pl => @other_player}
        end
        # @active_player == @player_one ? @active_player = @player_two : @active_player = @player_one
        @score[:rounds_played] += 1
        return {:error => nil, :winner => nil, :continue => "Y", :current_pl => @active_player,  :other_pl => @other_player}
  end
  
end


