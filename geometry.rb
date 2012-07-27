class Geometry
  
  def self.sin(deg)
    Math.sin deg_to_rad(deg)
  end
  
  def self.cos(deg)
    Math.cos deg_to_rad(deg)
  end
  
  def self.tan(deg)
    Math.cos deg_to_rad(deg)
  end
  
  def self.deg_to_rad(deg)
    (deg* Math::PI / 180)
  end
  
end