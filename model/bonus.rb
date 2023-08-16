class Bonus
  def initialize(x, y)
    @image = Gosu::Image.new("./media/bonus.png")
    @x = x
    @y = y
  end
  
  def shift(delta)
    @x -= delta
  end

  def hit?(x1, y1, x2, y2)
    i2 = @x + 16
    return false if i2 < x1

    j2 = @y + 16
    return false if j2 < y1

    i1 = @x + 16
    return false if i1 > x2

    j1 = @y + 16
    return false if j1 > y2

    return true
  end

  def draw
    @image.draw(@x, @y, 4)
  end
end