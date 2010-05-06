require 'gosu'
require 'map/grid'
require 'shadows'

NilDraw = Object.new
def NilDraw.draw(*args); end

module CutePlanetTest
  class DemoWindow < Gosu::Window
    include Shadows
    def initialize
      @tiles_wide, @tiles_high = 10,10
      @tile_width = 50
      @tile_height = 40
      @tile_top_margin = 25
      @z_differential = 20
      @horizontal_margin  = 0
      @top_margin = 100
      @bottom_margin = 20
      @width  = @tiles_wide * @tile_width + @horizontal_margin * 2
      @height = @tiles_high * @tile_height + @top_margin + @bottom_margin
      super(@width,@height,false)
      @map = create_map
      @needs_redraw = true
      @images = {
        :grass => Gosu::Image.new(self,"images/Grass Block.png",true),
        :stone => Gosu::Image.new(self,"images/Stone Block.png",true),
        :space => NilDraw,
        :door  => Gosu::Image.new(self,"images/Door Tall Closed.png",true),
        :window => Gosu::Image.new(self,"images/Window Tall.png",true),
        :dirt  => Gosu::Image.new(self,"images/Dirt Block.png",true),
        :bush  => Gosu::Image.new(self,"images/Tree Short.png",true),
        :water => Gosu::Image.new(self,"images/Water Block.png",true),
        :tree  => Gosu::Image.new(self,"images/Tree Tall.png",true),
        :chest => Gosu::Image.new(self,"images/Chest Closed.png",true),
        :rock  => Gosu::Image.new(self,"images/Rock.png",true),
        :princess => Gosu::Image.new(self,"images/Character Princess Girl.png",true),
        :horn_girl => Gosu::Image.new(self,"images/Character Horn Girl.png",true),
        :pink_girl => Gosu::Image.new(self,"images/Character Pink Girl.png",true),
        :boy => Gosu::Image.new(self,"images/Character Boy.png",true),
        :speech => Gosu::Image.new(self,"images/SpeechBubble.png",true),
        :heart => Gosu::Image.new(self,"images/Heart.png",true),
        :wood  => Gosu::Image.new(self,"images/Wood Block.png",true),
        :roof => {
          :north     => Gosu::Image.new(self,"images/Roof North.png",true),
          :south     => Gosu::Image.new(self,"images/Roof South.png",true),
          :east      => Gosu::Image.new(self,"images/Roof East.png",true),
          :west      => Gosu::Image.new(self,"images/Roof West.png",true),
          :northeast => Gosu::Image.new(self,"images/Roof North East.png",true),
          :northwest => Gosu::Image.new(self,"images/Roof North West.png",true),
          :southeast => Gosu::Image.new(self,"images/Roof South East.png",true),
          :southwest => Gosu::Image.new(self,"images/Roof South West.png",true),
        }
      }
      @shadows = {
        :north      => Gosu::Image.new(self,"images/Shadow North.png",true),
        :south      => Gosu::Image.new(self,"images/Shadow South.png",true),
        :east       => Gosu::Image.new(self,"images/Shadow East.png",true),
        :west       => Gosu::Image.new(self,"images/Shadow West.png",true),
        :side_west  => Gosu::Image.new(self,"images/Shadow Side West.png",true),
        :north_east => Gosu::Image.new(self,"images/Shadow North East.png",true),
        :north_west => Gosu::Image.new(self,"images/Shadow North West.png",true),
        :south_east => Gosu::Image.new(self,"images/Shadow South East.png",true),
        :south_west => Gosu::Image.new(self,"images/Shadow South West.png",true)
      }
    end
    
    def create_map
      map = Map::Grid.new(@tiles_wide,@tiles_high) do |cell|
        cell.terrain << :grass
      end
      CellGrid::SubGrid.new(1,1,5,5,map).each do |cell|
        case [cell.x-1,cell.y-1]
        when [3,4]
          cell.terrain << :door << :space << :space << :stone << :stone << :stone
        when [1,4]
          cell.terrain << :stone << :stone << :window << :space << :stone << :stone
        else
          cell.terrain << :stone << :stone << :stone << :stone << :stone << :stone
        end
      end      
      CellGrid::SubGrid.new(4,6,1,4,map).each do |cell|
        cell.terrain[0] = :dirt
      end
      CellGrid::SubGrid.new(3,6,3,4,map).each do |cell|
        cell.terrain << :bush if cell.x.odd? and cell.y.odd?
      end
      CellGrid::SubGrid.new(7,2,2,3,map).each do |cell|
        cell.terrain[0] = :water
      end
      map[7,1].terrain << :tree
      map[3,0].terrain << :bush
      map[4,0].terrain << :chest
      map[5,0].terrain << :rock
      map[8,1].terrain << :pink_girl
      map[8,5].terrain << :princess
      map[6,4].terrain << :horn_girl
      create_roof(map)
      map
    end
    
    def create_roof(map)
      #roof_layer(map,0,0,7,7,6)
      roof_layer(map,1,1,5,5,7)
      roof_layer(map,2,2,3,3,8)
      map[3,3].terrain[8] = :wood
    end
    
    def roof_layer(map,x,y,width,height,z)
      CellGrid::SubGrid.new(x,y+1,1,height-2,map).each do |cell|
        cell.terrain[z] = {:tile => :roof,:orient => :west}
      end
      CellGrid::SubGrid.new(x+width-1,y+1,1,height-2,map).each do |cell|
        cell.terrain[z] = {:tile => :roof,:orient => :east}
      end
      CellGrid::SubGrid.new(x+1,y,width-2,1,map).each do |cell|
        cell.terrain[z] = {:tile => :roof,:orient => :north}
      end
      CellGrid::SubGrid.new(x+1,y+height-1,width-2,1,map).each do |cell|
        cell.terrain[z] = {:tile => :roof,:orient => :south}
      end
      map[x,y].terrain[z] = {:tile => :roof, :orient => :northwest}
      map[x+width-1,y].terrain[z] = {:tile => :roof, :orient => :northeast}
      map[x,y+height-1].terrain[z] = {:tile => :roof, :orient => :southwest}
      map[x+width-1,y+height-1].terrain[z] = {:tile => :roof, :orient => :southeast}
    end
    
    def button_down(id)
      case id
      when Gosu::KbEscape then close
      when Gosu::KbLeft then @map.rotate_ccw; @needs_redraw = true
      when Gosu::KbRight then @map.rotate_cw; @needs_redraw = true
      end
    end
    
    def needs_redraw?
      @needs_redraw
    end
    
    def draw
      @needs_redraw = false
      draw_background
      @map.max_height.times do |z|
        @map.each do |cell|
          next unless cell.terrain[z]
          x_pos = cell.x * @tile_width + @horizontal_margin
          y_pos = (cell.y * @tile_height) - (z * @z_differential) + @top_margin - @tile_top_margin
          pic = get_pic(cell,z)
          pic.draw(x_pos,y_pos,z)
          draw_shadows(cell,x_pos,y_pos,z) unless no_shadow(cell.terrain[z])
          draw_speech(cell,x_pos,y_pos,z)
        end
      end
    end
    def draw_background
      white = 0xFFFFFFFF
      blue = 0xFFAAAAFF
      self.draw_quad(0,0,blue,@width,0,blue,0,@height,white,@width,@height,white,-1)
    end
    
    ORIENTATIONS = [:north,:northeast,:east,:southeast,:south,:southwest,:west,:northwest]
    def get_pic(cell,z)
      
      entry = cell.terrain[z]
      case entry
      when Symbol
        @images[entry]
      when Hash
        initial_index = ORIENTATIONS.index(entry[:orient])
        new_index = (initial_index + 2*cell.grid.rotation) % ORIENTATIONS.size
        new_orientation = ORIENTATIONS[new_index] 
        @images[entry[:tile]][new_orientation]
      else
        raise
      end
    end
    
    def draw_speech(cell,x_pos,y_pos,z)
      case cell.terrain[z]
      when :horn_girl
        @images[:speech].draw(x_pos+@tile_width,y_pos-@tile_height,z+3)
        @images[:boy].draw(x_pos+@tile_width,y_pos-@tile_height+4,z+3)
      when :princess
        @images[:speech].draw(x_pos+@tile_width,y_pos-@tile_height,z+3)
        @images[:heart].draw_rot(x_pos+(@tile_width*1.5),y_pos+@tile_height-@tile_top_margin,z+3,0,0.5,0.5,0.75,0.75)
      end
    end
    
  end
end

CutePlanetTest::DemoWindow.new.show