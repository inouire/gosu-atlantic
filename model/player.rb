class Player
  def initialize
    @x = @y = 100
    @vel_x = @vel_y = 0.0
    @score = 0
    @status = :alive
    @sub_countdown = 0
  end

  attr_reader :x
  attr_reader :y
  attr_reader :status
  attr_reader :score
  attr_reader :sub_countdown

  def kill
    @status = :dead
  end

  def dead?
    @status == :dead
  end

  def become_sub(type)
    if @status == :alive
      @status = type.to_sym
    end
    @sub_countdown = 500
  end

  def become_fish
    @status = :alive
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
    if @sub_countdown > 0
      @sub_countdown -= 1
    end
    if @sub_countdown <= 0 && @status != :dead
      @status = :alive
    end

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
    direction = if @status == :alive
      @vel_x > -0.1 ? 1 : -1
    else
      1
    end
    xoffset = if direction == -1
      PLAYER_WIDTH
    else
      0
    end
    IMAGE[:"hero_#{@status}"].draw(@x + xoffset, @y, ZINDEX[:hero], direction)

    if @sub_countdown > 0 && [:perceur, :mangeur].include?(status)
      # 500       -> 30 px
      # countdown -> countdown * 30 /  500
      offset = if @status == :perceur
        38
      else
        30
      end
      countdown_length = @sub_countdown * 30 / 500
      Gosu.draw_rect(@x + 13, @y + offset, 30, 2, Gosu::Color::BLACK, ZINDEX[:progress])
      Gosu.draw_rect(@x + 13, @y + offset, countdown_length, 2, Gosu::Color.from_hsv(22, 81, 93), ZINDEX[:progress])
    end
  end
end