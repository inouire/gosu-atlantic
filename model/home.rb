class Home
  def initialize(x)
    @x = x
    @y = 12
  end
  
  def shift(delta)
    @x -= delta
  end

  def draw
    IMAGE[:finish].draw(@x, @y, ZINDEX[:finish])
    #draw_hitbox
  end

  def draw_hitbox
    hx1, hy1, hx2, hy2 = hitbox
    Gosu.draw_rect(@x + hx1, @y + hy1, hx2 - hx1, hy2 - hy1, Gosu::Color::YELLOW, 20)
  end

  def hitbox
    [451, 26, 550, 108]
  end

  def hit?(x1, y1, x2, y2)
    hx1, hy1, hx2, hy2 = hitbox

    i2 = @x + hx2
    return false if i2 < x1

    j2 = @y + hy2
    return false if j2 < y1

    i1 = @x + hx1
    return false if i1 > x2

    j1 = @y + hy1
    return false if j1 > y2

    return true
  end
end