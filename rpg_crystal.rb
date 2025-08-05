#!/usr/bin/env ruby
# encoding: UTF-8

# RPG de Texto - A Lenda do Cristal Perdido

require 'io/console'

class RPGGame
  def initialize
    @player = {
      name: "",
      health: 100,
      max_health: 100,
      mana: 50,
      max_mana: 50,
      level: 1,
      experience: 0,
      gold: 100,
      inventory: ["Poção de Vida", "Adaga Enferrujada"],
      equipped_weapon: "Adaga Enferrujada"
    }

    @current_chapter = 1
    @story_flags = {}

    # Cores para os personagens
    @colors = {
      player: "\e[1;36m",      # Ciano brilhante
      narrator: "\e[0;37m",    # Branco
      sage: "\e[1;35m",        # Magenta brilhante
      guard: "\e[1;33m",       # Amarelo brilhante
      enemy: "\e[1;31m",       # Vermelho brilhante
      npc: "\e[1;32m",         # Verde brilhante
      system: "\e[1;34m",      # Azul brilhante
      reset: "\e[0m"           # Reset
    }
  end

  def colorize(text, color)
    "#{@colors[color]}#{text}#{@colors[:reset]}"
  end

  def display_title
    puts "\n" + "=" * 60
    puts colorize("    ✦ A LENDA DO CRISTAL PERDIDO ✦", :system)
    puts colorize("       Um RPG de Texto Épico", :narrator)
    puts "=" * 60
    puts
  end

  def display_status
    puts colorize("━" * 50, :system)
    puts colorize("#{@player[:name]} - Nível #{@player[:level]}", :player)
    puts colorize("Vida: #{@player[:health]}/#{@player[:max_health]} | " +
                  "Mana: #{@player[:mana]}/#{@player[:max_mana]} | " +
                  "Ouro: #{@player[:gold]}", :system)
    puts colorize("Arma: #{@player[:equipped_weapon]}", :system)
    puts colorize("━" * 50, :system)
    puts
  end

  def narrate(text)
    puts colorize(text, :narrator)
    puts
  end

  def character_speak(character, text, color = :npc)
    puts colorize("#{character}: \"#{text}\"", color)
    puts
  end

  def wait_for_input
    print colorize("Pressione ENTER para continuar...", :system)
    gets.chomp
    puts
  end

  def get_player_choice(options)
    puts colorize("Escolha sua ação:", :system)
    options.each_with_index do |option, index|
      puts colorize("#{index + 1}. #{option}", :player)
    end

    loop do
      print colorize("Sua escolha (1-#{options.length}): ", :system)
      choice = gets.chomp.to_i

      if choice >= 1 && choice <= options.length
        return choice - 1
      else
        puts colorize("Escolha inválida! Tente novamente.", :enemy)
      end
    end
  end

  def combat(enemy_name, enemy_health, enemy_damage, experience_reward = 25)
    puts colorize("⚔️  COMBATE INICIADO!", :enemy)
    puts colorize("Você enfrenta: #{enemy_name}", :enemy)
    puts

    enemy_max_health = enemy_health

    while enemy_health > 0 && @player[:health] > 0
      puts colorize("#{enemy_name}: #{enemy_health}/#{enemy_max_health}", :enemy)
      puts colorize("#{@player[:name]}: #{@player[:health]}/#{@player[:max_health]}", :player)
      puts

      options = ["Atacar", "Usar Poção de Vida", "Tentar Fugir"]
      choice = get_player_choice(options)

      case choice
      when 0 # Atacar
        damage = rand(15..25)
        enemy_health -= damage
        puts colorize("Você ataca #{enemy_name} causando #{damage} de dano!", :player)

        if enemy_health <= 0
          puts colorize("#{enemy_name} foi derrotado!", :system)
          @player[:experience] += experience_reward
          gold_reward = rand(20..50)
          @player[:gold] += gold_reward
          puts colorize("Você ganhou #{experience_reward} XP e #{gold_reward} moedas de ouro!", :system)
          check_level_up
          return true
        end

      when 1 # Usar Poção
        if @player[:inventory].include?("Poção de Vida")
          heal_amount = rand(30..50)
          @player[:health] = [@player[:health] + heal_amount, @player[:max_health]].min
          @player[:inventory].delete_at(@player[:inventory].index("Poção de Vida"))
          puts colorize("Você usa uma Poção de Vida e recupera #{heal_amount} de vida!", :system)
        else
          puts colorize("Você não tem Poções de Vida!", :enemy)
          next
        end

      when 2 # Fugir
        if rand(1..3) == 1
          puts colorize("Você conseguiu fugir!", :system)
          return false
        else
          puts colorize("Não conseguiu fugir!", :enemy)
        end
      end

      # Ataque do inimigo
      if enemy_health > 0
        enemy_attack = rand(enemy_damage - 5..enemy_damage + 5)
        @player[:health] -= enemy_attack
        puts colorize("#{enemy_name} te ataca causando #{enemy_attack} de dano!", :enemy)

        if @player[:health] <= 0
          puts colorize("Você foi derrotado...", :enemy)
          puts colorize("GAME OVER", :enemy)
          return false
        end
      end

      puts
    end
  end

  def check_level_up
    exp_needed = @player[:level] * 100
    if @player[:experience] >= exp_needed
      @player[:level] += 1
      @player[:experience] -= exp_needed
      @player[:max_health] += 20
      @player[:health] = @player[:max_health]
      @player[:max_mana] += 10
      @player[:mana] = @player[:max_mana]
      puts colorize("✨ LEVEL UP! ✨", :system)
      puts colorize("Você subiu para o nível #{@player[:level]}!", :system)
      puts colorize("Vida e Mana totalmente restauradas!", :system)
    end
  end

  def chapter_1
    display_title

    puts colorize("CAPÍTULO 1: O CHAMADO DO DESTINO", :system)
    puts

    narrate("Em uma pequena vila nas montanhas, você vivia uma vida simples como aprendiz de ferreiro.")
    narrate("Até que um dia, um estranho encapuzado chegou trazendo notícias terríveis...")

    wait_for_input

    character_speak("Estranho Encapuzado", "Jovem, preciso de sua ajuda! O Cristal Sagrado de Lumina foi roubado!", :sage)
    character_speak("Estranho Encapuzado", "Sem ele, o reino mergulhará em trevas eternas dentro de sete luas!", :sage)

    print colorize("Qual é o seu nome, jovem herói? ", :system)
    @player[:name] = gets.chomp

    puts
    character_speak("Sábio Aldric", "#{@player[:name]}, você foi escolhido pela profecia antiga!", :sage)
    character_speak("Sábio Aldric", "Apenas alguém de coração puro pode recuperar o Cristal Perdido.", :sage)

    options = [
      "Aceitar a missão heroicamente",
      "Perguntar sobre a recompensa",
      "Tentar recusar educadamente"
    ]

    choice = get_player_choice(options)

    case choice
    when 0
      character_speak(@player[:name], "Aceito a missão! Não posso deixar o reino em perigo!", :player)
      character_speak("Sábio Aldric", "Que coragem admirável! Que os deuses te protejam!", :sage)
      @story_flags[:heroic_choice] = true

    when 1
      character_speak(@player[:name], "E... qual seria a recompensa por essa missão?", :player)
      character_speak("Sábio Aldric", "Ah, pragmático! 1000 moedas de ouro e um item mágico lendário!", :sage)
      @player[:gold] += 50
      puts colorize("Sábio Aldric te dá 50 moedas de ouro como adiantamento!", :system)

    when 2
      character_speak(@player[:name], "Eu... não sei se sou a pessoa certa para isso...", :player)
      character_speak("Sábio Aldric", "A humildade é uma virtude, mas o destino já foi traçado!", :sage)
      @story_flags[:humble_choice] = true
    end

    puts
    narrate("Sábio Aldric te entrega um mapa antigo e uma adaga élfica.")

    @player[:inventory] << "Mapa do Reino"
    @player[:inventory] << "Adaga Élfica"
    @player[:equipped_weapon] = "Adaga Élfica"

    puts colorize("Itens adicionados ao inventário!", :system)
    puts

    narrate("Sua jornada épica está apenas começando...")

    wait_for_input
    @current_chapter = 2
  end

  def chapter_2
    puts colorize("CAPÍTULO 2: A FLORESTA SOMBRIA", :system)
    puts

    display_status

    narrate("Seguindo o mapa, você chega à entrada da temida Floresta Sombria.")
    narrate("Árvores antigas sussurram segredos antigos enquanto sombras dançam entre os troncos.")

    wait_for_input

    narrate("Subitamente, você escuta um grito de socorro vindo das profundezas da floresta!")

    options = [
      "Correr em direção ao grito",
      "Aproximar-se cautelosamente",
      "Ignorar e seguir pelo caminho principal"
    ]

    choice = get_player_choice(options)

    case choice
    when 0
      narrate("Você corre desesperadamente em direção ao som!")
      narrate("Tropeça em uma raiz e cai em uma armadilha!")

      if combat("Lobo Sombrio", 60, 15, 30)
        narrate("Após derrotar o lobo, você encontra uma elfa ferida.")
        character_speak("Elfa Lyralei", "Obrigada, corajoso aventureiro! Sou Lyralei, guardiã da floresta.", :npc)
        character_speak("Elfa Lyralei", "Tome esta poção mágica como recompensa por sua bravura!", :npc)
        @player[:inventory] << "Poção Mágica de Mana"
        @story_flags[:saved_elf] = true
      end

    when 1
      narrate("Você se aproxima silenciosamente...")
      narrate("Descobre que é uma armadilha de bandidos!")

      options_2 = ["Atacar de surpresa", "Tentar negociar", "Recuar silenciosamente"]
      choice_2 = get_player_choice(options_2)

      case choice_2
      when 0
        narrate("Você ataca de surpresa!")
        if combat("Bandido", 40, 12, 25)
          narrate("Você encontra um baú escondido com tesouros!")
          @player[:gold] += 75
          puts colorize("Você encontrou 75 moedas de ouro!", :system)
        end
      when 1
        character_speak(@player[:name], "Ei! Não queremos problemas aqui!", :player)
        character_speak("Bandido", "Então entregue suas moedas e ninguém se machuca!", :enemy)
        narrate("Você perde 30 moedas de ouro, mas evita o combate.")
        @player[:gold] -= 30
      when 2
        narrate("Você consegue recuar sem ser notado.")
        narrate("Ganha experiência por sua astúcia!")
        @player[:experience] += 15
      end

    when 2
      narrate("Você decide seguir pelo caminho principal.")
      narrate("Encontra um mercador misterioso...")

      character_speak("Mercador Sombrio", "Psiu... jovem aventureiro! Tenho itens especiais para vender!", :npc)

      options_2 = ["Comprar Espada de Aço (100 moedas)", "Comprar Poção de Vida (25 moedas)", "Recusar e continuar"]
      choice_2 = get_player_choice(options_2)

      case choice_2
      when 0
        if @player[:gold] >= 100
          @player[:gold] -= 100
          @player[:inventory] << "Espada de Aço"
          @player[:equipped_weapon] = "Espada de Aço"
          puts colorize("Você comprou uma Espada de Aço!", :system)
        else
          puts colorize("Você não tem ouro suficiente!", :enemy)
        end
      when 1
        if @player[:gold] >= 25
          @player[:gold] -= 25
          @player[:inventory] << "Poção de Vida"
          puts colorize("Você comprou uma Poção de Vida!", :system)
        else
          puts colorize("Você não tem ouro suficiente!", :enemy)
        end
      when 2
        narrate("Você decide não confiar no mercador suspeito.")
      end
    end

    puts
    narrate("Após várias horas caminhando, você finalmente sai da Floresta Sombria.")
    narrate("À distância, você vê as torres da Cidade de Pedra, seu próximo destino.")

    wait_for_input
    @current_chapter = 3
  end

  def chapter_3
    puts colorize("CAPÍTULO 3: A CIDADE DE PEDRA", :system)
    puts

    display_status

    narrate("Você chega às imponentes muralhas da Cidade de Pedra.")
    narrate("Guardas armados patrulham as entradas, verificando todos os visitantes.")

    wait_for_input

    character_speak("Capitão da Guarda", "Alto aí, forasteiro! Declare seus negócios na cidade!", :guard)

    options = [
      "Explicar sobre a missão do Cristal Perdido",
      "Mentir sobre ser um mercador",
      "Mostrar as moedas de ouro como suborno"
    ]

    choice = get_player_choice(options)

    case choice
    when 0
      character_speak(@player[:name], "Estou em uma missão sagrada para recuperar o Cristal Perdido!", :player)
      character_speak("Capitão da Guarda", "O Cristal Perdido?! Então você é o herói profetizado!", :guard)
      character_speak("Capitão da Guarda", "Entre, nobre aventureiro! O Prefeito quer falar com você!", :guard)
      @story_flags[:honest_with_guards] = true

    when 1
      character_speak(@player[:name], "Sou apenas um mercador humilde em busca de negócios.", :player)
      character_speak("Capitão da Guarda", "Hmm... está bem. Mas nada de confusão na cidade!", :guard)
      narrate("Você entra na cidade, mas os guardas ficam desconfiados.")

    when 2
      if @player[:gold] >= 50
        character_speak(@player[:name], "Talvez estas moedas possam acelerar o processo...", :player)
        character_speak("Capitão da Guarda", "Bem... dessa vez vou fazer vista grossa.", :guard)
        @player[:gold] -= 50
        puts colorize("Você perdeu 50 moedas de ouro!", :system)
      else
        character_speak("Capitão da Guarda", "Sem ouro suficiente para subornar? Que patético!", :guard)
        narrate("Você é forçado a explicar sua missão.")
      end
    end

    puts
    narrate("Dentro da cidade, você vê ruas movimentadas cheias de mercadores, artesãos e aventureiros.")
    narrate("Uma taverna chamada 'O Javali Dourado' chama sua atenção.")

    wait_for_input

    narrate("Dentro da taverna, você escuta rumores sobre uma masmorra antiga...")

    character_speak("Taberneiro", "Ei, aventureiro! Ouvi dizer que procura o Cristal Perdido!", :npc)
    character_speak("Taberneiro", "Há rumores de que foi levado para as Masmorras do Desespero!", :npc)
    character_speak("Taberneiro", "Mas cuidado... ninguém que entrou lá voltou para contar a história!", :npc)

    options = [
      "Perguntar sobre as Masmorras do Desespero",
      "Pedir informações sobre equipamentos",
      "Descansar no quarto da taverna (20 moedas)"
    ]

    choice = get_player_choice(options)

    case choice
    when 0
      character_speak("Taberneiro", "Fica três dias de viagem ao norte. Cheia de mortos-vivos e demônios!", :npc)
      character_speak("Taberneiro", "Dizem que no fundo dela está o Senhor das Trevas em pessoa!", :npc)
      @story_flags[:knows_about_dungeon] = true

    when 1
      character_speak("Taberneiro", "Há um ferreiro excelente aqui na cidade. Procure por Thorin Martelada!", :npc)
      character_speak("Taberneiro", "Ele pode forjar armas poderosas... por um preço justo!", :npc)

    when 2
      if @player[:gold] >= 20
        @player[:gold] -= 20
        @player[:health] = @player[:max_health]
        @player[:mana] = @player[:max_mana]
        puts colorize("Você descansou e recuperou toda vida e mana!", :system)
        narrate("Durante a noite, você tem sonhos proféticos sobre o Cristal...")
      else
        puts colorize("Você não tem ouro suficiente para um quarto!", :enemy)
      end
    end

    puts
    narrate("Após reunir informações, você se prepara para a jornada final.")
    narrate("As Masmorras do Desespero aguardam... e com elas, seu destino!")

    wait_for_input
    @current_chapter = 4
  end

  def chapter_4
    puts colorize("CAPÍTULO 4: AS MASMORRAS DO DESESPERO", :system)
    puts

    display_status

    narrate("Após três dias de viagem árdua, você finalmente chega às Masmorras do Desespero.")
    narrate("Uma entrada sombria se abre na rocha, exalando um ar frio e malévolo.")
    narrate("Runas antigas brilham fracamente nas paredes de pedra.")

    wait_for_input

    narrate("Você desce as escadas de pedra. Cada passo ecoa sinistro pelas profundezas.")
    narrate("Subitamente, esqueletos emergem das sombras!")

    if combat("Esqueleto Guerreiro", 70, 18, 35)
      narrate("Você derrota o esqueleto e encontra uma chave misteriosa.")
      @player[:inventory] << "Chave Ancestral"
      puts colorize("Chave Ancestral adicionada ao inventário!", :system)
    else
      narrate("Você consegue fugir, mas está ferido e cansado.")
      return
    end

    puts
    narrate("Mais profundamente na masmorra, você encontra uma porta trancada.")
    narrate("A Chave Ancestral brilha em sua mão...")

    wait_for_input

    narrate("A porta se abre revelando uma câmara imensa.")
    narrate("No centro, o Cristal Perdido flutua em um pedestal de mármore negro.")
    narrate("Mas guardando-o está uma figura encapuzada em armadura sombria...")

    character_speak("Senhor das Trevas", "Então... o 'herói' finalmente chegou.", :enemy)
    character_speak("Senhor das Trevas", "Você realmente acha que pode me derrotar, mortal patético?", :enemy)

    options = [
      "Desafiá-lo para combate",
      "Tentar negociar",
      "Usar magia (se tiver mana suficiente)"
    ]

    choice = get_player_choice(options)

    case choice
    when 0
      character_speak(@player[:name], "Eu não temerei você! Pelo reino de Lumina!", :player)

    when 1
      character_speak(@player[:name], "Espere! Podemos chegar a um acordo!", :player)
      character_speak("Senhor das Trevas", "Há apenas uma coisa que quero... sua alma!", :enemy)

    when 2
      if @player[:mana] >= 30
        character_speak(@player[:name], "Pelo poder da luz, eu te banirei!", :player)
        narrate("Você canaliza sua mana em um ataque mágico!")
        @player[:mana] -= 30
        puts colorize("Você causa 40 de dano mágico!", :system)
      else
        puts colorize("Você não tem mana suficiente!", :enemy)
      end
    end

    puts
    narrate("A batalha final está prestes a começar...")

    # Boss Fight
    if combat("Senhor das Trevas", 150, 25, 100)
      puts colorize("VITÓRIA ÉPICA!", :system)
      puts
      narrate("O Senhor das Trevas é derrotado! Sua armadura se desfaz em fumaça.")
      narrate("O Cristal Perdido brilha intensamente e flutua em sua direção.")

      @player[:inventory] << "Cristal Perdido"
      @player[:gold] += 1000
      puts colorize("Você obteve o Cristal Perdido e 1000 moedas de ouro!", :system)

      wait_for_input

      narrate("Com o Cristal em suas mãos, você sente um poder incrível.")
      narrate("A luz volta a brilhar pelo reino de Lumina!")

      chapter_epilogue
    else
      puts colorize("DERROTA...", :enemy)
      puts
      narrate("O Senhor das Trevas ri enquanto as trevas consomem o reino...")
      narrate("Mas talvez outro herói surja para continuar sua missão...")
    end
  end

  def chapter_epilogue
    puts colorize("EPÍLOGO: O RETORNO DO HERÓI", :system)
    puts

    display_status

    narrate("Você retorna triunfante à vila onde tudo começou.")
    narrate("O Sábio Aldric te espera com um sorriso orgulhoso.")

    character_speak("Sábio Aldric", "#{@player[:name]}! Você conseguiu! O reino está salvo!", :sage)
    character_speak("Sábio Aldric", "Sua bravura será lembrada por gerações!", :sage)

    if @story_flags[:saved_elf]
      narrate("Lyralei, a elfa que você salvou, aparece para agradecer.")
      character_speak("Elfa Lyralei", "Obrigada novamente, herói! A floresta estará sempre aberta para você!", :npc)
    end

    if @story_flags[:honest_with_guards]
      narrate("O Capitão da Guarda chega para te homenagear.")
      character_speak("Capitão da Guarda", "Será sempre bem-vindo em nossa cidade, herói!", :guard)
    end

    puts
    puts colorize("FINAL CONQUISTADO!", :system)
    puts
    puts colorize("Estatísticas Finais:", :system)
    puts colorize("━" * 30, :system)
    puts colorize("Nível Final: #{@player[:level]}", :player)
    puts colorize("Experiência: #{@player[:experience]} XP", :player)
    puts colorize("Ouro Final: #{@player[:gold]} moedas", :player)
    puts colorize("Itens no Inventário: #{@player[:inventory].length}", :player)
    puts colorize("━" * 30, :system)
    puts

    narrate("Obrigado por jogar 'A Lenda do Cristal Perdido'!")
    narrate("Sua jornada heroica chegou ao fim... ou seria apenas o começo?")

    puts
    puts colorize("FIM DE JOGO", :system)
  end

  def play
    display_title

    puts colorize("Bem-vindo ao mundo épico de Lumina!", :narrator)
    puts colorize("Prepare-se para uma aventura inesquecível!", :narrator)
    puts

    wait_for_input

    while @current_chapter <= 4 && @player[:health] > 0
      case @current_chapter
      when 1
        chapter_1
      when 2
        chapter_2
      when 3
        chapter_3
      when 4
        chapter_4
      end
    end

    if @player[:health] <= 0
      puts colorize("Sua aventura chegou ao fim...", :enemy)
      puts colorize("Mas lendas nunca morrem! Tente novamente!", :system)
    end
  end
end

# Iniciar o jogo
if __FILE__ == $0
  game = RPGGame.new
  game.play
end
