#Kriti - some of the ideas in there are right on!
#Would love to see it once you'll can get it working 
#It seems right now your until loop keeps looking at only the adj words for duck.
#It isnt moving on to the next word in the adj words array

class WordChains
  attr_accessor :dictionary, :word

  def initialize(word, target_word)
    #Kriti - again u can use readlines instead of open and each_line.
    #Ned mentioned choosing map over collect as a convention
    @dictionary = File.open("dictionary.txt").each_line.collect(&:strip)
    @word = Word.new(word)
    @target_word = target_word
    @dictionary = @dictionary.select { |word| word.length == @word.value.length }
    @dictionary.delete(@word.value) 
  end

  #run and adjacent words are a little bigger than they can be
  def run
    word_arr = []
    word_arr << @word.value
    adj_words = [word] #Kriti - Whats the point of this line? its redundent right?
    adj_words = adjacent_words(word)
    adj_words.each { |w| word_arr += [w.value] }
    modify_dictionary(adj_words)

    until word_arr.include?(@target_word)
      # p word_arr
      #Kriti - you are repeating these lines of code. 
      #See if you can find a way to bring the above block into the until loop 
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
      #Kriti - instead of having the char variable, the .times function 
      #allows for a parameter|i| equivalent to the index values in the words
      #i.e., .times {|i| matches += 1 if w[i] == word[i]}
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

#Kriti - Ryan showed me that the best thing about having this class is that you can just
#have each word only store one parent and because the parent is itself an instance of 
#this class, you can very easily just iterate through and print the parents until u hit
#the starting word
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