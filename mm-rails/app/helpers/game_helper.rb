module GameHelper

  def render_column
    "<div class=\"column\">#{(0...session[:game].colors).collect {|i| render_pick i}}</div>"
  end

  def render_pick i
    if session[:current_color] == i
      "<a class=\"piece p#{i} active\">#{i}</a>"
    else
      link_to i, {:action => :pick_color, :id => i}, :class => "piece p#{i}"
    end
  end

  def render_piece piece
    "<div class=\"piece p#{piece}\">#{piece}</div>"
  end

  def render_row row
    #"<div class=\"row\">#{render :partial => "piece", :collection => row}</div>"
    "<div class=\"row\">#{row.collect {|i| render_piece i}}</div>"
  end

end
