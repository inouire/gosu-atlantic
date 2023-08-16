class Player
  def initialize
    @images = {
      :alive => Gosu::Image.new("./media/hero.png"),
      :dead  => Gosu::Image.new("./media/hero_skel.png"),
    }
    @x = @y = 100
    @vel_x = @vel_y = 0.0
    @score = 0
    @status = :alive
  end

  attr_reader :x
  attr_reader :y
  attr_reader :score

  def kill
    @status = :dead
  end

  def warp(x, y)
    @x, @y = x, y
  end
  
  def go_up
    @vel_y -= 1
  end

  def go_down
    @vel_y += 1
  end

  def go_right
    @vel_x += 1
  end

  def go_left
    @vel_x -= 1
  end
  
  def gain(bonus)
    @score += bonus
  end

  def shift(delta)
    return unless @status == :dead
    @x -= delta
  end

  def move
    if @status == :dead
      if @y < HEIGHT - PLAYER_HEIGHT + 3
        @y += 4
      end
    else
      @x += @vel_x
      @y += @vel_y

      @x = 0 if @x < 0
      @y = 0 if @y < 0

      max_x = WIDTH - PLAYER_WIDTH
      max_y = HEIGHT - PLAYER_HEIGHT
      @x = max_x if @x > max_x
      @y = max_y if @y > max_y
        
      @vel_x *= 0.92
      @vel_y *= 0.92
    end
  end

  def draw
    @images[@status].draw(@x, @y, 1)
  end
end