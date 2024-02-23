class Word
    attr_accessor :selected_values
  
    def initialize
      @choices = ('a'..'z').to_a - %w[a i e u o]
      @selected_values = []
    end
  
    def get_random_word
      File.readlines('google-10000-english-no-swears.txt', chomp: true).select do |item|
        (5..12).include?(item.length)
      end.sample
    end
  
    def add_to_selected_values(guess)
      @selected_values.push(guess)
    end
  
    def valid_values(guessing)
      available_choices.include?(guessing)
    end
  
    def available_choices
      @choices - @selected_values
    end
  end