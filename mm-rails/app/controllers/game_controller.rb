class GameController < ApplicationController

  def index
    redirect_to :action => :new if not session[:game]
  end

  def new
    session[:game] = Game.new
    session[:current_color] = 1
    session[:pending] = session[:game].blank
    redirect_to :action => :index
  end

  def pick_color
    session[:current_color] = params[:id].to_i
    redirect_to :action => :index
  end

  def put_guess
    session[:pending][params[:id].to_i] = session[:current_color]
    if session[:pending].all? &:nonzero?
      session[:game].guess! session[:pending]
      session[:pending] = session[:game].blank
    end
    redirect_to :action => :index
  end

end
