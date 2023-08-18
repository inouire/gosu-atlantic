require 'gosu'
require "./model/player.rb"
require "./model/wall.rb"
require "./model/enemy.rb"
require "./model/algua.rb"
require "./model/bonus.rb"
require "./model/home.rb"
require 'byebug'
WIDTH  = 800
HEIGHT = 400
  
SCENE_WIDTH = 12500

PLAYER_HEIGHT = 26
PLAYER_WIDTH  = 36

RESIZE_FACTOR = 2
HIT_TOLERANCE = 3

class Atlantic < Gosu::Window
  def initialize
    super WIDTH, HEIGHT
    self.caption = "Atlantic game"

    @pop_sound     = Gosu::Sample.new("./media/pop.mp3")
    @wall_sound    = Gosu::Sample.new("./media/wall.mp3")
    @sonar_sound   = Gosu::Sample.new("./media/sonar.mp3")
    @bubbles_sound = Gosu::Sample.new("./media/bubbles.mp3")

    @bg_img = Gosu::Image.new("media/bg.png", :tileable => true)

    @font = Gosu::Font.new(20)
    init_game
  end 

  def init_game
    @won = false
    @player1 = Player.new
    @player1.warp(100, HEIGHT / 2)

    # @killed_sound = Gosu::Sample.new("media/beep.wav")

    @distance = 0
    @speed  = 1

    # Walls all along the way, home a bit after them
    @walls = []
    k = WIDTH / 4
    
    while k < SCENE_WIDTH
      direction = Random.rand(100) % 2 == 0 ? :up : :down
      @walls << Wall.new(k, direction, Random.rand(4))
      k += (Random.rand(250) + 15)
    end

    @home = Home.new(@walls.last.x + (3 * WIDTH / 4))

    # Alguas everywhere even after the end
    @alguas = []
    k = 0
    while k < (SCENE_WIDTH + 500)
      @alguas << Algua.new(k, Random.rand(40), Random.rand(5))
      k += Random.rand(200)
    end

    # Enemys everywhere even after the end
    @enemys = []
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
      k += Random.rand(400)
    end
    
    # A bit more crabs
    k = 0
    while k < SCENE_WIDTH
      direction = Random.rand(8) - 2
      @enemys << Enemy.new(k, HEIGHT - 30, "crabe", nil)
      k += Random.rand(800)
    end

    @bonuses = []
    k = WIDTH
    while k < (2 * SCENE_WIDTH / 3)
      y = if Random.rand(100) % 2 == 0
        4
      else
        HEIGHT - 16 - 4
      end

      @bonuses << Bonus.new(k, y)
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
    if Gosu.button_down?(Gosu::KB_R)
      init_game
    end

    @player1.move

    @distance += @speed
    @speed = 1 + (@distance / 1500) if @speed != 0
    @speed = 2 if @distance > SCENE_WIDTH

    (@bonuses + @walls + @enemys + @alguas  + [@home, @player1]).each do |item|
      item.shift(@speed)
    end

    @player1.gain(0)

    hero_width = 36
    hero_height = 26 

    @enemys.each do |enemy|
      next if enemy.dead?
      next if @won
      if enemy.hit?(@player1.x, @player1.y, @player1.x + hero_width, @player1.y + hero_height)
        if @player1.status == :mangeur
          
          enemy.kill
          @pop_sound.play
          @player1.gain(100)
        elsif @player1.status != :dead
          @player1.kill
          @bubbles_sound.play
          @speed = 0
        end
      end
    end

    @walls.each do |wall|
      next if wall.dead?
      next if @won
      if wall.hit?(@player1.x, @player1.y, @player1.x + hero_width, @player1.y + hero_height)
        if @player1.status == :perceur
          wall.kill
          @wall_sound.play
          @player1.gain(50)
        elsif @player1.status != :dead
          @player1.kill
          @bubbles_sound.play
          @speed = 0
        end
      end
    end

    if !@player1.dead?
      @bonuses.each do |bonus|
        next if bonus.used?
        if bonus.hit?(@player1.x, @player1.y, @player1.x + hero_width, @player1.y + hero_height)
          sub_type = Random.rand(100) % 2 == 0 ? "mangeur" : "perceur"
          @player1.become_sub(sub_type)
          @player1.gain(100)
          bonus.delete
        end
      end
    end

    if [:mangeur, :perceur].include?(@player1.status) && [500, 325, 150].include?(@player1.sub_countdown)
      @sonar_sound.play
    end

    if @home.hit?(@player1.x, @player1.y, @player1.x + hero_width, @player1.y + hero_height)
      @speed = 0
      @won = true
    end
  end
  
  def draw
    @bg_img.draw(0, 0, 0)

    @player1.draw
    @walls.each(&:draw)
    @enemys.each(&:draw)
    @alguas.each(&:draw)
    @bonuses.each(&:draw)
    @home.draw

    @font.draw_text("Score: #{@player1.score}", 10, 10, 5, 1.0, 1.0, Gosu::Color::YELLOW)
    vert = 25
    [
      ["Speed", @speed],
      ["Distance", @distance],
    ].each do |debug_label, debug_value|
      @font.draw_text("#{debug_label}: #{debug_value}", 10, vert, 5, 1.0, 1.0, Gosu::Color::BLACK)
      vert += 25
    end
    @font.draw_text("Score: #{@player1.score}", 10, 10, 5, 1.0, 1.0, Gosu::Color::YELLOW)
    
    if @player1.sub_countdown > 0
      @font.draw_text("* #{@player1.sub_countdown} *", 3 * WIDTH / 4, HEIGHT / 2, 5, 1.0, 1.0, Gosu::Color::BLUE)
    end

    if @player1.dead? || @won
      if @player1.dead?
        @font.draw_text("++ GAME OVER ++", WIDTH / 2 - 60, HEIGHT / 2 - 20, 10, 1.0, 1.0, Gosu::Color::BLUE)
      elsif @won
        @font.draw_text("*** YOU WON ***", WIDTH / 2 - 60, HEIGHT / 2 - 20, 10, 1.0, 1.0, Gosu::Color::YELLOW)
      end
      @font.draw_text("Score #{@player1.score}", WIDTH / 2 - 25, HEIGHT / 2, 10, 1.0, 1.0, Gosu::Color::YELLOW)
      @font.draw_text("Press R to restart", WIDTH / 2 - 60, HEIGHT / 2 + 20, 10, 1.0, 1.0, Gosu::Color::YELLOW)
    end
  end
end

Atlantic.new.show