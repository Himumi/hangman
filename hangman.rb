class Game
  def initialize
    @random_word = get_random_word
    @choices = (('a'..'z').to_a - %w[a i e u o])
    @lifes = 5
    @selected_values = []
    @board = default_board
  end

  def get_random_word
    contents = File.readlines('google-10000-english-no-swears.txt', chomp: true)
    contents.select { |item| (5..12).include?(item.length) }.sample
  end

  def get_guessing
    puts 'Please input any char!'
    loop do
      input = gets.chomp.downcase
      puts 'Please input again!' unless valid_values(input)

      if valid_values(input)
        @selected_values.push(input)
        return input
      end
    end
  end

  def corrected?(guess)
    @random_word.include?(guess)
  end

  def game_over
    @lifes == 0
  end

  def over?
    game_over || (@random_word == @board.join)
  end

  def valid_values(guessing)
    (@choices - @selected_values).include?(guessing)
  end

  def give_hints
    change_board(%w[a e i o u])
  end

  def default_board
    Array.new(@random_word.length, '_')
  end

  def change_board(guessing)
    @random_word.split('').each_with_index do |item, index|
      if guessing.length == 1
        @board[index] = guessing if item == guessing
      else
        guessing.each { |guess| @board[index] = guess if item == guess }
      end
    end
  end

  def print_board
    @board.each_with_index do |item, index|
      print index == @board.length - 1 ? "#{item}\n" : "#{item} "
    end
  end
  def display
    p(@choices - @selected_values)
    give_hints
    puts ''
    puts @random_word
    print_board
    puts ''
  end

  def play
    loop do
      puts "Lifes =  #{@lifes}"
      display
      guess = get_guessing
      corrected?(guess) ? change_board(guess) : @lifes -= 1
      return puts 'Game is over!!' if over?
    end
  end
end

game = Game.new
game.play
