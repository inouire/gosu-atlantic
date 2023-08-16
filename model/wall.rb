class Wall
  def initialize(x, up_or_down, resize)
    @image = Gosu::Image.new("./media/wall#{up_or_down}.png")
    @resize = resize
    @x = x
    @y = if up_or_down == :up
      0
    else
      HEIGHT - (54 * @resize)
    end
  end
  
  attr_reader :x

  def shift(delta)
    @x -= delta
  end

  def draw
    @image.draw(@x, @y, 1, 1, @resize)
  end
end