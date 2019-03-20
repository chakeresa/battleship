require './lib/board'

class Render
  attr_reader :board
  
  def initialize(board)
    @board = board
  end
end
