module GamingSets
  require "json"

  class GamingBody

    def initialize(hidden_word, shots = 10, word_working, words_tried)
      @@hidden_word = hidden_word
      @@word_working = word_working
      @@shots = shots
      @@words_tried = words_tried

      while @@shots > 0
        showgame
        print "\ttype a word: (or type 'save' to save the game) :"
        choice = ""      
        while !choice.match(/[a-z]/i)
          choice = gets.chomp
          if choice.downcase == "save"
            save_game
          end
          if @@words_tried.include?(choice)
            print "\n\talready typed !! try another one :\n\t"
            choice = ""
            next
          end
          if choice.size > 1 || choice.size == 0
            print "\tWrong entry, try again :\n\t"
            choice = ""
            next
          end
          @@words_tried << choice
        end

        if @@hidden_word.include?(choice)
          puts "\n\tRight !!!\n\n"
          set_hidden(choice)
          if @@hidden_word == @@word_working
            congratz
          end
          next
        end
        
        puts "\n\tWrong !\n\n"
        
        @@shots -= 1
      end
      lost
    end
    
    def lost
      puts "You lose !!!"
      puts "the right answer was '#{@@hidden_word.upcase}'"
      play_again
    end

    def congratz
      
      puts "\n\t############################################################"
      puts "\tCongratz !!!!! Right answer !!!!\t'#{@@hidden_word.upcase}'"
      puts "\t############################################################\n\n"
      

      play_again
    end

    def play_again
      print "\tDo you want play again? (y or n)\n\t"
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
      json_save = JSON.dump({
        :hidden_word => @@hidden_word,
        :word_working => @@word_working,
        :shots => @@shots,
        :words_tried => @@words_tried
      })
      
      
      File.open("saved.json", "w") { |file| file.puts json_save}
      puts "\n\n\ttil next time! bye!!"
      exit!
    end

    def showgame
      print "\t"
      @@word_working.each_char { |c| print c.upcase + " "}
      print "\ttry: #{@@shots}\ttrieds: #{@@words_tried.join(",").upcase} \n"      
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
  require 'json'
  include GamingSets

  def initialize
    a = welcome
    if a == ""
      Gaming.new
      a = "-" * Gaming.hidden_word.size
      GamingBody.new(Gaming.hidden_word, 10, a, [])
    else
      load_game
    end    
  end

  def load_game
    # file = File.open("saved.json")
    save = JSON.load File.read("saved.json")
    GamingBody.new(save['hidden_word'], save['shots'], 
      save['word_working'], save['words_tried'])
    
  end

  def welcome
    print "
    #############################################################
    #                    WELCOME TO HANGMAN                     #
    #############################################################
    
    Try to figure out one random word, before it's too late!!!
    You have 10 shots.

    Before we start, do you like to play a game previously saved?
    type 'y' to load a game, or type <enter> :\n\t
    "
    answer = "0"
    until answer.match(/y/i) or answer == ""
      answer = gets.chomp
    end
    return answer
  end
end

GameStart.new