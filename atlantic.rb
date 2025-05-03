require 'gosu'
require "./model/player.rb"
require "./model/wall.rb"
require "./model/enemy.rb"
require "./model/algua.rb"
require "./model/bonus.rb"
require "./model/home.rb"
require "./model/bubble.rb"
require "./model/pearl.rb"
require 'byebug'

WIDTH  = 800
HEIGHT = 400
  
SCENE_WIDTH = 12500

PLAYER_HEIGHT = 26
PLAYER_WIDTH  = 36

RESIZE_FACTOR = 2
HIT_TOLERANCE = 3

ZINDEX = {
  :plan3    => 0,
  :plan2    => 1,
  :plan1    => 2,
  :finish   => 6,
  :hero     => 10,
  :wall     => 11,
  :bonus    => 12,
  :fish     => 13,
  :algua    => 14,
  :progress => 15,
  :pearl    => 16,
  :score    => 17,
}

IMAGE = {
  :finish         => Gosu::Image.new("./media/image/finish.png"),
  :plan1          => Gosu::Image.new("./media/image/plan1.png"),
  :plan2          => Gosu::Image.new("./media/image/plan2.png"),
  :plan3          => Gosu::Image.new("./media/image/plan3.png"),
  :bubble1        => Gosu::Image.new("./media/image/bubble1.png"),
  :bubble2        => Gosu::Image.new("./media/image/bubble2.png"),
  :bubble3        => Gosu::Image.new("./media/image/bubble3.png"),
  :bubble4        => Gosu::Image.new("./media/image/bubble4.png"),
  :hero_alive     => Gosu::Image.new("./media/image/hero.png"),
  :hero_super     => Gosu::Image.new("./media/image/hero_super.png"),
  :hero_dead      => Gosu::Image.new("./media/image/hero_skel.png"),
  :hero_perceur   => Gosu::Image.new("./media/image/sub_perceur.png"),
  :hero_mangeur   => Gosu::Image.new("./media/image/sub_mangeur.png"),
  :spike_alive    => Gosu::Image.new("./media/image/spike.png"),
  :spike_dead     => Gosu::Image.new("./media/image/spike_skel.png"),
  :medusa_alive   => Gosu::Image.new("./media/image/medusa.png"),
  :medusa_dead    => Gosu::Image.new("./media/image/medusa_skel.png"),
  :squale_alive   => Gosu::Image.new("./media/image/squale.png"),
  :squale_dead    => Gosu::Image.new("./media/image/squale_skel.png"),
  :crabe_alive    => Gosu::Image.new("./media/image/crabe.png"),
  :crabe_dead     => Gosu::Image.new("./media/image/crabe_skel.png"),
  :wallup_alive   => Gosu::Image.new("./media/image/wallup.png"),
  :wallup_dead    => Gosu::Image.new("./media/image/wallup_broken.png"),
  :walldown_alive => Gosu::Image.new("./media/image/walldown.png"),
  :walldown_dead  => Gosu::Image.new("./media/image/walldown_broken.png"),
  :algua          => Gosu::Image.new("./media/image/algua.png"),
  :bonus          => Gosu::Image.new("./media/image/bonus.png"),
  :bonus_super    => Gosu::Image.new("./media/image/bonus_super.png"),
  :oyster_alive   => Gosu::Image.new("./media/image/oyster.png"),
  :oyster_dead    => Gosu::Image.new("./media/image/oyster.png"),
  :pearl          => Gosu::Image.new("./media/image/pearl.png"),
}

SOUND = {
  :pop     => Gosu::Sample.new("./media/sound/pop.mp3"),
  :wall    => Gosu::Sample.new("./media/sound/wall.mp3"),
  :sonar   => Gosu::Sample.new("./media/sound/sonar.mp3"),
  :bubbles => Gosu::Sample.new("./media/sound/bubbles.mp3"),
}

