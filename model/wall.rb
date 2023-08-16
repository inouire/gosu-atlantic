class Wall
  def initialize(x, up_or_down, resize)
    @images = {
      :alive => Gosu::Image.new("./media/wall#{up_or_down}.png"),
      :dead  => Gosu::Image.new("./media/wall#{up_or_down}.png"),
    }

    @resize = resize
    @x = x
    @y = if up_or_down == :up
      0
    else
      HEIGHT - (54 * @resize)
    end

    @hit_height = 54 * @resize
    @hit_width  = 32 

    @status = :alive
  end
  
  attr_reader :x

  def dead?
    @status == :dead
  end


  def shift(delta)
    @x -= delta
  end

  ###########################
  #  . (i1,j1)
  #  
  # 
  #                . (i2, j2)
  ###########################
  def hit?(x1, y1, x2, y2)
    i2 = @x + @hit_width - HIT_TOLERANCE
    return false if i2 < x1

    j2 = @y + @hit_height - HIT_TOLERANCE
    return false if j2 < y1

    i1 = @x + HIT_TOLERANCE
    return false if i1 > x2

    j1 = @y + HIT_TOLERANCE
    return false if j1 > y2

    return true
  end

  def kill
    @status = :dead
  end

  def draw
    @images[@status].draw(@x, @y, 1, 1, @resize)
  end
end