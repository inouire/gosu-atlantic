class Crabe
  def initialize(x, direction)
    @image = Gosu::Image.new("/home/edouard/Cozy Drive/Administratif/perso/Jeux/atlantic/crabe.png")
    @x = x
    @move_x = direction
  end
  
  def shift(delta)
    @x -= delta
    @x += @move_x
  end

  def draw
    @image.draw(@x, HEIGHT - 30, 0)
  end
end