class Atlantic < Gosu::Window
  def initialize
    super WIDTH, HEIGHT
    self.caption = "Atlantic game"

    @font = Gosu::Font.new(20)
    init_game
  end 

  def init_game
    @won = false
    @player1 = Player.new
    @player1.warp(100, HEIGHT / 2)

    @distance = 0
    @speed  = 1
    @easy = false

    @plan1_offset = 1000
    @plan2_offset = 1000

    @bubbles = []
    @enemys = []
    @pearls = []

    # Walls all along the way, home a bit after them
    @walls = []

    k = WIDTH / 4
    
    while k < SCENE_WIDTH
      direction = Random.rand(100) % 2 == 0 ? :up : :down
      @walls << Wall.new(k, direction, 1 + Random.rand(3))
      
      if Random.rand(12) == 10
        @enemys << Enemy.new(k - 12, direction == :up ? 16 : HEIGHT - 50, "oyster", nil)
        @pearls << Pearl.new(k, direction == :up ? 33 : HEIGHT - 33)
      end

      k += (Random.rand(250) + 15)
    end

    @home = Home.new(@walls.last.x + (3 * WIDTH / 4))

    # Alguas everywhere even after the end
    @alguas = []
    k = 0
    while k < (SCENE_WIDTH + 800)
      @alguas << Algua.new(k, Random.rand(40), Random.rand(5))
      k += Random.rand(200)
    end

    # Enemys everywhere even after the end
    k = WIDTH / 2
    while k < (SCENE_WIDTH + 100)
      y = Random.rand(HEIGHT - 60)
      type = {
        0 => "spike",
        1 => "medusa",
        2 => "squale",
      }[Random.rand(3)]

      move = Random.rand(100) % 2 == 0 ? 1 : -1
      @enemys << Enemy.new(k, y, type, move)
      k += Random.rand(300)
    end
    
    # A bit more crabs
    k = 0
    while k < SCENE_WIDTH
      direction = Random.rand(8) - 2
      @enemys << Enemy.new(k, HEIGHT - 30, "crabe", nil)
      k += Random.rand(800)
    end

    # A bit more oysters
    k = 0
    while k < SCENE_WIDTH
      k += Random.rand(1200)
    end

    @bonuses = []
    k = WIDTH
    while k < (2 * SCENE_WIDTH / 3)
      y = if Random.rand(100) % 2 == 0
        4
      else
        HEIGHT - 16 - 4
      end

      @bonuses << Bonus.new(k, y, @bonuses.size == 6)
      k += Random.rand(1200)
    end
  end

  def update
    if Gosu.button_down?(Gosu::KB_LEFT) or Gosu::button_down?(Gosu::GP_LEFT)
      @player1.go_left
    end
    if Gosu.button_down?(Gosu::KB_RIGHT) or Gosu::button_down?(Gosu::GP_RIGHT)
      @player1.go_right
    end
    if Gosu.button_down?(Gosu::KB_UP)or Gosu::button_down?(Gosu::GP_BUTTON_0)
      @player1.go_up
    end
    if Gosu.button_down?(Gosu::KB_DOWN)or Gosu::button_down?(Gosu::GP_BUTTON_1)
      @player1.go_down
    end
    if Gosu.button_down?(Gosu::KB_R) && @player1.dead?
      init_game
    end
    if Gosu.button_down?(Gosu::KB_X)
      @easy = true
    end
    if Gosu.button_down?(Gosu::KB_Z)
      @easy = false
      @score = 0
    end

    @player1.move

    @distance += @speed
    @speed = 1 + (@distance / 1500) if @speed != 0 && !@won
    @speed = 2 if @distance > SCENE_WIDTH && !@won

    # Free roaming at the end
    if @won
      if @player1.x < 20
        @speed = -3
      end
      if @player1.x > (WIDTH - 50)
        @speed = 3
      end
    end

    if @distance % 100 <= 30 && @player1.status == :alive
      if (@distance % 100) % 10 == 0
        @bubbles << Bubble.new(@player1.x, @player1.y)
      end
    end

    (@bubbles + @bonuses + @walls + @enemys + @alguas + @pearls + [@home, @player1]).each do |item|
      item.shift(@speed)
    end

    @player1.gain(0)

    if @speed > 0
      @plan1_offset -= 0.5 * @speed
      @plan2_offset -= 0.1 * @speed
      @plan1_offset = 1000 if @plan1_offset < 0
      @plan2_offset = 1000 if @plan2_offset < 0
    end

    hero_width = 36
    hero_height = 26 

    @pearls.each do |pearl|
      if pearl.x < WIDTH - 40
        pearl.activate
      end
      if pearl.hit?(@player1.x, @player1.y, @player1.x + hero_width, @player1.y + hero_height)
        @player1.gain(100)
        pearl.delete
      end
    end

    @enemys.each do |enemy|
      next if enemy.dead?
      next if @won
      if enemy.hit?(@player1.x, @player1.y, @player1.x + hero_width, @player1.y + hero_height)
        if [:mangeur, :super].include?(@player1.status)
          enemy.kill
          SOUND[:pop].play
          @player1.gain(100)
        elsif @player1.status != :dead && !@easy
          next if @won
          @player1.kill
          SOUND[:bubbles].play
          @speed = 0
        end
      end
    end

    @walls.each do |wall|
      next if wall.dead?
      next if @won
      if wall.hit?(@player1.x, @player1.y, @player1.x + hero_width, @player1.y + hero_height)
        if [:perceur, :super].include?(@player1.status)
          wall.kill
          SOUND[:wall].play
          @player1.gain(50)
        elsif @player1.status != :dead && !@easy
          next if @won
          @player1.kill
          SOUND[:bubbles].play
          @speed = 0
        end
      end
    end

    if !@player1.dead?
      @bonuses.each do |bonus|
        next if bonus.used?
        if bonus.hit?(@player1.x, @player1.y, @player1.x + hero_width, @player1.y + hero_height)
          sub_type = if bonus.is_super
            @player1.become_super
          else
            @player1.become_sub(Random.rand(100) % 2 == 0 ? "mangeur" : "perceur")
          end
          @player1.gain(100)
          bonus.delete
        end
      end
    end

    if [:mangeur, :perceur].include?(@player1.status) && [500, 325, 150].include?(@player1.sub_countdown)
      SOUND[:sonar].play
    end

    if @home.hit?(@player1.x, @player1.y, @player1.x + hero_width, @player1.y + hero_height)
      @speed = 0
      @won = true
    end
  end
  
  def draw
    IMAGE[:plan3].draw(0, 0, ZINDEX[:plan3])
    IMAGE[:plan2].draw(@plan2_offset - 1000, 0, ZINDEX[:plan2])
    IMAGE[:plan1].draw(@plan1_offset - 1000, 0, ZINDEX[:plan1])

    IMAGE[:plan2].draw(@plan2_offset, 0, ZINDEX[:plan2])
    IMAGE[:plan1].draw(@plan1_offset, 0, ZINDEX[:plan1])

    @player1.draw
    @walls.each(&:draw)
    @enemys.each(&:draw)
    @alguas.each(&:draw)
    @bonuses.each(&:draw)
    @bubbles.each(&:draw)
    @pearls.each(&:draw)
    @home.draw

    # SCENE_WIDTH -> WIDTH
    # distance    -> distance * WIDTH / SCENE_WIDTH
    progress = @distance * WIDTH / SCENE_WIDTH
    Gosu.draw_rect(0, HEIGHT - 2, WIDTH, 2, Gosu::Color::YELLOW, ZINDEX[:progress])
    Gosu.draw_rect(0, HEIGHT - 2, progress, 2, Gosu::Color.from_hsv(22, 81, 93), ZINDEX[:progress])

    if @easy
      @font.draw_text("PEACEFUL MODE", 10, 10, ZINDEX[:score], 1.0, 1.0, Gosu::Color::BLACK)
    else
      @font.draw_text("Score: #{@player1.score}", 10, 10, ZINDEX[:score], 1.0, 1.0, Gosu::Color::BLACK)
    end
        
    if @player1.dead? || @won
      if @player1.dead?
        @font.draw_text("++ GAME OVER ++", WIDTH / 2 - 60, HEIGHT / 2 - 20, ZINDEX[:score], 1.0, 1.0, Gosu::Color::BLUE)
      elsif @won
        @font.draw_text("*** YOU WON ***", WIDTH / 2 - 60, HEIGHT / 2 - 20, ZINDEX[:score], 1.0, 1.0, Gosu::Color::BLACK)
      end
      @font.draw_text("Score #{@player1.score}", WIDTH / 2 - 25, HEIGHT / 2, ZINDEX[:score], 1.0, 1.0, Gosu::Color::BLACK)
      @font.draw_text("Press R to restart", WIDTH / 2 - 60, HEIGHT / 2 + 20, ZINDEX[:score], 1.0, 1.0, Gosu::Color::BLACK)
    end
  end
end

Atlantic.new.show