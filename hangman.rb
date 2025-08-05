# hangtime.rb

words = ["ruby", "terminal", "syntax", "rails", "framework"]
secret_word = words.sample
correct_letters = []
lives = 6

puts "💀 HangTime – Terminal Hangman"

while lives > 0
    display = secret_word.chars.map { |char| correct_letters.include?(char) ? char : "_" }.join(" ")
    puts "\nWord: #{display}"
    break unless display.include?("_")

    print "Guess a letter: "
    guess = gets.chomp.downcase

    if secret_word.include?(guess)
        correct_letters << guess unless correct_letters.include?(guess)
        puts "Good guess!"
    else
        lives -= 1
        puts "Wrong! Lives left: #{lives}"
    end
end

if lives > 0
    puts "\nYou won! The word was '#{secret_word}'."
else
    puts "\nGame over. The word was '#{secret_word}'."
end
