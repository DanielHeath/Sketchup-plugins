require File.join(File.dirname(__FILE__), 'support')
require File.join(File.dirname(__FILE__), 'geometry')

model = Sketchup.active_model
entities = model.active_entities
entities.erase_entities entities.to_a

def rectangle(x, y, dx, dy)
  pts = []
  pts << [x, y]
  pts << [x+dx, y]
  pts << [x+dx, y+dy]
  pts << [x, y+dy]
  pts
end

def square(x, y, size)
  rectangle x, y, size, size
end

def rect_prism_faces(x, y, z, dx, dy, dz)
  [
    rectangle(x, y, dx, dy).map {|e| e + [z]}, # bottom
    rectangle(x, y, dx, dy).map {|e| e + [z + dz]}, # top
    rectangle(y, z, dy, dz).map {|e| [x] + e},
    rectangle(y, z, dy, dz).map {|e| [x + dx] + e},
    rectangle(x, z, dx, dz).map {|e| [e[0], y, e[1]] },
    rectangle(x, z, dx, dz).map {|e| [e[0], y + dy, e[1]] }
  ]
end

def cube_faces(x, y, z, size)
  rect_prism_faces(x, y, z, size, size, size)
end

long = 10
middle = 8
short = (long - middle) / 2

def rect_group(x, y, z, dx, dy, dz)
  group = Sketchup.active_model.active_entities.add_group
  faces = rect_prism_faces(x, y, z, dx, dy, dz).each { |face| group.entities.add_face face }
  puts "group #{x}, #{y}, #{z}, #{dx}, #{dy}, #{dz} is not manifold!" unless group.manifold?
  group
end

def cube_group(x, y, z, size)
  rect_group(x, y, z, size, size, size)
end

corners = [
  cube_group(0, 0, 0, short),
  cube_group(0, 0, middle + short, short),
  cube_group(0, middle + short, 0, short),
  cube_group(0, middle + short, middle + short, short),
  cube_group(middle + short, 0, 0, short),
  cube_group(middle + short, 0, middle + short, short),
  cube_group(middle + short, middle + short, 0, short),
  cube_group(middle + short, middle + short, middle + short, short),
]

pillars = [
  rect_group(0, 0, short, short, short, middle),
  rect_group(0, middle + short, short, short, short, middle),
  rect_group(middle + short, 0, short, short, short, middle),
  rect_group(middle + short, middle + short, short, short, short, middle),
]

lintels = [
  rect_group(short, 0, middle + short, middle, short, short),
  rect_group(short, middle + short, middle + short, middle, short, short),
  rect_group(0, short, middle + short, short, middle, short),
  rect_group(middle + short, short, middle + short, short, middle, short),
]

base_edges = [
  rect_group(short, 0, 0, middle, short, short),
  rect_group(short, middle + short, 0, middle, short, short),
  rect_group(0, short, 0, short, middle, short),
  rect_group(middle + short, short, 0, short, middle, short),
]

sides = [
  rect_group(short, short, 0, middle, middle, short),
  rect_group(short, short, middle + short, middle, middle, short),
  rect_group(0, short, short, short, middle, middle),
  rect_group(middle + short, short, short, short, middle, middle),
  rect_group(short, 0, short, middle, short, middle),
  rect_group(short, middle + short, short, middle, short, middle),

]

# Nested components suck :-(
10.times {
  Sketchup.active_model.entities.each {|e| e.explode if e.respond_to? :explode }
}

bits_to_remove = [
  [[0, 0, short], [0, short, short]],
  [[0, 0, short], [short, 0, short]],
  [[0, 0, middle + short], [0, short, middle + short]],
  [[0, 0, middle + short], [short, 0, middle + short]],
  [[0, short, 0], [0, short, short]],
  [[0, short, 0], [short, short, 0]],
  [[0, short, middle + short], [0, short, long]],
  [[0, short, long], [short, short, long]],
  [[0, middle + short, 0], [0, middle + short, short]],
  [[0, middle + short, 0], [short, middle + short, 0]],
  [[0, middle + short, short], [0, long, short]],
  [[0, middle + short, middle + short], [0, middle + short, long]],
  [[0, middle + short, middle + short], [0, long, middle + short]],
  [[0, middle + short, long], [short, middle + short, long]],
  [[0, long, short], [short, long, short]],
  [[0, long, middle + short], [short, long, middle + short]],
  [[short, 0, 0], [short, 0, short]],
  [[short, 0, 0], [short, short, 0]],
  [[short, 0, middle + short], [short, 0, long]],
  [[short, 0, long], [short, short, long]],
  [[short, middle + short, 0], [short, long, 0]],
  [[short, middle + short, long], [short, long, long]],
  [[short, long, 0], [short, long, short]],
  [[short, long, middle + short], [short, long, long]],
  [[middle + short, 0, 0], [middle + short, 0, short]],
  [[middle + short, 0, 0], [middle + short, short, 0]],
  [[middle + short, 0, short], [long, 0, short]],
  [[middle + short, 0, middle + short], [middle + short, 0, long]],
  [[middle + short, 0, middle + short], [long, 0, middle + short]],
  [[middle + short, 0, long], [middle + short, short, long]],
  [[middle + short, short, 0], [long, short, 0]],
  [[middle + short, short, long], [long, short, long]],
  [[middle + short, middle + short, 0], [middle + short, long, 0]],
  [[middle + short, middle + short, 0], [long, middle + short, 0]],
  [[middle + short, middle + short, long], [middle + short, long, long]],
  [[middle + short, middle + short, long], [long, middle + short, long]],
  [[middle + short, long, 0], [middle + short, long, short]],
  [[middle + short, long, short], [long, long, short]],
  [[middle + short, long, middle + short], [middle + short, long, long]],
  [[middle + short, long, middle + short], [long, long, middle + short]],
  [[long, 0, short], [long, short, short]],
  [[long, 0, middle + short], [long, short, middle + short]],
  [[long, short, 0], [long, short, short]],
  [[long, short, middle + short], [long, short, long]],
  [[long, middle + short, 0], [long, middle + short, short]],
  [[long, middle + short, short], [long, long, short]],
  [[long, middle + short, middle + short], [long, middle + short, long]],
  [[long, middle + short, middle + short], [long, long, middle + short]]
]

def edges
  Sketchup.active_model.entities.select {|e| e.is_a? Sketchup::Edge}
end

edges.each do |e|
  begin
    positions = [e.end.position.to_a.map(&:to_i), e.start.position.to_a.map(&:to_i)].sort
    if bits_to_remove.include? positions
      puts positions.inspect
      puts "erasing E"
      bits_to_remove.delete(positions)
      e.erase!
    end
  rescue TypeError
  end
end

puts bits_to_remove.inspect if bits_to_remove.length > 0

entities = Sketchup.active_model.entities.to_a
grp = Sketchup.active_model.entities.add_group(entities)
grp.transform!(Geom::Transformation.scaling(0.1))
