class Algua
  def initialize(x, length, resize)
    @length = length
    @x = x
    @resize = resize
    @y = HEIGHT - (length * @resize)
  end
  
  def shift(delta)
    @x -= delta
  end

  def draw
    IMAGE[:algua].draw(@x, @y, ZINDEX[:algua], 1, @resize)
  end
end