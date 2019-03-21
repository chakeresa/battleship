require './lib/player'
require './lib/computer'

$playerone = nil
$playertwo = nil
$humanplayers = nil
$renderer = Render.new

def load
    ships = []
    xs = IO.readlines('ships.csv')
    xs.each {|x| y = x.chomp.split(/,/); ships << Ship.new(y[0], y[1])}
    return ships
end

$listships = load

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
    boardsize = boardsize.to_i
    valid = false
    while !valid do
        puts "Enter number of players: (0, 1, or 2)."
        print ">> "; players = gets.chomp
        return false if players == '!'
        players.match?(/^[012]{1}$/) ? valid = true : \
                                (puts "Invalid input, options are 0, 1, or 2")
    end
    $humanplayers = players.to_i
    if $humanplayers == 0
        $playerone = Computer.new(boardsize)
        $listships.each {|ship| $playerone.place(ship)}
        $playertwo = Computer.new(boardsize)
        $listships.each {|ship| $playertwo.place(ship)}
    elsif $humanplayers == 1
        $playerone = Player.new(boardsize)
        puts "Place your ships."
        $listships.each do |ship|
            puts $renderer.render($playerone.board, true)
            puts "-" * 35
            result = $playerone.place(ship)
            return false if result == :quit
        end
        $playertwo = Computer.new(boardsize)
        $listships.each {|ship| $playertwo.place(ship)}
    elsif $humanplayers == 2
        $playerone = Player.new(boardsize)
        puts "PLAYER ONE: Place your ships."
        $listships.each do |ship|
            puts $renderer.render($playerone.board, true)
            puts "-" * 35
            result = $playerone.place(ship)
            return false if result == :quit
        end
        $playertwo = Player.new(boardsize)
        print "\n" * 100
        puts "PLAYER TWO: Place your ships."
        $listships.each do |ship|
            puts $renderer.render($playertwo.board, true)
            puts "-" * 35
            result = $playertwo.place(ship)
            return false if result == :quit
        end
    end
    return true
end

def game
    victor = :none
    if $humanplayers == 0
        while victor == :none

        end
    elsif $humanplayers == 1
        while victor == :none
            #PLAYER ONE GO:
            puts "Player One's Turn."
            puts $renderer.render($playertwo.board)
            puts "-" * 35
            result = $playerone.turn
            return false if result == :quit
            if result == :win
                victor = :one
                break
            end
            gets
            #COMPUTER GO:
            puts "Computer Turn"

        end
    elsif $humanplayers == 2
        while victor == :none
            #PLAYER ONE GO:
            puts "Player One's Turn."
            puts $renderer.render($playerone.board)
            puts "-" * 35
            result = $playerone.turn
            return false if result == :quit
            if result == :win
                victor = :one
                break
            end
            gets
            print "\n\n\n"
            puts "-" * 35
            #PLAYER TWO GO:
            puts "Player Two's Turn."
            puts $renderer.render($playertwo.board)
            puts "-" * 35
            result = $playertwo.turn
            return false if result == :quit
            if result == :win
                victor = :one
                break
            end
            gets
            print "\n\n\n"
            puts "-" * 35
        end
    end
    return true
end

def finish
    puts "end"
end

finish if game if setup
puts "Goodbye!"
