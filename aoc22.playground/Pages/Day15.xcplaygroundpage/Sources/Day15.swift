import Foundation

struct Point: Hashable, Equatable {
    let x: Int
    let y: Int
    
    func manhattan(_ p: Point) -> Int {
        abs(p.x - x) + abs(p.y - y)
    }
}

func inputData() -> [(Point,Point)] {
    var result = [(Point,Point)]()
    for line in stringsFromFile() where line != "" {
        let parts = line.replacingOccurrences(of: "Sensor at x=", with: "")
            .replacingOccurrences(of: ", y=", with: " ")
            .replacingOccurrences(of: ": closest beacon is at x=", with: " ")
            .split(separator: " ")

        result.append((
            Point(x: Int(parts[0])!, y: Int(parts[1])!),
            Point(x: Int(parts[2])!, y: Int(parts[3])!)
        ))
    }
    return result
}

func boundingBox(_ points: [(Point,Point)]) -> (Point, Point) {
    var minX = Int.max
    var minY = Int.max
    var maxX = Int.min
    var maxY = Int.min
    for (p, q) in points {
        var distance = p.manhattan(q)
        minX = min(minX, p.x - distance)
        maxX = max(maxX, p.y + distance)
        minY = min(minY, p.x - distance)
        maxY = max(maxY, p.y + distance)
    }
    return (Point(x: minX, y: minY), Point(x: maxX, y: maxY))
}

public func part1() -> Int {
    let points = inputData()
    let bounds = boundingBox(points)
    var result = 0
    for x in (bounds.0.x)...(bounds.1.x) {
        let q = Point(x: x, y: 2000000)
        for p in points {
            if q == p.1 {
                break
            } else if p.0.manhattan(q) <= p.0.manhattan(p.1) {
                result += 1
                break
            }
        }
    }
    return result
}

