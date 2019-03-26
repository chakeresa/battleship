module TurnResult
  def turn_result(opp, target)
    sunk = false
    opp.board[target].fire_upon
    refresh_render(opp)
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

  def refresh_render(opp)
    puts "\e[H\e[2J"
    puts "#{@name.lstrip.rstrip}'s Turn..."
    if $humanplayers == 0
      puts $renderer.render($playerone.board, $playertwo.board, :all)
    elsif $humanplayers == 2
      if opp == $playerone
        puts $renderer.render($playerone.board, $playertwo.board, :one)
      else
        puts $renderer.render($playertwo.board, $playerone.board, :one)
      end
    end
    puts "-" * 35
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
