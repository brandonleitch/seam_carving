require "chunky_png"

class Image < ChunkyPNG::Image


  def get_pixel x,y
    x = [[x, @width].min, 0].max
    y = [[x, @height].min, 0].max
    super x,y
  end

  def self.color_difference c_1, c_2
    (ChunkyPNG::Color.r(c_1) - ChunkyPNG::Color.r(c_2)) ** 2 +
    (ChunkyPNG::Color.g(c_1) - ChunkyPNG::Color.g(c_2)) ** 2 +
    (ChunkyPNG::Color.b(c_1) - ChunkyPNG::Color.b(c_2)) ** 2
  end

  def difference x_1, y_1, x_2, y_2
    Image.color_difference(get_pixel(x_1,y_1), get_pixel(x_2,y_2))
  end

  def entropy x, y
    sum = 0
    span = 2
    (-span..span).each do |i|
      (-span..span).each do |j|
        sum += difference(x, y, x + i, y + j)
      end
    end
    sum
  end

  def energy_map
    return EntropyMap.new(self)
  end

  def paths
    map = entropy_map

    (1...self.height).each do |r|
      (0...self.width).each do |c|

        current = map.get_ent(c,r)

        above  = (-1..1).map{|n| map.get_ent(c + n, r - 1)}

        min = above.min

        (-1..1).each do |n|
          if min == above[n + 1]
            map.set_dir(x,y,n)
            map.set_ent(x,y, current + above[n + 1])
          end
        end
      end
    end
    map
  end

  def least_entropy_path
    map = paths
    min_entropy = map.get_ent(0, @height - 1)
    pos = 0
    (1...@width).each do |i|
      cur = map.get_ent(i, @height - 1)
      if cur < min_entropy
        min_entropy = cur
        pos = i
      end
    end

    path = []
    (@height - 1).downto(0) do |r|
      path << pos
      pos += map.get_dir(pos, r)
    end

    path
end
