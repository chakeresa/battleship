require './lib/board'

class Player
    attr_reader :board
    def initialize(size = 10)
        @board = Board.new(size)
    end

    def place(ship)

    end

    def turn
        #puts render(board)
        valid = false
        while !valid do
            puts "Pick a target."
            print ">> "; input = gets.chomp
            return :quit if input == '!'
            if @board.valid_coordinate?(input)
                if !@board[input.to_sym].fired_upon?
                    @board[input.to_sym].fire_upon; valid = true
                else
                    puts "That's already been fired upon!"
                end
            else
                puts "Invalid coordinate."
            end
        end
        if @board[input.to_sym].empty?
            puts " --- MISS!"
            return :none
        else
            puts " --- HIT!"
            if @ships.all {|ship| ship.sunk?}
                return :win
            else
                return :none
            end
        end
    end
end