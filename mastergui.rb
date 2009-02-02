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

Shoes.app :title => "Mastermind" do

  @game = Game.new

  def colors n
    1.upto(n).collect {|i| hue2rgb 360*i/n}
  end

  COLORS = colors @game.colors

  @color_panel = stack do
    colors @game.colors
  end

  background white

  SIZE=50

  def peg i
    image SIZE,SIZE do
      fill COLORS[i-1]
      oval 1,1,SIZE-2
    end
  end

  def minipeg i,clr
    image SIZE/2,SIZE/2 do
      fill clr
      oval 1,1,SIZE/2-2
    end
  end

  def mini_pegs w,b
    flow :width => (w+b+1)*SIZE/4 do
      w.times { |i| minipeg i,white }
      b.times { |i| minipeg i,black }
    end
  end

  def row pegs
    flow :width => SIZE*pegs.count do
      pegs.each {|i| peg i}
    end
  end

  def column pegs
    stack do
      pegs.each {|i| peg i}
    end
  end

  def render
    @board.clear do

      @game.rows.each do |r|
        flow do
          row r
          black,white = @game.check r
          mini_pegs white,black
        end
      end

    end
  end

  stack :margin => 8 do
    border red, :strokewidth => 5
    flow :margin => 5 do

      flow :width => SIZE+10, :margin => 5 do
        column (1..@game.colors)
      end

      stack :width => 5 do
        background red
      end

      flow :width => -SIZE-15, :margin => 5 do
        @board = stack
      end

    end
  end

  @game.guess! [1,2,3,4]
  p @game

  render

end
