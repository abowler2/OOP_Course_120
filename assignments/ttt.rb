module Displayable
  def display_welcome_message
    puts "Welcome to Tic-Tac-Toe!"
    puts ""
  end

  def display_goodbye_message
    puts "Thanks for playing Tic-Tac-Toe! Goodbye!"
  end

  def clear
    system('clear') || system('cls')
  end

  def display_result
    clear_screen_and_display_board

    case board.winning_marker
    when human.marker
      puts "You won this match!"
      human.score += 1
    when computer.marker
      puts "Computer won this match!"
      computer.score += 1
    else
      puts "It's a tie!"
    end
  end

  def display_score
    puts "Score:  You #{human.score}  Computer #{computer.score}"
  end

  def display_game_winner
    puts "You won the game!!"
  end

  def display_play_again_message
    puts "OK, let's play again!"
    puts ""
  end

  def clear_screen_and_display_board
    clear
    display_board
  end

  def display_board
    puts "You are #{human.marker}'s. Computer is #{computer.marker}'s."
    puts ''
    board.draw
    puts ''
  end
end

class TTTGame
  HUMAN_MARKER = 'X'.freeze
  COMPUTER_MARKER = 'O'.freeze
  FIRST_TO_MOVE = HUMAN_MARKER.freeze
  MAX_GAMES = 5

  include Displayable

  attr_reader :board, :human, :computer

  def initialize
    @board = Board.new
    @human = Player.new(HUMAN_MARKER)
    @computer = Player.new(COMPUTER_MARKER)
    @current_marker = FIRST_TO_MOVE
  end

  def play
    display_welcome_message
    clear

    loop do
      main_game_play

      display_game_winner
      display_score
      break unless play_again?
      reset
      reset_score
      display_play_again_message
    end

    display_goodbye_message
  end

  # rubocop:disable Metrics/AbcSize
  def main_game_play
    loop do
      display_score
      display_board

      loop do
        current_player_moves
        break if board.someone_won? || board.full?
        clear_screen_and_display_board if human_turn?
      end

      display_result
      break if human.score == MAX_GAMES || computer.score == MAX_GAMES
      sleep(2)
      reset
    end
  end
  # rubocop:enable Metrics/AbcSize

  private

  def current_player_moves
    if human_turn?
      human_moves
      @current_marker = COMPUTER_MARKER
    else
      computer_moves
      @current_marker = HUMAN_MARKER
    end
  end

  def human_turn?
    @current_marker == HUMAN_MARKER
  end

  def joiner(unmarked_keys, join= ', ', word= 'or')
    case unmarked_keys.size
    when 0 then ''
    when 1 then unmarked_keys.first
    when 2 then unmarked_keys.join.insert(-2, " #{word} ")
    else unmarked_keys.join(join).insert(-2, "#{word} ")
    end
  end

  def human_moves
    puts "Choose one of these open squares (#{joiner(board.unmarked_keys)})"
    square = nil
    loop do
      square = gets.chomp.to_i
      break if board.unmarked_keys.include?(square)
      puts "Sorry, that is not a valid choice."
    end

    board[square] = human.marker
  end

  def computer_moves
    board[board.unmarked_keys.sample] = computer.marker
  end

  def play_again?
    answer = ''
    loop do
      puts "Would you like to play again? (y/n)"
      answer = gets.chomp.downcase
      break if %w(y n).include? answer
      puts "Sorry that is not a valid choice."
    end

    answer == 'y'
  end

  def reset_score
    human.score = 0
    computer.score = 0
  end

  def reset
    board.reset
    @current_marker = FIRST_TO_MOVE
    clear
  end
end

class Board
  WINNING_LINES = [[1, 2, 3], [4, 5, 6], [7, 8, 9]] +
                  [[1, 4, 7], [2, 5, 8], [3, 6, 9]] +
                  [[1, 5, 9], [3, 5, 7]]

  def initialize
    @squares = {}
    reset
  end

  # rubocop:disable Metrics/AbcSize
  def draw
    puts "     |     |"
    puts "  #{@squares[1]}  |  #{@squares[2]}  |  #{@squares[3]}"
    puts "     |     |"
    puts "-----+-----+-----"
    puts "     |     |"
    puts "  #{@squares[4]}  |  #{@squares[5]}  |  #{@squares[6]}"
    puts "     |     |"
    puts "-----+-----+-----"
    puts "     |     |"
    puts "  #{@squares[7]}  |  #{@squares[8]}  |  #{@squares[9]}"
    puts "     |     |"
  end
  # rubocop:enable Metrics/AbcSize

  def []=(num, marker)
    @squares[num].marker = marker
  end

  def unmarked_keys
    @squares.keys.select { |key| @squares[key].unmarked? }
  end

  def full?
    unmarked_keys.empty?
  end

  def someone_won?
    !!winning_marker
  end

  def winning_marker
    WINNING_LINES.each do |line|
      squares = @squares.values_at(*line)
      if three_identical_markers?(squares)
        return squares.first.marker
      end
    end
    nil
  end

  def reset
    (1..9).each { |key| @squares[key] = Square.new }
  end

  private

  def three_identical_markers?(squares)
    markers = squares.select(&:marked?).collect(&:marker)
    return false if markers.size != 3
    markers.min == markers.max
  end
end

class Square
  INITIAL_MARKER = " ".freeze

  attr_accessor :marker

  def initialize(marker=INITIAL_MARKER)
    @marker = marker
  end

  def to_s
    @marker
  end

  def unmarked?
    marker == INITIAL_MARKER
  end

  def marked?
    marker != INITIAL_MARKER
  end
end

class Player
  attr_reader :marker
  attr_accessor :score

  def initialize(marker)
    @marker = marker
    @score = 0
  end
end

game = TTTGame.new
game.play
