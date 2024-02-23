require 'json'
require './word.rb'
require './draw.rb'
class Game
  include Draw
  def initialize(word)
    @word = word.new
  end

  def new_game
    @random_word = @word.get_random_word
    @lifes = 6
    @board = default_board
    @word.selected_values = []
    delete_saved_game_if_exist
    start_message
  end

  def save_game
    delete_saved_game
    game_data = {
      random_word: @random_word,
      selected_values: @word.selected_values,
      lifes: @lifes,
      board: @board
    }
    File.open('saved_game.json', 'w') do |file|
      file.puts JSON.dump(game_data)
    end
    puts 'Game is saved'
  end

  def load_game
    data = JSON.parse(File.read('saved_game.json'))
    set_loaded_game(data)
    start_message
    puts 'Saved game is loaded'
  end

  def set_loaded_game(data)
    @random_word = data['random_word']
    @word.selected_values = data['selected_values']
    @lifes = data['lifes']
    @board = data['board']
  end

  def delete_saved_game_if_exist
    File.delete('saved_game.json') if File.exist?('saved_game.json')
  end

  def menu_game(input)
    case input
    when 1
      save_game
      exit
    when 2
      new_game
    when 3
      exit
    end
  end

  def ask_game
    if File.exist?('saved_game.json')
      loop do
        saved_game_exist_message
        input = gets.chomp.to_i
        puts 'Please select game' unless (1..2).include?(input)
        return input == 1 ? load_game : new_game
      end
    else
      new_game
    end
  end

  def get_input
    menu_text
    loop do
      input = gets.chomp
      number = input.to_i
      char = input.downcase
      puts 'Please input again!' unless @word.valid_values(char) || (1..3).include?(number)
      if @word.valid_values(char)
        @word.get_guessing(char)
        return check_guessing(char)
      end
      return menu_game(number) if (1..3).include?(number)
    end
  end

  def corrected?(guess)
    @random_word.include?(guess)
  end

  def check_guessing(guessing)
    corrected?(guessing) ? change_board(guessing) : @lifes -= 1
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
    @random_word.chars.each_with_index do |item, index|
      guessing.chars.each { |guess| @board[index] = guess if item == guess }
    end
  end

  def print_board
    @board.each_with_index do |item, index|
      print index == @board.length - 1 ? "#{item.upcase}\n\n" : "#{item.upcase} "
    end
  end

  def print_available_choices
    puts "\nAvailable choices => #{@word.available_choices.join('|').upcase}"
  end

  def display
    puts "\nLifes =>  #{@lifes}"
    give_hints
    print_available_choices
    puts @random_word # Hint for debugging
    print '=> '
    print_board
    puts draw(@lifes)
  end

  def start_message
    puts "\nWelcome to Hangman game made by me. It is a simple game"
    puts 'that you must guess every char of random word./n'
    puts 'You will provide with hints of vowel sounds, and printed'
    puts "board of available char like this.\n"
    print_available_choices
    puts 'You are just given 6 lifes for each game. Every mistake that'
    puts "you do program will draw hangman. don't die easily!!!"
  end

  def menu_text
    puts 'Menu'
    puts '1. Save game'
    puts '2. New game'
    puts '3. Exit'
    puts ''
    puts 'Please input any char!'
    puts ''
  end

  def saved_game_exist_message
    puts 'Do you wanna continue game?'
    puts '1. Continue Game'
    puts '2. New Game'
  end

  def game_over_message
    delete_saved_game_if_exist
    puts "\nGame is over!!\n\nRandom word was '#{@random_word.upcase}'"
  end

  def play
    ask_game
    loop do
      display
      get_input
      return game_over_message if over?
    end
  end
end

game = Game.new(Word)
game.play
