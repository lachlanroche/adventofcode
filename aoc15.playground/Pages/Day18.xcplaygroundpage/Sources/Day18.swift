import Foundation

func worldFromFile(named name: String) -> Set<Coordinate2D> {
    var world: Set<Coordinate2D> = []

    for (y, s) in stringsFromFile() .enumerated() {
        for (x, c) in s.enumerated() {
            if c == "#" {
                world.insert(Coordinate2D(x: x, y: y))
            }
        }
    }
    return world
}

struct Coordinate2D: Hashable {
    public let x: Int
    public let y: Int
    
    public init(x: Int, y: Int) {
        self.x = x
        self.y = y
    }
}

extension Coordinate2D {
    func neighbors() -> Set<Coordinate2D> {
        return [
            Coordinate2D(x: x-1, y: y-1),
            Coordinate2D(x: x, y: y-1),
            Coordinate2D(x: x+1, y: y-1),
            
            Coordinate2D(x: x-1, y: y),
            Coordinate2D(x: x+1, y: y),
            
            Coordinate2D(x: x-1, y: y+1),
            Coordinate2D(x: x, y: y+1),
            Coordinate2D(x: x+1, y: y+1),
        ]
    }
}

public func part1() -> Int {
    var world = worldFromFile(named: "input")
    
    for _ in 0..<100 {
        var next = Set<Coordinate2D>()

        for x in 0..<100 {
            for y in 0..<100 {
                let point = Coordinate2D(x: x, y: y)
                let friends = point.neighbors().intersection(world)
                
                if world.contains(point) {
                    if friends.count == 2 || friends.count == 3 {
                        next.insert(point)
                    }
                } else {
                    if friends.count == 3 {
                        next.insert(point)
                    }
                }
            }
        }
        
        world = next
    }
    return world.count
}
