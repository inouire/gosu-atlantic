class Wall
  def initialize(x, up_or_down)
    @image = Gosu::Image.new("/home/edouard/Cozy Drive/Administratif/perso/Jeux/atlantic/wall.png")
    @x = x
    @y = if up_or_down == :up
      0
    else
      HEIGHT - (26 * RESIZE_FACTOR)
    end
  end
  
  def shift(delta)
    @x -= delta
  end

  def draw
    @image.draw(@x, @y, 1, RESIZE_FACTOR, RESIZE_FACTOR)
  end
end