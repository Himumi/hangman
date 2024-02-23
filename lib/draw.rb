module Draw
    def draw(lifes)
      case lifes
      when 5
        puts ''
        puts '+'
        puts '+'
        puts '+'
        puts '+'
        puts '+'
        puts '+'
      when 4
        puts ''
        puts '++++++'
        puts '+'
        puts '+'
        puts '+'
        puts '+'
        puts '+'
      when 3
        puts ''
        puts '++++++'
        puts '+'
        puts '+    o'
        puts '+'
        puts '+'
        puts '+'
      when 2
        puts ''
        puts '++++++'
        puts '+'
        puts '+    o'
        puts '+   -+-'
        puts '+'
        puts '+'
      when 1
        puts ''
        puts '++++++'
        puts '+'
        puts '+    o'
        puts '+   -+-'
        puts '+    ^'
        puts '+'
      when 0
        puts ''
        puts '++++++'
        puts '+    |'
        puts '+    o'
        puts '+   -+-'
        puts '+    ^'
        puts '+'
      end
    end
  end