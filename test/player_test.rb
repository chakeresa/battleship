require 'minitest/autorun'
require 'stringio'
require 'o_stream_catcher' # if missing do `gem install o_stream_catcher`
require './lib/player'

class PlayerTest < Minitest::Test
  def test_player_init
    player = Player.new("Fred", 4)

    assert_instance_of Player, player
    assert_instance_of Board, player.board
    assert_equal [], player.ships
  end

  def test_player_get_starting_coord_returns_coord_when_valid
    player = Player.new("Fred", 2) # board is just A1-B2
    sub = Ship.new("sub", 2)
    testInp = StringIO.new

    testInp.puts "B2"
    testInp.rewind
    $stdin = testInp
    result, stdout, stderr = OStreamCatcher.catch do
      player.get_starting_coord(sub)
    end

    assert_equal "B2", result

    $stdin = STDIN
  end

  def test_player_get_starting_coord_returns_msg_when_invalid
    player = Player.new("Fred", 2) # board is just A1-B2
    sub = Ship.new("sub", 2)
    testInp = StringIO.new
    testInp.puts "C3"
    testInp.puts "A2"
    testInp.rewind
    $stdin = testInp
    result, stdout, stderr = OStreamCatcher.catch do
      player.get_starting_coord(sub)
    end

    assert_equal "A2", result
    assert_equal "Placing: sub, with Length of 2\nPick a starting coordinate.\n>> Invalid starting coordinate.\nPlacing: sub, with Length of 2\nPick a starting coordinate.\n>> ", stdout

    $stdin = STDIN
  end

  def test_player_get_starting_coord_quits_w_exclamation
    player = Player.new("Fred", 2) # board is just A1-B2
    sub = Ship.new("sub", 2)
    testInp = StringIO.new
    testInp.puts "!"
    testInp.rewind
    $stdin = testInp
    result, stdout, stderr = OStreamCatcher.catch do
      player.get_starting_coord(sub)
    end

    assert_equal :quit, result
    assert_equal "Placing: sub, with Length of 2\nPick a starting coordinate.\n>> ", stdout

    $stdin = STDIN
  end

  def test_player_get_dir_input_quits_w_exclamation
    player = Player.new("Fred", 2) # board is just A1-B2
    sub = Ship.new("sub", 2)
    testInp = StringIO.new
    testInp.puts "!"
    testInp.rewind
    $stdin = testInp
    result, stdout, stderr = OStreamCatcher.catch do
      player.get_dir_input("A1", sub)
    end

    assert_equal :quit, result
    assert_equal "Pick a direction (left, right, up, down OR l,r,u,d).\n>> ", stdout

    $stdin = STDIN
  end

  def test_player_get_dir_input_msg_when_invalid_direction
    player = Player.new("Fred", 2) # board is just A1-B2
    sub = Ship.new("sub", 2)
    testInp = StringIO.new
    testInp.puts "blah"
    testInp.puts "r"
    testInp.rewind
    $stdin = testInp
    result, stdout, stderr = OStreamCatcher.catch do
      player.get_dir_input("A1", sub)
    end

    assert_equal [true, "A1"], result
    assert_equal "Pick a direction (left, right, up, down OR l,r,u,d).\n>> Invalid direction input.\nPick a direction (left, right, up, down OR l,r,u,d).\n>> ", stdout

    $stdin = STDIN
  end

  def test_player_get_dir_input_changes_coord_when_left_input
    player = Player.new("Fred", 2) # board is just A1-B2
    sub = Ship.new("sub", 2)
    testInp = StringIO.new
    testInp.puts "left"
    testInp.rewind
    $stdin = testInp
    result, stdout, stderr = OStreamCatcher.catch do
      player.get_dir_input("A2", sub)
    end

    assert_equal [true, "A1"], result

    $stdin = STDIN
  end

  def test_player_get_dir_input_changes_coord_when_l_input
    player = Player.new("Fred", 2) # board is just A1-B2
    sub = Ship.new("sub", 2)
    testInp = StringIO.new
    testInp.puts "l"
    testInp.rewind
    $stdin = testInp
    result, stdout, stderr = OStreamCatcher.catch do
      player.get_dir_input("A2", sub)
    end

    assert_equal [true, "A1"], result

    $stdin = STDIN
  end

  def test_player_get_dir_input_changes_coord_when_up_input
    player = Player.new("Fred", 2) # board is just A1-B2
    sub = Ship.new("sub", 2)
    testInp = StringIO.new
    testInp.puts "up"
    testInp.rewind
    $stdin = testInp
    result, stdout, stderr = OStreamCatcher.catch do
      player.get_dir_input("B2", sub)
    end

    assert_equal [false, "A2"], result

    $stdin = STDIN
  end

  def test_player_get_dir_input_changes_coord_when_u_input
    player = Player.new("Fred", 2) # board is just A1-B2
    sub = Ship.new("sub", 2)
    testInp = StringIO.new
    testInp.puts "u"
    testInp.rewind
    $stdin = testInp
    result, stdout, stderr = OStreamCatcher.catch do
      player.get_dir_input("B2", sub)
    end

    assert_equal [false, "A2"], result

    $stdin = STDIN
  end

  def test_player_get_dir_input_keeps_coord_when_right_input
    player = Player.new("Fred", 2) # board is just A1-B2
    sub = Ship.new("sub", 2)
    testInp = StringIO.new
    testInp.puts "right"
    testInp.rewind
    $stdin = testInp
    result, stdout, stderr = OStreamCatcher.catch do
      player.get_dir_input("B2", sub)
    end

    assert_equal [true, "B2"], result

    $stdin = STDIN
  end

  def test_player_get_dir_input_keeps_coord_when_r_input
    player = Player.new("Fred", 2) # board is just A1-B2
    sub = Ship.new("sub", 2)
    testInp = StringIO.new
    testInp.puts "r"
    testInp.rewind
    $stdin = testInp
    result, stdout, stderr = OStreamCatcher.catch do
      player.get_dir_input("B2", sub)
    end

    assert_equal [true, "B2"], result

    $stdin = STDIN
  end

  def test_player_get_dir_input_keeps_coord_when_down_input
    player = Player.new("Fred", 2) # board is just A1-B2
    sub = Ship.new("sub", 2)
    testInp = StringIO.new
    testInp.puts "down"
    testInp.rewind
    $stdin = testInp
    result, stdout, stderr = OStreamCatcher.catch do
      player.get_dir_input("B2", sub)
    end

    assert_equal [false, "B2"], result

    $stdin = STDIN
  end

  def test_player_get_dir_input_keeps_coord_when_d_input
    player = Player.new("Fred", 2) # board is just A1-B2
    sub = Ship.new("sub", 2)
    testInp = StringIO.new
    testInp.puts "d"
    testInp.rewind
    $stdin = testInp
    result, stdout, stderr = OStreamCatcher.catch do
      player.get_dir_input("B2", sub)
    end

    assert_equal [false, "B2"], result

    $stdin = STDIN
  end

  # No tests of place method because it requires user input (from get_starting_coord and get_dir_input helper methods)
  # No tests of turn method because it requires user input

  def test_player_turn_valid_input
    player1 = Player.new("Fred", 6)
    player2 = Player.new("Mike", 6)
    testInp = StringIO.new
    testInp.puts "B6"
    testInp.rewind
    $stdin = testInp
    result, stdout, stderr = OStreamCatcher.catch do
      player1.turn(player2)
    end

    assert_equal :none, result

    $stdin = STDIN
  end

  def test_player_turn_invalid_input
    player1 = Player.new("Fred", 6)
    player2 = Player.new("Mike", 6)
    testInp = StringIO.new
    testInp.puts "545f"
    testInp.puts "4354"
    testInp.puts "!"
    testInp.rewind
    $stdin = testInp
    result, stdout, stderr = OStreamCatcher.catch do
      player1.turn(player2)
    end

    assert_equal :quit, result
    assert_equal "Pick a target.\n>> Invalid coordinate.\nPick a target.\n"\
                 ">> Invalid coordinate.\nPick a target.\n>> ", stdout

    $stdin = STDIN
  end

  def test_player_turn_already_hit
    player1 = Player.new("Fred", 6)
    player2 = Player.new("Mike", 6)
    testInp = StringIO.new
    testInp.puts "B6"
    testInp.puts "B6"
    testInp.puts "!"
    testInp.rewind
    $stdin = testInp

    result, stdout, stderr = OStreamCatcher.catch do
      player1.turn(player2); player1.turn(player2)
    end

    assert_equal "Pick a target.\n>>  --- MISS!\nPick a target.\n"\
            ">> That's already been fired upon!\nPick a target.\n>> ",\
            stdout

    $stdin = STDIN
  end
end
