module GamingSets  

  class Gaming
    
    def initialize
      @@hidden_word = choice_word      
    end
    
    def self.hidden_word
      @@hidden_word
    end
    
    def choice_word      
      file = File.open("lib/google-10000-english-no-swears.txt")
      word_array = file.readlines
      word = ""
      
      while word.size < 5 || word.size > 12 do
        word = word_array[rand(word_array.size)][0..-2]
      end

      return word
    end

  end

end


class GameStart
  include GamingSets

  def initialize
    a = welcome
    if a == ""
      p Gaming.new.hidden_word
    else
      Load_game
    end
    
  end


  def welcome
    puts "
    #############################################################
    #                    WELCOME TO HANGMAN                     #
    #############################################################
    
    Try to figure out one random word, before it's too late!!!
    You have 10 shots.

    Before we start, do you like to play a game previously saved?
    type 'y' to load a game, or type <enter> :
    "
    answer = "0"
    until answer.match(/y/i) or answer == ""
      answer = gets.chomp
    end
    return answer
  end
end

GameStart.new