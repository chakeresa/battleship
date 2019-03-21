require './lib/player'
require './lib/computer'

$playerone = nil
$playertwo = nil
$humanplayers = nil
$listships = [Ship.new("Test1", 3), Ship.new("Test2", 5)]
def setup
    valid = false
    while !valid do
        puts "Welcome to battleship! Enter board size (Enter for default of 10)."
        puts " -- (Type \'!\' at any time to exit the program.)"
        print ">> "; boardsize = gets.chomp
        return false if boardsize == '!'
        boardsize.match?(/^\d+$|^$/) ? valid = true : (puts "Invalid input.")
    end
    boardsize = 10 if boardsize.match?(/^$/)
    valid = false
    while !valid do
        puts "Enter number of players: (0, 1, or 2)."
        print ">> "; players = gets.chomp
        return false if players == '!'
        players.match?(/^[012]{1}$/) ? valid = true : (puts "Invalid input, options are 0, 1, or 2")
    end
    $humanplayers = player.to_i
    if $humanplayers == 0
        $playerone = Computer.new(boardsize)
        $listships.each {|ship| $playerone.place(ship)}
        $playertwo = Computer.new(boardsize)
        $listships.each {|ship| $playertwo.place(ship)}
    elsif $humanplayers == 1
        $playerone = Player.new(boardsize)
        puts "Place your ships."
        $listships.each do |ship|
            result = $playerone.place(ship)
            return false if result == :quit
        end
        $playertwo = Computer.new(boardsize)
        $listships.each {|ship| $playertwo.place(ship)}
    elsif $humanplayers == 2
        $playerone = Player.new(boardsize)
        puts "PLAYER ONE: Place your ships."
        $listships.each do |ship|
            result = $playerone.place(ship)
            return false if result == :quit
        end
        $playertwo = Player.new(boardsize)
        puts "PLAYER TWO: Place your ships."
        $listships.each do |ship|
            result = $playertwo.place(ship)
            return false if result == :quit
        end
    end
    return true
end

def game
    if $humanplayers == 0

    elsif $humanplayers == 1

    elsif $humanplayers == 2

    end
    return true
end

def finish
    puts "end"
end

finish if game if setup
puts "Goodbye!"
