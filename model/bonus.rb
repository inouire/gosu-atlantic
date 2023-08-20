class Bonus
  def initialize(x, y, is_super)
    @x = x
    @y = y
    @display = true
    @is_super = is_super
  end
    
  attr_reader :is_super

  def shift(delta)
    @x -= delta
  end

  def delete
    @display = false
  end

  def used?
    @display == false
  end

  def hit?(x1, y1, x2, y2)
    i2 = @x + 16
    return false if i2 < x1

    j2 = @y + 16
    return false if j2 < y1

    i1 = @x
    return false if i1 > x2

    j1 = @y
    return false if j1 > y2

    return true
  end

  def draw
    if @display
      if is_super
        IMAGE[:bonus_super].draw(@x, @y, ZINDEX[:bonus])
      else
        IMAGE[:bonus].draw(@x, @y, ZINDEX[:bonus])
      end
    end
  end
end