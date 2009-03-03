class Game

  attr_reader :colors,:pegs,:guesses,:rows,:puzzle

  def initialize colors = 6, pegs = 4, guesses = 10
    @colors = colors
    @pegs = pegs
    @guesses = guesses

    @rows = []

    @puzzle = (1..pegs).collect { rand colors + 1 }
  end

  def blank
    Array.new(pegs) {0}
  end

  def solved?
    @solved
  end

  def lost?
    @rows.count == @guesses
  end

  def guess! g
    raise "Out of guesses!" if @rows.length >= @guesses
    raise "Solved!" if @solved
    @rows << g
    @solved = @puzzle == g
  end

  def check g
    black = 0
    white = 0
    @puzzle.zip(g).each do |it,you|
      black += 1 if it == you
    end
    (1..@colors).each do |it|
      white += [g.count {|x| x == it}, @puzzle.count {|x| x == it}].min
    end
    white -= black
    [black,white]
  end

  # GUI bits that don't belong here
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

  def color_list
    1.upto(colors).collect {|i| hue2rgb 360*i/colors}
  end

end
