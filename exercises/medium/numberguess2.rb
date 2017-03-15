class PingGame

  RESULT_MESSAGE = {
    high: 'Your number it too high.',
    low:  'Your number is too low',
    lose: 'You are out of guesses. You lose.',
    win:  'You win!'
  }.freeze

  def initialize(first_num, last_num)
    @range = (first_num..last_num)
    @max_guesses = Math.log2(last_num - first_num + 1).to_i + 1
  end

  def play
    reset
    @max_guesses.downto(1) do |remaining_guesses|
      display_guesses_remaining(remaining_guesses)
      result = check_guess(request_number)
      puts RESULT_MESSAGE[result]
      return if result == :win
    end

    puts '\n', RESULT_MESSAGE[:lose]
  end

  private

  def display_guesses_remaining(remaining)
    puts
    if remaining == 1
      puts "You have 1 guess remaining."
    else
      puts "You have #{remaining} guesses remaining."
    end
  end

  def check_guess(guess_value)
    return :win if guess_value == @secret_number
    return :low if guess_value < @secret_number
    :high
  end

  def request_number
    loop do
      print "Enter a number #{@range.first} and #{@range.last}: "
      guess = gets.chomp.to_i
      return guess if @range.cover? guess
      print "Invalid guess. Enter a number between 1 and 100."
    end
  end

  def reset
    @secret_number = rand(@range)
  end
end

game = PingGame.new(501, 1500)
game.play