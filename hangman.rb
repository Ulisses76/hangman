module GamingSets
  class GamingBody
    def initialize(hidden_word, shots = 10, word_working)
      @@hidden_word = hidden_word
      @@word_working = word_working
      @@shots = shots      
      while @@word_working != @@hidden_word
        showgame
        print "\ttype a word: (or type 'save' to save the game) :"
        choice = ""      
        while !choice.match(/[a-z]/i)
          choice = gets.chomp
          if choice.downcase == "save"
            save_game          
          end
          if @@word_working.include?(choice)
            puts "\nalready typed !! try another one"
            choice = ""
          end
          if choice.size > 1
            puts "Wrong entry, try again"
            choice = ""
          end        
        end

        if @@hidden_word.include?(choice)
          set_hidden(choice)
        end
        if @@hidden_word == @@word_working
          congratz
        end
      end
    end
    
    def congratz
      puts ""
      puts "############################################################"
      puts "Congratz !!!!! Right asnwer !!!!\t'#{@@hidden_word.upcase}'"
      puts "############################################################"
      puts ""
      
      play_again
    end

    def play_again
      puts "Do you want play again? (y or n)"
      a = gets.chomp.downcase
      if a == "y"
        GameStart.new
      end
      
      exit!
    end      
      
    def set_hidden(choice)
      mat = @@hidden_word.split("")
      mat.each_with_index do |char,index|
        if char == choice
          @@word_working[index] = choice
        end
      end
    end

    def save_game
      exit!
    end

    def showgame
      print "\t"
      @@word_working.each_char { |c| print c + " "}
      print "\t\t\t try: #{@@shots} \n"      
    end

  end
end

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

class GameStart
  include GamingSets

  def initialize
    a = welcome
    if a == ""
      Gaming.new
      a = "-" * Gaming.hidden_word.size
      GamingBody.new(Gaming.hidden_word, 10, a)
    else
      load_game
    end    
  end

  def load_game
    exit!
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