require 'minitest/autorun'
require 'minitest/pride'
require './lib/render'

class RenderTest < Minitest::Test
  def test_it_exists
    board = Board.new
    render = Render.new(board)

    assert_instance_of Render, render
  end

  def test_it_has_a_board
    board = Board.new
    render = Render.new(board)

    assert_equal board, render.board
  end
end
