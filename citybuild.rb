#!/usr/bin/env ruby

require 'io/console'

# Game configuration
BRICK_DELAY = 0.1  # seconds between each brick placement
FAST_MODE = false  # Set to true for instant building

# Color codes for terminal output
class Colors
    BLUE = "\033[94m"
    GREEN = "\033[92m"
    YELLOW = "\033[93m"
    RED = "\033[91m"
    PURPLE = "\033[95m"
    CYAN = "\033[96m"
    WHITE = "\033[97m"
    RESET = "\033[0m"
end

# ASCII Art Definitions with categories
ASCII_STRUCTURES = {
    residential: {
                  lake_house: [
                               "       ~ ~ ~       ",
                               "      /|  |\\      ",
                               "     /_|__|_\\     ",
                               "    |        |    ",
                               "    |  [] [] |    ",
                               "    |________|    ",
                               " ~~~~~~~~~~~~~~~~ "
                              ],
                  tree_house: [
                               "       &&&         ",
                               "     &&&&&&&       ",
                               "    &&&|_|&&&      ",
                               "       | |         ",
                               "      /   \\        ",
                               "     /_____\\       "
                              ],
                  cottage: [
                            "      /\\\\\\\\      ",
                            "     /____\\     ",
                            "    |  __  |    ",
                            "    | |  | |    ",
                            "    |_|__|_|    "
                           ],
                  apartment: [
                              "   ┌─────────┐   ",
                              "   │ ■ ■ ■ ■ │   ",
                              "   │ ■ ■ ■ ■ │   ",
                              "   │ ■ ■ ■ ■ │   ",
                              "   └─────────┘   "
                             ]
                 },
    commercial: {
                 skyscraper: [
                              "     |||||     ",
                              "     |||||     ",
                              "     |||||     ",
                              "     |||||     ",
                              "     |||||     ",
                              "    [|||||]    "
                             ],
                 office: [
                          "   ┌─────────┐   ",
                          "   │ ████████ │   ",
                          "   │ ████████ │   ",
                          "   │ ████████ │   ",
                          "   │ ████████ │   ",
                          "   └─────────┘   "
                         ],
                 shop: [
                        "   ___________   ",
                        "  |    SHOP   |  ",
                        "  |  [][][]   |  ",
                        "  |___________|  "
                       ]
                },
    landmarks: {
                golden_gate: [
                              "|     |     |",
                              "|-----|-----|",
                              "|     |     |",
                              "|-----|-----|",
                              "|     |     |",
                              "~~~~~~~~~~~~~"
                             ],
                moscow_palace: [
                                "      /\\      ",
                                "     /__\\     ",
                                "    |    |    ",
                                "   /|_||_|\\   ",
                                "  |  ||||  |  ",
                                "  |__||||__|  "
                               ],
                statue_liberty: [
                                 "     /\\     ",
                                 "    /__\\    ",
                                 "     ||     ",
                                 "     ||     ",
                                 "    /||\\    ",
                                 "   /_||_\\   "
                                ],
                christ_redeemer: [
                                  "   __|__   ",
                                  " --  |  -- ",
                                  "     |     ",
                                  "    /|\\    ",
                                  "   / | \\   ",
                                  "     |     "
                                 ],
                tokyo_tower: [
                              "     /\\     ",
                              "    /__\\    ",
                              "   //\\\\\\\\   ",
                              "  ///\\\\\\\\\\  ",
                              " |||||||||| ",
                              " |||||||||| "
                             ]
               },
    infrastructure: {
                     road: [
                            "═══════════════════"
                           ],
                     park: [
                            "   🌳  🌳  🌳   ",
                            "  🌳 🌲 🌳 🌲  ",
                            "   🌲  🌳  🌲   "
                           ],
                     fountain: [
                                "      ~~~      ",
                                "     ( o )     ",
                                "    /_____\\    ",
                                "   |_______|   "
                               ]
                    }
}

