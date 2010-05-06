require 'cellgrid'
require 'map/cell'
require 'map/outofbounds'

module CutePlanetTest
  module Map
    class Grid < CellGrid::Grid
      composed_of Map::Cell
      attr_reader :rotation
      def initialize(*args,&block)
        @rotation = 0
        super(*args,&block)
      end
      def rotate_cw
        @rotation += 1
        @rotation %= 4
      end
      def rotate_ccw
        @rotation -= 1
        @rotation %= 4
      end
      
      alias_method :true_height, :height
      alias_method :true_width, :width
      
      def height
        @rotation.even? ? true_height : true_width
      end
      
      def width
        @rotation.even? ? true_width : true_height
      end
      
      def [](x,y)
        true_x,true_y = case @rotation
        when 0 then [x,y]
        when 3 then [height-y-1,x]
        when 2 then [width-x-1,height-y-1]
        when 1 then [y,width-x-1]
        end
        begin
          super(true_x,true_y)
        rescue CellGrid::OutOfBoundsError
          return Map::OutOfBounds
        end
      end
      def max_height
        self.map {|cell| cell.terrain.size}.max
      end
    end
  end
end