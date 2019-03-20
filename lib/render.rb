require './lib/board'

class Render

  def render(board)
    @board = board
    render_return = first_row

    @board.size.times do |i|
      render_return += subsequent_row(i)
    end
  end

  def first_row
    size = @board.size
    first_row_return = " "

    ('1'..size.to_s).each do |number|
      first_row_return += " " + number
    end

    first_row_return += " \n"
  end

  def subsequent_row(i)
    row_counter = i + 1 # starts at one
    row_render = (64 + row_counter).chr
    row_render += " . . . . \n" # HARD CODED
  end
end
