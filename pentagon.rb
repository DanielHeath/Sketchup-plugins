class Pentagon < Geometry
  def self.points_for(x, y, z, side_length)
    side_length = side_length.to_f
    x = x.to_f
    y = y.to_f
    z = z.to_f
    pts = []
    pts << [x, y, z]
    pts << [x + side_length, y, z]
    pts << [x + side_length + short_bit(side_length), y + long_bit(side_length), z]

    pts << [x + (side_length/2), y + y_height(side_length), z]

    pts << [x - short_bit(side_length), y + long_bit(side_length), z]
    pts
  end

private

  def self.short_bit(side_length)
    side_length * cos(base_angle)
  end

  def self.y_height(side_length)
    Math.sqrt( ((2 * side_length * sin(54))**2) - ((side_length/2)**2) )
  end

  def self.long_bit(side_length)
    side_length * sin(base_angle)
  end

  def self.base_angle
    72
  end

end