class Game
  def initialize
    @random_word = get_random_word
    @choices = (('a'..'z').to_a - %w[a i e u o])
    @lifes = 5
    @guessing = []
    @board = make_board(get_random_word)
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
        @guessing.push(input)
        return input
      end
    end
  end

  def check_guessing(guessing)
    if @random_word.include?(guessing)
      @random_word.each_with_index do |item, index|
        @board[index] = guessing if item == guessing
      end
    end
  end

  def valid_values(guessing)
    arr = (@choices - @guessing).include?(guessing)
  end
end

game = Game.new