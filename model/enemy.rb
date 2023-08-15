class Enemy
  def initialize(x, y, type, move)
    @image = Gosu::Image.new("/home/edouard/Cozy Drive/Administratif/perso/Jeux/atlantic/#{type}.png")
    @x = x
    @y = y
    @move_y = move
    @move_x = if type == "spike"
      -1
    elsif type == "squale"
      0.5
    else
      0
    end
  end
  
  def shift(delta)
    @x -= delta
    @y += @move_y

    @x += @move_x

    max_y = HEIGHT - 20 * RESIZE_FACTOR
    if @y > max_y || @y < 0
      @move_y = -@move_y
    end
  end

  def draw
    @image.draw(@x, @y, 1, RESIZE_FACTOR, RESIZE_FACTOR)
  end
end