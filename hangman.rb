def get_random_word
  contents = File.readlines('google-10000-english-no-swears.txt', chomp: true)
  contents.select { |item| (5..12).include?(item.length) }.sample
end