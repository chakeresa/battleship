require 'minitest/autorun'
require 'minitest/pride'
require './lib/render'

class RenderTest < Minitest::Test
  def test_it_exists
    render = Render.new

    assert_instance_of Render, render
  end

  def test_first_row_shows_1_thru_default_board_size
    board = Board.new
    render = Render.new

    render.render(board)

    assert_equal "  1 2 3 4 5 6 7 8 9 10 \n", render.first_row
  end

  def test_first_row_shows_1_thru_other_board_size
    board = Board.new(4)
    render = Render.new

    render.render(board)

    assert_equal "  1 2 3 4 \n", render.first_row
  end

  def test_subsequent_row_renders
    board = Board.new(4)
    render = Render.new

    render.render(board)

    assert_equal "A . . . . \n", render.subsequent_row(0)
    assert_equal "B . . . . \n", render.subsequent_row(1)
    assert_equal "C . . . . \n", render.subsequent_row(2)
    assert_equal "D . . . . \n", render.subsequent_row(3)
  end

end
