
require File.join(File.dirname(__FILE__), 'support')
require File.join(File.dirname(__FILE__), 'geometry')
require File.join(File.dirname(__FILE__), 'pentagon')
require File.join(File.dirname(__FILE__), 'pentagonal_pyramid')


model = Sketchup.active_model
entities = model.active_entities

faces = PentagonalPyramid.faces_for(0, 0, 0, 8, 10)
faces += PentagonalPyramid.faces_for(0, 0, 0, 8, -10)

resulting_faces = faces.map {|points| entities.add_face points}


# Validate the pyramid shape
base = resulting_faces[0]
rest = resulting_faces[1..4]

base_shaped_right = base.edges.map {|e| e.length }.all? {|l| l == 8}

puts "\n\n\n"
puts rest.map {|f| f.edges.map(&:length) - [8.0, 12.0]}.inspect
