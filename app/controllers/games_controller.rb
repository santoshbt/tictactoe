class GamesController < ApplicationController
  def play
      logger.info params.inspect
      logger.info "3333333333333333"
      logger.info current_game.inspect
   
      play = current_game.main_loop(params[:cell])
      puts play.inspect
      puts "4444444444444444444444"
      render :nothing => true
  end
end
