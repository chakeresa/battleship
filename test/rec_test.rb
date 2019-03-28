require './lib/rec'

class Heck
  extend TailRec

  rec def count(i)
    puts "#{i}\e[H"
    count(i + 1)
  end
end

test = Heck.new
test.count(0)