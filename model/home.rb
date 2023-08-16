class Home
  def initialize(x)
    @image = Gosu::Image.new("./media/home.png")
    @x = x
  end
  
  def shift(delta)
    @x -= delta
  end

  def draw
    @image.draw(@x, HEIGHT - 74, 1)
  end
end