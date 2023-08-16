class Bonus
  def initialize(x, y)
    @image = Gosu::Image.new("./media/bonus.png")
    @x = x
    @y = y
  end
  
  def shift(delta)
    @x -= delta
  end

  def draw
    @image.draw(@x, @y, 1, 2 * RESIZE_FACTOR, 2 * RESIZE_FACTOR)
  end
end