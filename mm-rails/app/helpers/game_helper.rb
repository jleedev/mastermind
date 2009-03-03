module GameHelper

  def render_column
    "<div class=\"column\">#{(1..session[:game].colors).collect {|i| render_pick i}}</div>"
  end

  def render_pick i
    if session[:current_color] == i
      "<a class=\"piece p#{i} active\">#{i}</a>"
    else
      link_to i, {:action => :pick_color, :id => i}, :class => "piece p#{i}"
    end
  end

  def render_guess
    "<div class=\"row\">#{(1..session[:game].pegs).collect {|i| render_hole i}}</div>"
  end

  def render_hole i
    p = session[:pending][i-1]
    link_to p, {:action => :put_guess, :id => i-1}, :class => "piece p#{p}"
  end

  def render_row row
    #"<div class=\"row\">#{render :partial => "piece", :collection => row}</div>"
    "<div class=\"row\">#{row.collect {|i| render_piece i}}</div>"
  end

  def render_piece piece
    "<div class=\"piece p#{piece}\">#{piece}</div>"
  end

  def render_mini hints
    b,w = hints
    "<div class=\"hints\">#{(1..w).collect {mini_peg :white}}#{(1..b).collect {mini_peg :black}}</div>"
  end

  def mini_peg color
    "<div class=\"mini #{color}\"></div>"
  end

end
