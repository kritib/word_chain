class WordChains
  attr_accessor :dictionary, :word

  def initialize(word, target_word)
    @dictionary = File.open("dictionary.txt").each_line.collect(&:strip)
    @word = Word.new(word)
    @target_word = target_word
    @dictionary = @dictionary.select { |word| word.length == @word.value.length }
    @dictionary.delete(@word.value)
  end

  def run
    word_arr = []
    word_arr << @word.value
    adj_words = [word]
    adj_words = adjacent_words(word)
    adj_words.each { |w| word_arr += [w.value] }
    modify_dictionary(adj_words)

    until word_arr.include?(@target_word)
      p word_arr
      adj_words = adj_words_from_array(adj_words)
      adj_words.each { |w| word_arr += [w.value] }
      modify_dictionary(adj_words)
    end

    index = adj_words.find_index { |word| word.value == @target_word }

    adj_words[index].parents
  end

  def adjacent_words(word)
    one_away = []
    @dictionary.each do |w|
      matches = 0
      char = 0

      word.value.length.times do
        if word.value[char] == w[char]
          matches += 1
        end
        char += 1
      end

      if matches == word.value.length - 1
        parents = word.parents.dup
        parents << word.value
        one_away << Word.new(w, parents)
      end
    end
    one_away
  end

  def adj_words_from_array(words)
    adjacent_words = []
    words.each do |word|
      adjacent_words += adjacent_words(word)
    end
  end

  def modify_dictionary(one_away)
    #take away word
    one_away.each do |word|
      @dictionary.delete(word.value)
    end
  end

end

class Word
  attr_accessor :value, :parents

  def initialize(value, parents = [])
    @value = value
    @parents = parents
  end
end

#script
w = WordChains.new('duck', 'ruby')
p w.run