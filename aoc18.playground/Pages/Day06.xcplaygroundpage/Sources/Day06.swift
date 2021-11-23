import Foundation

struct Point: Hashable {
    let x: Int
    let y: Int
    
    init(x: Int, y: Int) {
        self.x = x
        self.y = y
    }
    
    init?( str: String ) {
        guard str != "" else { return nil }
        let s = str.components(separatedBy: ",")
        x = Int(s[0].trimmingCharacters(in: .whitespacesAndNewlines))!
        y = Int(s[1].trimmingCharacters(in: .whitespacesAndNewlines))!
    }
}

extension Point {
    func manhattan(_ p: Point) -> Int {
        return abs(x - p.x) + abs(y - p.y)
    }
    
    func closest(_ points: [Point]) -> Point? {
        var pd = 1_000_000
        var pt: Point? = nil
        for p in points {
            let d = manhattan(p)
            if d < pd {
                pt = p
                pd = d
            } else if d == pd {
                pt = nil
            }
        }
        return pt
    }
}

public func part1() -> Int {
    let points = stringsFromFile().compactMap( Point.init )

    var edgePoints = Set<Point>()
    var closest = Dictionary<Point, Int>()
    for pt in points {
        closest[pt] = 0
    }
 
    for x in -1000...1000 {
        for y in -1000...1000 {
            guard let p = Point(x: x, y: y).closest(points) else { continue }

            if abs(x) == 1000 || abs(y) == 1000 {
                edgePoints.insert(p)
            }
            closest[p] = 1 + closest[p]!
        }
    }
    
    for ep in edgePoints {
        closest.removeValue(forKey: ep)
    }

    return closest.values.max() ?? 0
}

public func part2() -> Int {
    let points = stringsFromFile().compactMap( Point.init )

    var region = 0
 
    for x in -1000...1000 {
        for y in -1000...1000 {
            let p = Point(x: x, y: y)
            let d = points.reduce(0) { $0 + p.manhattan($1) }
            if d < 10000 {
                region = 1 + region
            }
        }
    }
    
    return region
}
