require './lib/board'

class Player
    attr_reader :board
    def initialize(size = 10)
        @board = Board.new(size)
    end

    def place(ship)
        valid = :none
        while valid != :success do
            puts "Placing :" + ship.name + ", with Length of " + ship.length
            puts "Pick a starting coordinate."
            print ">> "; coord = gets.chomp
            return :quit if input == '!'
            puts "Pick a direction (left,right,up,down OR l,r,u,d)."
            print ">> "; direction = gets.chomp.downcase
            return :quit if input == '!'
            if @board.valid_coordinate?(coord)
                if direction.match?(/^l$|^left$/)
                    coord = coord[0] + (coord[1].to_i - (ship.length - 1)).to_s
                    valid = @board.place(ship, coord, true)
                elsif direction.match?(/^r$|^right$/)
                    valid = @board.place(ship, coord, true)
                elsif direction.match?(/^u$|^up$/)
                    coord = (coord[0].ord - (ship.length - 1)).chr + coord[1]
                    valid = @board.place(ship, coord)
                elsif direction.match?(/^d$|^down$/)
                    valid = @board.place(ship, coord)
                else
                    puts "Invalid direction."
                end
                puts "Out of bounds!" if valid == :oob
                puts "Overlap!" if valid == :overlap
            else
                puts "Invalid starting coordinate."
            end
        end
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