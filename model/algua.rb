class Algua
  def initialize(x, length, resize)
    @image = Gosu::Image.new("./media/algua.png")
    @length = length
    @x = x
    @resize = resize
    @y = HEIGHT - (length * @resize)
  end
  
  def shift(delta)
    @x -= delta
  end

  def draw
    @image.draw(@x, @y, ZINDEX[:algua], 1, @resize)
  end
end