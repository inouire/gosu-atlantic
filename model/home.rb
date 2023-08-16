class Home
  def initialize(x)
    @image = Gosu::Image.new("./media/home.png")
    @image = Gosu::Image.new("./media/home2.png")
    @x = x
    @y = HEIGHT - 156
  end
  
  def shift(delta)
    @x -= delta
  end

  def draw
    @image.draw(@x, @y, 0)
  end

  def hit?(x1, y1, x2, y2)
    i2 = @x + 150
    return false if i2 < x1

    j2 = @y + 100
    return false if j2 < y1

    i1 = @x + 70
    return false if i1 > x2

    j1 = @y + 50
    return false if j1 > y2

    return true
  end
end