class GameController < ApplicationController

  def index
    session[:game] = Game.new if not session[:game]
  end

  def pick_color
    session[:current_color] = params[:id].to_i
    redirect_to :action => :index
  end

end
