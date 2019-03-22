require './lib/board'

class Render

  def render(*boards, reveal)
    # TO DO: ^ tests are very unhappy -- probably have to put reveal first
    @boards = boards
    @reveal = reveal
    render_return = names
    render_return += first_row

    @boards[0].size.times do |i|
      render_return += subsequent_row(i)
    end

    render_return
  end

  def names
      if @boards.size == 1
          return (" " * 12) + @boards[0].name + "\n"
      else
          return (" " * 5) + @boards[0].name + (" " * 8) + "|" + (" " * 9) + @boards[1].name + "\n"
      end
  end

  def first_row
    size = @boards[0].size
    if @boards.size == 1
        first_row_return = " " * 8
    else
        first_row_return = " "
    end

    #OUR BOARD
    ('1'..size.to_s).each do |number|
      first_row_return += " " + number
    end

    #THEIR BOARD
    if @boards.size > 1
        first_row_return += " " * 3
        first_row_return += " " if @boards[1].size < 10
        first_row_return += "|"
        first_row_return += " " * 5
        ('1'..size.to_s).each do |number|
          first_row_return += " " + number
        end
    end

    first_row_return += " \n"
  end

  def subsequent_row(i)
    row_counter = i + 1 # starts at one
    letter = (64 + row_counter).chr
    row_render = ""
    row_render = " " * 7 if @boards.length == 1
    row_render += letter

    #OUR BOARD
    @boards[0].size.times do |i|
      number = (i + 1).to_s
      cell = (letter + number).to_sym
      row_render += " " + @boards[0][cell].render(@reveal == :one || @reveal == :all)
    end

    #THEIR BOARD
    if @boards.size > 1
        row_render += " " * 4
        row_render += "|"
        row_render += " " * 4
        row_render += letter
        @boards[1].size.times do |i|
          number = (i + 1).to_s
          cell = (letter + number).to_sym
          row_render += " " + @boards[1][cell].render(@reveal == :two || @reveal == :all)
        end
    end

    row_render += " \n"
  end
end
