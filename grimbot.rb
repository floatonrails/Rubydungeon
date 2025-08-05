#!/usr/bin/env ruby

require 'io/console'

class GrimPrompt
    # Terminal colors for atmospheric effect
    COLORS = {
        red: "\033[31m",
        green: "\033[32m",
        yellow: "\033[33m",
        blue: "\033[34m",
        magenta: "\033[35m",
        cyan: "\033[36m",
        white: "\033[37m",
        gray: "\033[90m",
        reset: "\033[0m",
        bold: "\033[1m",
        dim: "\033[2m"
    }

    # Different categories of wisdom
    WISDOMS = {
        programming: [
                      "Not all who wander are lost, but some should check their routes.",
                      "A loop that never ends is a prison of your own making.",
                      "Even in darkness, a well-indented block brings light.",
                      "The compiler is never wrong, only misunderstood.",
                      "To recurse without end is to speak in echoes until madness comes.",
                      "Do not fear the unknown function; trace its parameters.",
                      "He who commits without reading commits regret.",
                      "A wizard reads logs before conjuring panic.",
                      "Silence is golden, but stderr speaks truth.",
                      "What you name, you control. Choose with care.",
                      "There is no magic in copy-paste, only delayed bugs.",
                      "The shell is but a mirror to your clarity of thought.",
                      "In every branch, a destiny split.",
                      "Strong types guard weak minds.",
                      "To delete is to forget, to version is to remember.",
                      "Ask not what your framework does, but what it hides.",
                      "One does not simply push to production.",
                      "The wise test before they trust.",
                      "Every abstraction is a trade. Know what you pay.",
                      "The path to mastery is piped through error."
                     ],
        debug: [
                "The bug you seek is often the bug you wrote.",
                "In the depths of stack traces, truth lies buried.",
                "A null pointer exception is the universe saying 'not today'.",
                "Printf debugging is the torch in the cavern of code.",
                "The rubber duck knows more than it speaks.",
                "Every error message is a riddle wrapped in frustration.",
                "The crash that teaches is worth a thousand successful runs.",
                "Memory leaks are the ghosts of objects past.",
                "Race conditions appear only when you're not watching.",
                "The heisenbug observes you observing it."
               ],
        philosophy: [
                     "Code is poetry written in a language machines understand.",
                     "The best code is code unwritten, the second best is code deleted.",
                     "Premature optimization is the root of all evil, but so is premature abstraction.",
                     "A program is never finished, only abandoned to time.",
                     "The user's path is paved with edge cases.",
                     "Documentation is a love letter to your future self.",
                     "In the beginning was the Word, and the Word was 'Hello, World!'",
                     "Every programmer is an architect of digital dreams.",
                     "The cloud is just someone else's computer in the mist.",
                     "To understand recursion, you must first understand recursion."
                    ],
        career: [
                 "The junior asks 'how?', the senior asks 'why?', the architect asks 'what if we didn't?'",
                 "Meeting-heavy days are code-light days.",
                 "The best solution is often the simplest one that works.",
                 "Legacy code is not your enemy, it is your teacher.",
                 "A deadline approaches like a storm - prepare or be swept away.",
                 "The rubber meets the road when the customer meets the bug.",
                 "Code reviews are mirrors that reflect our blind spots.",
                 "The shortest path to production is through testing.",
                 "Technical debt compounds like any other debt.",
                 "Today's hotfix is tomorrow's architectural decision."
                ]
    }

    FORTUNES = [
        "The stars align for a successful deploy... but check your tests first.",
        "A great refactoring approaches from the east.",
        "Beware the pull request that changes everything and nothing.",
        "The database whispers secrets to those who listen to its logs.",
        "Your code shall be read by many, but understood by few.",
        "A stack overflow awaits the unwary traveler.",
        "The production server dreams of electric sheep and backup strategies.",
        "In seven days, you will remember why you wrote that comment.",
        "The bug you ignore today will multiply tomorrow.",
        "A mentor appears when the student is ready to ask better questions."
    ]

    SPELLS = [
        "git reset --hard HEAD~1",
        "rm -rf node_modules && npm install",
        "sudo systemctl restart everything",
        "docker system prune -a",
        "kill -9 $(ps aux | grep -i zombie)",
        "find . -name '*.log' -delete",
        "curl -s http://iscodegreen.com/",
        "echo 'It works on my machine' > /dev/null"
    ]

    ASCII_ART = [
        "    ⚡ ⚡ ⚡",
        "   ╔═════╗",
        "   ║ ⚰️ ⚰️ ║",
        "   ║  👁️  ║",
        "   ╚═════╝",
        "    ⚡ ⚡ ⚡"
    ]

    def self.typewriter_effect(text, delay = 0.03)
        text.each_char do |char|
            print char
            sleep delay
        end
    end

    def self.clear_screen
        system('clear') || system('cls')
    end

    def self.display_header
        puts COLORS[:magenta] + COLORS[:bold]
        puts "╔══════════════════════════════════════════════════════════════════════════════╗"
        puts "║                            THE GRIM BOT                                  ║"
        puts "║                        Oracle of Coding & Wisdom                             ║"
        puts "╚══════════════════════════════════════════════════════════════════════════════╝"
        puts COLORS[:reset]
    end

    def self.display_menu
        puts COLORS[:cyan] + "Choose your path, mortal:" + COLORS[:reset]
        puts COLORS[:gray] + "  summon      - Receive ancient programming wisdom" + COLORS[:reset]
        puts COLORS[:gray] + "  debug       - Seek guidance for your debugging woes" + COLORS[:reset]
        puts COLORS[:gray] + "  philosophy  - Contemplate the deeper meaning of code" + COLORS[:reset]
        puts COLORS[:gray] + "  career      - Gain insight into the programmer's journey" + COLORS[:reset]
        puts COLORS[:gray] + "  fortune     - Consult the digital oracle" + COLORS[:reset]
        puts COLORS[:gray] + "  spell       - Learn a mystical incantation" + COLORS[:reset]
        puts COLORS[:gray] + "  ritual      - Perform the ancient debugging ritual" + COLORS[:reset]
        puts COLORS[:gray] + "  clear       - Clear the mists of confusion" + COLORS[:reset]
        puts COLORS[:gray] + "  help        - Show this grimoire" + COLORS[:reset]
        puts COLORS[:gray] + "  exit        - Return to the material realm" + COLORS[:reset]
        puts
    end

    def self.summon(category = :programming)
        animate_summoning
        wisdom = WISDOMS[category].sample

        puts COLORS[:yellow] + COLORS[:bold] + "\n[The Oracle speaks...]\n" + COLORS[:reset]
        sleep 0.5

        puts COLORS[:white] + " \"" + COLORS[:reset]
        typewriter_effect(wisdom)
        puts COLORS[:white] + "\"\n" + COLORS[:reset]

        puts COLORS[:dim] + COLORS[:magenta] + "[The wisdom echoes in the void...]\n" + COLORS[:reset]
        sleep 0.5
    end

    def self.animate_summoning
        puts COLORS[:red] + "\n[GrimPrompt awakens...]\n" + COLORS[:reset]

        # Animated ASCII art
        3.times do |i|
            print "\r" + " " * 20
            print "\r"

            case i % 3
            when 0
                print COLORS[:red] + "    ⚡ ⚡ ⚡" + COLORS[:reset]
            when 1
                print COLORS[:yellow] + "   ╔═════╗" + COLORS[:reset]
            when 2
                print COLORS[:magenta] + "   ║ 👁️  ║" + COLORS[:reset]
            end

            sleep 0.3
        end

        puts "\n"
        ASCII_ART.each do |line|
            puts COLORS[:magenta] + line + COLORS[:reset]
            sleep 0.1
        end
    end

    def self.cast_fortune
        puts COLORS[:cyan] + "\n[The digital oracle stirs...]\n" + COLORS[:reset]
        sleep 0.5

        fortune = FORTUNES.sample
        puts COLORS[:yellow] + "🔮 " + COLORS[:white] + fortune + COLORS[:reset]

        puts COLORS[:dim] + COLORS[:cyan] + "\n[The vision fades...]\n" + COLORS[:reset]
    end

    def self.cast_spell
        puts COLORS[:green] + "\n[Ancient incantations flow through the terminal...]\n" + COLORS[:reset]
        sleep 0.5

        spell = SPELLS.sample
        puts COLORS[:bold] + "Mystical Command: " + COLORS[:reset]
        puts COLORS[:yellow] + "   " + spell + COLORS[:reset]

        puts COLORS[:dim] + COLORS[:green] + "\n[The spell is cast... use wisely]\n" + COLORS[:reset]
    end

    def self.perform_ritual
        puts COLORS[:red] + "\n[Initiating the Ancient Debugging Ritual...]\n" + COLORS[:reset]

        ritual_steps = [
            "Light the candles of print debugging",
            "Recite the sacred stack overflow",
            "Examine the entry of your log files",
            "Meditate on the last working commit",
            "Run the tests of code",
            "Pray to the God of CD/CI"
        ]

        ritual_steps.each do |step|
            puts COLORS[:yellow] + step + COLORS[:reset]
            sleep 0.8
        end

        puts COLORS[:green] + "\nThe ritual is complete! Your bugs and terminal tremble in fear.\n" + COLORS[:reset]
    end

    def self.show_prompt
        print COLORS[:dim] + COLORS[:magenta] + "grimPrompt" + COLORS[:reset] +
              COLORS[:white] + " > " + COLORS[:reset]
    end

    def self.process_command(input)
        command = input.strip.downcase

        case command
        when 'summon', 's'
            summon
        when 'debug', 'd'
            summon(:debug)
        when 'philosophy', 'p'
            summon(:philosophy)
        when 'career', 'c'
            summon(:career)
        when 'fortune', 'f'
            cast_fortune
        when 'spell', 'sp'
            cast_spell
        when 'ritual', 'r'
            perform_ritual
        when 'clear', 'cls'
            clear_screen
            display_header
        when 'help', 'h', '?'
            display_menu
        when 'exit', 'quit', 'q'
            puts COLORS[:cyan] + "\n[The mists part...]\n" + COLORS[:reset]
            sleep 0.5
            typewriter_effect("Farewell, traveler. May your code compile and your tests pass.")
            puts COLORS[:dim] + COLORS[:magenta] + "\n\n[GrimPrompt returns to the void...]\n" + COLORS[:reset]
            return false
        when ''
            # Do nothing for empty input
        else
            responses = [
                "The winds do not understand that phrase.",
                "Your words dissolve in the digital ether.",
                "The Oracle remains silent to such mysteries.",
                "That command is lost in the void between keystrokes.",
                "The ancient terminal spirits do not recognize this incantation."
            ]
            puts COLORS[:red] + responses.sample + COLORS[:reset]
            puts COLORS[:dim] + "Type 'help' to consult the grimoire." + COLORS[:reset]
        end

        true
    end

    def self.run
        clear_screen
        display_header

        puts COLORS[:cyan] + "\nWelcome, weary developer, to the realm of the Grim Prompt." + COLORS[:reset]
        puts COLORS[:white] + "Here, ancient wisdom meets modern code." + COLORS[:reset]
        puts COLORS[:dim] + "\nType 'help' to see available commands, or 'summon' to begin.\n" + COLORS[:reset]

        loop do
            show_prompt
            input = gets

            # Handle Ctrl+C gracefully
            if input.nil?
                puts COLORS[:red] + "\n\n[Interrupted by cosmic forces...]\n" + COLORS[:reset]
                break
            end

            break unless process_command(input)
        end
    end
end

# Enhanced main program with error handling
if __FILE__ == $0
    begin
        Signal.trap("INT") do
            puts COLORS[:red] + "\n\n[The ritual is interrupted...]\n" + COLORS[:reset]
            exit 0
        end

        GrimPrompt.run
    rescue StandardError => e
        puts COLORS[:red] + "\n[A disturbance in the code...]\n" + COLORS[:reset]
        puts COLORS[:yellow] + "Error: #{e.message}" + COLORS[:reset]
        puts COLORS[:dim] + "The Oracle suggests checking your Ruby installation." + COLORS[:reset]
    end
end
