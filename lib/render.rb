require './lib/board'

class Render

  def render(board)
    first_row(board)
  end

  def first_row(board)
    size = board.size
    first_row_return = " "

    ('1'..size.to_s).each do |number|
      first_row_return += " " + number
    end

    first_row_return += " \n"
  end
end
