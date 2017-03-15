# Version adds abbreviations, eliminates ability to put a space for a name, and
# keeps a history of moves until player quits.

MAX_SCORE = 3

VALUES = ['rock', 'paper', 'scissors', 'lizard', 'spock'].freeze

ABBREVIATED_CHOICE = { 'r' => 'rock',
                       'p' => 'paper',
                       'sc' => 'scissors',
                       'l' => 'lizard',
                       'sp' => 'spock' }.freeze

WINNER = { 'rock' => ['scissors', 'lizard'],
           'paper' => ['rock', 'spock'],
           'scissors' => ['paper', 'lizard'],
           'lizard' => ['paper', 'spock'],
           'spock' => ['rock', 'scissors'] }.freeze

module Displayable
  def clear_screen
    system('clear') || system('cls')
  end

  def display_welcome_message
    puts "Hello, #{human.name}."
    puts "Lets play Rock, Paper, Scissors, Lizard, Spock!"
    puts "First one to win #{MAX_SCORE} games is the winner."
  end

  def display_goodbye_message
    puts "Thanks for playing Rock, Paper, Scissors, Lizard, Spock! Good-bye."
  end

  def display_moves
    puts "#{human.name} chose #{human.move}."
    puts "#{computer.name} chose #{computer.move}."
  end

  def display_winner
    if human.move > computer.move
      puts "#{human.name} won!"
      human.score += 1
    elsif computer.move > human.move
      puts "#{computer.name} won!"
      computer.score += 1
    else
      puts "It's a tie!"
    end
  end

  def display_score
    puts "Current score is #{human.name}: #{human.score}" \
         " #{computer.name}: #{computer.score}"
  end

  def display_match_winner
    if human.score == MAX_SCORE
      puts "#{human.name} is the Winner!!"
    elsif computer.score == MAX_SCORE
      puts "#{computer.name} is the Winner!!"
    end
  end

  def display_history
    puts "History: #{human.history}"
    puts "History: #{computer.history}"
  end
end

class RPSGame
  attr_accessor :human, :computer

  include Displayable

  def initialize
    @human = Human.new
    @computer = Computer.new
  end

  def reset_score
    human.score = 0
    computer.score = 0
  end

  def history
    human.history << human.move.value
    computer.history << computer.move.value
  end

  def clear_history
    human.history = []
    computer.history = []
  end

  def play_again?
    answer = nil
    loop do
      puts "Would you like to play again? (y/n)"
      answer = gets.chomp.downcase
      break if ['y', 'n'].include? answer
      puts "Sorry, must be y or n."
    end
    return false if answer == 'n'
    return true if answer == 'y'
  end

  def play
    clear_screen
    display_welcome_message

    loop do
      clear_history
      reset_score
      game_play
      display_match_winner
      break unless play_again?
    end
    display_history
    display_goodbye_message
  end

  def game_play
    loop do
      human.choose
      computer.choose
      history
      display_moves
      display_winner
      display_score
      break if human.score == MAX_SCORE || computer.score == MAX_SCORE
    end
  end
end

class Move
  attr_reader :value

  def initialize(value)
    @value = value
  end

  def to_s
    @value
  end

  def >(other_move)
    WINNER[value].include? other_move.value
  end
end

class Player
  attr_accessor :move, :name, :score, :history

  include Displayable

  def initialize
    set_name
    @score = 0
    @history = Array.new
  end
end

class Human < Player
  def set_name
    n = ''
    loop do
      clear_screen
      puts "What's your name?"
      n = gets.chomp
      break unless n.empty? || n.strip.empty?
      puts "Sorry, must enter a value."
    end
    self.name = n
  end

  def choose
    choice = nil
    loop do
      puts "Please choose (r)ock, (p)aper, (sc)issors, (l)izard, or (sp)ock:"
      choice = gets.chomp.downcase
      break if ABBREVIATED_CHOICE.keys.include? choice
      puts "Sorry, invalid choice."
    end
    choice = ABBREVIATED_CHOICE[choice]
    self.move = Move.new(choice)
  end
end

class Computer < Player
  def set_name
    self.name = ['R2D2', 'Hal', 'Chappie', 'Sonny', 'Number 5'].sample
  end

  def choose
    self.move = Move.new(VALUES.sample)
  end
end

RPSGame.new.play
