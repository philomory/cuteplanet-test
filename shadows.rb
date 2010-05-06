module CutePlanetTest
  module Shadows
    
    def shadow_directions(cell,z)
      dirs = []
      dirs << :north      if casts_shadow?(cell.north.terrain[z+1])
      dirs << :south      if casts_shadow?(cell.south.terrain[z+1])
      dirs << :east       if casts_shadow?(cell.east.terrain[z+1])
      dirs << :west       if casts_shadow?(cell.west.terrain[z+1])
      dirs << :side_west  if casts_shadow?(cell.south.west.terrain[z])
      dirs << :south_east if (casts_shadow?(cell.south.east.terrain[z+1]) and !cell.east.terrain[z+1])
      dirs << :south_west if (casts_shadow?(cell.south.west.terrain[z+1]) and !cell.west.terrain[z+1])
      dirs << :north_east if (casts_shadow?(cell.north.east.terrain[z+1]) and !cell.east.terrain[z+1] and !cell.north.terrain[z+1])
      dirs << :north_west if (casts_shadow?(cell.north.west.terrain[z+1]) and !cell.west.terrain[z+1] and !cell.north.terrain[z+1])
      dirs
    end
    
    def draw_shadows(cell,x_pos,y_pos,z)
      shadow_directions(cell,z).each do |dir|
        @shadows[dir].draw(x_pos,y_pos,z)
      end
    end
    
    def casts_shadow?(terrain)
      ([:dirt,:stone,:grass,:water].include?(terrain))
    end
    
    def no_shadow(terrain)
      ![:dirt,:stone,:grass,:water].include?(terrain)
    end
    
  end
end