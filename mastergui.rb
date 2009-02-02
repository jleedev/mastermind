require 'mastermodel'

def hue2rgb h
  h = (h.to_f / 60 + 1e-3) % 6
  c = h % 1
  case h
  when 0..1: rgb(1.0, c,   0.0)
  when 1..2: rgb(1-c, 1.0, 0.0)
  when 2..3: rgb(0.0, 1.0, c  )
  when 3..4: rgb(0.0, 1-c, 1.0)
  when 4..5: rgb(c,   0.0, 1.0)
  when 5..6: rgb(1.0, 0.0, 1-c)
  end
end

SIZE=50

Shoes.app :title => "Mastermind", :width => 300, :height => 550, :resizable => false do

  background "#ccc"

  @game = Game.new

  @current_color = 1
  @pending = @game.blank

  # PREPARE THE LIST OF COLORS

  def colors n
    1.upto(n).collect {|i| hue2rgb 360*i/n}
  end
  COLORS = colors @game.colors

  # RENDER A BIG PEG

  def peg i, highlight = false
    image SIZE,SIZE do
      if highlight
        fill "#6C0C7B"
        rect 0,0,SIZE,SIZE
      end
      if i != 0
        fill COLORS[i-1]
      else
        nofill
      end
      oval 1,1,SIZE-2
    end
  end

  # RENDER A SMALL PEG

  def minipeg i,clr
    image SIZE/2,SIZE/2 do
      fill clr
      oval 1,1,SIZE/2-2
    end
  end

  # RENDER A CHUNK OF SMALL PEGS

  def mini_pegs w,b
    flow :width => SIZE do
      w.times { |i| minipeg i,white }
      b.times { |i| minipeg i,black }
    end
  end

  # RENDER A ROW OF PEGS

  def row pegs
    flow :width => SIZE*pegs.count do
      pegs.each {|i| peg i}
    end
  end

  # RENDER THE PENDING ROW OF PEGS

  def pending_row
    flow :width => SIZE*@pending.count do
      @pending.each_with_index do |pg,i|
        pg = peg pg
        pg.click do
          @pending[i] = @current_color
          render
          commit if @pending.all? &:nonzero?
        end
      end
    end
  end

  # REDRAW THE COLOR PICKER

  def column
    pegs = 1..@game.colors
    @column.clear do
      stack do
        pegs.each do |i|
          pg = peg i, @current_color == i
          pg.click do
            @current_color = i
            column
          end
        end
      end
    end
  end

  # REDRAW THE GUESSING AREA

  def render
    @board.clear do

      @game.rows.each do |r|
        flow do
          row r
          black,white = @game.check r
          mini_pegs white,black
        end
      end

      if @game.solved? or @game.lost?
        flow :width => 200 do
          background gray
          row @game.puzzle
        end
      else
        pending_row
      end

    end
  end

  # OH SHIT HE MADE A GUESS
  
  def commit
    @game.guess! @pending
    @pending = @game.blank
    render
  end

  # GO GO GO

  flow do

    flow :width => SIZE do
      @column = stack
    end

    flow :width => -SIZE do
      @board = stack
    end

  end

  column
  render

end
