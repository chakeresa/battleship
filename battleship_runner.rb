require './lib/player'
require './lib/computer'
require './lib/render'

$renderer = Render.new

def load
    $oneships = []
    $twoships = []
    #redships
    #blueships
    xs = IO.readlines('ships.csv')
    xs.each do |x|
        y = x.chomp.split(/,/)
        $oneships << Ship.new(y[0], y[1].to_i)
        $twoships << Ship.new(y[0], y[1].to_i)
    end
end

def setup
    load
    valid = false
    puts "Welcome to battleship! Enter board size between 2 and 26"
    puts "(Enter for default of 10)."
    puts " -- (Type \'!\' at any time to exit the program.)"

    while !valid do
        print ">> "; boardsize = gets.chomp
        return false if boardsize == '!'
        if boardsize.match?(/^\d+$|^$/)
            (boardsize.to_i < 2 || boardsize.to_i > 26) ? (puts "Board size out of bounds!") : \
                                                                                                                                            valid = true
        else
            puts "Invalid input."
        end
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
        $playerone = Computer.new("COMPUTER ONE", boardsize)
        $oneships.each {|ship| $playerone.place(ship)}
        $playertwo = Computer.new("COMPUTER TWO", boardsize)
        $twoships.each {|ship| $playertwo.place(ship)}
    elsif $humanplayers == 1
        $playerone = Player.new("   PLAYER   ", boardsize)
        puts "Place your ships."
        $oneships.each do |ship|
            puts "\e[H\e[2J"
            puts $renderer.render($playerone.board, :all)
            puts "-" * 35
            result = $playerone.place(ship)
            return false if result == :quit
        end
        $playertwo = Computer.new("  COMPUTER  ", boardsize)
        $twoships.each {|ship| $playertwo.place(ship)}
    elsif $humanplayers == 2
        $playerone = Player.new(" PLAYER ONE ", boardsize)
        puts "PLAYER ONE: Place your ships."
        $oneships.each do |ship|
            puts "\e[H\e[2J"
            puts $renderer.render($playerone.board, :all)
            puts "-" * 35
            result = $playerone.place(ship)
            return false if result == :quit
        end
        $playertwo = Player.new(" PLAYER TWO ", boardsize)
        puts "\e[H\e[2J"
        puts "PLAYER TWO: Place your ships."
        $twoships.each do |ship|
            puts "\e[H\e[2J"
            puts $renderer.render($playertwo.board, :all)
            puts "-" * 35
            result = $playertwo.place(ship)
            return false if result == :quit
        end
    end
    return true
end

def game
    $victor = :none
    puts "\e[H\e[2J"
    if $humanplayers == 0
        while $victor == :none
            #COMPUTER ONE GO:
            puts "Computer One's Turn..."
            puts $renderer.render($playerone.board, $playertwo.board, :all)
            puts "-" * 35
            result = $playerone.turn($playertwo)
            if result == :win
                $victor = :one
                break
            end
            input = gets.chomp
            return false if input == '!'
            puts "\e[H\e[2J"
            puts "-" * 35
            #COMPUTER TWO GO:
            puts "Computer Two's Turn..."
            puts $renderer.render($playerone.board, $playertwo.board, :all)
            puts "-" * 35
            result = $playertwo.turn($playerone)
            if result == :win
                $victor = :two
                break
            end
            input = gets.chomp
            return false if input == '!'
            puts "\e[H\e[2J"
            puts "-" * 35
        end
    elsif $humanplayers == 1
        while $victor == :none
            #PLAYER ONE GO:
            puts "Player One's Turn..."
            puts $renderer.render($playerone.board, $playertwo.board, :one)
            puts "-" * 35
            result = $playerone.turn($playertwo)
            return false if result == :quit
            if result == :win
                $victor = :one
                break
            end
            input = gets.chomp
            return false if input == '!'
            puts "-" * 35
            #COMPUTER GO:
            puts "Computer Turn..."
            #puts $renderer.render($playerone.board, :all)
            #puts "-" * 35
            result = $playertwo.turn($playerone)
            if result == :win
                $victor = :two
                break
            end
            puts "-" * 35
        end
    elsif $humanplayers == 2
        while $victor == :none
            #PLAYER ONE GO:
            puts "Player One's Turn..."
            puts $renderer.render($playerone.board, $playertwo.board, :one)
            puts "-" * 55
            result = $playerone.turn($playertwo)
            return false if result == :quit
            if result == :win
                $victor = :one
                break
            end
            input = gets.chomp
            return false if input == '!'
            puts "\e[H\e[2J"
            puts "-" * 55
            #PLAYER TWO GO:
            puts "Player Two's Turn..."
            puts $renderer.render($playertwo.board, $playerone.board, :one)
            puts "-" * 55
            result = $playertwo.turn($playerone)
            return false if result == :quit
            if result == :win
                $victor = :two
                break
            end
            input = gets.chomp
            return false if input == '!'
            puts "\e[H\e[2J"
            puts "-" * 55
        end
    end
    return true
end

def finish
    puts "end"
end

finish if game if setup
puts "Goodbye!"
