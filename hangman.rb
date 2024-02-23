require 'json'
require './lib/word'
require './lib/draw'
require './lib/color'
class Game
  include Draw
  using ColorableString
  def initialize(word)
    @word = word.new
  end

  def play
    ask_game
    loop do
      puts draw(@lifes) # It will excute if @lifes' values is changed
      if over?
        game_over_message
        return delete_saved_game_if_exist
      end
      display
      get_input
    end
  end

  protected

  # Game Menu Functions
  def new_game
    @random_word = @word.get_random_word
    @lifes = 6
    @board = default_board
    @word.selected_values = []
    delete_saved_game_if_exist
    start_message
  end

  def save_game
    delete_saved_game_if_exist
    game_data = {
      random_word: @random_word,
      selected_values: @word.selected_values,
      lifes: @lifes,
      board: @board
    }
    File.open('saved_game.json', 'w') do |file|
      file.puts JSON.dump(game_data)
    end
    puts ''
    puts 'Game is saved'.fg_color(:green)
  end

  def load_game
    data = JSON.parse(File.read('saved_game.json'))
    set_loaded_game_values(data)
    start_message
    puts ''
    puts 'Saved game is loaded'.fg_color(:green)
  end

  def set_loaded_game_values(data)
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
      delete_saved_game_if_exist
      save_game
    when 2
      new_game
    when 3
      clean_exit
    end
  end

  def clean_exit
    loop do
      exit_agreement_message
      input = gets.chomp.to_i
      puts 'You entered wrong value!!'.fg_color(:red) unless (1..2).include?(input)
      exit if input == 1
      return if input == 2
    end
  end

  def ask_game
    if File.exist?('saved_game.json')
      loop do
        saved_game_exist_message
        input = gets.chomp.to_i
        puts 'Please select game'.fg_color(:red) unless (1..2).include?(input)
        return  load_game if input == 1
        return new_game if input == 2
      end
    else
      new_game
    end
  end

  def get_input
    loop do
      input = gets.chomp
      check_input = @word.valid_values(input.downcase) || (1..3).include?(input.to_i)
      return clean_get_input(input) if check_input == true

      puts 'Please input again!'.fg_color(:red) unless check_input == true
    end
  end

  def clean_get_input(input)
    if (1..3).include?(input.to_i)
      menu_game(input.to_i)
    else
      @word.add_to_selected_values(input.downcase)
      check_guessing(input.downcase)
    end
  end

  # Over Conditional Functions
  def corrected?(guess)
    @random_word.include?(guess)
  end

  def game_over
    @lifes == 0
  end

  def over?
    game_over || (@random_word == @board.join)
  end

  def check_guessing(guessing)
    corrected?(guessing) ? change_board(guessing) : @lifes -= 1
  end

  # Board Functions
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

  # Print Functions
  def print_board
    @board.each_with_index do |item, index|
      print index == @board.length - 1 ? "#{item.upcase}\n".fg_color(:cyan) : "#{item.upcase} ".fg_color(:cyan)
    end
  end

  def print_available_choices
    puts "\nAvailable choices => " + @word.available_choices.join('|').upcase.fg_color(:cyan)
  end

  def print_lifes
    puts "\nLifes".fg_color(:cyan) + ' => ' + "#{@lifes}".fg_color(:green)
  end

  def display
    give_hints
    print_lifes
    print_available_choices
    puts @random_word # Hint for debugging
    print '=> '
    print_board
    menu_text
  end

  # Message Functions
  def start_message
    puts "\nWelcome to Hangman game made by me. It is a simple game"
    puts 'that you must guess every char of random word.'
    puts 'You will provide with hints of vowel sounds, and printed'
    puts "board of available char like this.\n"
    print_available_choices
    puts ''
    puts 'You just enter number for each menu. Not the text'
    puts ''
    puts 'Do you wanna continue game?'.fg_color(:red)
    puts '1. Continue Game'
    puts '2. New Game'
    puts ''
    puts 'Enter : 2 #to new game'
    puts ''
    puts 'You are just given 6 lifes for each game. Every mistake that'
    puts "you do program will draw hangman. don't die easily!!!"
  end

  def menu_text
    puts ''
    puts 'Menu'.fg_color(:green)
    puts '1. Save game'
    puts '2. New game'
    puts '3. Exit'
    puts ''
    puts 'Please input any char!'.fg_color(:green)
    puts ''
  end

  def saved_game_exist_message
    puts 'Do you wanna continue game or new game?'.fg_color(:green)
    puts '1. Continue Game'
    puts '2. New Game'
  end

  def game_over_message
    puts 'Game is over!!'.fg_color(:red)
    puts 'Random word was ' + @random_word.upcase.fg_color(:green)
  end

  def exit_agreement_message
    puts 'Do you really wanna exit without save game??'.fg_color(:red)
    puts ''
    puts '1. Yes'
    puts '2. No'
  end
end

game = Game.new(Word)
game.play
