class Home
  def initialize(x)
    @image = Gosu::Image.new("/home/edouard/Cozy Drive/Administratif/perso/Jeux/atlantic/home.png")
    @x = x
  end
  
  def shift(delta)
    @x -= delta
  end

  def draw
    @image.draw(@x, HEIGHT  - (37 * RESIZE_FACTOR * 2), 1, 2 * RESIZE_FACTOR, 2 * RESIZE_FACTOR)
  end
end