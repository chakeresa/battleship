module TurnResult
  def turn_result(opp, target)
    sunk = false
    opp.board[target].fire_upon
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
        return :win
      else
        return sunk ? :sunk : :hit
      end
    end
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

  def initialize
    @name = "dummy"
  end
end
