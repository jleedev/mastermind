class Game

  attr_reader :colors,:pegs,:guesses,:rows,:puzzle

  def initialize colors = 6, pegs = 4, guesses = 10
    @colors = colors
    @pegs = pegs
    @guesses = guesses

    @rows = []

    @puzzle = (1..pegs).collect { (1..colors).rand }
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

end