class CityBuilder
    def initialize
        @city_parts = []
        @city_stats = {
            population: 0,
            happiness: 50,
            money: 1000,
            buildings: 0
        }
        @building_costs = {
            residential: 100,
            commercial: 200,
            landmarks: 500,
            infrastructure: 50
        }
    end

    def clear_screen
        system('clear') || system('cls')
    end

    def display_header
        puts Colors::CYAN + "="*60 + Colors::RESET
        puts Colors::YELLOW + "          🏙️  ASCII CITY BUILDER  🏙️          " + Colors::RESET
        puts Colors::CYAN + "="*60 + Colors::RESET
        puts
        puts Colors::WHITE + "Money: $#{@city_stats[:money]} | " +
         "Population: #{@city_stats[:population]} | " +
         "Happiness: #{@city_stats[:happiness]}% | " +
         "Buildings: #{@city_stats[:buildings]}" + Colors::RESET
        puts
    end

    def display_menu
        puts Colors::GREEN + "Choose a category to build:" + Colors::RESET
        puts "1. 🏠 Residential (Cost: $#{@building_costs[:residential]})"
        puts "2. 🏢 Commercial (Cost: $#{@building_costs[:commercial]})"
        puts "3. 🗽 Landmarks (Cost: $#{@building_costs[:landmarks]})"
        puts "4. 🛣️  Infrastructure (Cost: $#{@building_costs[:infrastructure]})"
        puts "5. 🎯 Auto-build random city"
        puts "6. 👁️  View current city"
        puts "7. 📊 Show city stats"
        puts "8. 🚪 Exit"
        puts
        print "Enter your choice (1-8): "
    end

    def display_structures(category)
        puts Colors::BLUE + "Available #{category.to_s.capitalize} structures:" + Colors::RESET
        ASCII_STRUCTURES[category].each_with_index do |(name, _), index|
            puts "#{index + 1}. #{name.to_s.gsub('_', ' ').split.map(&:capitalize).join(' ')}"
        end
        puts "0. Back to main menu"
        puts
        print "Choose a structure: "
    end

    def build_structure(name, art, category)
        cost = @building_costs[category]

        if @city_stats[:money] < cost
            puts Colors::RED + "❌ Not enough money! Need $#{cost}, have $#{@city_stats[:money]}" + Colors::RESET
            sleep(2)
            return
        end

        @city_stats[:money] -= cost
        @city_stats[:buildings] += 1

        puts Colors::GREEN + "\n🔨 Building: #{name.to_s.gsub('_', ' ').split.map(&:capitalize).join(' ')}" + Colors::RESET
        puts Colors::YELLOW + "💰 Cost: $#{cost}" + Colors::RESET
        puts

        built = []
        art.each_with_index do |line, index|
            built << line
            print Colors::WHITE + "#{' ' * 5}#{line}" + Colors::RESET

            # Add building sound effect
            building_chars = ['🔨', '🏗️', '⚒️', '🔧']
            print " #{building_chars[index % building_chars.length]}"
            puts

            unless FAST_MODE
                sleep(BRICK_DELAY)
            end
        end

        @city_parts << built
        update_city_stats(category)

        puts Colors::GREEN + "\n✅ Construction complete!" + Colors::RESET
        puts Colors::BLUE + "💰 Remaining money: $#{@city_stats[:money]}" + Colors::RESET
        sleep(1)
    end

    def update_city_stats(category)
        case category
        when :residential
            @city_stats[:population] += rand(50..150)
            @city_stats[:happiness] += rand(1..5)
        when :commercial
            @city_stats[:money] += rand(20..50)
            @city_stats[:population] += rand(10..30)
        when :landmarks
            @city_stats[:happiness] += rand(10..25)
            @city_stats[:population] += rand(100..300)
        when :infrastructure
            @city_stats[:happiness] += rand(5..15)
        end

        # Cap happiness at 100%
        @city_stats[:happiness] = [@city_stats[:happiness], 100].min
    end

    def combine_structures(structures)
        return [] if structures.empty?

        max_height = structures.map(&:length).max
        padded = []

        structures.each do |structure|
            lines = structure.dup
            max_width = lines.map(&:length).max

            # Pad height (add empty lines at top)
            while lines.length < max_height
                lines.unshift(" " * max_width)
            end

            # Ensure all lines have same width
            lines.map! { |line| line.ljust(max_width) }
            padded << lines
        end

        final_scene = []
        (0...max_height).each do |i|
            line = padded.map { |structure| structure[i] }.join("   ")
            final_scene << line
        end

        final_scene
    end

    def display_city
        if @city_parts.empty?
            puts Colors::RED + "🏜️  Your city is empty! Build something first." + Colors::RESET
            return
        end

        puts Colors::CYAN + "\n🏙️  YOUR MAGNIFICENT CITY:" + Colors::RESET
        puts Colors::CYAN + "=" * 80 + Colors::RESET

        final_art = combine_structures(@city_parts)
        final_art.each do |line|
            puts Colors::WHITE + line + Colors::RESET
        end

        puts Colors::CYAN + "=" * 80 + Colors::RESET
        puts Colors::GREEN + "🎉 City completed with #{@city_stats[:buildings]} buildings!" + Colors::RESET
    end

    def auto_build_city
        puts Colors::YELLOW + "\n🤖 Auto-building a random city..." + Colors::RESET

        # Build 3-8 random structures
        num_buildings = rand(3..8)

        num_buildings.times do |i|
            break if @city_stats[:money] < 50

            category = ASCII_STRUCTURES.keys.sample
            structure_name = ASCII_STRUCTURES[category].keys.sample
            art = ASCII_STRUCTURES[category][structure_name]

            puts Colors::BLUE + "\n🏗️  Auto-building #{i + 1}/#{num_buildings}..." + Colors::RESET
            build_structure(structure_name, art, category)
            sleep(0.5)
        end

        puts Colors::GREEN + "\n🎊 Auto-build complete!" + Colors::RESET
    end

    def display_stats
        puts Colors::CYAN + "\n📊 CITY STATISTICS:" + Colors::RESET
        puts Colors::CYAN + "=" * 30 + Colors::RESET
        puts Colors::WHITE + "💰 Money: $#{@city_stats[:money]}" + Colors::RESET
        puts Colors::WHITE + "👥 Population: #{@city_stats[:population]}" + Colors::RESET
        puts Colors::WHITE + "😊 Happiness: #{@city_stats[:happiness]}%" + Colors::RESET
        puts Colors::WHITE + "🏗️  Buildings: #{@city_stats[:buildings]}" + Colors::RESET
        puts Colors::CYAN + "=" * 30 + Colors::RESET

        # City rating
        if @city_stats[:happiness] >= 80
            puts Colors::GREEN + "🌟 City Rating: EXCELLENT!" + Colors::RESET
        elsif @city_stats[:happiness] >= 60
            puts Colors::YELLOW + "⭐ City Rating: Good" + Colors::RESET
        elsif @city_stats[:happiness] >= 40
            puts Colors::YELLOW + "⚠️  City Rating: Average" + Colors::RESET
        else
            puts Colors::RED + "💀 City Rating: Poor" + Colors::RESET
        end
    end

    def run
        loop do
            clear_screen
            display_header
            display_menu

            choice = gets.chomp.to_i

            case choice
            when 1..4
                category = [:residential, :commercial, :landmarks, :infrastructure][choice - 1]

                clear_screen
                display_header
                display_structures(category)

                structure_choice = gets.chomp.to_i

                if structure_choice == 0
                    next
                elsif structure_choice > 0 && structure_choice <= ASCII_STRUCTURES[category].length
                    structure_name = ASCII_STRUCTURES[category].keys[structure_choice - 1]
                    art = ASCII_STRUCTURES[category][structure_name]

                    clear_screen
                    display_header
                    build_structure(structure_name, art, category)

                    puts "\nPress Enter to continue..."
                    gets
                else
                    puts Colors::RED + "❌ Invalid choice!" + Colors::RESET
                    sleep(1)
                end

            when 5
                clear_screen
                display_header
                auto_build_city
                puts "\nPress Enter to continue..."
                gets

            when 6
                clear_screen
                display_header
                display_city
                puts "\nPress Enter to continue..."
                gets

            when 7
                clear_screen
                display_header
                display_stats
                puts "\nPress Enter to continue..."
                gets

            when 8
                puts Colors::GREEN + "\n👋 Thanks for playing ASCII City Builder!" + Colors::RESET
                puts Colors::YELLOW + "🏙️  Final city stats:" + Colors::RESET
                display_stats
                display_city if @city_stats[:buildings] > 0
                break

            else
                puts Colors::RED + "❌ Invalid choice! Please enter 1-8." + Colors::RESET
                sleep(1)
            end
        end
    end
end

# Run the game
if __FILE__ == $0
    puts Colors::CYAN + "\n🎮 Welcome to ASCII City Builder!" + Colors::RESET
    puts Colors::WHITE + "Build your dream city one structure at a time!" + Colors::RESET
    puts "\nPress Enter to start..."
    gets

    game = CityBuilder.new
    game.run
end
