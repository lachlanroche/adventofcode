import Foundation

struct Point: Hashable, Equatable {
    let x: Int
    let y: Int
}

func parsePair(s: String) -> Point {
    let xy = s.components(separatedBy: ",")
        .map { Int($0)! }
    return Point(x: xy[0], y: xy[1] )
}

func line1(p1: Point, p2: Point) -> [Point] {
    var result = [Point]()
    
    var x0 = min(p1.x, p2.x)
    var x1 = max(p1.x, p2.x)
    var y0 = min(p1.y, p2.y)
    var y1 = max(p1.y, p2.y)

    for x in x0...x1 {
        for y in y0...y1 {
            result.append(Point(x: x, y: y))
        }
    }

    return result
}

public func part1() -> Int {
    let inputData: [[Point]] = stringsFromFile()
        .filter { $0 != "" }
        .map { $0.components(separatedBy: " -> ")}
        .map { $0.map(parsePair) }
        
    let data = inputData.filter { $0[0].x == $0[1].x || $0[0].y == $0[1].y }

    var seen = Dictionary<Point,Int>()
    
    for pp in data {
        for p in line1(p1: pp[0], p2: pp[1]) {
            seen[p] = 1 + (seen[p] ?? 0)
        }
    }
    
    return seen.filter { k, v in v > 1 }.count
}

