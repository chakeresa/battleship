module TurnResult
  def turn_result(opp, target)
    sunk = false
    opp.board[target].fire_upon
    refresh_render(opp)
    puts "#{@name.lstrip.rstrip} fired upon #{target}."
    if opp.board[target].empty?
      puts " --- MISS!"
      return :miss
    else
      puts " --- HIT!"

      if opp.board[target].ship.sunk?
        puts "#{@name.lstrip.rstrip.capitalize} sunk #{opp.name.lstrip.rstrip.capitalize}'s #{opp.board[target].ship.name}!!!"
        sunk = true
      end

      if opp.ships.all? {|ship| ship.sunk?}
        puts "#{@name.lstrip.rstrip} wins!!!"
        return :win
      else
        return sunk ? :sunk : :hit
      end
    end
  end

  def refresh_render(opp)
    puts "\e[H\e[2J"
    puts "#{@name.lstrip.rstrip}'S TURN..."
    puts "-" * (@board.size * 6 + 11)
    if $humanplayers == 0
      puts $renderer.render($playerone.board, $playertwo.board, :all)
    elsif $humanplayers == 1
      puts $renderer.render($playerone.board, $playertwo.board, :one)
    elsif $humanplayers == 2
      if opp == $playerone
        puts $renderer.render($playertwo.board, $playerone.board, :one)
      else
        puts $renderer.render($playerone.board, $playertwo.board, :one)
      end
    end
    puts "-" * (@board.size * 6 + 11)
  end

  def valid_target?(opp, target)
    if opp.board.valid_coordinate?(target.to_s)
      if !opp.board[target].fired_upon?
        return true
      else
        puts "That's already been fired upon!" if self.class == Player
        return false
      end

    else
      puts "Invalid coordinate." if self.class == Player
      return false
    end
  end
end

class DummyTurnResult
  include TurnResult

  attr_accessor :name, :board
  def initialize
    @name = "dummy"
    @board = Board.new("dummy")
  end
end
