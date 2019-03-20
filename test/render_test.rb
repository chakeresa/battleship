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

  def test_subsequent_row_renders_initial_board
    board = Board.new(4)
    render = Render.new

    render.render(board)

    assert_equal "A . . . . \n", render.subsequent_row(0)
    assert_equal "B . . . . \n", render.subsequent_row(1)
    assert_equal "C . . . . \n", render.subsequent_row(2)
    assert_equal "D . . . . \n", render.subsequent_row(3)
  end

  def test_subsequent_row_renders_ships_if_reveal
    board = Board.new(4)
    render = Render.new
    sub = Ship.new("Sub", 2)
    cruiser = Ship.new("Cruiser", 3)

    board.place(sub, "A1", true)
    # ^ places sub in A1 horizontally -- A1 and A2
    board.place(cruiser, "A4", false)
    # ^ places cruiser in A1 vertically -- A4 thru D4

    render.render(board, true)

    assert_equal "A S S . S \n", render.subsequent_row(0)
    assert_equal "B . . . S \n", render.subsequent_row(1)
    assert_equal "C . . . S \n", render.subsequent_row(2)
    assert_equal "D . . . . \n", render.subsequent_row(3)
  end

  def test_subsequent_row_doesnt_render_ships_if_reveal_is_false
    board = Board.new(4)
    render = Render.new
    sub = Ship.new("Sub", 2)
    cruiser = Ship.new("Cruiser", 3)

    board.place(sub, "A1", true)
    # ^ places sub in A1 horizontally -- A1 and A2
    board.place(cruiser, "A4", false)
    # ^ places cruiser in A1 vertically -- A4 thru D4

    render.render(board) # inherent false for reveal

    assert_equal "A . . . . \n", render.subsequent_row(0)
    assert_equal "B . . . . \n", render.subsequent_row(1)
    assert_equal "C . . . . \n", render.subsequent_row(2)
    assert_equal "D . . . . \n", render.subsequent_row(3)
  end

  def test_entire_reveal
    board = Board.new(5)
    render = Render.new

    expected = "  1 2 3 4 5 \n"
    expected += "A . . . . . \n"
    expected += "B . . . . . \n"
    expected += "C . . . . . \n"
    expected += "D . . . . . \n"
    expected += "E . . . . . \n"

    assert_equal expected, render.render(board)
  end

end
