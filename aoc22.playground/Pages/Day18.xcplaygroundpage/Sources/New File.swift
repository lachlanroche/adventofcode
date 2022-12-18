import Foundation

struct Point: Hashable, Equatable {
    let x: Int
    let y: Int
    let z: Int
    
    var neighbors: [Point] {
        [
            Point(x: x, y: y, z: z + 1),
            Point(x: x, y: y, z: z - 1),
            Point(x: x, y: y + 1, z: z),
            Point(x: x, y: y - 1, z: z),
            Point(x: x + 1, y: y, z: z),
            Point(x: x - 1, y: y, z: z)
        ]
    }
}

public func part1() -> Int {
    var canvas = Set<Point>()
    for line in stringsFromFile() where line != "" {
        let xyz = line.split(separator: ",").compactMap { Int(String($0)) }
        canvas.insert(Point(x: xyz[0], y: xyz[1], z: xyz[2]))
    }
    var result = 0
    for p in canvas {
        let neighbors = canvas.intersection(p.neighbors)
        result += 6 - neighbors.count
    }
    return result
}
