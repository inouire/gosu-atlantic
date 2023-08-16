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
  
PLAYER_HEIGHT = 26
PLAYER_WIDTH  = 36

RESIZE_FACTOR = 2
HIT_TOLERANCE = 3

class Atlantic < Gosu::Window
  def initialize
    super WIDTH, HEIGHT
    self.caption = "Atlantic game"

    @bg_img = Gosu::Image.new("media/bg.png", :tileable => true)

    @font = Gosu::Font.new(20)
    init_game
  end 

  def init_game
    @won = false
    @player1 = Player.new
    @player1.warp(100, HEIGHT / 2)

    @time = 0
    @speed  = 1

    @walls = []
    k = 0
    (1..100).each do |i|
      k += Random.rand(250)
      direction = Random.rand(100) % 2 == 0 ? :up : :down
      @walls << Wall.new(k, direction, Random.rand(4))
    end

    @alguas = []
    k = 0
    (1..100).each do |i|
      k += Random.rand(450)
      @alguas << Algua.new(k, Random.rand(40), Random.rand(5))
    end

    @home = Home.new(@walls.last.x + 200)

    @enemys = []
    k = 0
    (1..50).each do |i|
      k += Random.rand(500)
      y = Random.rand(HEIGHT - 60)
      type = {
        0 => "spike",
        1 => "medusa",
        2 => "squale",
      }[Random.rand(3)]

      move = Random.rand(100) % 2 == 0 ? 1 : -1
      @enemys << Enemy.new(k, y, type, move)
    end
    
    k = 0
    (1..30).each do |i|
      k += Random.rand(600)
      direction = Random.rand(8) - 2
      @enemys << Enemy.new(k, HEIGHT - 30, "crabe", nil)
    end

    @bonuses = []
    k = 0
    (1..6).each do |i|
      k += Random.rand(1200)
      y = if Random.rand(100) % 2 == 0
        4
      else
        HEIGHT - 16 - 4
      end

      @bonuses << Bonus.new(k, y)
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

    @time += 1

    if @time % 1000 == 0
      @speed += 1
    end

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
          @player1.gain(100)
        else
          @player1.kill
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
          @player1.gain(50)
        else
          @player1.kill
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
          bonus.delete
        end
      end
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