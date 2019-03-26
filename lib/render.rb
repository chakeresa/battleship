require './lib/board'

class Render

  def render(*boards, reveal)
    @boards = boards
    @reveal = reveal
    render_return = names
    render_return += first_row

    @boards[0].size.times do |i|
      render_return += subsequent_row(i)
    end

    render_return
  end

  def padding
    first_name_length = @boards[0].name.length
    board_size = @boards[0].size
    board_render_width = 7 + 3 * board_size
    padding_return = (board_render_width - first_name_length) / 2
    padding_return = [padding_return, 0].max
  end

  def names
    if @boards.size == 1
      return (" " * (5 + padding)) + @boards[0].name + "\n"
    else
      return (" " * padding) + @boards[0].name + (" " * padding) + (" " * padding) + @boards[1].name + "\n"
    end
  end

  def initial_padding
    if @boards.size == 1
      " " * 9
    else
      " " * 2
    end
  end

  def first_row_our_board(size)
    our_board_return = ""

    ('1'..size.to_s).each do |number|
      our_board_return += " " + number
      our_board_return += " " if number.to_i < 9
    end

    our_board_return
  end

  def first_row_their_board(size)
    if @boards.size > 1
      their_board_return = " " * 2
      their_board_return += " " if size >= 9
      their_board_return += " |      "

      ('1'..size.to_s).each do |number|
        their_board_return += " " + number
        their_board_return += " " if number.to_i < 9
      end

      their_board_return
    else
      ""
    end
  end

  def first_row
    size = @boards[0].size
    first_row_return = initial_padding
    first_row_return += first_row_our_board(size)
    first_row_return += first_row_their_board(size)
    first_row_return += " \n"
  end

  def sub_row_ours(letter)
    sub_row_return = ""

    @boards[0].size.times do |i|
      number = (i + 1).to_s
      cell = (letter + number).to_sym
      sub_row_return += "  " + @boards[0][cell].render(@reveal == :one || @reveal == :all)
    end

    sub_row_return
  end

  def sub_row_theirs(letter)
    sub_row_return = ""

    if @boards.size > 1
      sub_row_return += "    |    "
      sub_row_return += letter

      @boards[1].size.times do |i|
        number = (i + 1).to_s
        cell = (letter + number).to_sym
        sub_row_return += "  " + @boards[1][cell].render(@reveal == :two || @reveal == :all)
      end
    end

    sub_row_return
  end

  def subsequent_row(i)
    row_counter = i + 1 # starts at one
    letter = (64 + row_counter).chr
    row_render = ""
    row_render = " " * 7 if @boards.length == 1
    row_render += letter
    row_render += sub_row_ours(letter)
    row_render += sub_row_theirs(letter)
    row_render += " \n"
  end
end
