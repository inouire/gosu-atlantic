class Bubble
  def initialize(x, y)
    @x = x
    @y = y
    @vel_y = 2
    @lifespan = 0
  end
  
  def shift(delta)
    if @sub_countdown > 0
      @sub_countdown -= 1
    end
    if @sub_countdown <= 0 && @status != :dead
      @status = :alive
    end

    return unless @status == :dead
    @x -= delta
  end

  def shift(delta)
    @x -= delta
    @y -= @vel_y
    @lifespan += 1
  end

  def draw
    type = if @lifespan > 50
      4
    elsif @lifespan > 40
      3
    elsif @lifespan > 20
      2
    else
      1
    end

    IMAGE[:"bubble#{type}"].draw(@x, @y, ZINDEX[:hero])
  end
end