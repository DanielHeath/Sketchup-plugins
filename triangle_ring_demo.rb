require File.join(File.dirname(__FILE__), 'support')
require File.join(File.dirname(__FILE__), 'geometry')

model = Sketchup.active_model
entities = model.active_entities
entities.erase_entities entities.to_a

class Position
  attr_reader :x, :y, :z
  def initialize(@x, @y, @z)
  end
end

class EquilateralTriangle
  def initialize(start_position, @size)
    #
  end
end

class Arc
  def initialize(x, y, z, radius)

  end
end


outer_outer_points_of_ring = EquilateralTriangle.new(Position.new(0, 0, 0), 22.millimeters).points

outer_edges_of_ring = [
  Arc.new(:from => outer_points_of_ring[0], :to => outer_points_of_ring[1], :center => outer_points_of_ring[2]),
  Arc.new(:from => outer_points_of_ring[1], :to => outer_points_of_ring[2], :center => outer_points_of_ring[0]),
  Arc.new(:from => outer_points_of_ring[2], :to => outer_points_of_ring[0], :center => outer_points_of_ring[1])
]

inner_edges_of_ring = outer_edges_of_ring.map(&:clone)
inner_edges_of_ring.scale_centered(0.82) # Seems to be a good size for a ring

base_of_ring = Face.new(outer_edges_of_ring, inner_edges_of_ring)

base_of_ring.push(3.millimeters)

# Manually select face

selected_face.add_3d_text("LPOS", :font => "copperplate")

def Face.add_3d_text(text, opts)
  Entities.add_3d_textSketchUp(text, TextAlignCenter, opts[:font], false, false, 2.millimeters.in_inches, 0.0, 0.inches, true, )
end
