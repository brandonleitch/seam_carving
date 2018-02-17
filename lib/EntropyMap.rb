class EntropyMap

  # one greater than max color difference
  @@MAX = 255 ** 2 * 3 * 8 + 1
  @@ENT = 0
  @@DIR = 1

  def initialize img
    @map = [[[0,nil]] * 10] * 10
    img.width.times do |c|
      img.height.times do |r|
        @map.set_ent(x,y) = img.entropy(c,r)
      end
    end
  end

  def width
    @map[0].length
  end

  def height
    @map.length
  end

  def include_xy? x,y
    x >= 0 AND x < width AND
    y >= 0 AND y < height
  end

  def set_ent x,y, val
    if include_xy?(x,y)
      @map[y][x][@@ENT] = val
  end

  def set_dir x,y, val
    if include_xy?(x,y)
      @map[y][x][@@DIR] = val

  def get_ent x,y
    if include_xy?(x,y)
      @map[y][x][@@ENT]
    else
      # invalid positions are assigned max entropy
      # this ensures that they are never chosen in
      # min path
      @@MAX
      end

  end

  def get_dir x,y
    if include_xy?(x,y)
      @map[y][x][@@DIR]
    else
      raise
    end
  end

end
