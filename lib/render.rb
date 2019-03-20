require './lib/board'

class Render

  def render(board, reveal = false)
    @board = board
    @reveal = reveal
    render_return = first_row

    @board.size.times do |i|
      render_return += subsequent_row(i)
    end

    render_return
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
    letter = (64 + row_counter).chr
    row_render = letter

    @board.size.times do |i|
      number = (i + 1).to_s
      cell = (letter + number).to_sym
      row_render += " " + @board.cells[cell].render(@reveal) # TO DO: Board has a new method to get rid of .cells from this line -- update accordingly after merging
    end

    row_render += " \n"
  end
end
