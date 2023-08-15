class Wall
  def initialize(x, up_or_down, resize)
    @image = Gosu::Image.new("/home/edouard/Cozy Drive/Administratif/perso/Jeux/atlantic/wall.png")
    @resize = resize
    @x = x
    @y = if up_or_down == :up
      0
    else
      HEIGHT - (27 * RESIZE_FACTOR * @resize)
    end
  end
  
  attr_reader :x
    
  def shift(delta)
    @x -= delta
  end

  def draw
    @image.draw(@x, @y, 1, RESIZE_FACTOR, RESIZE_FACTOR * @resize)
  end
end