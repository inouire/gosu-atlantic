require 'gosu'
require "./model/player.rb"
require "./model/wall.rb"
require "./model/enemy.rb"

WIDTH  = 800
HEIGHT = 400
  
PLAYER_HEIGHT = 13
PLAYER_WIDTH  = 18

RESIZE_FACTOR = 2

class Atlantic < Gosu::Window
  def initialize
    super WIDTH, HEIGHT
    self.caption = "Atlantic game"

    @bg_img = Gosu::Image.new("media/bg.png", :tileable => true)

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

    @player1.move

    @time += 1

    if @time % 1000 == 0
      @speed += 1
    end

    @walls.each do |wall|
      wall.shift(@speed)
    end

    @enemys.each do |enemy|
      enemy.shift(@speed)
    end
  end
  
  def draw
    @bg_img.draw(0, 0, 0)

    @player1.draw
    @walls.each(&:draw)
    @enemys.each(&:draw)
  end
end

Atlantic.new.show