module CutePlanetTest
  module Map
    OutOfBounds = Cell.new(nil,nil,nil)
    def OutOfBounds.north; self; end
    def OutOfBounds.south; self; end
    def OutOfBounds.east; self; end
    def OutOfBounds.west; self; end
  end
end