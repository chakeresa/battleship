require 'minitest/autorun'
require 'minitest/pride'
require './lib/render'

class RenderTest < Minitest::Test
  def test_it_exists
    render = Render.new

    assert_instance_of Render, render
  end

  def test_padding_returns_a_non_negative_int_for_big_board
    board = Board.new("Board 1", 15)
    render = Render.new
    render.render(board, false)

    actual = render.padding

    assert_instance_of Integer, actual
    assert actual >= 0
  end

  def test_padding_returns_a_non_negative_int_for_small_board
    board = Board.new("Board 1", 3)
    render = Render.new
    render.render(board, false)

    actual = render.padding

    assert_instance_of Integer, actual
    assert actual >= 0
  end

  def test_names_returns_padding_and_one_name_for_one_board
    board = Board.new("Board 1", 12)
    render = Render.new
    render.render(board, false)

    actual = render.names

    assert_equal "                       Board 1\n", actual
  end

  def test_names_returns_padding_and_two_names_for_two_boards
    board1 = Board.new("Board 1", 12)
    board2 = Board.new("Board 2", 12)
    render = Render.new
    render.render(board1, board2, false)

    actual = render.names

    assert_equal "                  Board 1                                    Board 2\n", actual
  end

  def test_initial_padding_returns_9_spaces_for_1_board
    board = Board.new("Board 1", 12)
    render = Render.new
    render.render(board, false)

    actual = render.initial_padding

    assert_equal "         ", actual
  end

  def test_initial_padding_returns_2_spaces_for_2_boards
    board1 = Board.new("Board 1", 12)
    board2 = Board.new("Board 2", 12)
    render = Render.new
    render.render(board1, board2, false)

    actual = render.initial_padding

    assert_equal "  ", actual
  end

  def test_first_row_our_board_returns_string_of_num_headings_for_small_board
    board = Board.new("Board 1", 5)
    render = Render.new
    render.render(board, false)

    actual = render.first_row_our_board(5)

    assert_equal " 1  2  3  4  5 ", actual
  end

  def test_first_row_our_board_returns_string_of_num_headings_for_large_board
    board = Board.new("Board 1", 11)
    render = Render.new
    render.render(board, false)

    actual = render.first_row_our_board(11)

    assert_equal " 1  2  3  4  5  6  7  8  9 10 11", actual
  end

  def test_first_row_their_board_returns_string_of_num_headings_for_small_board
    board = Board.new("Board 1", 5)
    render = Render.new
    render.render(board, false)

    actual = render.first_row_our_board(5)

    assert_equal " 1  2  3  4  5 ", actual
  end

  def test_first_row_their_board_returns_string_of_num_headings_for_large_board
    board = Board.new("Board 1", 11)
    render = Render.new
    render.render(board, false)

    actual = render.first_row_our_board(11)

    assert_equal " 1  2  3  4  5  6  7  8  9 10 11", actual
  end

  def test_first_row_shows_1_thru_default_board_size
    board = Board.new("Board 1")
    render = Render.new

    render.render(board, false)

    assert_equal "          1  2  3  4  5  6  7  8  9 10 \n", render.first_row
  end

  def test_first_row_shows_1_thru_other_board_size
    board = Board.new("Board 1", 4)
    render = Render.new

    render.render(board, false)

    assert_equal "          1  2  3  4  \n", render.first_row
  end

  def test_subsequent_row_renders_initial_board
    board = Board.new("Board 1", 4)
    render = Render.new

    render.render(board, false)

    assert_equal "       A  .  .  .  . \n", render.subsequent_row(0)
    assert_equal "       B  .  .  .  . \n", render.subsequent_row(1)
    assert_equal "       C  .  .  .  . \n", render.subsequent_row(2)
    assert_equal "       D  .  .  .  . \n", render.subsequent_row(3)
  end

  def test_subsequent_row_renders_ships_if_reveal
    board = Board.new("Board 1", 4)
    render = Render.new
    sub = Ship.new("Sub", 2)
    cruiser = Ship.new("Cruiser", 3)

    board.place(sub, "A1", true)
    # ^ places sub in A1 horizontally -- A1 and A2
    board.place(cruiser, "A4", false)
    # ^ places cruiser in A1 vertically -- A4 thru D4

    render.render(board, :one)

    assert_equal "       A  S  S  .  S \n", render.subsequent_row(0)
    assert_equal "       B  .  .  .  S \n", render.subsequent_row(1)
    assert_equal "       C  .  .  .  S \n", render.subsequent_row(2)
    assert_equal "       D  .  .  .  . \n", render.subsequent_row(3)
  end

  def test_subsequent_row_doesnt_render_ships_if_reveal_is_false
    board = Board.new("Board 1", 4)
    render = Render.new
    sub = Ship.new("Sub", 2)
    cruiser = Ship.new("Cruiser", 3)

    board.place(sub, "A1", true)
    # ^ places sub in A1 horizontally -- A1 and A2
    board.place(cruiser, "A4", false)
    # ^ places cruiser in A1 vertically -- A4 thru D4

    render.render(board, false) # inherent false for reveal

    assert_equal "       A  .  .  .  . \n", render.subsequent_row(0)
    assert_equal "       B  .  .  .  . \n", render.subsequent_row(1)
    assert_equal "       C  .  .  .  . \n", render.subsequent_row(2)
    assert_equal "       D  .  .  .  . \n", render.subsequent_row(3)
  end

  def test_subsequent_renders_hit_ships
    board = Board.new("Board 1", 4)
    render = Render.new
    sub = Ship.new("Sub", 2)

    board.place(sub, "A1", true)
    # ^ places sub in A1 horizontally -- A1 and A2
    board.cells[:A1].fire_upon

    render.render(board, :one)

    assert_equal "       A  H  S  .  . \n", render.subsequent_row(0)
    assert_equal "       B  .  .  .  . \n", render.subsequent_row(1)
    assert_equal "       C  .  .  .  . \n", render.subsequent_row(2)
    assert_equal "       D  .  .  .  . \n", render.subsequent_row(3)
  end

  def test_subsequent_renders_sunken_ships
    board = Board.new("Board 1", 4)
    render = Render.new
    sub = Ship.new("Sub", 2)

    board.place(sub, "A1", true)
    # ^ places sub in A1 horizontally -- A1 and A2
    board.cells[:A1].fire_upon
    board.cells[:A2].fire_upon

    render.render(board, false)

    assert_equal "       A  X  X  .  . \n", render.subsequent_row(0)
    assert_equal "       B  .  .  .  . \n", render.subsequent_row(1)
    assert_equal "       C  .  .  .  . \n", render.subsequent_row(2)
    assert_equal "       D  .  .  .  . \n", render.subsequent_row(3)
  end

  def test_subsequent_renders_misses
    board = Board.new("Board 1", 4)
    render = Render.new
    sub = Ship.new("Sub", 2)

    board.place(sub, "A1", true)
    # ^ places sub in A1 horizontally -- A1 and A2
    board.cells[:A4].fire_upon # miss
    board.cells[:C2].fire_upon # miss

    render.render(board, :one)

    assert_equal "       A  S  S  .  M \n", render.subsequent_row(0)
    assert_equal "       B  .  .  .  . \n", render.subsequent_row(1)
    assert_equal "       C  .  M  .  . \n", render.subsequent_row(2)
    assert_equal "       D  .  .  .  . \n", render.subsequent_row(3)
  end

  def test_entire_reveal
    board = Board.new("Board 1", 5)
    render = Render.new

    expected = "            Board 1\n"
    expected += "          1  2  3  4  5  \n"
    expected += "       A  .  .  .  .  . \n"
    expected += "       B  .  .  .  .  . \n"
    expected += "       C  .  .  .  .  . \n"
    expected += "       D  .  .  .  .  . \n"
    expected += "       E  .  .  .  .  . \n"

    assert_equal expected, render.render(board, false)
  end

end
