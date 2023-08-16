class Enemy

  def initialize(x, y, type, move)
    @images = {
      :alive => Gosu::Image.new("./media/#{type}.png"),
      :dead  => Gosu::Image.new("./media/#{type}_skel.png"),
    }
    @x = x
    @y = y
    @move_y = if type == "crabe"
      0
    else
      move
    end

    @move_x = if type == "spike"
      -1
    elsif type == "squale"
      0.5
    elsif type == "crabe"
      Random.rand(8) - 2
    else
      0
    end

    @hit_width, @hit_height = {
      "spike"  => [36, 24],
      "medusa" => [20, 36], 
      "squale" => [24, 18], 
      "crabe"  => [46, 30], 
    }[type]

    @status = :alive
  end

  def dead?
    @status == :dead
  end

  def kill
    @status = :dead
  end

  def shift(delta)
    @x -= delta

    if @status == :dead
      if @y < HEIGHT - PLAYER_HEIGHT + 3
        @y += 4
      end
    else
      @y += @move_y

      @x += @move_x

      max_y = HEIGHT - 40
      if @y > max_y || @y < 0
        @move_y = -@move_y
      end
    end  
  end

  ###########################
  #  . (i1,j1)
  #  
  # 
  #                . (i2, j2)
  ###########################
  def hit?(x1, y1, x2, y2)
    return false if @status == :dead
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

  def draw
    @images[@status].draw(@x, @y, 1)
  end
end