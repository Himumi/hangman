class Word
  attr_accessor :choices, :selected_values, :available_choices

  def initialize
    @choices = ('a'..'z').to_a - %w[a i e u o]
    @selected_values = []
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

  def valid_values(guessing)
    available_choices.include?(guessing)
  end

  def available_choices
    @choices - @selected_values
  end
end

class Game
  def initialize(word)
    @word = word.new
    @random_word = @word.get_random_word
    @lifes = 5
    @board = default_board
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

  def give_hints
    change_board('aeiuo')
  end

  def default_board
    Array.new(@random_word.length, '_')
  end

  def change_board(guessing)
    @random_word.split('').each_with_index do |item, index|
      guessing.split('').each { |guess| @board[index] = guess if item == guess }
    end
  end

  def print_board
    @board.each_with_index do |item, index|
      print index == @board.length - 1 ? "#{item.upcase}\n\n" : "#{item.upcase} "
    end
  end

  def print_available_choices
    @word.available_choices.join("|").upcase
  end

  def display
    give_hints
    puts "\nAvailable choices => #{print_available_choices}"
    puts @random_word
    print_board
  end

  def start_message
    puts "\nWelcome to Hangman game made by me. It is a simple game"
    puts "that you must guess every char of random word./n"
    puts "You will provide with hints of vowel sounds, and printed"
    puts "board of available char like this./n"
    puts "\nAvailable choices => #{print_available_choices}/n"
    puts "You are just given 5 lifes for each game. Every mistake that"
    puts "you do program will draw hangman. don't die easily!!!"
  end

  def play
    start_message
    loop do
      puts "\nLifes =>  #{@lifes}"
      display
      guess = @word.get_guessing
      corrected?(guess) ? change_board(guess) : @lifes -= 1
      return puts "\nGame is over!! Random word was '#{@random_word.upcase}'" if over?
    end
  end
end

game = Game.new(Word)
game.play
