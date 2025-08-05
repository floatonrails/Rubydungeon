# moodify_cli.rb

MOOD_PLAYLISTS = {
    "happy" => [
                "Happy – Pharrell Williams",
                "Walking on Sunshine – Katrina & The Waves",
                "Good as Hell – Lizzo",
                "Can’t Stop the Feeling! – Justin Timberlake",
                "Uptown Funk – Bruno Mars",
                "Sugar – Maroon 5",
                "Best Day of My Life – American Authors",
                "I Wanna Dance with Somebody – Whitney Houston",
                "Valerie – Mark Ronson ft. Amy Winehouse",
                "September – Earth, Wind & Fire",
                "Shut Up and Dance – WALK THE MOON",
                "On Top of the World – Imagine Dragons",
                "I'm Still Standing – Elton John",
                "I Gotta Feeling – The Black Eyed Peas",
                "Don’t Stop Me Now – Queen",
                "Send Me On My Way – Rusted Root",
                "Dynamite – Taio Cruz",
                "Treasure – Bruno Mars",
                "Firework – Katy Perry",
                "Freedom! – George Michael",
                "Good Vibes – Chris Janson"
               ],

    "sad" => [
              "Someone Like You – Adele",
              "Fix You – Coldplay",
              "Skinny Love – Bon Iver",
              "Creep – Radiohead",
              "The Night We Met – Lord Huron",
              "Hurt – Johnny Cash",
              "Tears Dry on Their Own – Amy Winehouse",
              "All I Want – Kodaline",
              "Let Her Go – Passenger",
              "Back to Black – Amy Winehouse",
              "Liability – Lorde",
              "Fast Car – Tracy Chapman",
              "Youth – Daughter",
              "I Will Always Love You – Whitney Houston",
              "The A Team – Ed Sheeran",
              "Everybody Hurts – R.E.M.",
              "Half a Man – Dean Lewis",
              "When the Party's Over – Billie Eilish",
              "Say Something – A Great Big World",
              "Jealous – Labrinth",
              "Un-break My Heart – Toni Braxton"
             ],

    "angry" => [
                "Break Stuff – Limp Bizkit",
                "Killing in the Name – Rage Against the Machine",
                "Duality – Slipknot",
                "Bodies – Drowning Pool",
                "Given Up – Linkin Park",
                "Papercut – Linkin Park",
                "Headstrong – Trapt",
                "Smells Like Teen Spirit – Nirvana",
                "Before I Forget – Slipknot",
                "Down With the Sickness – Disturbed",
                "One Step Closer – Linkin Park",
                "Chop Suey! – System of a Down",
                "Faint – Linkin Park",
                "Monster – Skillet",
                "You're Going Down – Sick Puppies",
                "Indestructible – Disturbed",
                "Bleed It Out – Linkin Park",
                "Coming Undone – Korn",
                "I Hate Everything About You – Three Days Grace",
                "Bat Country – Avenged Sevenfold",
                "War – Sick Puppies"
               ],

    "calm" => [
               "Weightless – Marconi Union",
               "Clair de Lune – Debussy",
               "Bloom – The Paper Kites",
               "Intro – The xx",
               "Sunset Lover – Petit Biscuit",
               "Holocene – Bon Iver",
               "Night Owl – Galimatias",
               "River Flows in You – Yiruma",
               "Experience – Ludovico Einaudi",
               "Banana Pancakes – Jack Johnson",
               "Coffee – Beabadoobee",
               "Ocean Eyes – Billie Eilish",
               "Flightless Bird, American Mouth – Iron & Wine",
               "The Ocean – Mike Perry ft. Shy Martin",
               "Slow Dancing in a Burning Room – John Mayer",
               "I’m Yours – Jason Mraz",
               "Let It Go – James Bay",
               "Breathe – Télépopmusik",
               "Lovely – Billie Eilish & Khalid",
               "Somewhere Only We Know – Keane",
               "Heartbeats – José González"
              ],

    "anxious" => [
                  "Breathe Me – Sia",
                  "Nude – Radiohead",
                  "River Flows in You – Yiruma",
                  "Experience – Ludovico Einaudi",
                  "Don’t Panic – Coldplay",
                  "Holocene – Bon Iver",
                  "Intro – The xx",
                  "Motion Picture Soundtrack – Radiohead",
                  "Oblivion – Bastille",
                  "Spirits – The Strumbellas",
                  "Saturn – Sleeping At Last",
                  "Space Song – Beach House",
                  "Retrograde – James Blake",
                  "Skinny Love – Bon Iver",
                  "All We Do – Oh Wonder",
                  "Everything In Its Right Place – Radiohead",
                  "The Blower’s Daughter – Damien Rice",
                  "Night Changes – One Direction",
                  "Lost – Dermot Kennedy",
                  "All I Want – Kodaline",
                  "As It Was – Harry Styles"
                 ]
}.freeze

# Show all available moods
def list_moods
    puts "Available Moods:"
    MOOD_PLAYLISTS.each_key.with_index(1) do |mood, i|
        puts "#{i}. #{mood.capitalize}"
    end
end

# Display the playlist in a neat format
def show_playlist(mood)
    songs = MOOD_PLAYLISTS[mood]
    puts "\n🎵 Playlist for: #{mood.capitalize}"
    puts "-" * 50
    songs.each_with_index do |song, index|
        puts "%2d. %s" % [index + 1, song]
    end
    puts "-" * 50
end

# Moodify App Loop
puts "Moodify CLI – Your Mood, Your Music"
list_moods

print "\n🗣️ How are you feeling today? > "
chosen_mood = gets.chomp.downcase

if MOOD_PLAYLISTS.key?(chosen_mood)
    show_playlist(chosen_mood)
else
    puts "Sorry, no playlist for that mood yet."
end
