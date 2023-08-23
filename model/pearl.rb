class Pearl
  def initialize(x, y)
    @x = x
    @y = y
    @display = true
    @vel_x = 0
    @vel_y = 0
  end
  
  attr_reader :x

  def activate
    if @vel_x == 0
      @vel_x = -3
      @vel_y  = if @y < HEIGHT / 2
        3
      else
        -3
      end
    end
  end

  def shift(delta)
    @x -= delta
    @x += @vel_x
    @y += @vel_y
    if @y > HEIGHT - 8
      @y = HEIGHT - 8
      @vel_y = - @vel_y
    end
    if @y < 0
      @y = 0
      @vel_y = - @vel_y
    end
  end

  def delete
    @display = false
  end

  def used?
    @display == false
  end

  def hit?(x1, y1, x2, y2)
    i2 = @x + 8
    return false if i2 < x1

    j2 = @y + 8
    return false if j2 < y1

    i1 = @x
    return false if i1 > x2

    j1 = @y
    return false if j1 > y2

    return true
  end

  def draw
    if @display
      IMAGE[:pearl].draw(@x, @y, ZINDEX[:pearl])
    end
  end
end