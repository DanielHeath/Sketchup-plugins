class PentagonalPyramid < Geometry
  def self.faces_for(x, y, z, side_length, height)
    side_length = side_length.to_f
    height = height.to_f
    x = x.to_f
    y = y.to_f
    z = z.to_f
    
    base = Pentagon.points_for(x, y, z, side_length)
    tip = [side_length / 2, side_length / 2 * tan(54), height]
    sides = (0..4).map {|i| [base[i], base[(i + 1) % base.length], tip]}

    [base, *sides]
  end
end
