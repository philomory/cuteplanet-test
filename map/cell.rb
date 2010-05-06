require 'cellgrid'

module CutePlanetTest
  module Map
    class Cell < CellGrid::Cell
      has_many :terrain
      alias_method :true_x, :x
      alias_method :true_y, :y
      def x
        case @grid.rotation
        when 0 then true_x
        when 1 then @grid.height - true_y - 1
        when 2 then @grid.width - true_x - 1
        when 3 then true_y
        end
      end
      def y
        case @grid.rotation
        when 0 then true_y
        when 1 then true_x
        when 2 then @grid.height - true_y - 1
        when 3 then @grid.width - true_x - 1
        end
      end
      
    end
  end
end