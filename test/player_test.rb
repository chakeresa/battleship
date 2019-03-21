require 'minitest/autorun'
require 'stringio'
require 'o_stream_catcher' # if missing do gem install o_stream_catcher
require './lib/player'

class PlayerTest < Minitest::Test
    def test_player_init
        test = Player.new

        assert_instance_of Player, test
        assert_instance_of Board, test.board
    end

    # TO DO: need tests of place method

    def test_player_turn_valid_input
        test = Player.new
        testInp = StringIO.new
        testInp.puts "B6"
        testInp.rewind
        $stdin = testInp
        result, stdout, stderr = OStreamCatcher.catch do
            test.turn
        end

        assert_equal :none, result

        $stdin = STDIN
    end

    def test_player_turn_invalid_input
        test = Player.new
        testInp = StringIO.new
        testInp.puts "545f"
        testInp.puts "4354"
        testInp.puts "!"
        testInp.rewind
        $stdin = testInp
        result, stdout, stderr = OStreamCatcher.catch do
            test.turn
        end

        assert_equal :quit, result
        assert_equal "Pick a target.\n>> Invalid coordinate.\nPick a target.\n"\
                     ">> Invalid coordinate.\nPick a target.\n>> ", stdout

        $stdin = STDIN
    end

    def test_player_turn_already_hit
        test = Player.new
        testInp = StringIO.new
        testInp.puts "B6"
        testInp.puts "B6"
        testInp.puts "!"
        testInp.rewind
        $stdin = testInp
        result, stdout, stderr = OStreamCatcher.catch do
            test.turn; test.turn
        end

        assert_equal "Pick a target.\n>>  --- MISS!\nPick a target.\n"\
                ">> That's already been fired upon!\nPick a target.\n>> ",\
                stdout

        $stdin = STDIN
    end
end
