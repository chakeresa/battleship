module TurnResult
  def turn_result(opp, target)
    if opp.board[target].empty?
      puts " --- MISS!"
      return :none
    else
      puts " --- HIT!"

      if opp.board[target].ship.sunk?
        puts "#{@name.lstrip.rstrip} sunk #{opp.name.lstrip.rstrip}'s #{opp.board[target].ship.name}!!!"
      end

      if opp.ships.all? {|ship| ship.sunk?}
        puts "#{@name.lstrip.rstrip} wins!!!"
        return :win
      else
        return :none
      end
    end
  end

  def valid_target?(opp, target)
    if opp.board.valid_coordinate?(target.to_s)
      if !opp.board[target].fired_upon?
        opp.board[target].fire_upon
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

  def initialize
    @name = "dummy"
  end
end
