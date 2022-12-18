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
    
    static let origin = Point(x: 0, y: 0, z: 0)
}

func flood(start: Point, canvas: Set<Point>) -> Set<Point> {
    var maxX = Int.min
    var maxY = Int.min
    var maxZ = Int.min
    for p in canvas {
        maxX = max(maxX, p.y)
        maxY = max(maxY, p.y)
        maxZ = max(maxY, p.z)
    }
    var seen = Set<Point>()
    seen.insert(start)
    var queue = [Point]()
    queue.append(start)

    while !queue.isEmpty {
        let cur = queue.remove(at: 0)
        for n in cur.neighbors where !canvas.contains(n) {
            guard
                !seen.contains(n),
                -1...(maxX + 1) ~= n.x,
                -1...(maxY + 1) ~= n.y,
                -1...(maxZ + 1) ~= n.z
            else  {continue }
            seen.insert(n)
            queue.append(n)
        }
    }
    return seen
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

public func part2() -> Int {
    var canvas = Set<Point>()
    for line in stringsFromFile() where line != "" {
        let xyz = line.split(separator: ",").compactMap { Int(String($0)) }
        canvas.insert(Point(x: xyz[0], y: xyz[1], z: xyz[2]))
    }
    let reachable = flood(start: .origin, canvas: canvas)
    var result = 0
    for p in canvas {
        for n in p.neighbors {
            if !canvas.contains(n) && reachable.contains(n) {
                result += 1
            }
        }
    }
    return result
}
