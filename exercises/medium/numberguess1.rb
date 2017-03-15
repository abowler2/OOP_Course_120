class PingGame

  MAX_GUESSES = 7
  RANGE = 1..100
  RESULT_MESSAGE = {
    high: 'Your number it too high.',
    low:  'Your number is too low',
    lose: 'You are out of guesses. You lose.',
    win:  'You win!'
  }.freeze

  def play
    reset
    MAX_GUESSES.downto(1) do |remaining_guesses|
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
      print "Enter a number #{RANGE.first} and #{RANGE.last}: "
      guess = gets.chomp.to_i
      return guess if RANGE.cover? guess
      print "Invalid guess. Enter a number between 1 and 100."
    end
  end

  def reset
    @secret_number = rand(RANGE)
  end
end

game = PingGame.new
game.play

