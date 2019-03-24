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
        return :win
      else
        return :none
      end
    end
  end
end
