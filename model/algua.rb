class Algua
  def initialize(x, length, resize)
    @image = Gosu::Image.new("/home/edouard/Cozy Drive/Administratif/perso/Jeux/atlantic/algua.png")
    @length = length
    @x = x
    @resize = resize
    @y = HEIGHT - (length * @resize)
  end
  
  def shift(delta)
    @x -= delta
  end

  def draw
    @image.draw(@x, @y, 1, 1, @resize)
  end
end